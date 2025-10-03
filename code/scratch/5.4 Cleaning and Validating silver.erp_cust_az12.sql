/*
=============================================================================================
Scratch of Data Cleaning, Transformation, and Validation Scratch For silver.erp_cust_az12
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
FROM bronze.crm_cust_info

SELECT TOP 100 *
FROM bronze.erp_cust_az12

SELECT TOP 100 *
FROM bronze.crm_sales_details
-- so in cid, we need to delete some exra character

-- 2. cid column

-- 2.1 checking is there any null or duplicate values in cid column

SELECT *
FROM(SELECT
	cid,
	bdate,
	gen,
	COUNT(cid) OVER (PARTITION BY cid) AS cid_count
FROM bronze.erp_cust_az12) s
WHERE cid_count > 1
-- we dint have any

-- 2.2 Clean the extra character in cid

SELECT
	REPLACE(cid, 'NAS', '') AS cid,
	bdate,
	gen
FROM bronze.erp_cust_az12

-- 3. bdate column

-- 3.1 Checking the correctness of bdate column

SELECT bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1925-01-01' OR bdate >= GETDATE()
-- so we have some anomalies data that irationally correct

-- 3.2 Cleaning the uncorrect data on bdate column

SELECT
	REPLACE(cid, 'NAS', '') AS cid,
	CASE
		WHEN bdate >= GETDATE() OR bdate < '1925-01-01' THEN NULL
		ELSE bdate
	END AS bdate,
	gen
FROM bronze.erp_cust_az12

-- 4. gen column

-- 4.1 Checking the consistency and standardization of gen column

SELECT DISTINCT gen
FROM bronze.erp_cust_az12
-- the values is unconsistent

-- 4.2 Performing data standardization on gen column

SELECT
	REPLACE(cid, 'NAS', '') AS cid,
	CASE
		WHEN bdate >= GETDATE() OR bdate < '1925-01-01' THEN NULL
		ELSE bdate
	END AS bdate,
	CASE
		WHEN TRIM(gen) = 'F' OR TRIM(gen) = 'Female' THEN 'Female'
		WHEN TRIM(gen) = 'M' OR TRIM(gen) = 'Male' THEN 'Male'
		ELSE 'n/a'
	END AS gen
FROM bronze.erp_cust_az12;

/*
======================================================= Data Validation ===========================================================
*/

-- 1. Checking is there any duplicate, extra character, and null values in the cid column

WITH cleaned_data AS(
SELECT
	REPLACE(cid, 'NAS', '') AS cid,
	CASE
		WHEN bdate >= GETDATE() OR bdate < '1925-01-01' THEN NULL
		ELSE bdate
	END AS bdate,
	CASE
		WHEN TRIM(gen) = 'F' OR TRIM(gen) = 'Female' THEN 'Female'
		WHEN TRIM(gen) = 'M' OR TRIM(gen) = 'Male' THEN 'Male'
		ELSE 'n/a'
	END AS gen,
	COUNT(REPLACE(cid, 'NAS', '')) OVER (PARTITION BY REPLACE(cid, 'NAS', '')) AS count_id
FROM bronze.erp_cust_az12)
SELECT *
FROM cleaned_data
WHERE cid IS NULL OR cid LIKE 'NAS%' OR count_id > 1
-- data is valid

-- 2. Checking is there any uncorrect data in bdate column

WITH cleaned_data AS(
SELECT
	REPLACE(cid, 'NAS', '') AS cid,
	CASE
		WHEN bdate >= GETDATE() OR bdate < '1925-01-01' THEN NULL
		ELSE bdate
	END AS bdate,
	CASE
		WHEN TRIM(gen) = 'F' OR TRIM(gen) = 'Female' THEN 'Female'
		WHEN TRIM(gen) = 'M' OR TRIM(gen) = 'Male' THEN 'Male'
		ELSE 'n/a'
	END AS gen
FROM bronze.erp_cust_az12)
SELECT *
FROM cleaned_data
WHERE bdate >= GETDATE() OR bdate < '1925-01-01'
-- data is valid

-- 3. Checking the consistency and standardization on the gen column

WITH cleaned_data AS(
SELECT
	REPLACE(cid, 'NAS', '') AS cid,
	CASE
		WHEN bdate >= GETDATE() OR bdate < '1925-01-01' THEN NULL
		ELSE bdate
	END AS bdate,
	CASE
		WHEN TRIM(gen) = 'F' OR TRIM(gen) = 'Female' THEN 'Female'
		WHEN TRIM(gen) = 'M' OR TRIM(gen) = 'Male' THEN 'Male'
		ELSE 'n/a'
	END AS gen
FROM bronze.erp_cust_az12)
SELECT DISTINCT gen
FROM cleaned_data
-- data is valid

/*
Its all good, now we have the query code that we will use to select the cleaned data from bronze.erp_cust_az12 into silver.erp_cust_az12

The query is stated below
*/

SELECT
	REPLACE(cid, 'NAS', '') AS cid,
	CASE
		WHEN bdate >= GETDATE() OR bdate < '1925-01-01' THEN NULL
		ELSE bdate
	END AS bdate,
	CASE
		WHEN TRIM(gen) = 'F' OR TRIM(gen) = 'Female' THEN 'Female'
		WHEN TRIM(gen) = 'M' OR TRIM(gen) = 'Male' THEN 'Male'
		ELSE 'n/a'
	END AS gen
FROM bronze.erp_cust_az12

