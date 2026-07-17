--
-- PostgreSQL database dump
--

\restrict Sy2BNyK9hIWiQuZSlf8RarxPsw3ofJOrWeg3HWdBVFLJ3xBUcjyno6VBYIYjRsy

-- Dumped from database version 16.11
-- Dumped by pg_dump version 16.14 (Debian 16.14-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: repmeta_qs; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA repmeta_qs;


--
-- Name: rx_int(text, text); Type: FUNCTION; Schema: repmeta_qs; Owner: -
--

CREATE FUNCTION repmeta_qs.rx_int(src text, pat text) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $$
  SELECT NULLIF((regexp_match(src, pat))[1],'')::int
$$;


--
-- Name: rx_text(text, text); Type: FUNCTION; Schema: repmeta_qs; Owner: -
--

CREATE FUNCTION repmeta_qs.rx_text(src text, pat text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
  SELECT (regexp_match(src, pat))[1]
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: about; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.about (
    snapshot_id integer NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: access_analyzer; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.access_analyzer (
    snapshot_id integer NOT NULL,
    access_id text NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: access_analyzer_time; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.access_analyzer_time (
    snapshot_id integer NOT NULL,
    access_id text NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: access_professional; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.access_professional (
    snapshot_id integer NOT NULL,
    access_id text NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: access_type_info; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.access_type_info (
    snapshot_id integer NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: app; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.app (
    snapshot_id integer NOT NULL,
    id text NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: app_object; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.app_object (
    snapshot_id integer NOT NULL,
    id text NOT NULL,
    data jsonb NOT NULL,
    app_id text
);


--
-- Name: app_objects; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.app_objects (
    snapshot_id integer NOT NULL,
    object_id text NOT NULL,
    app_id text,
    data jsonb NOT NULL
);


--
-- Name: apps; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.apps (
    snapshot_id integer NOT NULL,
    app_id text NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: extension; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.extension (
    snapshot_id integer NOT NULL,
    id text NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: extensions; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.extensions (
    snapshot_id integer NOT NULL,
    extension_id text NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: license; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.license (
    snapshot_id integer NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: reload_task; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.reload_task (
    snapshot_id integer NOT NULL,
    id text NOT NULL,
    data jsonb NOT NULL,
    app_id text
);


--
-- Name: reload_tasks; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.reload_tasks (
    snapshot_id integer NOT NULL,
    task_id text NOT NULL,
    app_id text,
    data jsonb NOT NULL
);


--
-- Name: server_config; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.server_config (
    snapshot_id integer NOT NULL,
    id text NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: server_hardware; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.server_hardware (
    snapshot_id integer NOT NULL,
    hostname text NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: servernode_config; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.servernode_config (
    snapshot_id integer NOT NULL,
    node_id text NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: servernode_configuration; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.servernode_configuration AS
 SELECT snapshot_id,
    id,
    data
   FROM repmeta_qs.server_config;


--
-- Name: snapshot; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.snapshot (
    snapshot_id integer NOT NULL,
    customer_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    notes text
);


--
-- Name: snapshot_snapshot_id_seq; Type: SEQUENCE; Schema: repmeta_qs; Owner: -
--

CREATE SEQUENCE repmeta_qs.snapshot_snapshot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


--
-- Name: snapshot_snapshot_id_seq1; Type: SEQUENCE; Schema: repmeta_qs; Owner: -
--

CREATE SEQUENCE repmeta_qs.snapshot_snapshot_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snapshot_snapshot_id_seq1; Type: SEQUENCE OWNED BY; Schema: repmeta_qs; Owner: -
--

ALTER SEQUENCE repmeta_qs.snapshot_snapshot_id_seq1 OWNED BY repmeta_qs.snapshot.snapshot_id;


--
-- Name: snapshots; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.snapshots AS
 SELECT snapshot_id,
    customer_id,
    created_at,
    created_at AS snapshot_ts,
    notes
   FROM repmeta_qs.snapshot;


--
-- Name: stream; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.stream (
    snapshot_id integer NOT NULL,
    id text NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: streams; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.streams (
    snapshot_id integer NOT NULL,
    stream_id text NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: system_info; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.system_info (
    snapshot_id integer NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: system_rule; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.system_rule (
    snapshot_id integer NOT NULL,
    id text NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: system_rules; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.system_rules (
    snapshot_id integer NOT NULL,
    rule_id text NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: tasks; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.tasks (
    snapshot_id integer NOT NULL,
    task_id text NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: user; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs."user" (
    snapshot_id integer NOT NULL,
    id text NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: repmeta_qs; Owner: -
--

CREATE TABLE repmeta_qs.users (
    snapshot_id integer NOT NULL,
    user_id text NOT NULL,
    data jsonb NOT NULL
);


--
-- Name: v_app_objects; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_app_objects AS
 SELECT snapshot_id,
    object_id,
    app_id,
    data,
    COALESCE((data ->> 'name'::text), (data ->> 'title'::text)) AS object_name,
    lower(COALESCE((data ->> 'type'::text), (data ->> 'qType'::text))) AS object_type,
    (lower(COALESCE((data ->> 'published'::text), ((data -> 'qMeta'::text) ->> 'published'::text))) = 'true'::text) AS published
   FROM repmeta_qs.app_objects o;


--
-- Name: v_app_objects_summary; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_app_objects_summary AS
 WITH base AS (
         SELECT v_app_objects.snapshot_id,
            v_app_objects.object_type,
            v_app_objects.published
           FROM repmeta_qs.v_app_objects
        )
 SELECT s.snapshot_id,
    count(*) FILTER (WHERE (b.object_type = 'sheet'::text)) AS total_sheets,
    count(*) FILTER (WHERE (b.object_type = 'story'::text)) AS total_stories,
    count(*) AS total_objects,
    count(*) FILTER (WHERE ((b.object_type = 'sheet'::text) AND b.published)) AS published_sheets,
    count(*) FILTER (WHERE ((b.object_type = 'story'::text) AND b.published)) AS published_stories
   FROM (repmeta_qs.snapshot s
     LEFT JOIN base b ON ((b.snapshot_id = s.snapshot_id)))
  GROUP BY s.snapshot_id;


--
-- Name: v_apps; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_apps AS
 SELECT snapshot_id,
    app_id,
    data,
    COALESCE((data ->> 'name'::text), (data ->> 'appName'::text), (data ->> 'title'::text)) AS app_name,
    COALESCE((data ->> 'stream'::text), (data ->> 'streamName'::text)) AS stream,
    (data ->> 'streamId'::text) AS stream_id,
    (lower((data ->> 'published'::text)) = 'true'::text) AS published
   FROM repmeta_qs.apps a;


--
-- Name: v_streams; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_streams AS
 SELECT snapshot_id,
    stream_id,
    data,
    COALESCE((data ->> 'name'::text), (data ->> 'streamName'::text), (data ->> 'displayName'::text)) AS stream_name
   FROM repmeta_qs.streams s;


--
-- Name: v_app_summary; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_app_summary AS
 WITH apps AS (
         SELECT v_apps.snapshot_id,
            v_apps.app_id,
            v_apps.published,
            v_apps.stream
           FROM repmeta_qs.v_apps
        )
 SELECT snapshot_id,
    ( SELECT count(*) AS count
           FROM apps a
          WHERE (a.snapshot_id = s.snapshot_id)) AS total_apps,
    ( SELECT count(*) AS count
           FROM apps a
          WHERE ((a.snapshot_id = s.snapshot_id) AND a.published)) AS published_apps,
    ( SELECT count(*) AS count
           FROM repmeta_qs.v_streams st
          WHERE (st.snapshot_id = s.snapshot_id)) AS streams,
    ( SELECT count(DISTINCT a.stream) AS count
           FROM apps a
          WHERE ((a.snapshot_id = s.snapshot_id) AND (a.stream IS NOT NULL))) AS streams_with_apps
   FROM repmeta_qs.snapshot s;


--
-- Name: v_counts_by_snapshot; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_counts_by_snapshot AS
 SELECT snapshot_id,
    ( SELECT count(*) AS count
           FROM repmeta_qs.apps t
          WHERE (t.snapshot_id = s.snapshot_id)) AS apps,
    ( SELECT count(*) AS count
           FROM repmeta_qs.app_objects t
          WHERE (t.snapshot_id = s.snapshot_id)) AS app_objects,
    ( SELECT count(*) AS count
           FROM repmeta_qs.streams t
          WHERE (t.snapshot_id = s.snapshot_id)) AS streams,
    ( SELECT count(*) AS count
           FROM repmeta_qs.users t
          WHERE (t.snapshot_id = s.snapshot_id)) AS users,
    ( SELECT count(*) AS count
           FROM repmeta_qs.reload_tasks t
          WHERE (t.snapshot_id = s.snapshot_id)) AS reload_tasks,
    ( SELECT count(*) AS count
           FROM repmeta_qs.extensions t
          WHERE (t.snapshot_id = s.snapshot_id)) AS extensions
   FROM repmeta_qs.snapshot s;


--
-- Name: v_customer; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_customer AS
 SELECT s.snapshot_id,
    s.customer_id,
    COALESCE((to_jsonb(dc.*) ->> 'display_name'::text), (to_jsonb(dc.*) ->> 'customer_name'::text), (to_jsonb(dc.*) ->> 'name'::text), (to_jsonb(dc.*) ->> 'company_name'::text), (to_jsonb(dc.*) ->> 'legal_name'::text), (to_jsonb(dc.*) ->> 'short_name'::text)) AS customer_name
   FROM (repmeta_qs.snapshot s
     LEFT JOIN repmeta.dim_customer dc ON ((dc.customer_id = s.customer_id)));


--
-- Name: v_environment_overview; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_environment_overview AS
 SELECT s.snapshot_id,
    s.customer_id,
    s.created_at,
    s.notes,
    COALESCE((a.data ->> 'productName'::text), (a.data ->> 'ProductName'::text), (a.data ->> 'product'::text), (a.data ->> 'Product'::text)) AS product_name,
    COALESCE((a.data ->> 'productVersion'::text), (a.data ->> 'ProductVersion'::text), (a.data ->> 'version'::text), (a.data ->> 'Version'::text)) AS product_version,
    COALESCE((a.data ->> 'buildVersion'::text), (a.data ->> 'BuildVersion'::text)) AS build_version,
    COALESCE((a.data ->> 'buildDate'::text), (a.data ->> 'BuildDate'::text)) AS build_date,
    ( SELECT count(*) AS count
           FROM repmeta_qs.servernode_config t
          WHERE (t.snapshot_id = s.snapshot_id)) AS node_count,
    ( SELECT count(*) AS count
           FROM repmeta_qs.extensions t
          WHERE (t.snapshot_id = s.snapshot_id)) AS extension_count,
    ( SELECT count(*) AS count
           FROM repmeta_qs.streams t
          WHERE (t.snapshot_id = s.snapshot_id)) AS stream_count,
    ( SELECT count(*) AS count
           FROM repmeta_qs.apps t
          WHERE (t.snapshot_id = s.snapshot_id)) AS app_count,
    ( SELECT count(*) AS count
           FROM repmeta_qs.users t
          WHERE (t.snapshot_id = s.snapshot_id)) AS user_count,
    ( SELECT count(*) AS count
           FROM repmeta_qs.reload_tasks t
          WHERE (t.snapshot_id = s.snapshot_id)) AS reload_task_count,
    (( SELECT count(*) AS count
           FROM repmeta_qs.servernode_config t
          WHERE (t.snapshot_id = s.snapshot_id)) = 1) AS single_node_only
   FROM (((repmeta_qs.snapshot s
     LEFT JOIN repmeta_qs.about a ON ((a.snapshot_id = s.snapshot_id)))
     LEFT JOIN repmeta_qs.system_info si ON ((si.snapshot_id = s.snapshot_id)))
     LEFT JOIN repmeta_qs.license l ON ((l.snapshot_id = s.snapshot_id)));


--
-- Name: v_environment_overview_enriched; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_environment_overview_enriched AS
 SELECT e.snapshot_id,
    e.customer_id,
    e.created_at,
    e.notes,
    e.product_name,
    e.product_version,
    e.build_version,
    e.build_date,
    e.node_count,
    e.extension_count,
    e.stream_count,
    e.app_count,
    e.user_count,
    e.reload_task_count,
    e.single_node_only,
    v.customer_name
   FROM (repmeta_qs.v_environment_overview e
     LEFT JOIN repmeta_qs.v_customer v USING (snapshot_id));


--
-- Name: v_extensions; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_extensions AS
 SELECT snapshot_id,
    extension_id,
    data,
    COALESCE((data ->> 'name'::text), (data ->> 'extensionName'::text)) AS extension_name,
    (lower(COALESCE((data ->> 'isBundled'::text), (data ->> 'bundled'::text))) = 'true'::text) AS is_bundled
   FROM repmeta_qs.extensions e;


--
-- Name: v_extension_summary; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_extension_summary AS
 SELECT snapshot_id,
    ( SELECT count(*) AS count
           FROM repmeta_qs.v_extensions e
          WHERE (e.snapshot_id = s.snapshot_id)) AS total_extensions,
    ( SELECT count(*) AS count
           FROM repmeta_qs.v_extensions e
          WHERE ((e.snapshot_id = s.snapshot_id) AND e.is_bundled)) AS bundled_extensions,
    ( SELECT count(*) AS count
           FROM repmeta_qs.v_extensions e
          WHERE ((e.snapshot_id = s.snapshot_id) AND (NOT e.is_bundled))) AS custom_extensions
   FROM repmeta_qs.snapshot s;


--
-- Name: v_governance_checks; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_governance_checks AS
 WITH app_ids AS (
         SELECT a.snapshot_id,
            a.app_id
           FROM repmeta_qs.v_apps a
        ), task_by_app AS (
         SELECT t.snapshot_id,
            COALESCE(t.app_id, ((t.data -> 'app'::text) ->> 'id'::text)) AS app_id,
                CASE
                    WHEN (lower((t.data ->> 'enabled'::text)) = 'true'::text) THEN true
                    WHEN (lower((t.data ->> 'enabled'::text)) = 'false'::text) THEN false
                    ELSE NULL::boolean
                END AS enabled
           FROM repmeta_qs.reload_tasks t
        )
 SELECT snapshot_id,
    ( SELECT count(*) AS count
           FROM (app_ids a
             LEFT JOIN task_by_app tb ON (((tb.snapshot_id = a.snapshot_id) AND (tb.app_id = a.app_id))))
          WHERE ((a.snapshot_id = s.snapshot_id) AND (tb.app_id IS NULL))) AS apps_without_tasks,
    ( SELECT count(*) AS count
           FROM task_by_app tb
          WHERE ((tb.snapshot_id = s.snapshot_id) AND (tb.enabled = false))) AS disabled_tasks_count
   FROM repmeta_qs.snapshot s;


--
-- Name: v_license_summary; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_license_summary AS
 SELECT s.snapshot_id,
    COALESCE((l.data ->> 'licenseNumber'::text), (l.data ->> 'serial'::text), (l.data ->> 'key'::text), (l.data #>> '{license,number}'::text[])) AS license_number,
    COALESCE((l.data ->> 'controlNumber'::text), (l.data #>> '{control,number}'::text[]), (l.data ->> 'control'::text)) AS control_number,
    COALESCE((l.data ->> 'expiration'::text), (l.data ->> 'expiryDate'::text), (l.data #>> '{expiration,date}'::text[]), (l.data #>> '{license,expires}'::text[])) AS expiration,
    ( SELECT count(*) AS count
           FROM repmeta_qs.access_professional t
          WHERE (t.snapshot_id = s.snapshot_id)) AS professional_allocations,
    ( SELECT count(*) AS count
           FROM repmeta_qs.access_analyzer_time t
          WHERE (t.snapshot_id = s.snapshot_id)) AS analyzer_allocations
   FROM (repmeta_qs.snapshot s
     LEFT JOIN repmeta_qs.license l ON ((l.snapshot_id = s.snapshot_id)));


--
-- Name: v_license_usage_30d; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_license_usage_30d AS
 WITH allocs AS (
         SELECT access_professional.snapshot_id,
            'professional'::text AS kind,
            (access_professional.data ->> 'id'::text) AS alloc_id,
            (COALESCE(NULLIF((access_professional.data ->> 'lastUsed'::text), ''::text), NULLIF((access_professional.data ->> 'lastAccess'::text), ''::text), NULLIF((access_professional.data ->> 'lastSeen'::text), ''::text)))::timestamp with time zone AS last_used
           FROM repmeta_qs.access_professional
        UNION ALL
         SELECT access_analyzer_time.snapshot_id,
            'analyzer'::text AS kind,
            (access_analyzer_time.data ->> 'id'::text),
            (COALESCE(NULLIF((access_analyzer_time.data ->> 'lastUsed'::text), ''::text), NULLIF((access_analyzer_time.data ->> 'lastAccess'::text), ''::text), NULLIF((access_analyzer_time.data ->> 'lastSeen'::text), ''::text)))::timestamp with time zone AS last_used
           FROM repmeta_qs.access_analyzer_time
        ), snapshot_max AS (
         SELECT allocs.snapshot_id,
            max(allocs.last_used) AS max_used
           FROM allocs
          WHERE (allocs.last_used IS NOT NULL)
          GROUP BY allocs.snapshot_id
        ), bucketed AS (
         SELECT allocs.snapshot_id,
            allocs.kind,
                CASE
                    WHEN (allocs.last_used IS NULL) THEN 'never'::text
                    WHEN (allocs.last_used >= (sm.max_used - '30 days'::interval)) THEN 'used_30d'::text
                    ELSE 'not_used_30d'::text
                END AS bucket
           FROM (allocs
             LEFT JOIN snapshot_max sm ON ((sm.snapshot_id = allocs.snapshot_id)))
        )
 SELECT s.snapshot_id,
    COALESCE(sum(((b.bucket = 'used_30d'::text))::integer) FILTER (WHERE (b.kind = 'analyzer'::text)), (0)::bigint) AS analyzer_used_30d,
    COALESCE(sum(((b.bucket = 'not_used_30d'::text))::integer) FILTER (WHERE (b.kind = 'analyzer'::text)), (0)::bigint) AS analyzer_not_used_30d,
    COALESCE(sum(((b.bucket = 'never'::text))::integer) FILTER (WHERE (b.kind = 'analyzer'::text)), (0)::bigint) AS analyzer_never_used,
    COALESCE(sum(((b.bucket = 'used_30d'::text))::integer) FILTER (WHERE (b.kind = 'professional'::text)), (0)::bigint) AS professional_used_30d,
    COALESCE(sum(((b.bucket = 'not_used_30d'::text))::integer) FILTER (WHERE (b.kind = 'professional'::text)), (0)::bigint) AS professional_not_used_30d,
    COALESCE(sum(((b.bucket = 'never'::text))::integer) FILTER (WHERE (b.kind = 'professional'::text)), (0)::bigint) AS professional_never_used
   FROM (repmeta_qs.snapshot s
     LEFT JOIN bucketed b ON ((b.snapshot_id = s.snapshot_id)))
  GROUP BY s.snapshot_id;


--
-- Name: v_nodes; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_nodes AS
 SELECT snapshot_id,
    node_id,
    data
   FROM repmeta_qs.servernode_config n;


--
-- Name: v_reload_activity_json; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_reload_activity_json AS
 WITH raw AS (
         SELECT rt.snapshot_id,
            (NULLIF(((rt.data -> 'app'::text) ->> 'id'::text), ''::text))::uuid AS app_id,
            COALESCE((NULLIF((((rt.data -> 'operational'::text) -> 'lastExecutionResult'::text) ->> 'stopTime'::text), ''::text))::timestamp with time zone, (NULLIF(((rt.data -> 'operational'::text) ->> 'stopTime'::text), ''::text))::timestamp with time zone, (NULLIF((rt.data ->> 'stopTime'::text), ''::text))::timestamp with time zone) AS stop_ts
           FROM repmeta_qs.reload_tasks rt
        ), last_by_app AS (
         SELECT raw.snapshot_id,
            raw.app_id,
            max(raw.stop_ts) AS ts
           FROM raw
          WHERE (raw.stop_ts IS NOT NULL)
          GROUP BY raw.snapshot_id, raw.app_id
        ), snapshot_max AS (
         SELECT last_by_app.snapshot_id,
            max(last_by_app.ts) AS max_stop
           FROM last_by_app
          GROUP BY last_by_app.snapshot_id
        )
 SELECT lba.snapshot_id,
    count(*) FILTER (WHERE (lba.ts >= (sm.max_stop - '30 days'::interval))) AS apps_reloaded_30d,
    count(*) FILTER (WHERE (lba.ts >= (sm.max_stop - '90 days'::interval))) AS apps_reloaded_90d
   FROM (last_by_app lba
     LEFT JOIN snapshot_max sm ON ((sm.snapshot_id = lba.snapshot_id)))
  GROUP BY lba.snapshot_id;


--
-- Name: v_reload_tasks; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_reload_tasks AS
 SELECT snapshot_id,
    task_id,
    app_id,
    data,
    COALESCE((data ->> 'name'::text), (data ->> 'taskName'::text), (data ->> 'appName'::text)) AS task_name,
        CASE
            WHEN (lower((data ->> 'enabled'::text)) = 'true'::text) THEN true
            WHEN (lower((data ->> 'enabled'::text)) = 'false'::text) THEN false
            ELSE NULL::boolean
        END AS enabled,
    COALESCE((NULLIF((data #>> '{operational,lastExecution,durationSec}'::text[]), ''::text))::integer, (NULLIF((data ->> 'lastExecutionDurationSec'::text), ''::text))::integer, (NULLIF((data ->> 'durationSec'::text), ''::text))::integer) AS duration_sec,
    COALESCE(((data #>> '{operational,lastExecution,stopTime}'::text[]))::timestamp with time zone, ((data #>> '{lastExecution,stopTime}'::text[]))::timestamp with time zone, ((data ->> 'lastExecutionStopTime'::text))::timestamp with time zone) AS last_stop_time,
    lower(COALESCE((data #>> '{operational,lastExecution,status}'::text[]), (data ->> 'lastExecutionStatus'::text))) AS last_status
   FROM repmeta_qs.reload_tasks t;


--
-- Name: v_reload_task_summary; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_reload_task_summary AS
 SELECT s.snapshot_id,
    count(*) FILTER (WHERE (rt.task_id IS NOT NULL)) AS total_tasks,
    count(*) FILTER (WHERE ((rt.duration_sec IS NOT NULL) AND (rt.duration_sec > ((3 * 60) * 60)))) AS over_3h,
    count(*) FILTER (WHERE ((rt.duration_sec IS NOT NULL) AND (rt.duration_sec <= ((3 * 60) * 60)))) AS under_3h,
    count(*) FILTER (WHERE (rt.last_status = ANY (ARRAY['failed'::text, 'error'::text]))) AS failed
   FROM (repmeta_qs.snapshot s
     LEFT JOIN repmeta_qs.v_reload_tasks rt ON ((rt.snapshot_id = s.snapshot_id)))
  GROUP BY s.snapshot_id;


--
-- Name: v_security_rule_breakdown; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_security_rule_breakdown AS
 WITH rules AS (
         SELECT system_rules.snapshot_id,
            (COALESCE(NULLIF(lower((system_rules.data ->> 'disabled'::text)), ''::text), 'false'::text) = ANY (ARRAY['true'::text, 't'::text, '1'::text, 'yes'::text, 'y'::text])) AS disabled,
            NULLIF((system_rules.data ->> 'seedId'::text), ''::text) AS seed1,
            NULLIF((system_rules.data ->> 'seedID'::text), ''::text) AS seed2,
            NULLIF(((system_rules.data -> 'references'::text) ->> 'seedId'::text), ''::text) AS seed3,
            lower(COALESCE((system_rules.data ->> 'type'::text), ''::text)) AS ruletype
           FROM repmeta_qs.system_rules
        ), norm AS (
         SELECT rules.snapshot_id,
            rules.disabled,
                CASE
                    WHEN (rules.ruletype = 'custom'::text) THEN true
                    WHEN (COALESCE(rules.seed1, rules.seed2, rules.seed3) IS NULL) THEN true
                    WHEN (COALESCE(rules.seed1, rules.seed2, rules.seed3) = '00000000-0000-0000-0000-000000000000'::text) THEN true
                    ELSE false
                END AS is_custom
           FROM rules
        )
 SELECT snapshot_id,
    count(*) AS total_rules,
    count(*) FILTER (WHERE is_custom) AS custom_total,
    count(*) FILTER (WHERE (is_custom AND (NOT disabled))) AS custom_enabled,
    count(*) FILTER (WHERE (is_custom AND disabled)) AS custom_disabled,
    count(*) FILTER (WHERE (NOT is_custom)) AS default_total,
    count(*) FILTER (WHERE ((NOT is_custom) AND (NOT disabled))) AS default_enabled,
    count(*) FILTER (WHERE ((NOT is_custom) AND disabled)) AS default_disabled
   FROM norm
  GROUP BY snapshot_id;


--
-- Name: v_system_rules; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_system_rules AS
 SELECT snapshot_id,
    rule_id,
    data,
    COALESCE((data ->> 'name'::text), (data ->> 'ruleName'::text)) AS rule_name,
    (lower(COALESCE((data ->> 'disabled'::text), (data ->> 'isDisabled'::text))) = 'true'::text) AS disabled,
    (lower(COALESCE((data ->> 'isReadOnly'::text), (data ->> 'readOnly'::text))) = 'true'::text) AS is_readonly,
    (lower(COALESCE((data ->> 'isDefault'::text), (data ->> 'default'::text))) = 'true'::text) AS is_default
   FROM repmeta_qs.system_rules r;


--
-- Name: v_security_rule_summary; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_security_rule_summary AS
 SELECT s.snapshot_id,
    count(*) FILTER (WHERE (r.rule_id IS NOT NULL)) AS total_rules,
    count(*) FILTER (WHERE ((r.rule_id IS NOT NULL) AND (NOT r.is_default) AND (NOT r.is_readonly))) AS custom_rules,
    count(*) FILTER (WHERE r.is_readonly) AS readonly_rules,
    count(*) FILTER (WHERE r.is_default) AS default_rules,
    count(*) FILTER (WHERE r.disabled) AS disabled_rules
   FROM (repmeta_qs.snapshot s
     LEFT JOIN repmeta_qs.v_system_rules r ON ((r.snapshot_id = s.snapshot_id)))
  GROUP BY s.snapshot_id;


--
-- Name: v_task_execution_summary; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_task_execution_summary AS
 WITH parsed AS (
         SELECT t.snapshot_id,
            t.task_id,
            COALESCE((t.data ->> 'name'::text), (t.data ->> 'taskName'::text), '?'::text) AS task_name,
            ((((t.data -> 'operational'::text) -> 'lastExecutionResult'::text) ->> 'status'::text))::integer AS status,
            (NULLIF((((t.data -> 'operational'::text) -> 'lastExecutionResult'::text) ->> 'stopTime'::text), ''::text))::timestamp with time zone AS stop_time
           FROM repmeta_qs.tasks t
        ), snapshot_max AS (
         SELECT parsed.snapshot_id,
            max(parsed.stop_time) AS max_stop
           FROM parsed
          WHERE (parsed.stop_time IS NOT NULL)
          GROUP BY parsed.snapshot_id
        )
 SELECT p.snapshot_id,
    count(*) AS total_tasks,
    count(*) FILTER (WHERE (p.status IS NOT NULL)) AS tasks_with_results,
    count(*) FILTER (WHERE (p.stop_time >= (sm.max_stop - '30 days'::interval))) AS tasks_run_30d,
    count(*) FILTER (WHERE ((p.stop_time >= (sm.max_stop - '30 days'::interval)) AND (p.status = 7))) AS successful_30d,
    count(*) FILTER (WHERE ((p.stop_time >= (sm.max_stop - '30 days'::interval)) AND (p.status <> 7))) AS failed_30d,
        CASE
            WHEN (count(*) FILTER (WHERE (p.stop_time >= (sm.max_stop - '30 days'::interval))) > 0) THEN round(((100.0 * (count(*) FILTER (WHERE ((p.stop_time >= (sm.max_stop - '30 days'::interval)) AND (p.status = 7))))::numeric) / (count(*) FILTER (WHERE (p.stop_time >= (sm.max_stop - '30 days'::interval))))::numeric), 1)
            ELSE (0)::numeric
        END AS success_pct_30d,
    count(*) FILTER (WHERE (p.status = 7)) AS successful_overall,
    count(DISTINCT p.task_name) FILTER (WHERE ((p.status IS NOT NULL) AND (p.status <> 7))) AS not_successful_overall,
        CASE
            WHEN (count(*) FILTER (WHERE (p.status IS NOT NULL)) > 0) THEN round(((100.0 * (count(*) FILTER (WHERE (p.status = 7)))::numeric) / (count(*) FILTER (WHERE (p.status IS NOT NULL)))::numeric), 1)
            ELSE (0)::numeric
        END AS success_pct_overall,
    count(DISTINCT p.task_name) FILTER (WHERE ((p.status IS NULL) OR (p.status <> 7))) AS never_succeeded_count
   FROM (parsed p
     LEFT JOIN snapshot_max sm ON ((sm.snapshot_id = p.snapshot_id)))
  GROUP BY p.snapshot_id;


--
-- Name: v_users; Type: VIEW; Schema: repmeta_qs; Owner: -
--

CREATE VIEW repmeta_qs.v_users AS
 SELECT snapshot_id,
    user_id,
    data,
    COALESCE((data ->> 'name'::text), (data ->> 'userName'::text), (data ->> 'userId'::text)) AS user_name,
    COALESCE((data ->> 'userDirectory'::text), (data ->> 'directory'::text), (data ->> 'user_directory'::text)) AS user_directory
   FROM repmeta_qs.users u;


--
-- Name: snapshot snapshot_id; Type: DEFAULT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.snapshot ALTER COLUMN snapshot_id SET DEFAULT nextval('repmeta_qs.snapshot_snapshot_id_seq1'::regclass);


--
-- Name: about about_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.about
    ADD CONSTRAINT about_pkey PRIMARY KEY (snapshot_id);


--
-- Name: access_analyzer access_analyzer_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.access_analyzer
    ADD CONSTRAINT access_analyzer_pkey PRIMARY KEY (snapshot_id, access_id);


--
-- Name: access_analyzer_time access_analyzer_time_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.access_analyzer_time
    ADD CONSTRAINT access_analyzer_time_pkey PRIMARY KEY (snapshot_id, access_id);


--
-- Name: access_professional access_professional_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.access_professional
    ADD CONSTRAINT access_professional_pkey PRIMARY KEY (snapshot_id, access_id);


--
-- Name: access_type_info access_type_info_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.access_type_info
    ADD CONSTRAINT access_type_info_pkey PRIMARY KEY (snapshot_id);


--
-- Name: app_object app_object_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.app_object
    ADD CONSTRAINT app_object_pkey PRIMARY KEY (snapshot_id, id);


--
-- Name: app_objects app_objects_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.app_objects
    ADD CONSTRAINT app_objects_pkey PRIMARY KEY (snapshot_id, object_id);


--
-- Name: app app_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.app
    ADD CONSTRAINT app_pkey PRIMARY KEY (snapshot_id, id);


--
-- Name: apps apps_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.apps
    ADD CONSTRAINT apps_pkey PRIMARY KEY (snapshot_id, app_id);


--
-- Name: extension extension_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.extension
    ADD CONSTRAINT extension_pkey PRIMARY KEY (snapshot_id, id);


--
-- Name: extensions extensions_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.extensions
    ADD CONSTRAINT extensions_pkey PRIMARY KEY (snapshot_id, extension_id);


--
-- Name: license license_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.license
    ADD CONSTRAINT license_pkey PRIMARY KEY (snapshot_id);


--
-- Name: reload_task reload_task_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.reload_task
    ADD CONSTRAINT reload_task_pkey PRIMARY KEY (snapshot_id, id);


--
-- Name: reload_tasks reload_tasks_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.reload_tasks
    ADD CONSTRAINT reload_tasks_pkey PRIMARY KEY (snapshot_id, task_id);


--
-- Name: server_config server_config_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.server_config
    ADD CONSTRAINT server_config_pkey PRIMARY KEY (snapshot_id, id);


--
-- Name: server_hardware server_hardware_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.server_hardware
    ADD CONSTRAINT server_hardware_pkey PRIMARY KEY (snapshot_id, hostname);


--
-- Name: servernode_config servernode_config_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.servernode_config
    ADD CONSTRAINT servernode_config_pkey PRIMARY KEY (snapshot_id, node_id);


--
-- Name: snapshot snapshot_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.snapshot
    ADD CONSTRAINT snapshot_pkey PRIMARY KEY (snapshot_id);


--
-- Name: stream stream_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.stream
    ADD CONSTRAINT stream_pkey PRIMARY KEY (snapshot_id, id);


--
-- Name: streams streams_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.streams
    ADD CONSTRAINT streams_pkey PRIMARY KEY (snapshot_id, stream_id);


--
-- Name: system_info system_info_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.system_info
    ADD CONSTRAINT system_info_pkey PRIMARY KEY (snapshot_id);


--
-- Name: system_rule system_rule_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.system_rule
    ADD CONSTRAINT system_rule_pkey PRIMARY KEY (snapshot_id, id);


--
-- Name: system_rules system_rules_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.system_rules
    ADD CONSTRAINT system_rules_pkey PRIMARY KEY (snapshot_id, rule_id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (snapshot_id, task_id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (snapshot_id, id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (snapshot_id, user_id);


--
-- Name: access_analyzer_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX access_analyzer_id_idx ON repmeta_qs.access_analyzer USING btree (access_id);


--
-- Name: access_analyzer_time_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX access_analyzer_time_id_idx ON repmeta_qs.access_analyzer_time USING btree (access_id);


--
-- Name: access_anlz_data_gin; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX access_anlz_data_gin ON repmeta_qs.access_analyzer USING gin (data);


--
-- Name: access_prof_data_gin; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX access_prof_data_gin ON repmeta_qs.access_professional USING gin (data);


--
-- Name: access_professional_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX access_professional_id_idx ON repmeta_qs.access_professional USING btree (access_id);


--
-- Name: app_data_gin; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX app_data_gin ON repmeta_qs.app USING gin (data);


--
-- Name: app_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX app_id_idx ON repmeta_qs.app USING btree (id);


--
-- Name: app_object_app_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX app_object_app_id_idx ON repmeta_qs.app_object USING btree (app_id);


--
-- Name: app_object_data_gin; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX app_object_data_gin ON repmeta_qs.app_object USING gin (data);


--
-- Name: app_object_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX app_object_id_idx ON repmeta_qs.app_object USING btree (id);


--
-- Name: app_objects_app_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX app_objects_app_id_idx ON repmeta_qs.app_objects USING btree (app_id);


--
-- Name: app_objects_data_gin; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX app_objects_data_gin ON repmeta_qs.app_objects USING gin (data);


--
-- Name: app_objects_object_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX app_objects_object_id_idx ON repmeta_qs.app_objects USING btree (object_id);


--
-- Name: apps_app_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX apps_app_id_idx ON repmeta_qs.apps USING btree (app_id);


--
-- Name: apps_data_gin; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX apps_data_gin ON repmeta_qs.apps USING gin (data);


--
-- Name: extension_data_gin; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX extension_data_gin ON repmeta_qs.extension USING gin (data);


--
-- Name: extension_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX extension_id_idx ON repmeta_qs.extension USING btree (id);


--
-- Name: extensions_data_gin; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX extensions_data_gin ON repmeta_qs.extensions USING gin (data);


--
-- Name: extensions_extension_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX extensions_extension_id_idx ON repmeta_qs.extensions USING btree (extension_id);


--
-- Name: reload_task_data_gin; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX reload_task_data_gin ON repmeta_qs.reload_task USING gin (data);


--
-- Name: reload_task_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX reload_task_id_idx ON repmeta_qs.reload_task USING btree (id);


--
-- Name: reload_tasks_app_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX reload_tasks_app_id_idx ON repmeta_qs.reload_tasks USING btree (app_id);


--
-- Name: reload_tasks_data_gin; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX reload_tasks_data_gin ON repmeta_qs.reload_tasks USING gin (data);


--
-- Name: reload_tasks_task_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX reload_tasks_task_id_idx ON repmeta_qs.reload_tasks USING btree (task_id);


--
-- Name: server_config_data_gin; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX server_config_data_gin ON repmeta_qs.server_config USING gin (data);


--
-- Name: server_config_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX server_config_id_idx ON repmeta_qs.server_config USING btree (id);


--
-- Name: servernode_config_data_gin; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX servernode_config_data_gin ON repmeta_qs.servernode_config USING gin (data);


--
-- Name: servernode_config_node_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX servernode_config_node_id_idx ON repmeta_qs.servernode_config USING btree (node_id);


--
-- Name: snapshot_customer_created_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX snapshot_customer_created_idx ON repmeta_qs.snapshot USING btree (customer_id, created_at DESC);


--
-- Name: stream_data_gin; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX stream_data_gin ON repmeta_qs.stream USING gin (data);


--
-- Name: stream_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX stream_id_idx ON repmeta_qs.stream USING btree (id);


--
-- Name: streams_data_gin; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX streams_data_gin ON repmeta_qs.streams USING gin (data);


--
-- Name: streams_stream_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX streams_stream_id_idx ON repmeta_qs.streams USING btree (stream_id);


--
-- Name: system_rule_data_gin; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX system_rule_data_gin ON repmeta_qs.system_rule USING gin (data);


--
-- Name: system_rule_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX system_rule_id_idx ON repmeta_qs.system_rule USING btree (id);


--
-- Name: system_rules_data_gin; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX system_rules_data_gin ON repmeta_qs.system_rules USING gin (data);


--
-- Name: system_rules_rule_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX system_rules_rule_id_idx ON repmeta_qs.system_rules USING btree (rule_id);


--
-- Name: tasks_snapshot_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX tasks_snapshot_id_idx ON repmeta_qs.tasks USING btree (snapshot_id);


--
-- Name: tasks_task_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX tasks_task_id_idx ON repmeta_qs.tasks USING btree (task_id);


--
-- Name: user_data_gin; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX user_data_gin ON repmeta_qs."user" USING gin (data);


--
-- Name: user_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX user_id_idx ON repmeta_qs."user" USING btree (id);


--
-- Name: users_data_gin; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX users_data_gin ON repmeta_qs.users USING gin (data);


--
-- Name: users_user_id_idx; Type: INDEX; Schema: repmeta_qs; Owner: -
--

CREATE INDEX users_user_id_idx ON repmeta_qs.users USING btree (user_id);


--
-- Name: about about_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.about
    ADD CONSTRAINT about_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: access_analyzer access_analyzer_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.access_analyzer
    ADD CONSTRAINT access_analyzer_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: access_analyzer_time access_analyzer_time_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.access_analyzer_time
    ADD CONSTRAINT access_analyzer_time_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: access_professional access_professional_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.access_professional
    ADD CONSTRAINT access_professional_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: app_object app_object_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.app_object
    ADD CONSTRAINT app_object_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: app_objects app_objects_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.app_objects
    ADD CONSTRAINT app_objects_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: app app_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.app
    ADD CONSTRAINT app_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: apps apps_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.apps
    ADD CONSTRAINT apps_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: extension extension_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.extension
    ADD CONSTRAINT extension_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: extensions extensions_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.extensions
    ADD CONSTRAINT extensions_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: license license_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.license
    ADD CONSTRAINT license_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: reload_task reload_task_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.reload_task
    ADD CONSTRAINT reload_task_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: reload_tasks reload_tasks_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.reload_tasks
    ADD CONSTRAINT reload_tasks_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: server_config server_config_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.server_config
    ADD CONSTRAINT server_config_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: server_hardware server_hardware_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.server_hardware
    ADD CONSTRAINT server_hardware_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: servernode_config servernode_config_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.servernode_config
    ADD CONSTRAINT servernode_config_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: stream stream_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.stream
    ADD CONSTRAINT stream_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: streams streams_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.streams
    ADD CONSTRAINT streams_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: system_info system_info_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.system_info
    ADD CONSTRAINT system_info_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: system_rule system_rule_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.system_rule
    ADD CONSTRAINT system_rule_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: system_rules system_rules_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.system_rules
    ADD CONSTRAINT system_rules_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: tasks tasks_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.tasks
    ADD CONSTRAINT tasks_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: user user_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs."user"
    ADD CONSTRAINT user_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- Name: users users_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: repmeta_qs; Owner: -
--

ALTER TABLE ONLY repmeta_qs.users
    ADD CONSTRAINT users_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshot(snapshot_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict Sy2BNyK9hIWiQuZSlf8RarxPsw3ofJOrWeg3HWdBVFLJ3xBUcjyno6VBYIYjRsy

