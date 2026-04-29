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
WHERE region = 'east' AND
GROUP BY transaction_date;

-- Breakdown by Store_Manager #1 Connecticut
SELECT SUM(sale_amount) AS total_revenue,
transaction_date
FROM store_sales
INNER JOIN management
ON store_sales.id = management.id
WHERE salesmanager = 'Ellen Lemon'
GROUP BY transaction_date; -- $144

-- Breakdown by Store_Manager #2 New York
SELECT SUM(sale_amount) AS total_revenue,
transaction_date
FROM store_sales
INNER JOIN management
ON store_sales.id = management.id
WHERE salesmanager = 'See Ellefson'
GROUP BY transaction_date; -- $8

-- Online sales still trying to group by month
SELECT ROUND(SUM(salestotal),2) AS total_revenue,
Date
FROM online_sales
GROUP BY date(mm); -- $8