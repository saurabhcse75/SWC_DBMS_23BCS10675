WITH s AS (
    SELECT
        product_id,
        product_name,
        month_start,

        monthly_active_users AS m4,

        LAG(monthly_active_users, 1) OVER (
            PARTITION BY product_id
            ORDER BY month_start
        ) AS m3,

        LAG(monthly_active_users, 2) OVER (
            PARTITION BY product_id
            ORDER BY month_start
        ) AS m2,

        LAG(monthly_active_users, 3) OVER (
            PARTITION BY product_id
            ORDER BY month_start
        ) AS m1,

        LAG(month_start, 3) OVER (
            PARTITION BY product_id
            ORDER BY month_start
        ) AS decline_start_month,

        LEAD(monthly_active_users, 1) OVER (
            PARTITION BY product_id
            ORDER BY month_start
        ) AS m5,

        LEAD(monthly_active_users, 2) OVER (
            PARTITION BY product_id
            ORDER BY month_start
        ) AS m6,

        LEAD(monthly_active_users, 3) OVER (
            PARTITION BY product_id
            ORDER BY month_start
        ) AS m7,

        LEAD(month_start, 1) OVER (
            PARTITION BY product_id
            ORDER BY month_start
        ) AS growth_resume_month
    FROM product_engagement
)

SELECT
    product_name,
    decline_start_month,
    growth_resume_month,
    ROUND(
        ((m7 - m4)::numeric) / NULLIF(m4, 0),
        4
    ) AS growth_ratio
FROM s
WHERE
    m1 > m2
    AND m2 > m3
    AND m3 > m4
    AND m4 < m5
    AND m5 < m6
    AND m6 < m7
ORDER BY product_name;