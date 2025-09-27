Task 4: SQL for Data Analysis
Dataset: Online Retail II
Tool: PostgreSQL


Step 1: Create database (run outside if not already created)
CREATE DATABASE ecommerce_db;

Step 2: Connect to database
\c ecommerce_db

Step 3: Drop table if exists
DROP TABLE IF EXISTS online_retail;

Step 4: Create table
CREATE TABLE online_retail (
    invoice       TEXT,
    stock_code    TEXT,
    description   TEXT,
    quantity      INT,
    invoice_date  TIMESTAMP,
    unit_price    NUMERIC(10,2),
    customer_id   TEXT,
    country       TEXT
);

Step 5: Load CSV (update path if needed!)
Run this inside psql, not pgAdmin
Change file path to where CSV is saved
Example: C:/Users/reshw/Documents/sql_data/online_retail_II.csv
\copy online_retail(invoice, stock_code, description, quantity, invoice_date, unit_price, customer_id, country)
FROM 'C:/Users/reshw/Documents/sql_data/online_retail_II.csv'
CSV HEADER;

(a) SELECT, WHERE, ORDER BY, GROUP BY


Select invoices from UK customers
SELECT invoice, customer_id, country
FROM online_retail
WHERE country = 'United Kingdom'
ORDER BY invoice_date DESC
LIMIT 10;

Total revenue per country
SELECT country, SUM(quantity * unit_price) AS revenue
FROM online_retail
GROUP BY country
ORDER BY revenue DESC
LIMIT 10;

(b) JOINS (INNER, LEFT, RIGHT)
 Create a temporary product lookup table
CREATE TEMP TABLE products AS
SELECT DISTINCT stock_code, description
FROM online_retail;

INNER JOIN
SELECT r.invoice, p.description, r.quantity, r.unit_price
FROM online_retail r
INNER JOIN products p
ON r.stock_code = p.stock_code
LIMIT 10;

LEFT JOIN
SELECT r.invoice, r.stock_code, p.description
FROM online_retail r
LEFT JOIN products p
ON r.stock_code = p.stock_code
LIMIT 10;

RIGHT JOIN
SELECT p.stock_code, p.description, r.invoice
FROM online_retail r
RIGHT JOIN products p
ON r.stock_code = p.stock_code
LIMIT 10;

(c) Subqueries
 Customers who spent more than 5000 total
SELECT customer_id, total_spent
FROM (
    SELECT customer_id, SUM(quantity * unit_price) AS total_spent
    FROM online_retail
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
) AS sub
WHERE total_spent > 5000
ORDER BY total_spent DESC;

(d) Aggregate functions (SUM, AVG)
Average order value
SELECT AVG(order_total) AS avg_order_value
FROM (
    SELECT invoice, SUM(quantity * unit_price) AS order_total
    FROM online_retail
    GROUP BY invoice
) AS orders;
 Total quantity sold per product
SELECT description, SUM(quantity) AS total_quantity
FROM online_retail
GROUP BY description
ORDER BY total_quantity DESC
LIMIT 10;


(e) Views for analysis
Create a view for monthly revenue
CREATE OR REPLACE VIEW monthly_revenue AS
SELECT DATE_TRUNC('month', invoice_date) AS month,
       SUM(quantity * unit_price) AS revenue
FROM online_retail
GROUP BY month
ORDER BY month;

Use the view
SELECT * FROM monthly_revenue LIMIT 12;


(f) Optimize queries with indexes
Index on customer_id
CREATE INDEX idx_customer_id ON online_retail(customer_id);

Index on invoice_date
CREATE INDEX idx_invoice_date ON online_retail(invoice_date);


 END 

