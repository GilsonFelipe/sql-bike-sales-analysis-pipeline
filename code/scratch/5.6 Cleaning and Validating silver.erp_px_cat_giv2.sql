/*
=============================================================================================
Scratch of Data Cleaning, Transformation, and Validation Scratch For silver.erp_px_cat_giv2
=============================================================================================

Pupose:
	This script clean, transform, and validate the data from bronze layer before insert it into silver layer. This script is a scratch to get
	the right query language that extract the good quality data into silver layer
*/

USE Data_Warehouse
GO

/*
========================================== Checking Data Coorrectness, Cleaning Data, and Transforming Data =======================================
*/

-- 1. Checking the integrity of the data

SELECT TOP 100 *
FROM bronze.crm_sales_details

SELECT TOP 100 *
FROM bronze.crm_prd_info

SELECT TOP 100 *
FROM bronze.erp_px_cat_giv2
-- no anomalies, no extra character

-- 2. id column

-- 2.1 Checking is there null and duplicate values in id column

SELECT *
FROM(SELECT
	id,
	cat,
	subcat,
	maintanance,
	COUNT(id) OVER (PARTITION BY id) as id_count
FROM bronze.erp_px_cat_giv2) as s
WHERE id_count > 1 or id is null
-- no null and duplicates

-- 3. cat column

-- 3.1 Checking the consistency of cat column

SELECT DISTINCT cat
FROM bronze.erp_px_cat_giv2
-- data is consistent

-- 3.2 CHecking is there any unwanted spaces in cat column

SELECT cat
FROM bronze.erp_px_cat_giv2
WHERE TRIM(cat) <> cat
-- no unwanted spaces

-- 4. subcat column

-- 4.1 Checking is there any unwanted spaces

SELECT subcat
FROM bronze.erp_px_cat_giv2
WHERE TRIM(subcat) <> subcat

-- 5. maintanance column

-- 5.1 Checking data consistency at maintanance column

SELECT DISTINCT maintanance
FROM bronze.erp_px_cat_giv2
-- data is consistent

-- NO ISSUES AT ALL

/*
Its all good, now we have the query code that we will use to select the cleaned data from bronze.erp_px_cat_giv2 into silver.erp_px_cat_giv2

The query is stated below
*/

SELECT
	id,
	cat,
	subcat,
	maintanance
FROM bronze.erp_px_cat_giv2