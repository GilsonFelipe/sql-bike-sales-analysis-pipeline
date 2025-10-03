/*
====================================================================================================
ADVANCE ANALYSIS
====================================================================================================

What we cover:
- Sales & performance growth overtime analysis.
- Customer segmentation & behaviors analysis.
- Product performance & profitability analysis.
- Sales channel & order fulfillment efficiency analysis.
- Performance benchmarking & cumulative analysis.

Problem Question:
1. How are total sales trending over time?  
2. What is the YoY or MoM growth rate?  
3. Which months/quarters contribute the most to sales?  
4. What is the Average Order Value (AOV) and how has it changed over time?  
5. Who are the top customers by revenue contribution (Pareto 80/20)?  
6. How do customer segments (marital status, gender) affect behavior?  
7. What is the customer retention rate (repeat vs. one-time buyers)?  
8. Are there geographic sales trends?  
9. Which products generate the highest revenue and profit?  
10. Which product categories perform best?  
11. Is there a product cannibalization effect?  
12. What is the sales mix of high/mid/low-cost products?  
13. What is the average order processing and delivery time?  
14. How concentrated is revenue among top customers?  
15. How concentrated is revenue among top products? 
*/

USE Data_Warehouse
GO

/*
==================================================================================
1. How are total sales trending over time? 
==================================================================================
*/

SELECT
	YEAR(order_date) AS year,
	LEFT(DATENAME(MONTH, order_date), 3) AS month,
	SUM(sales) AS total_sales
FROM gold.fact_sales_details
WHERE order_date IS NOT NULL
GROUP BY 
	YEAR(order_date),
	LEFT(DATENAME(MONTH, order_date), 3),
	DATEPART(MONTH, order_date)
ORDER BY YEAR(order_date) ASC, DATEPART(MONTH, order_date) ASC;

/*
==================================================================================
2. What is the YoY or MoM growth rate? 
==================================================================================
*/
-- Growth: Percentage sales difference between current time unit and previous time unit
-- Formula = (current sales - previous sales / previous sales) * 100%

-- YoY
WITH
yoy AS(
SELECT
	YEAR(order_date) AS year,
	SUM(sales) AS total_sales
FROM gold.fact_sales_details
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
),
performance_yoy AS(SELECT
	year,
	total_sales,
	total_sales - LAG(total_sales) OVER (ORDER BY year ASC) AS sales_diff
FROM yoy
)
SELECT
	year,
	total_sales,
	sales_diff,
	CAST(ROUND(CAST(sales_diff AS float) / CAST(LAG(total_sales) OVER (ORDER BY year ASC) AS float) * 100, 2) AS nvarchar) + '%' AS percentage_diff
FROM performance_yoy;

-- MoM
WITH mom AS (
SELECT
	YEAR(order_date) AS order_year,
	LEFT(DATENAME(MONTH, order_date), 3) AS order_month,
	SUM(sales) AS total_sales,
	SUM(sales) - LAG(SUM(sales)) OVER (ORDER BY YEAR(order_date) ASC, DATEPART(MONTH, order_date) asc) sales_different,
	DATEPART(MONTH, order_date) AS month_number
FROM gold.fact_sales_details
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date),
		LEFT(DATENAME(MONTH, order_date), 3),
		DATEPART(MONTH, order_date)
)
SELECT
	order_year,
	order_month,
	total_sales,
	sales_different,
	CAST(ROUND(CAST(sales_different AS float) / CAST(LAG(total_sales) OVER (ORDER BY order_year ASC, month_number ASC) AS float) * 100, 2) AS nvarchar) + '%' AS different_percentage
FROM mom

/*
==================================================================================
3. Which months/quarters contribute the most to sales? 
==================================================================================
*/
-- Analyzing the seasonality performance

SELECT
	DATENAME(MONTH, order_date) AS month,
	SUM(sales)AS total_sales
FROM gold.fact_sales_details
WHERE order_date IS NOT NULL
GROUP BY DATENAME(MONTH, order_date), DATEPART(MONTH, order_date)
ORDER BY DATEPART(MONTH, order_date) ASC

/*
==================================================================================
4. What is the Average Order Value (AOV) and how has it changed over time?
==================================================================================
*/

SELECT
	YEAR(order_date) AS order_year,
	LEFT(DATENAME(MONTH, order_date), 3) AS order_month,
	ROUND(CAST(SUM(sales) AS float) / CAST(COUNT(order_number) AS float), 2) average_order_value
FROM gold.fact_sales_details
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), LEFT(DATENAME(MONTH, order_date), 3), DATEPART(MONTH, order_date)
ORDER BY YEAR(order_date) ASC, DATEPART(MONTH, order_date) ASC

/*
==================================================================================
5. Who are the top customers by revenue contribution (Pareto 80/20)? 
==================================================================================
*/
-- Pareto Rules: 80% of sales comes from 20% of customers
-- We will analyze is this satisfied or not

