SELECT
    c.customer_id
FROM customer_contracts c
JOIN products p
ON c.product_id = p.product_id
GROUP BY c.customer_id
HAVING COUNT(DISTINCT p.product_category) =
(
    SELECT COUNT(DISTINCT product_category)
    FROM products
);