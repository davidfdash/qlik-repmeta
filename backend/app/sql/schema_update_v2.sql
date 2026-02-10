-- Schema update to support new ingested files
-- Run this after the initial schema is created

-- Create schema if not exists
CREATE SCHEMA IF NOT EXISTS repmeta_qs;

-- Streams table (QlikStream.json)
CREATE TABLE IF NOT EXISTS repmeta_qs.streams (
    snapshot_id int4 NOT NULL,
    stream_id text NOT NULL,
    data jsonb NOT NULL,
    CONSTRAINT streams_pkey PRIMARY KEY (snapshot_id, stream_id)
);

-- Access Analyzer table (QlikAnalyzerAccessType.json)
CREATE TABLE IF NOT EXISTS repmeta_qs.access_analyzer (
    snapshot_id int4 NOT NULL,
    access_id text NOT NULL,
    data jsonb NOT NULL,
    CONSTRAINT access_analyzer_pkey PRIMARY KEY (snapshot_id, access_id)
);

-- Access Analyzer Time table (QlikAnalyzerTimeAccessType.json) - if not exists
CREATE TABLE IF NOT EXISTS repmeta_qs.access_analyzer_time (
    snapshot_id int4 NOT NULL,
    access_id text NOT NULL,
    data jsonb NOT NULL,
    CONSTRAINT access_analyzer_time_pkey PRIMARY KEY (snapshot_id, access_id)
);

-- Access Professional table (QlikProfessionalAccessType.json) - if not exists
CREATE TABLE IF NOT EXISTS repmeta_qs.access_professional (
    snapshot_id int4 NOT NULL,
    access_id text NOT NULL,
    data jsonb NOT NULL,
    CONSTRAINT access_professional_pkey PRIMARY KEY (snapshot_id, access_id)
);

-- Server Hardware table (OSInfo_*.json from Hardware folder)
CREATE TABLE IF NOT EXISTS repmeta_qs.server_hardware (
    snapshot_id int4 NOT NULL,
    hostname text NOT NULL,
    data jsonb NOT NULL,
    CONSTRAINT server_hardware_pkey PRIMARY KEY (snapshot_id, hostname)
);

-- Add foreign key constraints if snapshots table exists
DO $$
BEGIN
    -- streams -> snapshots
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'streams_snapshot_id_fkey'
    ) THEN
        BEGIN
            ALTER TABLE repmeta_qs.streams
            ADD CONSTRAINT streams_snapshot_id_fkey
            FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshots(snapshot_id) ON DELETE CASCADE;
        EXCEPTION WHEN undefined_table THEN
            -- snapshots table doesn't exist, try alternate name
            BEGIN
                ALTER TABLE repmeta_qs.streams
                ADD CONSTRAINT streams_snapshot_id_fkey
                FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs."snapshot"(snapshot_id) ON DELETE CASCADE;
            EXCEPTION WHEN undefined_table THEN
                NULL; -- No snapshots table, skip FK
            END;
        END;
    END IF;

    -- access_analyzer -> snapshots
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'access_analyzer_snapshot_id_fkey'
    ) THEN
        BEGIN
            ALTER TABLE repmeta_qs.access_analyzer
            ADD CONSTRAINT access_analyzer_snapshot_id_fkey
            FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshots(snapshot_id) ON DELETE CASCADE;
        EXCEPTION WHEN undefined_table THEN
            BEGIN
                ALTER TABLE repmeta_qs.access_analyzer
                ADD CONSTRAINT access_analyzer_snapshot_id_fkey
                FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs."snapshot"(snapshot_id) ON DELETE CASCADE;
            EXCEPTION WHEN undefined_table THEN
                NULL;
            END;
        END;
    END IF;

    -- access_analyzer_time -> snapshots
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'access_analyzer_time_snapshot_id_fkey'
    ) THEN
        BEGIN
            ALTER TABLE repmeta_qs.access_analyzer_time
            ADD CONSTRAINT access_analyzer_time_snapshot_id_fkey
            FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshots(snapshot_id) ON DELETE CASCADE;
        EXCEPTION WHEN undefined_table THEN
            BEGIN
                ALTER TABLE repmeta_qs.access_analyzer_time
                ADD CONSTRAINT access_analyzer_time_snapshot_id_fkey
                FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs."snapshot"(snapshot_id) ON DELETE CASCADE;
            EXCEPTION WHEN undefined_table THEN
                NULL;
            END;
        END;
    END IF;

    -- access_professional -> snapshots
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'access_professional_snapshot_id_fkey'
    ) THEN
        BEGIN
            ALTER TABLE repmeta_qs.access_professional
            ADD CONSTRAINT access_professional_snapshot_id_fkey
            FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshots(snapshot_id) ON DELETE CASCADE;
        EXCEPTION WHEN undefined_table THEN
            BEGIN
                ALTER TABLE repmeta_qs.access_professional
                ADD CONSTRAINT access_professional_snapshot_id_fkey
                FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs."snapshot"(snapshot_id) ON DELETE CASCADE;
            EXCEPTION WHEN undefined_table THEN
                NULL;
            END;
        END;
    END IF;

    -- server_hardware -> snapshots
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'server_hardware_snapshot_id_fkey'
    ) THEN
        BEGIN
            ALTER TABLE repmeta_qs.server_hardware
            ADD CONSTRAINT server_hardware_snapshot_id_fkey
            FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshots(snapshot_id) ON DELETE CASCADE;
        EXCEPTION WHEN undefined_table THEN
            BEGIN
                ALTER TABLE repmeta_qs.server_hardware
                ADD CONSTRAINT server_hardware_snapshot_id_fkey
                FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs."snapshot"(snapshot_id) ON DELETE CASCADE;
            EXCEPTION WHEN undefined_table THEN
                NULL;
            END;
        END;
    END IF;
