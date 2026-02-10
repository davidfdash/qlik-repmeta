"""Analyze QlikTask.json: tasks run in last 30 days, success rate, never-succeeded tasks."""

import json
from datetime import datetime, timedelta, timezone
from collections import Counter

# Qlik Sense task execution status codes
STATUS_LABELS = {
    0: "NeverStarted",
    1: "Triggered",
    2: "Started",
    3: "Queued",
    4: "AbortInitiated",
    5: "Aborting",
    6: "Aborted",
    7: "FinishedSuccess",
    8: "FinishedFail",
    9: "Skipped",
    10: "Retry",
    11: "Error",
    12: "Reset",
}

def _parse_ts(s):
    if not s:
        return None
    try:
        return datetime.fromisoformat(s.replace("Z", "+00:00"))
    except Exception:
        return None

def analyze(path: str):
    with open(path, "r", encoding="utf-8") as f:
        tasks = json.load(f)

    # Determine the most recent execution in the dataset to anchor the 30-day window
    all_stop_times = []
    for t in tasks:
        st = _parse_ts((t.get("operational") or {}).get("lastExecutionResult", {}).get("stopTime"))
        if st:
            all_stop_times.append(st)

    if all_stop_times:
        data_max = max(all_stop_times)
    else:
        data_max = datetime.now(timezone.utc)

    cutoff_30d = data_max - timedelta(days=30)

    total_tasks = len(tasks)
    ran_last_30d = []
    never_succeeded = []
    status_counts = Counter()

    for t in tasks:
        op = t.get("operational") or {}
        last = op.get("lastExecutionResult") or {}
        status = last.get("status")
        stop_time = _parse_ts(last.get("stopTime"))

        # Track status distribution
        if status is not None:
            status_counts[status] += 1

        # Tasks run in the last 30 days (based on stopTime relative to data snapshot)
        if stop_time and stop_time >= cutoff_30d:
            ran_last_30d.append(t)

        # Tasks that have NEVER completed successfully
        # status 7 = FinishedSuccess; if status is not 7 (or no execution at all), it never succeeded
        if status != 7:
            never_succeeded.append(t)

    # Success rate among ALL tasks with a last execution result
    tasks_with_result = [t for t in tasks if (t.get("operational") or {}).get("lastExecutionResult", {}).get("status") is not None]
    successful_total = sum(1 for t in tasks_with_result if t["operational"]["lastExecutionResult"]["status"] == 7)
    success_pct_overall = (successful_total / len(tasks_with_result) * 100) if tasks_with_result else 0

    # Success rate among tasks that ran in last 30 days
    successful_30d = sum(1 for t in ran_last_30d if t["operational"]["lastExecutionResult"]["status"] == 7)
    success_pct_30d = (successful_30d / len(ran_last_30d) * 100) if ran_last_30d else 0

    # Print report
    print("=" * 70)
    print("  QLIK SENSE TASK EXECUTION REPORT")
    print(f"  Data snapshot date:               {data_max.strftime('%Y-%m-%d %H:%M UTC')}")
    print(f"  30-day window: {cutoff_30d.strftime('%Y-%m-%d')} to {data_max.strftime('%Y-%m-%d')}")
    print("=" * 70)

    print(f"\n  Total tasks in file:              {total_tasks}")
    print(f"  Tasks with execution results:     {len(tasks_with_result)}")

    print(f"\n--- Tasks Run in Last 30 Days ---")
    print(f"  Count:                            {len(ran_last_30d)}")
    print(f"  Successful (status=7):            {successful_30d}")
    print(f"  Failed/Other:                     {len(ran_last_30d) - successful_30d}")
    print(f"  Success rate (30d):               {success_pct_30d:.1f}%")

    print(f"\n--- Overall Success Rate (last execution per task) ---")
    print(f"  Successful:                       {successful_total}")
    print(f"  Not successful:                   {len(tasks_with_result) - successful_total}")
    print(f"  Success rate (overall):           {success_pct_overall:.1f}%")

    print(f"\n--- Tasks That Have Never Completed Successfully ---")
    print(f"  Count:                            {len(never_succeeded)}")
    if never_succeeded:
        print(f"\n  {'Task Name':<60} {'Status':<20}")
        print(f"  {'-'*60} {'-'*20}")
        for t in never_succeeded:
            name = t.get("name", "?")[:58]
            op = t.get("operational") or {}
            last = op.get("lastExecutionResult") or {}
            st = last.get("status")
            label = STATUS_LABELS.get(st, f"Unknown({st})") if st is not None else "NoExecution"
            print(f"  {name:<60} {label:<20}")

    print(f"\n--- Status Distribution (all tasks) ---")
    for code in sorted(status_counts.keys()):
        label = STATUS_LABELS.get(code, f"Unknown({code})")
        print(f"  {label:<25} (status={code}):  {status_counts[code]}")

    print()


if __name__ == "__main__":
    analyze(r"JNJ_NA_PROD\QlikTask.json")