WITH 
pareto AS (
SELECT
	c.customer_key,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	SUM(s.sales) AS revenue_generated
FROM gold.fact_sales_details As s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key, CONCAT(c.first_name, ' ', c.last_name)
),
revenue_cont AS (SELECT
	customer_name,
	revenue_generated,
	SUM(revenue_generated) OVER () AS revenue_total,
	CAST(revenue_generated AS float) / CAST(SUM(revenue_generated) OVER () AS float) * 100 AS revenue_contribution
FROM pareto),
pareto_2 AS (
SELECT
	customer_name,
	revenue_generated,
	revenue_total,
	revenue_contribution,
	ROUND(SUM(revenue_contribution) OVER (ORDER BY revenue_generated DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS cumulative_revenue_contribution
FROM revenue_cont
)
SELECT
	ROW_NUMBER() OVER (ORDER BY revenue_generated DESC) AS row_index,
	customer_name,
	revenue_generated,
	revenue_total,
	revenue_contribution,
	CAST(cumulative_revenue_contribution AS nvarchar) + '%' AS cumulative_revenue_contribution
FROM pareto_2
WHERE cumulative_revenue_contribution <= 80

/*
==================================================================================
6. How do customer segments (marital status, gender) affect behavior?
==================================================================================
*/
-- Segment the customer by its marital status and gender.
-- Analyze the behavior by comparing metrcis of each segmentation.

-- 1. Gender
WITH gender_segmentation AS(
SELECT
	c.gender AS gender,
	s.sales,
	s.sales - s.quantity*p.product_cost AS profit,
	s.order_number,
	SUM(s.sales) OVER () AS total_revenue,
	COUNT(order_number) OVER () AS total_order
FROM gold.fact_sales_details AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE c.gender <> 'n/a'
)
SELECT
	gender,
	SUM(sales) AS revenue_generated,
	SUM(profit) AS total_profit,
	COUNT(order_number) AS order_count,
	ROUND(CAST(SUM(sales) AS float)/ CAST(COUNT(order_number) AS float), 2) AS avg_order_value,
	CAST(ROUND(CAST(SUM(sales) AS float) / CAST(total_revenue AS float) * 100, 2) AS nvarchar) + '%' AS customer_share
FROM gender_segmentation
GROUP BY gender, total_revenue, total_order;

-- 2. Marital Status
WITH marital_status_segmentation AS (
SELECT
	c.marital_status,
	s.sales,
	s.sales - s.quantity*p.product_cost AS profit,
	order_number,
	SUM(s.sales) OVER () AS total_revenue
FROM gold.fact_sales_details AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
)
SELECT
	marital_status,
	SUM(sales) AS revenue_generated,
	SUM(profit) AS total_profit,
	COUNT(order_number) AS order_count,
	ROUND(CAST(SUM(sales) AS float) / CAST(COUNT(order_number) AS float), 2) AS avg_order_value,
	CAST(ROUND(CAST(SUM(sales) AS float) / CAST(total_revenue AS float) * 100, 2) AS nvarchar) + '%' AS customer_share
FROM marital_status_segmentation
GROUP BY marital_status, total_revenue;

/*
==================================================================================
7. What is the customer retention rate (repeat vs. one-time buyers)?
==================================================================================
*/
-- Retention rate: percentage of the customers who come back and buy more than once
-- Formula = (Nr. of repeat buyer / Nr. of total customers) * 100%

WITH
retention_analysis AS (
SELECT
	customer_key,
	COUNT(customer_key) AS total_order_per_customer,
	COUNT(customer_key) OVER() AS total_customers
FROM gold.fact_sales_details
GROUP BY customer_key
),
retention_rate_count AS (
SELECT
	customer_key,
	total_customers,
	CASE
		WHEN total_order_per_customer > 1 THEN 1
		ELSE NULL
	END AS repeat_buyer,
	CASE
		WHEN total_order_per_customer = 1 THEN 1 
	END AS one_time_buyer
FROM retention_analysis
)
SELECT
	COUNT(one_time_buyer) AS one_time_buyer_count,
	COUNT(repeat_buyer) AS repeat_buyer_count,
	CAST(ROUND(CAST(COUNT(repeat_buyer) AS float) / total_customers * 100, 2) AS nvarchar) + '%' AS retention_rate
FROM retention_rate_count
GROUP BY total_customers;

/*
==================================================================================
8. Are there geographic sales trends?
==================================================================================
*/
-- Part-to-Whole analysis of country
-- Comparing the performance of each country.

WITH country_segmentation AS (
SELECT
	c.country,
	s.sales,
	order_number,
	sales - (s.quantity * p.product_cost) AS profit,
	SUM(s.sales) OVER () AS total_revenue
FROM gold.fact_sales_details AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE country <> 'n/a'
)
SELECT
	country,
	SUM(sales) AS revenue_generated,
	SUM(profit) AS profit_generated,
	COUNT(order_number) AS order_count,
	ROUND(CAST(SUM(sales) AS float) / CAST(COUNT(order_number) AS float), 2) AS avg_order_value,
	CAST(ROUND(CAST(SUM(sales) AS float) / CAST(total_revenue AS float) * 100, 2) AS nvarchar) + '%' AS customer_share
FROM country_segmentation
GROUP BY country, total_revenue
ORDER BY ROUND(CAST(SUM(sales) AS float) / CAST(total_revenue AS float) * 100, 2) DESC;

/*
==================================================================================
9. Which products generate the highest revenue and profit? 
==================================================================================
*/
-- To utilize the performance, we will aggregate the fact tables before joining it with product table

WITH revenue_profit AS (
SELECT
	product_key,
	SUM(sales) AS revenue_generated,
	SUM(quantity) AS total_item_sold
FROM gold.fact_sales_details
GROUP BY product_key
)
SELECT
	p.product_name,
	revenue_generated,
	total_item_sold*p.product_cost AS cost_total,
	revenue_generated - total_item_sold*p.product_cost AS profit_margin
FROM revenue_profit AS rp
LEFT JOIN gold.dim_products AS p
ON rp.product_key = p.product_key
ORDER BY revenue_generated DESC;

/*
==================================================================================
10. Which product categories perform best?
==================================================================================
*/
-- Segment the product by its categories

WITH category_performance AS(
SELECT
	p.category,
	s.sales,
	s.order_number,
	SUM(sales) OVER() AS revenue_total,
	s.sales - p.product_cost*s.quantity AS profit
FROM gold.fact_sales_details AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
)
SELECT
	category,
	COUNT(order_number) AS total_order,
	SUM(sales) AS revenue_generated,
	SUM(profit) AS profit_generated,
	ROUND(CAST(SUM(sales) AS FLOAT) / CAST(COUNT(order_number) AS FLOAT), 2) AS avg_order_value,
	CAST(ROUND(CAST(SUM(sales) AS FLOAT) / CAST(revenue_total AS FLOAT) * 100, 2) AS nvarchar) + '%' AS category_share
FROM category_performance
GROUP BY category, revenue_total
ORDER BY revenue_generated DESC

/*
==================================================================================
11. Is there a product cannibalization effect?
==================================================================================
*/
-- Cannibalization effect: Condition where the new version of product replenish the sales of old product.
-- We paired the old version and new version of product, then compared its sales trend overtime.
-- If the old version sales trend declining when the new version released, then the cannibalization effect is exist.
-- The paired product must be the same product with different version.

--1. Mountain-100 Black- 42 (2011-07-01) and Mountain-200 Black- 42 (2013-07-01)
SELECT
	p.product_name,
	YEAR(s.order_date) AS year,
	MONTH(s.order_date) AS month,
	SUM(sales) AS revenue_generated
FROM gold.fact_sales_details AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE p.product_name IN ('Mountain-100 Black- 42', 'Mountain-200 Black- 42')
GROUP BY p.product_name, YEAR(s.order_date), MONTH(s.order_date)
ORDER BY YEAR(s.order_date) ASC, MONTH(s.order_date) ASC

-- 2. Road-150 Red- 44 (2011-07-01) vs. Road-250 Red- 44 (2012-07-01)
SELECT
	p.product_name,
	YEAR(s.order_date) AS year,
	MONTH(s.order_date) AS month,
	SUM(sales) AS revenue_generated
FROM gold.fact_sales_details AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE p.product_name IN ('Road-150 Red- 44', 'Road-250 Red- 44')
GROUP BY p.product_name, YEAR(s.order_date), MONTH(s.order_date)
ORDER BY YEAR(s.order_date) ASC, MONTH(s.order_date) ASC

/*
==================================================================================
12. What is the sales mix of high/mid/low-cost products?
==================================================================================
*/
-- Segment product by its cost.
-- Low Cost: < 100
-- Mid Cost: Between 100 and 1500
-- High Cost: > 1500

WITH price_analysis AS (
SELECT
	CASE
		WHEN s.price < 100 THEN 'Low Cost'
		WHEN s.price >= 100 AND s.price < 1500 THEN 'Mid Cost'
		ELSE'High Cost'
	END AS price_tier,
	s.order_number,
	s.sales,
	s.sales - p.product_cost * s.quantity AS profit,
	SUM(sales) OVER () as revenue_total,
	SUM(s.sales - p.product_cost * s.quantity) OVER () AS profit_total,
	COUNT(order_number) OVER () AS whole_total_order
FROM gold.fact_sales_details AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
)
SELECT
	price_tier,
	SUM(sales) AS revenue_generated,
	CAST(ROUND(CAST(SUM(sales) AS float) / revenue_total * 100 , 2) AS nvarchar) + '%' AS revenue_share,
	COUNT(order_number) AS number_of_order,
	CAST(ROUND(COUNT(order_number) / CAST(whole_total_order AS float) * 100 ,2) AS nvarchar) + '%' AS total_order_share,
	ROUND(CAST(SUM(sales) AS float) / COUNT(order_number), 2) AS average_order_value,
	SUM(profit) AS total_profit,
	CAST(ROUND(SUM(profit) / CAST(profit_total AS float) * 100, 2) AS nvarchar) + '%' AS profit_share
FROM price_analysis
GROUP BY price_tier, revenue_total, profit_total, whole_total_order;

/*
==================================================================================
13. What is the average order processing and delivery time?
==================================================================================
*/
-- Order processing time: order date - ship date.
-- Delivery time: due date - ship date.

WITH order_efficiency AS (
SELECT
	DATEDIFF(day, order_date, ship_date) AS order_to_ship,
	DATEDIFF(day, ship_date, due_date) AS ship_to_due
FROM gold.fact_sales_details
)
SELECT
	'Order Processing Time' AS indicator,
	AVG(CAST(order_to_ship AS float)) AS avg_in_day
FROM order_efficiency
UNION ALL
SELECT
	'Delivery Time' AS indicator,
	AVG(CAST(ship_to_due AS float))
FROM order_efficiency;

/*
==================================================================================
14. How concentrated is revenue among top customers? 
==================================================================================
*/
-- This analysis addressed the concentration risk in customers, checking revenue share of 1%, 5%, and 10% customers.
-- Total Customers: 18484
-- 1% Customers: 185
-- 5% Custoners: 925
-- 10% Customers: 1849

WITH 
concentration_risk AS (
SELECT
	c.customer_key,
	SUM(sales) AS revenue_generated
FROM gold.fact_sales_details AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key
),
concentration_risk_2 AS (
SELECT
	ROW_NUMBER() OVER (ORDER BY revenue_generated DESC) AS row_index,
	customer_key,
	revenue_generated,
	ROUND(CAST(SUM(revenue_generated) OVER (ORDER BY revenue_generated DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS float) / SUM(revenue_generated) OVER () * 100, 2) AS customer_share_percentage 
FROM concentration_risk
GROUP BY customer_key, revenue_generated
)
SELECT
	'% of revenue from Top 1% customer' as metric,
	CAST(MAX(customer_share_percentage) AS nvarchar) + '%' AS value
FROM concentration_risk_2
WHERE row_index <= 185
UNION ALL
SELECT TOP 925
	'% of revenue from Top 5% customer' as metric,
	CAST(MAX(customer_share_percentage) AS nvarchar) + '%' AS value
FROM concentration_risk_2
WHERE row_index <= 925
UNION ALL
SELECT TOP 1849
	'% of revenue from Top 10% customer' as metric,
	CAST(MAX(customer_share_percentage) AS nvarchar) + '%' AS value
FROM concentration_risk_2
WHERE row_index <= 1849

/*
==================================================================================
15. How concentrated is revenue among top products? 
==================================================================================
*/
-- This analysis addressed the concentration risk in products, checking revenue share of 1%, 5%, and 10% products.
-- Total products: 295
-- 1% products: 3
-- 5% products: 15
-- 10% products: 50

WITH 
concentration_risk AS (
SELECT
	p.product_key,
	SUM(sales) AS revenue_generated
FROM gold.dim_products AS p
LEFT JOIN gold.fact_sales_details AS s
ON p.product_key = s.product_key
GROUP BY p.product_key
),
concentration_risk_2 AS (
SELECT
	ROW_NUMBER() OVER (ORDER BY revenue_generated DESC) AS row_index,
	product_key,
	revenue_generated,
	ROUND(CAST(SUM(revenue_generated) OVER (ORDER BY revenue_generated DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS float) / SUM(revenue_generated) OVER () * 100, 2) AS customer_share_percentage 
FROM concentration_risk
GROUP BY product_key, revenue_generated
)
SELECT
	'% of revenue from Top 1% product' as metric,
	CAST(MAX(customer_share_percentage) AS nvarchar) + '%' AS value
FROM concentration_risk_2
WHERE row_index <= 3
UNION ALL
SELECT TOP 925
	'% of revenue from Top 5% product' as metric,
	CAST(MAX(customer_share_percentage) AS nvarchar) + '%' AS value
FROM concentration_risk_2
WHERE row_index <= 15
UNION ALL
SELECT TOP 1849
	'% of revenue from Top 10% product' as metric,
	CAST(MAX(customer_share_percentage) AS nvarchar) + '%' AS value
FROM concentration_risk_2
WHERE row_index <= 30;

