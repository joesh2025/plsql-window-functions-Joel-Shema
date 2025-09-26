-- RANK(): Assigns rank to products within each region and quarter
-- DENSE_RANK(): Same as RANK() but without gaps in ranking sequence
-- PARTITION BY: Divides data into regions and quarters for separate ranking
SELECT 
    p.name AS product_name,
    c.region,
    EXTRACT(QUARTER FROM t.sale_date) AS quarter,
    SUM(t.amount) AS total_sales,
    RANK() OVER (PARTITION BY c.region, EXTRACT(QUARTER FROM t.sale_date) 
                 ORDER BY SUM(t.amount) DESC) AS sales_rank,
    DENSE_RANK() OVER (PARTITION BY c.region, EXTRACT(QUARTER FROM t.sale_date) 
                      ORDER BY SUM(t.amount) DESC) AS dense_rank,
    ROW_NUMBER() OVER (PARTITION BY c.region, EXTRACT(QUARTER FROM t.sale_date) 
                      ORDER BY SUM(t.amount) DESC) AS row_num
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
JOIN products p ON t.product_id = p.product_id
GROUP BY p.name, c.region, EXTRACT(QUARTER FROM t.sale_date)
ORDER BY region, quarter, sales_rank;










-- SUM() OVER(): Calculates running total of monthly sales
-- ROWS UNBOUNDED PRECEDING: Includes all rows from start to current row
-- GROUP BY: Aggregates data by month before window function calculation
SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') AS month,
    SUM(amount) AS monthly_sales,
    -- Running total from January to current month
    SUM(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM') 
                          ROWS UNBOUNDED PRECEDING) AS running_total,
    -- 3-month moving average for trend analysis
    AVG(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM')
                          ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3mon
FROM transactions
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY month;









-- LAG(): Accesses data from previous row in the ordered result set
-- Useful for calculating month-over-month growth percentages
-- WITH clause: Creates temporary result set for monthly sales data
WITH monthly_sales AS (
    SELECT 
        TO_CHAR(sale_date, 'YYYY-MM') AS month,
        SUM(amount) AS total_sales,
        COUNT(*) AS transaction_count
    FROM transactions
    GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
)
SELECT 
    month,
    total_sales,
    -- Previous month's sales for comparison
    LAG(total_sales, 1) OVER (ORDER BY month) AS previous_month_sales,
    -- Calculate percentage growth from previous month
    ROUND(((total_sales - LAG(total_sales, 1) OVER (ORDER BY month)) 
           / LAG(total_sales, 1) OVER (ORDER BY month)) * 100, 2) AS growth_percentage,
    -- Look ahead to next month's sales
    LEAD(total_sales, 1) OVER (ORDER BY month) AS next_month_sales
FROM monthly_sales
ORDER BY month;








-- Customer spending quartiles (corrected)
WITH customer_spending AS (
    SELECT 
        c.customer_id,
        c.name,
        c.region,
        SUM(t.amount) AS total_spent
    FROM transactions t
    JOIN customers c ON t.customer_id = c.customer_id
    GROUP BY c.customer_id, c.name, c.region
)
SELECT 
    customer_id,
    name,
    region,
    total_spent,
    NTILE(4) OVER (ORDER BY total_spent DESC) AS spending_quartile,
    ROUND(CUME_DIST() OVER (ORDER BY total_spent) * 100, 2) AS cumulative_distribution
FROM customer_spending
ORDER BY total_spent DESC;










-- Top 5 routes per region/quarter using RANK()
WITH ranked_products AS (
    SELECT 
        p.name AS product_name,
        c.region,
        EXTRACT(QUARTER FROM t.sale_date) AS quarter,
        SUM(t.amount) AS total_sales,
        RANK() OVER (PARTITION BY c.region, EXTRACT(QUARTER FROM t.sale_date) 
                     ORDER BY SUM(t.amount) DESC) AS sales_rank
    FROM transactions t
    JOIN customers c ON t.customer_id = c.customer_id
    JOIN products p ON t.product_id = p.product_id
    GROUP BY p.name, c.region, EXTRACT(QUARTER FROM t.sale_date)
)
SELECT 
    product_name,
    region,
    quarter,
    total_sales,
    sales_rank
FROM ranked_products
WHERE sales_rank <= 5
ORDER BY region, quarter, sales_rank;





-- Top 5 routes per region/quarter using RANK()
WITH ranked_products AS (
    SELECT 
        p.name AS product_name,
        c.region,
        EXTRACT(QUARTER FROM t.sale_date) AS quarter,
        SUM(t.amount) AS total_sales,
        RANK() OVER (PARTITION BY c.region, EXTRACT(QUARTER FROM t.sale_date) 
                     ORDER BY SUM(t.amount) DESC) AS sales_rank
    FROM transactions t
    JOIN customers c ON t.customer_id = c.customer_id
    JOIN products p ON t.product_id = p.product_id
    GROUP BY p.name, c.region, EXTRACT(QUARTER FROM t.sale_date)
)
SELECT 
    product_name,
    region,
    quarter,
    total_sales,
    sales_rank
FROM ranked_products
WHERE sales_rank <= 5
ORDER BY region, quarter, sales_rank;

SELECT 
    c.customer_id,
    c.name,
    c.region,
    SUM(t.amount) AS total_spent,
    NTILE(4) OVER (ORDER BY SUM(t.amount) DESC) AS spending_quartile
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.customer_id, c.name, c.region
ORDER BY total_spent DESC;



SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') AS month,
    SUM(amount) AS monthly_sales,
    AVG(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM') 
                          ROWS 2 PRECEDING) AS moving_avg_3mon
FROM transactions
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY month;


WITH sales_summary AS (
    SELECT 
        p.name AS product_name,
        c.region,
        TO_CHAR(t.sale_date, 'Q') AS quarter,
        SUM(t.amount) AS total_sales
    FROM transactions t
    JOIN customers c ON t.customer_id = c.customer_id
    JOIN products p ON t.product_id = p.product_id
    GROUP BY p.name, c.region, TO_CHAR(t.sale_date, 'Q')
)
SELECT 
    product_name,
    region,
    quarter,
    total_sales,
    RANK() OVER (PARTITION BY region, quarter ORDER BY total_sales DESC) AS sales_rank
FROM sales_summary
ORDER BY region, quarter, sales_rank;




SELECT * FROM (
    SELECT 
        p.name AS product_name,
        c.region,
        TO_CHAR(t.sale_date, 'Q') AS quarter,
        SUM(t.amount) AS total_sales,
        RANK() OVER (PARTITION BY c.region, TO_CHAR(t.sale_date, 'Q') 
                     ORDER BY SUM(t.amount) DESC) AS sales_rank
    FROM transactions t
    JOIN customers c ON t.customer_id = c.customer_id
    JOIN products p ON t.product_id = p.product_id
    GROUP BY p.name, c.region, TO_CHAR(t.sale_date, 'Q')
)
WHERE sales_rank <= 5
ORDER BY region, quarter, sales_rank;


ER DIAGRAM - Ritco Rwanda Ticket System
=======================================

customers                    transactions                    products
+-------------------+       +------------------------+      +-------------------+
| customer_id (PK)  |       | transaction_id (PK)    |      | product_id (PK)   |
| name              |1    M | customer_id (FK) ------|----->| name              |
| region            |<------| product_id (FK)  ------|----->| category          |
|                   |       | sale_date              |      |                   |
|                   |       | amount                 |      |                   |
+-------------------+       +------------------------+      +-------------------+




-- Generate DDL for your existing tables
SELECT DBMS_METADATA.GET_DDL('TABLE', table_name) 
FROM user_tables 
WHERE table_name IN ('CUSTOMERS', 'PRODUCTS', 'TRANSACTIONS');