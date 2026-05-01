-- Questions -- ==============================================================
-- 1.What is total revenue overall for sales in the assigned territory, plus the start date and end date
-- that tell you what period the data covers

-- === Answer: Line 32 ========----

-- 2.What is the month by month revenue breakdown for the sales territory?

-- === Answer: Line 124  ========----

-- 3.Provide a comparison of total revenue for the specific sales territory and the region it belongs to.

-- === Answer: Line 32, Line 70, Line 90,  ========----

-- 4.What is the number of transactions per month and average transaction size by product category 
-- for the sales territory?

-- === Answer: Line 257 and Line 227 ========----

-- 5.Can you provide a ranking of in-store sales performance by each store in the sales territory, 
-- or a ranking of online sales performance by state within an online sales territory?

-- === Answer: Line 240 ========----

-- 6.What is your recommendation for where to focus sales attention in the next quarter?
-- === Answer:   ========----
USE sample_sales;
-- =================================================================
-- Start Date and END Date -- East vs. Online --

-- EAST --

SELECT SUM(sale_amount) AS total_revenue,
MIN(transaction_date) AS start_date,
MAX(transaction_date) AS end_date, region,
AVG(sale_amount) AS average_revenue
FROM store_sales
INNER JOIN store_locations
ON store_sales.store_id = store_locations.storeid
INNER JOIN store_managers
ON store_managers.state = store_locations.state
WHERE region = 'east'; -- Total '6,723,039.53', '2022-01-01', '2025-12-31', 'East', Average '138.85'


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
-- -- CONNECTICUT -- -- Overall Sale -- Breakdowns

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
-- -- NEW YORK -- -- Overall Sale Amount -- Breakdown

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
FROM store_salesD
INNER JOIN store_locations
ON store_sales.store_id = store_locations.storeid
WHERE state = 'New York'; -- total = '4,330,817.09', average = '139.53'

-- ======================================================================

-- IN STORE --
-- Overall Sale -- -- Month by Month -- 

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

SELECT *
FROM shipper_list;

-- ===============================================================================
-- Store Products -- Breakdown -- Common Products

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

-- is this showing me the most commonly purchased items in new york
-- -- ======================================================================
-- +++++++  AVG transaction amount by product category

SELECT avg(sale_amount), category
FROM store_sales
JOIN products
ON store_sales.Prod_Num = products.ProdNum
JOIN inventory_categories
ON inventory_categories.Categoryid = Products.Categoryid
Group by category;


--     AVG transaction amount By territory
SELECT avg(sale_amount) as 'Average Sales', category, region
FROM store_sales
JOIN products
ON store_sales.Prod_Num = products.ProdNum
JOIN inventory_categories
ON inventory_categories.Categoryid = Products.Categoryid
JOIN store_list 
ON store_list.Store_ID = store_sales.Store_ID
JOIN management
ON management.State = store_list.state
WHERE Region = 'EAST'
Group by category 
ORDER BY category ASC;

-- ================================================================================
-- Rank by Store by total sales in the eastern region --

SELECT SUM(sale_amount) AS Total_Sales, ss.Store_ID, sl.state, m.Region
FROM store_sales ss
JOIN store_list sl
ON ss.Store_ID = sl.store_ID
JOIN management m
ON sl.State = m.State
 WHERE Region = 'EAST'
 group by m.region, ss.store_id, sl.state
 ORDER BY Total_sales DESC;


-- =============================================================================
-- # of transactions per month -- -- and year --

-- Month --
SELECT EXTRACT(MONTH FROM transaction_date) AS month,
COUNT(transaction_date) AS total_transactions
FROM store_sales
INNER JOIN store_locations
ON store_sales.Store_ID = store_locations.StoreID
INNER JOIN store_managers
ON store_locations.state = store_managers.State
WHERE region = 'East'
GROUP BY EXTRACT(MONTH FROM transaction_date)
ORDER BY month;

-- Month and Year --
SELECT DATE_FORMAT(transaction_date, '%Y-%m') AS month,
COUNT(transaction_date) AS total_transactions
FROM store_sales
INNER JOIN store_locations
ON store_sales.Store_ID = store_locations.StoreID
INNER JOIN store_managers
ON store_locations.state = store_managers.State
WHERE region = 'East'
GROUP BY month
ORDER BY month;

-- 
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

-- year by category --

SELECT 
    EXTRACT(YEAR FROM s.transaction_date) AS year,
    c.category,
    SUM(s.sale_amount) AS total_sales
FROM store_sales s
JOIN products p
    ON s.Prod_Num = p.ProdNum
JOIN inventory_categories c
    ON c.Categoryid = p.Categoryid
JOIN store_list sl
    ON sl.Store_ID = s.Store_ID
JOIN management m
    ON m.State = sl.State
WHERE m.Region = 'EAST'
GROUP BY year, c.category
ORDER BY year, total_sales DESC;

-- ====================================================================
-- category, city, and state breakdowns ---

-- Connecticut --
SELECT SUM(sale_amount), store_list.store_id, city, state, category
FROM store_sales 
JOIN store_list
ON store_sales.Store_ID = store_list.Store_ID
JOIN products
ON store_sales.Prod_Num = products.ProdNum
JOIN Inventory_categories
ON inventory_categories.Categoryid = products.Categoryid
WHERE state = 'Connecticut'
GROUP BY category, Store_ID;

SELECT SUM(sale_amount), store_list.store_id, city, state, category
FROM store_sales 
JOIN store_list
ON store_sales.Store_ID = store_list.Store_ID
JOIN products
ON store_sales.Prod_Num = products.ProdNum
JOIN Inventory_categories
ON inventory_categories.Categoryid = products.Categoryid
WHERE state = 'New York'
GROUP BY category, Store_ID;
-- percentages --

SELECT store_list.store_id,
    category,
    SUM(sale_amount) / SUM(SUM(sale_amount)) OVER (PARTITION BY store_id) AS category_percentage
FROM store_sales 
JOIN store_list
ON store_sales.Store_ID = store_list.Store_ID
JOIN products
ON store_sales.Prod_Num = products.ProdNum
JOIN Inventory_categories
ON inventory_categories.Categoryid = products.Categoryid
WHERE state = 'Connecticut'
GROUP BY category, Store_ID;


SELECT store_list.store_id,
    category,
    SUM(sale_amount) / SUM(SUM(sale_amount)) OVER (PARTITION BY store_id) AS category_percentage
FROM store_sales 
JOIN store_list
ON store_sales.Store_ID = store_list.Store_ID
JOIN products
ON store_sales.Prod_Num = products.ProdNum
JOIN Inventory_categories
ON inventory_categories.Categoryid = products.Categoryid
WHERE state = 'New York'
GROUP BY category, Store_ID;