END $$;

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_streams_snapshot_id ON repmeta_qs.streams(snapshot_id);
CREATE INDEX IF NOT EXISTS idx_access_analyzer_snapshot_id ON repmeta_qs.access_analyzer(snapshot_id);
CREATE INDEX IF NOT EXISTS idx_access_analyzer_time_snapshot_id ON repmeta_qs.access_analyzer_time(snapshot_id);
CREATE INDEX IF NOT EXISTS idx_access_professional_snapshot_id ON repmeta_qs.access_professional(snapshot_id);
CREATE INDEX IF NOT EXISTS idx_server_hardware_snapshot_id ON repmeta_qs.server_hardware(snapshot_id);

-- Index on lastUsed for license usage queries
CREATE INDEX IF NOT EXISTS idx_access_professional_last_used
ON repmeta_qs.access_professional((data->>'lastUsed'));

CREATE INDEX IF NOT EXISTS idx_access_analyzer_last_used
ON repmeta_qs.access_analyzer((data->>'lastUsed'));

-- Tasks table (QlikTask.json — all task types: ReloadTask + ExternalProgramTask)
CREATE TABLE IF NOT EXISTS repmeta_qs.tasks (
    snapshot_id int4 NOT NULL,
    task_id text NOT NULL,
    data jsonb NOT NULL,
    CONSTRAINT tasks_pkey PRIMARY KEY (snapshot_id, task_id)
);

CREATE INDEX IF NOT EXISTS idx_tasks_snapshot_id ON repmeta_qs.tasks(snapshot_id);

-- FK for tasks -> snapshots
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'tasks_snapshot_id_fkey'
    ) THEN
        BEGIN
            ALTER TABLE repmeta_qs.tasks
            ADD CONSTRAINT tasks_snapshot_id_fkey
            FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs.snapshots(snapshot_id) ON DELETE CASCADE;
        EXCEPTION WHEN undefined_table THEN
            BEGIN
                ALTER TABLE repmeta_qs.tasks
                ADD CONSTRAINT tasks_snapshot_id_fkey
                FOREIGN KEY (snapshot_id) REFERENCES repmeta_qs."snapshot"(snapshot_id) ON DELETE CASCADE;
            EXCEPTION WHEN undefined_table THEN
                NULL;
            END;
        END;
    END IF;
