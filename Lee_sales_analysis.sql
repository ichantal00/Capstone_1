USE sample_sales;

-- What is total revenue overall for sales in the assigned territory, plus the start date and end date
-- that tell you what period the data covers

SELECT SUM(sale_amount) AS Total_Revenue,
MIN(transaction_date) AS Start_Date,
MAX(transaction_date) AS End_Date
FROM store_sales
INNER JOIN management
ON store_sales.id = management.id
WHERE region = 'east';

-- What is the month by month revenue breakdown for the sales territory?

SELECT SUM(sale_amount) AS total_revenue,
transaction_date
FROM store_sales
INNER JOIN management
ON store_sales.id = management.id
WHERE region = 'east'
GROUP BY transaction_date;

-- -- Breakdown by Store_Manager #1 Connecticut
SELECT SUM(sale_amount) AS total_revenue,
transaction_date
FROM store_sales
INNER JOIN management
ON store_sales.id = management.id
WHERE salesmanager = 'Ellen Lemon'
GROUP BY transaction_date; -- $144

-- Breakdown price individuals -- 
SELECT sale_amount AS total_revenue,
storeid
FROM store_sales
INNER JOIN store_locations
ON store_sales.id = store_locations.storeid
WHERE state = 'Connecticut';

-- Connecticut SUM
SELECT SUM(sale_amount) AS total_revenue
FROM store_sales
INNER JOIN store_locations
ON store_sales.id = store_locations.storeid
WHERE state = 'Connecticut'; -- 831.98


-- Breakdown by Store_Manager #2 New York
SELECT SUM(sale_amount) AS total_revenue,
transaction_date
FROM store_sales
INNER JOIN management
ON store_sales.id = management.id
WHERE salesmanager = 'See Ellefson'
GROUP BY transaction_date; -- $8

-- Breakdown price individuals -- 
SELECT sale_amount AS total_revenue,
storeid
FROM store_sales
INNER JOIN store_locations
ON store_sales.id = store_locations.storeid
WHERE state = 'New York';

-- New York SUM
SELECT SUM(sale_amount) AS total_revenue
FROM store_sales
INNER JOIN store_locations
ON store_sales.id = store_locations.storeid
WHERE state = 'New York'; -- 467.61


-- Online sales by month
SELECT 
    EXTRACT(MONTH FROM date) AS month,
    ROUND(SUM(salestotal),2) AS total_revenue
FROM online_sales
GROUP BY month
ORDER BY month;

-- Online sales by month and years
SELECT 
    DATE_FORMAT(Date, '%Y-%m') AS month,
    ROUND(SUM(salestotal), 2) AS total_revenue
FROM online_sales
GROUP BY month
ORDER BY month;

-- Select All's for added information --
SELECT *
FROM inventory_categories;

SELECT *
FROM store_locations

SELECT *
FROM inventory_subcategories;

SELECT *
FROM store_sales;

SELECT *
FROM products;

SELECT *
FROM online_sales;

-- Store Sales for East --
SELECT product
FROM products
JOIN store_sales
ON products.ProdNum = store_sales.Prod_Num
JOIN regional_directors
ON store_sales.id = regional_directors.id
WHERE Region = 'east';



-- -- Extra Curious
-- -- Online sales shipped to the east
-- ONLINE sales to Connecticut
SELECT product, shiptostate
FROM products
JOIN online_sales
ON products.ProdNum = online_sales.ProdNum
WHERE shiptostate = 'Connecticut';

-- ONLINE sales to NEW YORK
SELECT product, shiptostate
FROM products
JOIN online_sales
ON products.ProdNum = online_sales.ProdNum
WHERE shiptostate = 'New York';
