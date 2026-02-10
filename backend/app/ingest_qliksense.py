
import os, io, json, zipfile, hashlib, asyncio
from pathlib import Path
from typing import Any, Dict, List, Optional
import psycopg
from psycopg.rows import dict_row

def _conninfo() -> str:
    dsn = os.getenv("DATABASE_URL") or os.getenv("PG_DSN")
    if not dsn:
        raise RuntimeError("Set DATABASE_URL or PG_DSN for Postgres connection")
    return dsn

def _read_json_bytes(b: bytes):
    return json.loads(b.decode("utf-8"))

def _safe_id(obj: Dict[str, Any]) -> str:
    if isinstance(obj, dict) and obj.get("id"):
        return str(obj["id"])
    digest = hashlib.sha1(json.dumps(obj, sort_keys=True).encode("utf-8")).hexdigest()
    return digest

async def _ensure_schema(cur):
    sql_path_env = os.getenv("QS_SCHEMA_SQL")
    if sql_path_env and Path(sql_path_env).exists():
        await cur.execute(Path(sql_path_env).read_text(encoding="utf-8"))
        return
    default = Path(__file__).parent / "sql" / "repmeta_qs_schema.sql"
    if default.exists():
        await cur.execute(default.read_text(encoding="utf-8"))

async def _insert_single(cur, table: str, snapshot_id: str, data: Dict[str, Any]):
    await cur.execute(
        f"INSERT INTO repmeta_qs.{table} (snapshot_id, data) VALUES (%s, %s) "
        f"ON CONFLICT (snapshot_id) DO UPDATE SET data = EXCLUDED.data",
        (snapshot_id, json.dumps(data)),
    )

async def _insert_collection(cur, table: str, key_name: str, rows: List[Dict[str, Any]], snapshot_id: str, app_id_key: Optional[str] = None):
    if not rows:
        return
    if app_id_key:
        await cur.executemany(
            f"INSERT INTO repmeta_qs.{table} (snapshot_id, {key_name}, app_id, data) VALUES (%s, %s, %s, %s) "
            f"ON CONFLICT (snapshot_id, {key_name}) DO UPDATE SET data = EXCLUDED.data, app_id = EXCLUDED.app_id",
            [(snapshot_id, str(r.get('id') or r.get(key_name) or _safe_id(r)), r.get(app_id_key), json.dumps(r)) for r in rows],
        )
    else:
        await cur.executemany(
            f"INSERT INTO repmeta_qs.{table} (snapshot_id, {key_name}, data) VALUES (%s, %s, %s) "
            f"ON CONFLICT (snapshot_id, {key_name}) DO UPDATE SET data = EXCLUDED.data",
            [(snapshot_id, str(r.get('id') or r.get(key_name) or _safe_id(r)), json.dumps(r)) for r in rows],
        )

FILES_MAP = [
    ("about", "QlikAbout.json", None),
    ("system_info", "QlikSystemInfo.json", None),
    ("license", "QlikLicense.json", None),
    ("apps", "QlikApp.json", None),
    ("app_objects", "QlikAppObject.json", "appId"),
    ("users", "QlikUser.json", None),
    ("extensions", "QlikExtension.json", None),
    ("access_professional", "QlikProfessionalAccessType.json", None),
    ("access_analyzer", "QlikAnalyzerAccessType.json", None),
    ("access_analyzer_time", "QlikAnalyzerTimeAccessType.json", None),
    ("reload_tasks", "QlikReloadTask.json", "appId"),
    ("tasks", "QlikTask.json", None),
    ("servernode_config", "QlikServernodeConfiguration.json", None),
    ("system_rules", "QlikSystemRule.json", None),
    ("streams", "QlikStream.json", None),
]

# Fallback files when primary doesn't exist
FALLBACK_FILES = {
    "QlikUser.json": "QlikUserAccessType.json",
}

