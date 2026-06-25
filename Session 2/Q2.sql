WITH max_date AS (
    SELECT MAX(DATE(event_time)) AS latest_date
    FROM search_events
),

user_segments AS (
    SELECT
        a.user_id,
        CASE
            WHEN a.registration_date >= (
                SELECT latest_date - INTERVAL '30 days'
                FROM max_date
            )
            THEN 'new'
            ELSE 'existing'
        END AS user_segment
    FROM accounts a
),

searches AS (
    SELECT
        se.user_id,
        se.event_time AS search_time
    FROM search_events se
    WHERE se.event_type = 'search'
),

search_results AS (
    SELECT
        s.user_id,
        s.search_time,
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM search_events c
                WHERE c.user_id = s.user_id
                  AND c.event_type = 'click'
                  AND c.event_time > s.search_time
                  AND c.event_time <= s.search_time + INTERVAL '30 seconds'
            )
            THEN 1
            ELSE 0
        END AS successful_search
    FROM searches s
)

SELECT
    us.user_segment,
    COUNT(*) AS total_searches,
    SUM(sr.successful_search) AS successful_searches,
    ROUND(
        100.0 * SUM(sr.successful_search) / COUNT(*),
        2
    ) AS success_rate
FROM search_results sr
JOIN user_segments us
    ON sr.user_id = us.user_id
GROUP BY us.user_segment
ORDER BY us.user_segment;