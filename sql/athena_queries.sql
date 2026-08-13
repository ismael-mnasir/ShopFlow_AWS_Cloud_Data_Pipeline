-- Query 1: Calculate total revenue and units sold by product
SELECT 
    product, 
    SUM(CAST(price AS DOUBLE) * CAST(quantity AS INT)) AS total_revenue,
    SUM(CAST(quantity AS INT)) AS total_units_sold
FROM "shopflow_db"."raw_data"
GROUP BY product
ORDER BY total_revenue DESC;

-- Query 2: Total sales metrics overview
SELECT 
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(CAST(quantity AS INT)) AS total_items_sold,
    ROUND(SUM(CAST(price AS DOUBLE) * CAST(quantity AS INT)), 2) AS grand_total_revenue
FROM "shopflow_db"."raw_data";