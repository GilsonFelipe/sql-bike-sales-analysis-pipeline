/*
=============================================================================================
Scratch of Data Cleaning, Transformation, and Validation Scratch For silver.crm_cust_info
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

-- 1. cst_id Column

-- 1.1 Check the duplicate and null of cst_id as primary key

SELECT *
FROM (SELECT
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date,
	COUNT(cst_id) OVER (PARTITION BY cst_id) as count_data
FROM bronze.crm_cust_info)s
WHERE count_data > 1 or cst_id is null
/*We have some null data, and it seems like the data contain the history data so we have a lot of duplicates, we will clean the null and take
only the newest data*/

-- 1.2. Clean the duplicate and null cst_id

SELECT *
FROM (SELECT
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date,
	RANK() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as newest_data
FROM bronze.crm_cust_info)s
WHERE newest_data = 1 AND cst_id IS NOT NULL

-- 2. cst_key column

-- 2.1 Check is there any duplicate in the cst_key
SELECT *
FROM (SELECT
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date,
	COUNT(cst_key) OVER (PARTITION BY cst_id) as count_data
FROM bronze.crm_cust_info)s
WHERE count_data > 1 or cst_id is null
-- It seems like the duplicates data in cst_key because the history data that we have cleaned before, so its all good

-- 3. cst_firstname and cst_lastname column

-- 3.1 Checking is there any unwanted spaces in the cst_firstname and cst_lastname

SELECT 
	cst_firstname,
	cst_lastname
FROM bronze.crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname) OR cst_lastname <> TRIM(cst_lastname)
-- We have a lot unwanted spaces, so lets clean it

-- 3.2 CLean the unwanted spaces in cst_firstname and cst_lastname

SELECT *
FROM (SELECT
	cst_id,
	cst_key,
	TRIM(cst_firstname) as cst_firstname,
	TRIM(cst_lastname) as cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date,
	RANK() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as newest_data
FROM bronze.crm_cust_info)s
WHERE newest_data = 1 AND cst_id IS NOT NULL

-- 4. cst_marital_status

-- 4.1 Check the validity of the data

SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info
-- We have null values, and the value is an abbreviation, its hard to read for the user, so lets transform it

-- 4.2 Standardize the data, and handle the null values

SELECT *
FROM (SELECT
	cst_id,
	cst_key,
	TRIM(cst_firstname) as cst_firstname,
	TRIM(cst_lastname) as cst_lastname,
	CASE
		WHEN cst_marital_status = 'M' THEN 'Married'
		WHEN cst_marital_status = 'S' THEN 'Single'
		ELSE 'n/a'
	END AS cst_marital_status,
	cst_gndr,
	cst_create_date,
	RANK() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as newest_data
FROM bronze.crm_cust_info)s
WHERE newest_data = 1 AND cst_id IS NOT NULL

-- 5. cst_gndr column

-- 5.1 check the validity of the data

SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info
-- Same here, we have null values, and the values is an abbreviation, we need to make it user friendly

-- 5.2 Standardize the data

SELECT *
FROM (SELECT
	cst_id,
	cst_key,
	TRIM(cst_firstname) as cst_firstname,
	TRIM(cst_lastname) as cst_lastname,
	CASE
		WHEN cst_marital_status = 'M' THEN 'Married'
		WHEN cst_marital_status = 'S' THEN 'Single'
		ELSE 'n/a'
	END AS cst_marital_status,
	CASE
		WHEN cst_gndr = 'M' THEN 'Male'
		WHEN cst_gndr = 'F'	THEN 'Female'
		ELSE 'n/a'
	END AS cst_gndr,
	cst_create_date,
	RANK() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as newest_data
FROM bronze.crm_cust_info)s
WHERE newest_data = 1 AND cst_id IS NOT NULL

/*
========================================== Validate the cleaned data =======================================
*/
-- To do this, we are going to make a TEMP TABLE to prevent the redundancy of the code

SELECT *
INTO #TEMP_1
FROM (SELECT
	cst_id,
	cst_key,
	TRIM(cst_firstname) as cst_firstname,
	TRIM(cst_lastname) as cst_lastname,
	CASE
		WHEN cst_marital_status = 'M' THEN 'Married'
		WHEN cst_marital_status = 'S' THEN 'Single'
		ELSE 'n/a'
	END AS cst_marital_status,
	CASE
		WHEN cst_gndr = 'M' THEN 'Male'
		WHEN cst_gndr = 'F'	THEN 'Female'
		ELSE 'n/a'
	END AS cst_gndr,
	cst_create_date,
	RANK() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as newest_data
FROM bronze.crm_cust_info)s
WHERE newest_data = 1 AND cst_id IS NOT NULL

-- 1. Check the duplicate and null values in cst_id column

SELECT
	cst_id,
	COUNT(cst_id)
FROM #TEMP_1
WHERE cst_id IS NULL
GROUP BY cst_id
HAVING COUNT(cst_id) > 1
-- Perfect, the cleaned data is valid

-- 2. Check the unwanted spaces in cst_firstname and cst_lastnames columns

SELECT *
FROM #TEMP_1
WHERE TRIM(cst_firstname) <> cst_firstname OR TRIM(cst_lastname) <> cst_lastname
-- Perfect, the cleaned data is valid

-- 3. Check the data standardization of cst_marital_status column

SELECT DISTINCT cst_marital_status
FROM #TEMP_1
-- it's all good, perfect

-- 4. Check the data standardization of cst_gndr column

SELECT DISTINCT cst_gndr
FROM #TEMP_1
-- Good, perfect

/*
Its all good, now we have the query code that we will use to select the cleaned data from bronze.crm_cust_info into silver.crm_cust_info

The query is stated below (p.s dont forget to drop the TEMP TABLE for later purposes)
*/

SELECT
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
FROM (SELECT
	cst_id,
	cst_key,
	TRIM(cst_firstname) as cst_firstname,
	TRIM(cst_lastname) as cst_lastname,
	CASE
		WHEN cst_marital_status = 'M' THEN 'Married'
		WHEN cst_marital_status = 'S' THEN 'Single'
		ELSE 'n/a'
	END AS cst_marital_status,
	CASE
		WHEN cst_gndr = 'M' THEN 'Male'
		WHEN cst_gndr = 'F'	THEN 'Female'
		ELSE 'n/a'
	END AS cst_gndr,
	cst_create_date,
	RANK() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as newest_data
FROM bronze.crm_cust_info)s
WHERE newest_data = 1 AND cst_id IS NOT NULL

-- DROP TEMP TABLE
IF OBJECT_ID(N'tempdb..#TEMP1') IS NOT NULL
BEGIN
DROP TABLE #TEMP1
END
GO