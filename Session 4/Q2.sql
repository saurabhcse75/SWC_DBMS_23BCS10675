WITH valid_tasks AS (
    SELECT DISTINCT
        task_id,
        start_time,
        end_time
    FROM task_schedule
    WHERE start_time IS NOT NULL
      AND end_time IS NOT NULL
),

events AS (
    SELECT
        start_time AS event_time,
        1 AS delta
    FROM valid_tasks

    UNION ALL

    SELECT
        end_time AS event_time,
        -1 AS delta
    FROM valid_tasks
),

running AS (
    SELECT
        SUM(delta) OVER (
            ORDER BY event_time, delta
            ROWS UNBOUNDED PRECEDING
        ) AS active_cpus
    FROM events
)

SELECT MAX(active_cpus) AS min_cpus_required
FROM running;