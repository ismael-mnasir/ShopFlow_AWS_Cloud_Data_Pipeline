-- ============================================================
-- ShopFlow Analytics — Amazon Athena SQL Queries
-- Database: shopflow_db
-- Table: raw_data
-- Output Location: s3://ismael-shopflow-2026/athena-results/
-- ============================================================

-- QUESTION 3.1: Retrieve all records where total order value (quantity * price) > £100
SELECT 
    customer_name, 
    product, 
    (CAST(quantity AS INT) * CAST(price AS DOUBLE)) AS total_order_value
FROM "shopflow_db"."raw_data"
WHERE (CAST(quantity AS INT) * CAST(price AS DOUBLE)) > 100
ORDER BY total_order_value DESC;


-- QUESTION 3.2: Return total revenue per product, sorted from highest to lowest
SELECT 
    product, 
    SUM(CAST(price AS DOUBLE) * CAST(quantity AS INT)) AS total_revenue,
    SUM(CAST(quantity AS INT)) AS total_units_sold
FROM "shopflow_db"."raw_data"
GROUP BY product
ORDER BY total_revenue DESC;

-- RESULT FINDINGS:
-- Question 3.1 Result: Multiple orders exceeded £100 total value.
-- Question 3.2 Result: The "Standing Desk" generated the highest revenue (£498.00).
