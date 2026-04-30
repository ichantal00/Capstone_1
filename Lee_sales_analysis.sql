-- Questions -- ==============================================================
-- 1.What is total revenue overall for sales in the assigned territory, plus the start date and end date
-- that tell you what period the data covers

-- 2.What is the month by month revenue breakdown for the sales territory?

-- 3.Provide a comparison of total revenue for the specific sales territory and the region it belongs to.

-- 4.What is the number of transactions per month and average transaction size by product category 
-- for the sales territory?

-- 5.Can you provide a ranking of in-store sales performance by each store in the sales territory, 
-- or a ranking of online sales performance by state within an online sales territory?

-- 6.What is your recommendation for where to focus sales attention in the next quarter?

USE sample_sales;
-- =================================================================
-- Start Date and END Date -- 

-- EAST --

SELECT SUM(sale_amount) AS total_revenue,
MIN(transaction_date) AS start_date,
MAX(transaction_date) AS end_date, region
FROM store_sales
INNER JOIN store_locations
ON store_sales.store_id = store_locations.storeid
INNER JOIN store_managers
ON store_managers.state = store_locations.state
WHERE region = 'east';

-- Online--
SELECT MAX(date) AS End_Date,
MIN(date) AS Start_Date
FROM online_sales;

-- ================================================================
-- -- Breakdown for Store_Managers --#1 
SELECT SUM(sale_amount) AS total_revenue,
store_manager
FROM store_sales
INNER JOIN store_locations
ON store_sales.store_id = store_locations.storeid
INNER JOIN store_managers
ON store_managers.state = store_locations.state
GROUP BY store_manager; -- 

-- =====================================================================
-- -- CONNECTICUT -- --
--  Price Breakdown -- 
SELECT sale_amount AS total_revenue,
storeid, state
FROM store_sales
INNER JOIN store_locations
ON store_sales.store_id = store_locations.storeid
WHERE state = 'Connecticut';

-- Connecticut SUM
SELECT SUM(sale_amount) AS total_revenue,
ROUND(AVG(sale_amount),2) AS average_revenue
FROM store_sales
INNER JOIN store_locations
ON store_sales.store_id = store_locations.storeid
WHERE state = 'Connecticut'; -- total = '2,392,222.44', average = '137.66'


-- ================================================================
-- -- NEW YORK -- -- 

-- Breakdown price individuals -- 
SELECT sale_amount AS total_revenue,
storeid, state
FROM store_sales
INNER JOIN store_locations
ON store_sales.store_id = store_locations.storeid
WHERE state = 'New York';

-- New York SUM and Average
SELECT SUM(sale_amount) AS total_revenue,
ROUND(AVG(sale_amount),2) AS average_revenue
FROM store_sales
INNER JOIN store_locations
ON store_sales.store_id = store_locations.storeid
WHERE state = 'New York'; -- total = '4,330,817.09', average = '139.53'

-- ======================================================================

-- IN STORE --
-- Month by Month -- 

-- Connecticut --
SELECT DATE_FORMAT(Transaction_Date, '%Y-%m') AS month,
    ROUND(SUM(sale_amount), 2) AS total_revenue
FROM store_sales
INNER JOIN store_locations
ON store_sales.Store_ID = store_locations.StoreID
WHERE state = 'Connecticut'
GROUP BY month
ORDER BY month;

-- New York --
SELECT DATE_FORMAT(Transaction_Date, '%Y-%m') AS month,
    ROUND(SUM(sale_amount), 2) AS total_revenue
FROM store_sales
INNER JOIN store_locations
ON store_sales.Store_ID = store_locations.StoreID
WHERE state = 'New York'
GROUP BY month
ORDER BY month;

-- -- General East -- --
SELECT DATE_FORMAT(Transaction_Date, '%Y-%m') AS month,
    ROUND(SUM(sale_amount), 2) AS total_revenue
FROM store_sales
INNER JOIN store_locations
ON store_sales.Store_ID = store_locations.StoreID
INNER JOIN store_managers
ON store_locations.state = store_managers.State
WHERE region = 'East'
GROUP BY month
ORDER BY month;

-- ===============================================================
-- Online sales by month and years
SELECT DATE_FORMAT(Date, '%Y-%m') AS month,
    ROUND(SUM(salestotal), 2) AS total_revenue
FROM online_sales
GROUP BY month
ORDER BY month;

select count(prodNum) from online_sales;

-- =====================================================================
-- Select All's for added information --
SELECT *
FROM inventory_categories;

SELECT *
FROM store_locations;

SELECT *
FROM inventory_subcategories;

SELECT *
FROM store_sales;

SELECT *
FROM products;

SELECT *
FROM online_sales;

-- ===============================================================================
-- Store products --

-- Product price Breakdown -- Connecticut --
SELECT product, 
sale_amount, state, id, storeid
FROM products
JOIN store_sales
ON products.ProdNum = store_sales.Prod_Num
JOIN store_locations
ON store_sales.store_id = store_locations.storeid
WHERE state = 'connecticut';

-- Common products -- Connecticut --
SELECT COUNT(product), state, product
FROM products
JOIN store_sales
ON products.ProdNum = store_sales.Prod_Num
JOIN store_locations
ON store_sales.Store_ID = store_locations.StoreID
WHERE state = 'Connecticut'
Group by product;

-- Product price Breakdown -- New York --
SELECT product, 
sale_amount, state, id, storeid
FROM products
JOIN store_sales
ON products.ProdNum = store_sales.Prod_Num
JOIN store_locations
ON store_sales.store_id = store_locations.storeid
WHERE state = 'new york';

-- Common products -- New York --
SELECT COUNT(product), state, product
FROM products
JOIN store_sales
ON products.ProdNum = store_sales.Prod_Num
JOIN store_locations
ON store_sales.Store_ID = store_locations.StoreID
WHERE state = 'New York'
Group by product;

-- -- Extra Curious =============================================
-- -- Online sales shipped to the east
-- ONLINE sales to Connecticut
SELECT product, shiptostate
FROM products
JOIN online_sales
ON products.ProdNum = online_sales.ProdNum
WHERE shiptostate = 'Connecticut';

-- ONLINE Common Products -- Connecticut --
SELECT COUNT(product), shiptostate, product
FROM products
JOIN online_sales
ON products.ProdNum = online_sales.ProdNum
WHERE shiptostate = 'Connecticut'
Group by product;

-- ONLINE sales to NEW YORK
SELECT product, shiptostate
FROM products
JOIN online_sales
ON products.ProdNum = online_sales.ProdNum
WHERE shiptostate = 'New York';

-- ONLINE Common Products -- New York --
SELECT COUNT(product), shiptostate, product
FROM products
JOIN online_sales
ON products.ProdNum = online_sales.ProdNum
WHERE shiptostate = 'New York'
Group by product;












