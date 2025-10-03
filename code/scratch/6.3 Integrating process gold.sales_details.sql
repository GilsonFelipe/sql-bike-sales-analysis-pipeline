/*
=============================================================================================
Scratch of Data Integration For gold.fact_sales_details
=============================================================================================

Pupose:
	This script integrate the data from silver layer before insert it into gold layer. This script is a scratch to get the right query language
	that retrieve the necessary data from silver layer into the data model in gold layer (star schema model)
*/

USE Data_Warehouse
GO

/*
=========================================================== Integrating Data ========================================================
*/

-- 1. Checking the integrity of the data

SELECT *
FROM silver.crm_sales_details

SELECT *
FROM gold.dim_customers

SELECT *
FROM gold.dim_products

-- 2 Retrieving all the data needed for gold.fact_sales_details

SELECT
	csd.sls_ord_num AS order_number,
	dc.customer_key AS customer_key,
	dp.product_key AS product_key,
	csd.sls_order_dt AS order_date,
	csd.sls_ship_dt AS ship_date,
	csd.sls_due_dt AS due_date,
	csd.sls_sales AS sales,
	csd.sls_quantity AS quantity,
	csd.sls_price AS price
FROM silver.crm_sales_details AS csd
LEFT JOIN gold.dim_products AS dp
ON csd.sls_prd_key = dp.product_number
LEFT JOIN gold.dim_customers AS dc
ON csd.sls_cust_id = dc.customer_id

/*
========================================== Validate the integrated data =======================================
*/

SELECT
	csd.sls_ord_num AS order_number,
	dc.customer_key AS customer_key,
	dp.product_key AS product_key,
	csd.sls_order_dt AS order_date,
	csd.sls_ship_dt AS ship_date,
	csd.sls_due_dt AS due_date,
	csd.sls_sales AS sales,
	csd.sls_quantity AS quantity,
	csd.sls_price AS price
INTO #TEMP1
FROM silver.crm_sales_details AS csd
LEFT JOIN gold.dim_products AS dp
ON csd.sls_prd_key = dp.product_number
LEFT JOIN gold.dim_customers AS dc
ON csd.sls_cust_id = dc.customer_id

-- 1. Check if the data has been inserted correctly

SELECT *
FROM #TEMP1
-- data is valid

-- 2. Check the integrity of the data

SELECT *
FROM #TEMP1 AS t
LEFT JOIN gold.dim_products as dp
ON t.product_key = dp.product_key
LEFT JOIN gold.dim_customers as dc
ON t.customer_key = dc.customer_key
-- data is valid

/*
Its all good, now we have the query code that we will use to select the intefrated data data from silver layer into gold.dim_products

The query is stated below (p.s dont forget to drop the TEMP TABLE for later purposes)
*/

SELECT
	csd.sls_ord_num AS order_number,
	dc.customer_key AS customer_key,
	dp.product_key AS product_key,
	csd.sls_order_dt AS order_date,
	csd.sls_ship_dt AS ship_date,
	csd.sls_due_dt AS due_date,
	csd.sls_sales AS sales,
	csd.sls_quantity AS quantity,
	csd.sls_price AS price
FROM silver.crm_sales_details AS csd
LEFT JOIN gold.dim_products AS dp
ON csd.sls_prd_key = dp.product_number
LEFT JOIN gold.dim_customers AS dc
ON csd.sls_cust_id = dc.customer_id

-- DROP TEMP TABLE
IF OBJECT_ID(N'tempdb..#TEMP1') IS NOT NULL
BEGIN
DROP TABLE #TEMP1
END
GO