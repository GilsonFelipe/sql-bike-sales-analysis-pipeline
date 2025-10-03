/*
=============================================================================================
Scratch of Data Integration For gold.dim_products
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

-- 1. Check the integrity of the data

SELECT *
FROM silver.crm_prd_info

SELECT DISTINCT id
FROM silver.erp_px_cat_g1v2
-- We have 1 category id that's not available in erp_px_cat_g1v2

-- 2. Selecting data for gold.dim_products

SELECT
	cpi.prd_id AS product_id,
	cpi.prd_key AS product_number,
	cpi.prd_nm AS product_name,
	cpi.prd_cat_id AS category_id,
	epcg.cat AS category,
	epcg.subcat AS subcategory,
	cpi.prd_cost AS product_cost,
	epcg.maintanance AS maintanance,
	cpi.prd_start_dt AS start_date
FROM silver.crm_prd_info AS cpi
LEFT JOIN silver.erp_px_cat_g1v2 as epcg
ON cpi.prd_cat_id = epcg.id

-- 3. Clean the historical data

SELECT
	cpi.prd_id AS product_id,
	cpi.prd_key AS product_number,
	cpi.prd_nm AS product_name,
	cpi.prd_cat_id AS category_id,
	epcg.cat AS category,
	epcg.subcat AS subcategory,
	cpi.prd_cost AS product_cost,
	epcg.maintanance AS maintanance,
	cpi.prd_start_dt AS start_date
FROM silver.crm_prd_info AS cpi
LEFT JOIN silver.erp_px_cat_g1v2 as epcg
ON cpi.prd_cat_id = epcg.id
WHERE cpi.prd_end_dt IS NULL

-- 4. Create surogate key

SELECT
	RANK() OVER (ORDER BY cpi.prd_start_dt ASC, cpi.prd_key) AS product_key,
	cpi.prd_id AS product_id,
	cpi.prd_key AS product_number,
	cpi.prd_nm AS product_name,
	cpi.prd_cat_id AS category_id,
	epcg.cat AS category,
	epcg.subcat AS subcategory,
	cpi.prd_cost AS product_cost,
	epcg.maintanance AS maintanance,
	cpi.prd_start_dt AS start_date
FROM silver.crm_prd_info AS cpi
LEFT JOIN silver.erp_px_cat_g1v2 as epcg
ON cpi.prd_cat_id = epcg.id
WHERE cpi.prd_end_dt IS NULL

-- 5. Check are all the category_id availale in both table or not

SELECT
	RANK() OVER (ORDER BY cpi.prd_start_dt ASC, cpi.prd_key) AS product_key,
	cpi.prd_id AS product_id,
	cpi.prd_key AS product_number,
	cpi.prd_nm AS product_name,
	cpi.prd_cat_id AS category_id,
	epcg.cat AS category,
	epcg.subcat AS subcategory,
	cpi.prd_cost AS product_cost,
	epcg.maintanance AS maintanance,
	cpi.prd_start_dt AS start_date
FROM silver.crm_prd_info AS cpi
LEFT JOIN silver.erp_px_cat_g1v2 as epcg
ON cpi.prd_cat_id = epcg.id
WHERE cpi.prd_end_dt IS NULL AND epcg.id IS NULL
/*
so we have one category_id that's not available in erp_px_cat_g1v2 table, its causing some null values in the integrated table, so we need to clean it
*/

-- 6. CLean the null values caused by the uncomplete data

WITH dim_products AS(
SELECT
	RANK() OVER (ORDER BY cpi.prd_start_dt ASC, cpi.prd_key) AS product_key,
	cpi.prd_id AS product_id,
	cpi.prd_key AS product_number,
	cpi.prd_nm AS product_name,
	cpi.prd_cat_id AS category_id,
	epcg.cat AS category,
	epcg.subcat AS subcategory,
	cpi.prd_cost AS product_cost,
	epcg.maintanance AS maintanance,
	cpi.prd_start_dt AS start_date
FROM silver.crm_prd_info AS cpi
LEFT JOIN silver.erp_px_cat_g1v2 as epcg
ON cpi.prd_cat_id = epcg.id
WHERE cpi.prd_end_dt IS NULL)
SELECT
	product_key,
	product_id,
	product_number,
	product_name,
	category_id,
	ISNULL(category, 'n/a') as category,
	ISNULL(subcategory, 'n/a') as subcategory,
	product_cost,
	ISNULL(maintanance, 'n/a') as maintanance,
	start_date
FROM dim_products;

/*
========================================== Validate the integrated data =======================================
*/

-- Because our final query is a CTE, we wont be using CTE again and use TEMP TABLE isntead to recall the query

WITH dim_products AS(
SELECT
	RANK() OVER (ORDER BY cpi.prd_start_dt ASC, cpi.prd_key) AS product_key,
	cpi.prd_id AS product_id,
	cpi.prd_key AS product_number,
	cpi.prd_nm AS product_name,
	cpi.prd_cat_id AS category_id,
	epcg.cat AS category,
	epcg.subcat AS subcategory,
	cpi.prd_cost AS product_cost,
	epcg.maintanance AS maintanance,
	cpi.prd_start_dt AS start_date
FROM silver.crm_prd_info AS cpi
LEFT JOIN silver.erp_px_cat_g1v2 as epcg
ON cpi.prd_cat_id = epcg.id
WHERE cpi.prd_end_dt IS NULL)
SELECT
	product_key,
	product_id,
	product_number,
	product_name,
	category_id,
	ISNULL(category, 'n/a') as category,
	ISNULL(subcategory, 'n/a') as subcategory,
	product_cost,
	ISNULL(maintanance, 'n/a') as maintanance,
	start_date
INTO #TEMP1
FROM dim_products

-- 1. Checking duplicates data

SELECT
	product_number,
	COUNT(*) as num_count
FROM #TEMP1
GROUP BY product_number
HAVING COUNT(*) > 1
-- data is valid

-- 2. Check if all the data is inserted correctly

SELECT *
FROM #TEMP1;
-- data is valid

/*
Its all good, now we have the query code that we will use to select the intefrated data data from silver layer into gold.dim_products

The query is stated below (p.s dont forget to drop the TEMP TABLE for later purposes)
*/


WITH dim_products AS(
SELECT
	RANK() OVER (ORDER BY cpi.prd_start_dt ASC, cpi.prd_key) AS product_key,
	cpi.prd_id AS product_id,
	cpi.prd_key AS product_number,
	cpi.prd_nm AS product_name,
	cpi.prd_cat_id AS category_id,
	epcg.cat AS category,
	epcg.subcat AS subcategory,
	cpi.prd_cost AS product_cost,
	epcg.maintanance AS maintanance,
	cpi.prd_start_dt AS start_date
FROM silver.crm_prd_info AS cpi
LEFT JOIN silver.erp_px_cat_g1v2 as epcg
ON cpi.prd_cat_id = epcg.id
WHERE cpi.prd_end_dt IS NULL)
SELECT
	product_key,
	product_id,
	product_number,
	product_name,
	category_id,
	ISNULL(category, 'n/a') as category,
	ISNULL(subcategory, 'n/a') as subcategory,
	product_cost,
	ISNULL(maintanance, 'n/a') as maintanance,
	start_date
FROM dim_products;

-- DROP TEMP TABLE
IF OBJECT_ID(N'tempdb..#TEMP1') IS NOT NULL
BEGIN
DROP TABLE #TEMP1
END
GO