def _extract_hardware_info(hw_data: Dict[str, Any]) -> Dict[str, Any]:
    """Extract relevant hardware info (CPU, memory) from OSInfo JSON."""
    hostname = hw_data.get("Hostname", "")

    # Get CPU and memory from CIM_ComputerSystem
    cpu_cores = None
    total_memory_bytes = None
    model = None

    cim_cs = hw_data.get("CIM_ComputerSystem", [])
    if cim_cs and len(cim_cs) > 0:
        cs = cim_cs[0]
        cpu_cores = cs.get("NumberOfLogicalProcessors")
        total_memory_bytes = cs.get("TotalPhysicalMemory")
        model = cs.get("Model")

    # Get OS info
    os_caption = None
    win_os = hw_data.get("Win32_OperatingSystem", [])
    if win_os and len(win_os) > 0:
        os_caption = win_os[0].get("Caption")

    return {
        "hostname": hostname,
        "cpu_cores": int(cpu_cores) if cpu_cores else None,
        "total_memory_gb": round(int(total_memory_bytes) / (1024**3), 1) if total_memory_bytes else None,
        "model": model,
        "os": os_caption,
    }

def _classify_hardware_files(files: Dict[str, bytes]) -> List[Dict[str, Any]]:
    """Extract hardware info from OSInfo_*.json files."""
    hardware_list = []
    for filename, content in files.items():
        if filename.lower().startswith("osinfo_") and filename.lower().endswith(".json"):
            try:
                hw_data = json.loads(content.decode("utf-8"))
                hw_info = _extract_hardware_info(hw_data)
                hw_info["_raw"] = hw_data
                hardware_list.append(hw_info)
            except Exception:
                pass
    return hardware_list

def _classify_files(files: Dict[str, bytes]) -> Dict[str, Optional[bytes]]:
    out: Dict[str, Optional[bytes]] = {fname: None for (_, fname, _) in FILES_MAP}
    for canon in out.keys():
        # Try primary file first
        for k, v in files.items():
            if k.lower().endswith(canon.lower()):
                out[canon] = v
                break
        # Try fallback if primary not found
        if out[canon] is None and canon in FALLBACK_FILES:
            fallback = FALLBACK_FILES[canon]
            for k, v in files.items():
                if k.lower().endswith(fallback.lower()):
                    out[canon] = v
                    break
    return out

def _build_server_name_map(nodes: List[Dict[str, Any]], hardware: List[Dict[str, Any]]) -> Dict[str, str]:
    """Build a mapping from real hostnames to obfuscated names (Server 1, Server 2, etc.)."""
    # Collect all unique hostnames (lowercase for matching)
    hostnames = set()
    for node in nodes:
        hostname = node.get("hostName", "")
        if hostname:
            hostnames.add(hostname.lower())
    for hw in hardware:
        hostname = hw.get("hostname", "")
        if hostname:
            hostnames.add(hostname.lower())

    # Sort for consistent ordering, with central nodes first if identifiable
    central_hosts = set()
    for node in nodes:
        if node.get("isCentral"):
            hostname = node.get("hostName", "")
            if hostname:
                central_hosts.add(hostname.lower())

    sorted_hosts = sorted(central_hosts) + sorted(hostnames - central_hosts)

    # Build mapping
    name_map = {}
    for i, hostname in enumerate(sorted_hosts, 1):
        name_map[hostname] = f"Server {i}"

    return name_map

def _obfuscate_servernode_config(nodes: List[Dict[str, Any]], name_map: Dict[str, str]) -> List[Dict[str, Any]]:
    """Obfuscate server names in servernode_config data."""
    obfuscated = []
    for node in nodes:
        node_copy = dict(node)
        hostname = (node.get("hostName") or "").lower()
        obfuscated_name = name_map.get(hostname, "Server")

        # Replace name and hostName with obfuscated version
        node_copy["name"] = obfuscated_name
        node_copy["hostName"] = obfuscated_name

        obfuscated.append(node_copy)
    return obfuscated

def _obfuscate_hardware_info(hardware: List[Dict[str, Any]], name_map: Dict[str, str]) -> List[Dict[str, Any]]:
    """Obfuscate hostnames in hardware info."""
    obfuscated = []
    for hw in hardware:
        hw_copy = dict(hw)
        hostname = (hw.get("hostname") or "").lower()
        obfuscated_name = name_map.get(hostname, "Server")

        hw_copy["hostname"] = obfuscated_name
        # Remove raw data which may contain hostname
        hw_copy.pop("_raw", None)

        obfuscated.append(hw_copy)
    return obfuscated

