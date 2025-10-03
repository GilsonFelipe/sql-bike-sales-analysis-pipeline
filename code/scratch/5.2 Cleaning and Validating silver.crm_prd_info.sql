/*
=============================================================================================
Scratch of Data Cleaning, Transformation, and Validation Scratch For silver.crm_prd_info
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

-- 1. Check the integrity of all table

SELECT TOP 100 *
FROM bronze.crm_cust_info

SELECT TOP 100 *
FROM bronze.crm_prd_info

SELECT TOP 100 *
FROM bronze.crm_sales_details

SELECT TOP 100 *
FROM bronze.erp_cust_az12

SELECT TOP 100 *
FROM bronze.erp_loc_a101

SELECT TOP 100 *
FROM bronze.erp_px_cat_giv2

/*by understanding the data, we know there are some messed up key integrity between table, in this case, prd_key column contain 2 information,
which are catagory id and product key itself, so we need to enrich the data later*/

-- 2. prd_id column

-- 2.1 check is there any duplicates and null values on prd_id column

SELECT *
FROM(SELECT
	prd_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt,
	COUNT(prd_id) OVER (PARTITION BY prd_id) as id_count
FROM bronze.crm_prd_info)s
WHERE id_count > 1 or prd_id is NULL
-- we dont have any issue here, good

-- 3. prd_key column

-- 3.1 Lets check is there any null values or duplicate values in prd_key column

SELECT *
FROM(SELECT
	prd_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt,
	COUNT(prd_key) OVER (PARTITION BY prd_key) as key_count
FROM bronze.crm_prd_info)s
WHERE key_count > 1 or prd_key is NULL
/*actually there are a lot of historical data, we will keep it since their prd_id is different and to evade historical lost for old sales data
on crm_sales_details*/

-- 3.2 Retrieve the category from prd_key column

SELECT
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') as prd_cat_id,
	SUBSTRING(prd_key,7, LEN(prd_key) - 6) as prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info

-- 4. prd_nm column

-- 4.1 Checking is there any unwanted spaces in prd_nm column

SELECT
	prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm <> TRIM(prd_nm)
-- no unwanted space

-- 5. prd_cost column

-- 5.1 Checking is there any null values in prd-cost column

SELECT
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') as prd_cat_id,
	SUBSTRING(prd_key,7, LEN(prd_key) - 6) as prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info
WHERE prd_cost IS NULL
-- we have some null cost, which is didn't make any sense

-- 5.2 Handling null values at prd_cost column

SELECT
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') as prd_cat_id,
	SUBSTRING(prd_key,7, LEN(prd_key) - 6) as prd_key,
	prd_nm,
	ISNULL(prd_cost,0) AS prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info

-- 6. prd_line column

-- 6.1 Checking data consistency and standardization of prd-line column

SELECT DISTINCT prd_line
FROM bronze.crm_prd_info
-- we have some null values, and the values is not user friendly enough

-- 6.2 Handling the null values and standardizing the data on prd_line column

SELECT
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') as prd_cat_id,
	SUBSTRING(prd_key,7, LEN(prd_key) - 6) as prd_key,
	prd_nm,
	ISNULL(prd_cost,0) AS prd_cost,
	CASE
		WHEN prd_line = 'M' THEN 'Mountain'
		WHEN prd_line = 'R' THEN 'Road'
		WHEN prd_line = 'T' THEN 'Touring'
		WHEN prd_line = 'S' THEN 'Other Sales'
		ELSE 'n/a'
	END AS prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info

-- 7. prd_start_dt and prd_end_dt columns

-- 7.1 Checking the correctness of the date data

SELECT
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') as prd_cat_id,
	SUBSTRING(prd_key,7, LEN(prd_key) - 6) as prd_key,
	prd_nm,
	ISNULL(prd_cost,0) AS prd_cost,
	CASE
		WHEN prd_line = 'M' THEN 'Mountain'
		WHEN prd_line = 'R' THEN 'Road'
		WHEN prd_line = 'T' THEN 'Touring'
		WHEN prd_line = 'S' THEN 'Other Sales'
		ELSE 'n/a'
	END AS prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info