END $$;

-- View: Task execution summary per snapshot
-- Status codes: 7=FinishedSuccess, 8=FinishedFail, 9=Skipped, 11=Error
-- 30-day window anchored to MAX(stopTime) in the snapshot (data may be historical)
CREATE OR REPLACE VIEW repmeta_qs.v_task_execution_summary AS
WITH parsed AS (
    SELECT
        t.snapshot_id,
        t.task_id,
        COALESCE(t.data->>'name', t.data->>'taskName', '?') AS task_name,
        (t.data->'operational'->'lastExecutionResult'->>'status')::int AS status,
        NULLIF(t.data->'operational'->'lastExecutionResult'->>'stopTime','')::timestamptz AS stop_time
    FROM repmeta_qs.tasks t
),
snapshot_max AS (
    SELECT snapshot_id, MAX(stop_time) AS max_stop
    FROM parsed
    WHERE stop_time IS NOT NULL
    GROUP BY snapshot_id
)
SELECT
    p.snapshot_id,
    COUNT(*) AS total_tasks,
    COUNT(*) FILTER (WHERE p.status IS NOT NULL) AS tasks_with_results,
    COUNT(*) FILTER (WHERE p.stop_time >= sm.max_stop - interval '30 days') AS tasks_run_30d,
    COUNT(*) FILTER (WHERE p.stop_time >= sm.max_stop - interval '30 days' AND p.status = 7) AS successful_30d,
    COUNT(*) FILTER (WHERE p.stop_time >= sm.max_stop - interval '30 days' AND p.status != 7) AS failed_30d,
    CASE
        WHEN COUNT(*) FILTER (WHERE p.stop_time >= sm.max_stop - interval '30 days') > 0
        THEN ROUND(100.0 * COUNT(*) FILTER (WHERE p.stop_time >= sm.max_stop - interval '30 days' AND p.status = 7)
             / COUNT(*) FILTER (WHERE p.stop_time >= sm.max_stop - interval '30 days'), 1)
        ELSE 0
    END AS success_pct_30d,
    COUNT(*) FILTER (WHERE p.status = 7) AS successful_overall,
    COUNT(*) FILTER (WHERE p.status IS NOT NULL AND p.status != 7) AS not_successful_overall,
    CASE
        WHEN COUNT(*) FILTER (WHERE p.status IS NOT NULL) > 0
        THEN ROUND(100.0 * COUNT(*) FILTER (WHERE p.status = 7)
             / COUNT(*) FILTER (WHERE p.status IS NOT NULL), 1)
        ELSE 0
    END AS success_pct_overall,
    COUNT(DISTINCT p.task_name) FILTER (WHERE p.status IS NULL OR p.status != 7) AS never_succeeded_count
FROM parsed p
LEFT JOIN snapshot_max sm ON sm.snapshot_id = p.snapshot_id
GROUP BY p.snapshot_id;

-- Update v_reload_activity_json: anchor to MAX(stop_ts) instead of now()
CREATE OR REPLACE VIEW repmeta_qs.v_reload_activity_json
AS WITH raw AS (
         SELECT rt.snapshot_id,
            NULLIF((rt.data -> 'app'::text) ->> 'id'::text, ''::text)::uuid AS app_id,
            COALESCE(NULLIF(((rt.data -> 'operational'::text) -> 'lastExecutionResult'::text) ->> 'stopTime'::text, ''::text)::timestamp with time zone, NULLIF((rt.data -> 'operational'::text) ->> 'stopTime'::text, ''::text)::timestamp with time zone, NULLIF(rt.data ->> 'stopTime'::text, ''::text)::timestamp with time zone) AS stop_ts
           FROM repmeta_qs.reload_tasks rt
        ), last_by_app AS (
         SELECT raw.snapshot_id,
            raw.app_id,
            max(raw.stop_ts) AS ts
           FROM raw
          WHERE raw.stop_ts IS NOT NULL
          GROUP BY raw.snapshot_id, raw.app_id
        ), snapshot_max AS (
         SELECT last_by_app.snapshot_id, MAX(last_by_app.ts) AS max_stop
           FROM last_by_app
          GROUP BY last_by_app.snapshot_id
        )
 SELECT lba.snapshot_id,
    count(*) FILTER (WHERE lba.ts >= (sm.max_stop - '30 days'::interval)) AS apps_reloaded_30d,
    count(*) FILTER (WHERE lba.ts >= (sm.max_stop - '90 days'::interval)) AS apps_reloaded_90d
   FROM last_by_app lba
   LEFT JOIN snapshot_max sm ON sm.snapshot_id = lba.snapshot_id
  GROUP BY lba.snapshot_id;

