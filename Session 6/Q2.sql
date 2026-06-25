WITH cte AS (
    SELECT
        user_id,
        spend,
        transaction_date,
        ROW_NUMBER() OVER(
            PARTITION BY user_id
            ORDER BY transaction_date
        ) AS rn
    FROM transactions
)
SELECT
    user_id,
    spend,
    transaction_date
FROM cte
WHERE rn = 3;