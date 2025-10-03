/*
=============================================================================================
Scratch of Data Cleaning, Transformation, and Validation Scratch For silver.erp_loc_a101
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
FROM bronze.erp_loc_a101

SELECT TOP 100 *
FROM bronze.crm_cust_info

SELECT TOP 100 *
FROM bronze.erp_cust_az12
-- we have some extra character that we need to clean later

-- 2. cid column

-- 2.1 Checking is there any duplicates and null values in cid column

SELECT *
FROM(SELECT
	cid,
	cntry,
	COUNT(cid) OVER (PARTITION BY cid) as cid_count
FROM bronze.erp_loc_a101) AS S
WHERE cid_count > 1
-- no null and duplicates value

-- 2.2 clean some extra character in cid column

SELECT
	REPLACE(cid, '-', '') AS cid,
	cntry
FROM bronze.erp_loc_a101

-- 3. cntry column

-- 3.1 Checking the data consistency in cntry column

SELECT DISTINCT cntry
FROM bronze.erp_loc_a101
-- so much unconsistency right there

-- 3.2 Checking is there any unwanted spaces in cntry column

SELECT cntry
FROM bronze.erp_loc_a101
WHERE TRIM(cntry) <> cntry
-- we dont have any, so when we standardize the data, dont need to put extra trim

-- 3.3 Cleaning the unconsistent data, Performing data standardization

SELECT
	REPLACE(cid, '-', '') AS cid,
	CASE
		WHEN cntry = 'DE' OR cntry = 'Germany' THEN 'Germany'
		WHEN cntry = 'USA' OR cntry = 'US' OR cntry = 'United States' THEN 'United States'
		WHEN cntry = '' OR cntry IS NULL THEN 'n/a'
		ELSE cntry
	END AS cntry
FROM bronze.erp_loc_a101;

/*
======================================================= Data Validation ===========================================================
*/

-- 1. Checking is there any duplicates and null values in cid column

WITH cleaned_data AS (
SELECT
	REPLACE(cid, '-', '') AS cid,
	CASE
		WHEN cntry = 'DE' OR cntry = 'Germany' THEN 'Germany'
		WHEN cntry = 'USA' OR cntry = 'US' OR cntry = 'United States' THEN 'United States'
		WHEN cntry = '' OR cntry IS NULL THEN 'n/a'
		ELSE cntry
	END AS cntry
FROM bronze.erp_loc_a101)
SELECT cid, COUNT(cid)
FROM cleaned_data
GROUP BY cid
HAVING COUNT(cid) > 1
-- no duplicates values

WITH cleaned_data AS (
SELECT
	REPLACE(cid, '-', '') AS cid,
	CASE
		WHEN cntry = 'DE' OR cntry = 'Germany' THEN 'Germany'
		WHEN cntry = 'USA' OR cntry = 'US' OR cntry = 'United States' THEN 'United States'
		WHEN cntry = '' OR cntry IS NULL THEN 'n/a'
		ELSE cntry
	END AS cntry
FROM bronze.erp_loc_a101)
SELECT *
FROM cleaned_data
WHERE cid IS NULL
-- no null values

-- 2. Checking the consistency of the data

WITH cleaned_data AS (
SELECT
	REPLACE(cid, '-', '') AS cid,
	CASE
		WHEN cntry = 'DE' OR cntry = 'Germany' THEN 'Germany'
		WHEN cntry = 'USA' OR cntry = 'US' OR cntry = 'United States' THEN 'United States'
		WHEN cntry = '' OR cntry IS NULL THEN 'n/a'
		ELSE cntry
	END AS cntry
FROM bronze.erp_loc_a101)
SELECT DISTINCT cntry
FROM cleaned_data
-- data is valid

/*
Its all good, now we have the query code that we will use to select the cleaned data from bronze.erp_cust_az12 into silver.erp_cust_az12

The query is stated below
*/

SELECT
	REPLACE(cid, '-', '') AS cid,
	CASE
		WHEN cntry = 'DE' OR cntry = 'Germany' THEN 'Germany'
		WHEN cntry = 'USA' OR cntry = 'US' OR cntry = 'United States' THEN 'United States'
		WHEN cntry = '' OR cntry IS NULL THEN 'n/a'
		ELSE cntry
	END AS cntry
FROM bronze.erp_loc_a101