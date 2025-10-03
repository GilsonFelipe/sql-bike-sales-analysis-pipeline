/*
=============================================================================================
Scratch of Data Cleaning, Transformation, and Validation Scratch For silver.crm_sales_details
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

SELECT TOP 100 *
FROM bronze.crm_sales_details

-- 1. sls_ord_num column

-- 1.1 Checking is there any null or duplicate values in sls_ord_num column

SELECT *
FROM(SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price,
	COUNT(sls_ord_num) OVER (PARTITION BY sls_ord_num) AS ord_num_count
FROM bronze.crm_sales_details) as c
WHERE ord_num_count > 1 OR ord_num_count IS NULL
/*
so, we have a tons of duplicates data, but, it seems like because if one customer ordering mupltiple product, it will be recorded in the same 
ord_num, so it's nice, we wont gonna do anything about it. in other hand, we dont have any null values, which is good
*/

-- 2. sls_prd_key

-- 2.1 Checking is there any null values in sls_prd_key column

SELECT *
FROM bronze.crm_sales_details
WHERE sls_prd_key IS NULL
-- no null values, good

-- 2.2 Checking is there any unwanted spaces in sls_prd_key column

SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_prd_key != TRIM(sls_prd_key)
-- we don't have any unwanted spaces

-- 3. sls_cust_id

-- 3.1 Checking is there any null values in sls_cust_id

SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_cust_id IS NULL
-- we don't have any

-- 4. Checking the correctness of date data

-- 4.1 Checking is there any NULL data in sls_order_dt, sls_ship_dt, sls_due_dt columns

SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_order_dt IS NULL OR sls_ship_dt IS NULL OR sls_due_dt IS NULL
-- we dont have any

-- 4.2 Checking is there any 'nonsense' data in sls_order_dt, sls_ship_dt, sls_due_dt columns

SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt OR sls_ship_dt > sls_due_dt
-- all data is good

-- 4.3 Checking is there any anomaly data in sls_order_dt, sls_ship_dt, sls_due_dt columns

SELECT
	sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0
or len(sls_order_dt) <> 8
or sls_order_dt >= 20500101
or sls_order_dt <= 19000101;
-- we have some anomalies here, there are some order date that have value 0, and there is one order_date that have value '32154', we need to clean it


SELECT
	sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0
or len(sls_ship_dt) <> 8
or sls_ship_dt >= 20500101
or sls_ship_dt <= 19000101; -- no errors


SELECT
	sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
or len(sls_due_dt) <> 8
or sls_due_dt >= 20500101
or sls_due_dt <= 19000101; -- no errors

-- 4.4 Clean the anomalies in sls_order_dt column, and change all the date values into DATE format

SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE
		WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) <> 8 THEN NULL
		ELSE sls_order_dt
	END as sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details

-- 5. Checking the correctness of sls_sales, sls_quantity, and sls_price

-- 5.1 Checking is the calculation on sls_sales, sls_price, and sls_quantity is correct

SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CAST(CAST(CASE
		WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) <> 8 THEN NULL
		ELSE sls_order_dt
	END AS NVARCHAR) AS DATE) as sls_order_dt,
	CAST(CAST(sls_ship_dt AS nvarchar) AS DATE) AS sls_ship_dt,
	CAST(CAST(sls_due_dt AS nvarchar) AS date) AS sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_price * sls_quantity <> sls_sales
-- we have a lot of uncorrect data

-- 5.2 Transform the sls_price, sls_quantity, sls_sales with rules:
-- if the sales negative, 0, null, or unmatch with price*quantity, then transform based on price and quantitiy value
-- if the price zero and null, match the value based on saes and quantitiy
-- if price is negative, transform it into positive

SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CAST(CAST(CASE
		WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) <> 8 THEN NULL
		ELSE sls_order_dt
	END AS NVARCHAR) AS DATE) as sls_order_dt,
	CAST(CAST(sls_ship_dt AS nvarchar) AS DATE) AS sls_ship_dt,
	CAST(CAST(sls_due_dt AS nvarchar) AS date) AS sls_due_dt,
	sls_sales,
	CASE
		WHEN sls_sales <= 0 THEN CAST(sls_price * sls_quantity AS float)
		WHEN sls_sales IS NULL THEN CAST(sls_price * sls_quantity AS float)
		WHEN sls_sales <> sls_price * sls_quantity THEN CAST(sls_price * sls_quantity AS float)
		ELSE sls_sales
	END as sls_sales,
	sls_quantity,
	CASE
		WHEN sls_price = 0 THEN CAST(sls_sales/sls_quantity AS float)
		WHEN sls_price IS NULL THEN CAST(sls_sales/sls_quantity AS float)
		WHEN sls_price < 0 THEN ABS(sls_price)
		ELSE sls_price
	END AS sls_price
FROM bronze.crm_sales_details

/*
======================================================= Data Validation ===========================================================
*/
-- To do this, we are goimg to use TEMP TABLE to avoid redundancy

IF OBJECT_ID(N'tempdb..#TEMP1') IS NOT NULL
BEGIN
DROP TABLE #TEMP1
END
GO
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CAST(CAST(CASE
		WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) <> 8 THEN NULL
		ELSE sls_order_dt
	END AS NVARCHAR) AS DATE) as sls_order_dt,
	CAST(CAST(sls_ship_dt AS nvarchar) AS DATE) AS sls_ship_dt,
	CAST(CAST(sls_due_dt AS nvarchar) AS date) AS sls_due_dt,
	CASE
		WHEN sls_sales = 0 THEN ABS(sls_price * sls_quantity)
		WHEN sls_sales < 0 THEN ABS(sls_quantity * sls_price)
		WHEN sls_sales IS NULL THEN ABS(sls_price * sls_quantity)
		WHEN sls_sales <> sls_price * sls_quantity THEN ABS(sls_price * sls_quantity)
		ELSE sls_sales
	END as sls_sales,
	sls_quantity,
	CASE
		WHEN sls_price = 0 THEN ABS(sls_sales/sls_quantity)
		WHEN sls_price IS NULL THEN ABS(sls_sales/sls_quantity)
		WHEN sls_price < 0 THEN ABS(sls_price)
		ELSE sls_price
	END AS sls_price
INTO #TEMP1
FROM bronze.crm_sales_details

-- 1. Checking the correctness of all data

SELECT *
FROM #TEMP1
-- the date data have been converted into DATE format, all data valid

-- 2. Checking is there any anomalies in sls_order_dt column

SELECT *
FROM #TEMP1
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt OR sls_ship_dt > sls_due_dt
-- data is valid

-- 3. CHecking the correctness of price, sales, and quantity data

SELECT *
FROM #TEMP1
WHERE sls_sales <> sls_quantity * sls_price
-- data is valid


/*
Its all good, now we have the query code that we will use to select the cleaned data from bronze.crm_sales_details into silver.crm_sales_details

The query is stated below (p.s dont forget to drop the TEMP TABLE for later purposes)
*/

SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CAST(CAST(CASE
		WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) <> 8 THEN NULL
		ELSE sls_order_dt
	END AS NVARCHAR) AS DATE) as sls_order_dt,
	CAST(CAST(sls_ship_dt AS nvarchar) AS DATE) AS sls_ship_dt,
	CAST(CAST(sls_due_dt AS nvarchar) AS date) AS sls_due_dt,
	CASE
		WHEN sls_sales = 0 THEN ABS(sls_price * sls_quantity)
		WHEN sls_sales < 0 THEN ABS(sls_quantity * sls_price)
		WHEN sls_sales IS NULL THEN ABS(sls_price * sls_quantity)
		WHEN sls_sales <> sls_price * sls_quantity THEN ABS(sls_price * sls_quantity)
		ELSE sls_sales
	END as sls_sales,
	sls_quantity,
	CASE
		WHEN sls_price = 0 THEN ABS(sls_sales/sls_quantity)
		WHEN sls_price IS NULL THEN ABS(sls_sales/sls_quantity)
		WHEN sls_price < 0 THEN ABS(sls_price)
		ELSE sls_price
	END AS sls_price
FROM bronze.crm_sales_details


-- * Drop TEMP TABLE
IF OBJECT_ID(N'tempdb..#TEMP1') IS NOT NULL
BEGIN
DROP TABLE #TEMP1
END
GO