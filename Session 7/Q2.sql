WITH channel_stats AS (
    SELECT
        advertising_channel,
        MAX(money_spent) AS max_yearly_spending
    FROM uber_advertising
    GROUP BY advertising_channel
    HAVING MIN(customers_acquired) > 1500
)
SELECT advertising_channel
FROM channel_stats
ORDER BY max_yearly_spending
LIMIT 1;