WHERE prd_start_dt > prd_end_dt OR prd_start_dt IS NULL OR prd_end_dt IS NULL
-- the product with null prd_end_dt suggesting the product still aired, so we will keep the null in prd_end_dt
-- no null data in prd_start_dt
-- there are some problem in the historical record, where the prd_start_dt > prd_end_dt, which doesn't make any sense

-- 7.2 Clean the date data

SELECT
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') as prd_cat_id,
	SUBSTRING(prd_key,7, LEN(prd_key) - 6) as prd_key,
	prd_nm,
	ISNULL(prd_cost,0) AS prd_cost,
	CASE
		WHEN prd_line = 'M' THEN 'Mountain'
		WHEN prd_line = 'R' THEN 'Road'
		WHEN prd_line = 'T' THEN 'Touring'
		WHEN prd_line = 'S' THEN 'Other Sales'
		ELSE 'n/a'
	END AS prd_line,
	prd_start_dt,
	DATEADD(DAY, -1, (LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt))) as prd_end_dt
FROM bronze.crm_prd_info

/*
======================================================= Data Validation ===========================================================
*/
-- To do this, we are goimg to use TEMP TABLE to avoid redundancy

SELECT
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') as prd_cat_id,
	SUBSTRING(prd_key,7, LEN(prd_key) - 6) as prd_key,
	prd_nm,
	ISNULL(prd_cost,0) AS prd_cost,
	CASE
		WHEN prd_line = 'M' THEN 'Mountain'
		WHEN prd_line = 'R' THEN 'Road'
		WHEN prd_line = 'T' THEN 'Touring'
		WHEN prd_line = 'S' THEN 'Other Sales'
		ELSE 'n/a'
	END AS prd_line,
	prd_start_dt,
	DATEADD(DAY, 1, (LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt))) as prd_end_dt
INTO #TEMP1
FROM bronze.crm_prd_info

-- 1. Validate is there any duplicates and null data in prd_id column

SELECT *
FROM(SELECT *,
	COUNT(prd_id) OVER (PARTITION BY prd_id) as id_count
FROM #TEMP1) AS s
WHERE id_count > 1
-- data is valid

-- 2. Checking have the category id been seperated from prd_key column or not

SELECT prd_key,
	prd_cat_id
FROM #TEMP1
-- data is valid

-- 3. Checking is there any unwanted spaces in prd_nm column

SELECT *
FROM #TEMP1
WHERE prd_nm <> TRIM(prd_nm)
-- data is valid

-- 4. Checking the data consistency and standardization on prd_line column

SELECT DISTINCT prd_line
FROM #TEMP1
-- Good, its valid

-- 5. Checking the correctness of the date data

SELECT *
FROM #TEMP1
WHERE prd_start_dt > prd_end_dt OR prd_start_dt IS NULL
-- perfect. data is valid


/*
Its all good, now we have the query code that we will use to select the cleaned data from bronze.crm_prd_info into silver.crm_prd_info

The query is stated below (p.s dont forget to drop the TEMP TABLE for later purposes)
*/

SELECT
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') as prd_cat_id,
	SUBSTRING(prd_key,7, LEN(prd_key) - 6) as prd_key,
	prd_nm,
	ISNULL(prd_cost,0) AS prd_cost,
	CASE
		WHEN prd_line = 'M' THEN 'Mountain'
		WHEN prd_line = 'R' THEN 'Road'
		WHEN prd_line = 'T' THEN 'Touring'
		WHEN prd_line = 'S' THEN 'Other Sales'
		ELSE 'n/a'
	END AS prd_line,
	prd_start_dt,
	DATEADD(DAY, 1, (LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt))) as prd_end_dt
FROM bronze.crm_prd_info

-- *DROP TEMP TABLE

IF OBJECT_ID(N'tempdb..#TEMP1') IS NOT NULL
BEGIN
DROP TABLE #TEMP1
END
GO