async def ingest_from_buffers(buffers: Dict[str, bytes], customer_id: int, notes: Optional[str], hardware_buffers: Optional[Dict[str, bytes]] = None) -> str:
    async with await psycopg.AsyncConnection.connect(_conninfo()) as conn:
        await conn.set_autocommit(False)
        async with conn.cursor(row_factory=dict_row) as cur:
            await _ensure_schema(cur)
            row = await (await cur.execute(
                "INSERT INTO repmeta_qs.snapshots (customer_id, notes) VALUES (%s, %s) RETURNING snapshot_id",
                (customer_id, notes),
            )).fetchone()
            snapshot_id = row["snapshot_id"]
            filemap = _classify_files(buffers)

            # Singletons
            for table, canon, _ in FILES_MAP[:3]:
                data = filemap.get(canon)
                if data:
                    await _insert_single(cur, table, snapshot_id, _read_json_bytes(data))

            # Build server name obfuscation map before processing collections
            servernode_data = []
            servernode_bytes = filemap.get("QlikServernodeConfiguration.json")
            if servernode_bytes:
                servernode_data = _read_json_bytes(servernode_bytes)
                if isinstance(servernode_data, dict):
                    servernode_data = [servernode_data]

            hardware_list = []
            if hardware_buffers:
                hardware_list = _classify_hardware_files(hardware_buffers)

            # Build obfuscation map from all server names
            server_name_map = _build_server_name_map(servernode_data, hardware_list)

            # Obfuscate server data
            obfuscated_nodes = _obfuscate_servernode_config(servernode_data, server_name_map)
            obfuscated_hardware = _obfuscate_hardware_info(hardware_list, server_name_map)

            # Collections
            for table, canon, app_id_key in FILES_MAP[3:]:
                b = filemap.get(canon)
                if not b:
                    continue

                # Use obfuscated data for servernode_config
                if table == "servernode_config":
                    data = obfuscated_nodes
                else:
                    data = _read_json_bytes(b)

                key_name = "id"
                if table in ("apps", "users", "extensions", "reload_tasks", "tasks", "servernode_config", "system_rules", "app_objects", "streams", "access_professional", "access_analyzer", "access_analyzer_time"):
                    key_name = {"apps":"app_id","users":"user_id","extensions":"extension_id","reload_tasks":"task_id","tasks":"task_id","servernode_config":"node_id","system_rules":"rule_id","app_objects":"object_id","streams":"stream_id","access_professional":"access_id","access_analyzer":"access_id","access_analyzer_time":"access_id"}[table]
                if isinstance(data, list):
                    await _insert_collection(cur, table, key_name, data, snapshot_id, app_id_key=app_id_key)
                elif isinstance(data, dict):
                    await _insert_collection(cur, table, key_name, [data], snapshot_id, app_id_key=app_id_key)

            # Hardware info (from OSInfo_*.json files) - use obfuscated data
            if obfuscated_hardware:
                await cur.executemany(
                    "INSERT INTO repmeta_qs.server_hardware (snapshot_id, hostname, data) VALUES (%s, %s, %s) "
                    "ON CONFLICT (snapshot_id, hostname) DO UPDATE SET data = EXCLUDED.data",
                    [(snapshot_id, h["hostname"], json.dumps(h)) for h in obfuscated_hardware],
                )

            await conn.commit()
            return str(snapshot_id)

async def ingest_zip_bytes(zip_bytes: bytes, customer_id: int, notes: Optional[str]) -> str:
    zf = zipfile.ZipFile(io.BytesIO(zip_bytes))
    buffers: Dict[str, bytes] = {}
    hardware_buffers: Dict[str, bytes] = {}
    for name in zf.namelist():
        base = name.split("/")[-1]
        # Qlik metadata files
        if base.lower().endswith(".json") and base.lower().startswith("qlik"):
            buffers[base] = zf.read(name)
        # Hardware files from Hardware subfolder (OSInfo_*.json)
        elif base.lower().startswith("osinfo_") and base.lower().endswith(".json"):
            hardware_buffers[base] = zf.read(name)
    return await ingest_from_buffers(buffers, customer_id, notes, hardware_buffers=hardware_buffers)