-- Update v_license_usage_30d: anchor to MAX(last_used) instead of now()
CREATE OR REPLACE VIEW repmeta_qs.v_license_usage_30d
AS WITH allocs AS (
         SELECT access_professional.snapshot_id,
            'professional'::text AS kind,
            access_professional.data ->> 'id'::text AS alloc_id,
            COALESCE(NULLIF(access_professional.data ->> 'lastUsed'::text, ''::text), NULLIF(access_professional.data ->> 'lastAccess'::text, ''::text), NULLIF(access_professional.data ->> 'lastSeen'::text, ''::text))::timestamp with time zone AS last_used
           FROM repmeta_qs.access_professional
        UNION ALL
         SELECT access_analyzer_time.snapshot_id,
            'analyzer'::text AS kind,
            access_analyzer_time.data ->> 'id'::text,
            COALESCE(NULLIF(access_analyzer_time.data ->> 'lastUsed'::text, ''::text), NULLIF(access_analyzer_time.data ->> 'lastAccess'::text, ''::text), NULLIF(access_analyzer_time.data ->> 'lastSeen'::text, ''::text))::timestamp with time zone AS last_used
           FROM repmeta_qs.access_analyzer_time
        ), snapshot_max AS (
         SELECT allocs.snapshot_id, MAX(allocs.last_used) AS max_used
           FROM allocs
          WHERE allocs.last_used IS NOT NULL
          GROUP BY allocs.snapshot_id
        ), bucketed AS (
         SELECT allocs.snapshot_id,
            allocs.kind,
                CASE
                    WHEN allocs.last_used IS NULL THEN 'never'::text
                    WHEN allocs.last_used >= (sm.max_used - '30 days'::interval) THEN 'used_30d'::text
                    ELSE 'not_used_30d'::text
                END AS bucket
           FROM allocs
           LEFT JOIN snapshot_max sm ON sm.snapshot_id = allocs.snapshot_id
        )
 SELECT s.snapshot_id,
    COALESCE(sum((b.bucket = 'used_30d'::text)::integer) FILTER (WHERE b.kind = 'analyzer'::text), 0::bigint) AS analyzer_used_30d,
    COALESCE(sum((b.bucket = 'not_used_30d'::text)::integer) FILTER (WHERE b.kind = 'analyzer'::text), 0::bigint) AS analyzer_not_used_30d,
    COALESCE(sum((b.bucket = 'never'::text)::integer) FILTER (WHERE b.kind = 'analyzer'::text), 0::bigint) AS analyzer_never_used,
    COALESCE(sum((b.bucket = 'used_30d'::text)::integer) FILTER (WHERE b.kind = 'professional'::text), 0::bigint) AS professional_used_30d,
    COALESCE(sum((b.bucket = 'not_used_30d'::text)::integer) FILTER (WHERE b.kind = 'professional'::text), 0::bigint) AS professional_not_used_30d,
    COALESCE(sum((b.bucket = 'never'::text)::integer) FILTER (WHERE b.kind = 'professional'::text), 0::bigint) AS professional_never_used
   FROM repmeta_qs.snapshot s
     LEFT JOIN bucketed b ON b.snapshot_id = s.snapshot_id
  GROUP BY s.snapshot_id;
