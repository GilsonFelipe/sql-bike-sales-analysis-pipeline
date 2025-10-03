/*
===============================================================================================
EXPLORATORY DATA ANALYSIS:
===============================================================================================

What We Covers:
	- Dimension Exploration
	- Date Range Exploration
	- KPI Exploration
	- Magnitude Exploration
	- Ranking Exploration
*/

USE Data_Warehouse
GO

/*
===============================================================================================
1. DIMENSION EXPLORATION
===============================================================================================

Purpose:
	Explore the dimension data in the tables
*/

-- Retrieve a list of unique country from which the customers from

SELECT DISTINCT country
FROM gold.dim_customers
ORDER BY country

-- Retrieve a list of unique gender of the customers recorded in the datasets

SELECT DISTINCT gender
FROM gold.dim_customers
ORDER BY gender

-- Retrieve a list of unique marital status of the customers recorded in the datasets

SELECT DISTINCT marital_status
FROM gold.dim_customers
ORDER BY marital_status

-- Retrieve a list of unique category, and subcategory of the products

SELECT DISTINCT 
	category,
	subcategory
from gold.dim_products

/*
===============================================================================================
2. DATE RANGE EXPLORATION
===============================================================================================

Purpose:
	Explore the date range of the date data in the datasets
*/

-- Explore the oldest order and the newest order

SELECT
	MIN(order_date) AS oldest_order,
	MAX(order_date) AS newest_order
FROM gold.fact_sales_details

-- Explore the duration of the order in year, month, and day

SELECT
	CAST(DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS nvarchar) + ' years' AS duration_year,
	CAST(DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS nvarchar) + ' months' AS duration_month,
	CAST(DATEDIFF(DAY, MIN(order_date), MAX(order_date)) AS nvarchar) + ' days' AS duration_day
FROM gold.fact_sales_details

-- Explore the oldest and the youngest customers by the birthdate data

SELECT
	CAST(DATEDIFF(YEAR, MIN(birth_date), GETDATE()) AS nvarchar) + ' Year Old' AS youngest_customer,
	CAST(DATEDIFF(YEAR, MAX(birth_date), GETDATE()) AS nvarchar) + ' Year Old' AS oldest_customer
FROM gold.dim_customers

/*
===============================================================================================
3. KPI EXPLORATION
===============================================================================================

Purpose:
	- Calculate aggregated metrics to get quick insight about key performance index (KPI)
	- Exploring metrics data to spot anomalies and trends
*/

-- Generate e report that shows all the KPIs in one table/output

SELECT
	'Total Sales' as KPI,
	SUM(sales) AS measures
FROM gold.fact_sales_details
UNION ALL
SELECT 
	'Number of Item Sold',
	SUM(quantity)
FROM gold.fact_sales_details
UNION ALL
SELECT 
	'Average Selling Price',
	AVG(price)
FROM gold.fact_sales_details
UNION ALL
SELECT 
	'Total Number of Order',
	COUNT(order_number)
FROM gold.fact_sales_details
UNION ALL
SELECT 
	'Total Number of Unique Order',
	COUNT(DISTINCT order_number)
FROM gold.fact_sales_details
UNION ALL
SELECT 
	'Total Number of Customers',
	COUNT(customer_key)
FROM gold.dim_customers
UNION ALL
SELECT 
	'Total Number of Customers Having Placed Order',
	COUNT(customer_key)
FROM gold.fact_sales_details
UNION ALL
SELECT 
	'Total Number of Products',
	COUNT(product_key) AS nr_of_products
FROM gold.dim_products

/*
===============================================================================================
4. MAGNITUDE EXPLORATION
===============================================================================================

Purpose:
	- Calculate aggregated metrics by a group of dimension
	- Understanding performance distribution by specific dimension
*/

-- Explore total sales of each country

SELECT
	c.country,
	SUM(sales) AS total_sales
FROM gold.fact_sales_details as sd
LEFT JOIN gold.dim_customers as c
ON sd.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_sales DESC

-- Explore total sales of each category of products

SELECT
	p.category,
	SUM(sales) AS total_sales
FROM gold.fact_sales_details as sd
LEFT JOIN gold.dim_products as p
ON sd.product_key = p.product_key
GROUP BY p.category
ORDER BY SUM(sales) DESC

-- Explore total customers by country

SELECT
	country,
	COUNT(customer_key) AS total_customer
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customer DESC

/*
===============================================================================================
5. RANKING EXPLORATION
===============================================================================================

Purpose:
	- Explore the top and bottom perfromance by category
	- Explore the most or the lesst impactful item or category based on performance or metric
*/

-- Explore top 5 products by revenue

SELECT TOP 5
	p.product_name,
	SUM(sd.sales) AS total_revenue
FROM gold.fact_sales_details AS sd
LEFT JOIN gold.dim_products AS p
ON sd.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

-- Explore 5 product with worst performace in revenue

SELECT TOP 5
	p.product_name,
	SUM(sd.sales) AS total_revenue
FROM gold.fact_sales_details AS sd
LEFT JOIN gold.dim_products AS p
ON sd.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC

-- Explore 10 customers with the highest generated revenue

SELECT TOP 10
	CONCAT(ISNULL(c.first_name, ''), ' ', ISNULL(c.last_name, '')) AS customer_name,
	SUM(SALES) AS total_revenue
FROM gold.fact_sales_details AS sd
LEFT JOIN gold.dim_customers AS c
ON sd.customer_key = c.customer_key
GROUP BY CONCAT(ISNULL(c.first_name, ''), ' ', ISNULL(c.last_name, ''))
ORDER BY total_revenue DESC

-- Explore 10 customers with the worst generated revenue

SELECT TOP 10
	CONCAT(ISNULL(c.first_name, ''), ' ', ISNULL(c.last_name, '')) AS customer_name,
	SUM(SALES) AS total_revenue
FROM gold.fact_sales_details AS sd
LEFT JOIN gold.dim_customers AS c
ON sd.customer_key = c.customer_key
GROUP BY CONCAT(ISNULL(c.first_name, ''), ' ', ISNULL(c.last_name, ''))
ORDER BY total_revenue ASC

-- Explore top 10 customers with the most number of order

SELECT TOP 10
	CONCAT(ISNULL(c.first_name, ''), ' ', ISNULL(c.last_name, '')) AS customer_name,
	COUNT(sd.order_number) AS total_order
FROM gold.fact_sales_details AS sd
LEFT JOIN gold.dim_customers AS c
ON sd.customer_key = c.customer_key
GROUP BY CONCAT(ISNULL(c.first_name, ''), ' ', ISNULL(c.last_name, ''))
ORDER BY total_order DESC
