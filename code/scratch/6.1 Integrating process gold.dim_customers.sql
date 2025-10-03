/*
=============================================================================================
Scratch of Data Integration For gold.dim_customers
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
FROM silver.crm_cust_info

SELECT *
FROM silver.erp_cust_az12

SELECT *
FROM silver.erp_loc_a101

/*
From the integrity checking we know:

1. There is 1 customers that dont have any birthdate data, because its not available in silver.erp_cust_az12
2. There are two gender data of customer, one in silver.crm_cust_info and another in silver.erp_cust_az12, so here is the rules:
	- The crm_cust_info is the master table, so the reference is based on it, when there is unnmatching data betwen gender on the join table,
	  we use gender from master table.
	- if the master table gender data is not avalible, then ref the gender from erp_cust_az12
*/
-- 2. Selecting data for gold.dim_customers

SELECT
	cci.cst_id AS customer_id,
	cci.cst_key AS customer_number,
	cci.cst_firstname AS fist_name,
	cci.cst_lastname AS last_name,
	CASE
		WHEN cci.cst_gndr = 'n/a' AND eca.gen IS NOT NULL THEN eca.gen
		WHEN cci.cst_gndr = 'n/a' AND eca.gen IS NULL THEN 'n/a'
		ELSE cci.cst_gndr
	END AS gender,
	eca.bdate AS birth_date,
	ela.cntry AS country,
	cci.cst_create_date AS create_date
FROM silver.crm_cust_info AS cci
LEFT JOIN silver.erp_cust_az12 as eca
ON cci.cst_key = eca.cid
LEFT JOIN silver.erp_loc_a101 as ela
ON ela.cid = cci.cst_key

-- 3. Create Surrogate Key

SELECT
	RANK() OVER (ORDER BY cci.cst_id ASC) AS customer_key,
	cci.cst_id AS customer_id,
	cci.cst_key AS customer_number,
	cci.cst_firstname AS fist_name,
	cci.cst_lastname AS last_name,
	CASE
		WHEN cci.cst_gndr = 'n/a' AND eca.gen IS NOT NULL THEN eca.gen
		WHEN cci.cst_gndr = 'n/a' AND eca.gen IS NULL THEN 'n/a'
		ELSE cci.cst_gndr
	END AS gender,
	eca.bdate AS birth_date,
	ela.cntry AS country,
	cci.cst_create_date AS create_date
FROM silver.crm_cust_info AS cci
LEFT JOIN silver.erp_cust_az12 as eca
ON cci.cst_key = eca.cid
LEFT JOIN silver.erp_loc_a101 as ela
ON ela.cid = cci.cst_key;

/*
========================================== Validate the integrated data =======================================
*/

-- 1. Checking duplicates data

WITH integrated_data AS(
SELECT
	RANK() OVER (ORDER BY cci.cst_id ASC) AS customer_key,
	cci.cst_id AS customer_id,
	cci.cst_key AS customer_number,
	cci.cst_firstname AS fist_name,
	cci.cst_lastname AS last_name,
	CASE
		WHEN cci.cst_gndr = 'n/a' AND eca.gen IS NOT NULL THEN eca.gen
		WHEN cci.cst_gndr = 'n/a' AND eca.gen IS NULL THEN 'n/a'
		ELSE cci.cst_gndr
	END AS gender,
	eca.bdate AS birth_date,
	ela.cntry AS country,
	cci.cst_create_date AS create_date
FROM silver.crm_cust_info AS cci
LEFT JOIN silver.erp_cust_az12 as eca
ON cci.cst_key = eca.cid
LEFT JOIN silver.erp_loc_a101 as ela
ON ela.cid = cci.cst_key)
SELECT
	customer_number,
	COUNT(customer_number) AS number_count
FROM integrated_data
GROUP BY customer_number
HAVING COUNT(customer_number) > 1
-- all good

-- 2. Checking surrogate key

WITH integrated_data AS(
SELECT
	RANK() OVER (ORDER BY cci.cst_id ASC) AS customer_key,
	cci.cst_id AS customer_id,
	cci.cst_key AS customer_number,
	cci.cst_firstname AS fist_name,
	cci.cst_lastname AS last_name,
	CASE
		WHEN cci.cst_gndr = 'n/a' AND eca.gen IS NOT NULL THEN eca.gen
		WHEN cci.cst_gndr = 'n/a' AND eca.gen IS NULL THEN 'n/a'
		ELSE cci.cst_gndr
	END AS gender,
	eca.bdate AS birth_date,
	ela.cntry AS country,
	cci.cst_create_date AS create_date
FROM silver.crm_cust_info AS cci
LEFT JOIN silver.erp_cust_az12 as eca
ON cci.cst_key = eca.cid
LEFT JOIN silver.erp_loc_a101 as ela
ON ela.cid = cci.cst_key)
SELECT
	customer_key,
	COUNT(customer_key) AS number_key
FROM integrated_data
GROUP BY customer_key
HAVING COUNT(customer_key) > 1
-- all good

-- 3. Check the gender column

WITH integrated_data AS(
SELECT
	RANK() OVER (ORDER BY cci.cst_id ASC) AS customer_key,
	cci.cst_id AS customer_id,
	cci.cst_key AS customer_number,
	cci.cst_firstname AS fist_name,
	cci.cst_lastname AS last_name,
	CASE
		WHEN cci.cst_gndr = 'n/a' AND eca.gen IS NOT NULL THEN eca.gen
		WHEN cci.cst_gndr = 'n/a' AND eca.gen IS NULL THEN 'n/a'
		ELSE cci.cst_gndr
	END AS gender,
	eca.bdate AS birth_date,
	ela.cntry AS country,
	cci.cst_create_date AS create_date
FROM silver.crm_cust_info AS cci
LEFT JOIN silver.erp_cust_az12 as eca
ON cci.cst_key = eca.cid
LEFT JOIN silver.erp_loc_a101 as ela
ON ela.cid = cci.cst_key)
SELECT DISTINCT gender
FROM integrated_data
-- all good

-- 4. Make sure we have all data that we need, and check if all the data is placed in the correct column or not

SELECT
	RANK() OVER (ORDER BY cci.cst_id ASC) AS customer_key,
	cci.cst_id AS customer_id,
	cci.cst_key AS customer_number,
	cci.cst_firstname AS fist_name,
	cci.cst_lastname AS last_name,
	CASE
		WHEN cci.cst_gndr = 'n/a' AND eca.gen IS NOT NULL THEN eca.gen
		WHEN cci.cst_gndr = 'n/a' AND eca.gen IS NULL THEN 'n/a'
		ELSE cci.cst_gndr
	END AS gender,
	eca.bdate AS birth_date,
	ela.cntry AS country,
	cci.cst_create_date AS create_date
FROM silver.crm_cust_info AS cci
LEFT JOIN silver.erp_cust_az12 as eca
ON cci.cst_key = eca.cid
LEFT JOIN silver.erp_loc_a101 as ela
ON ela.cid = cci.cst_key
-- all good

/*
Its all good, now we have the query code that we will use to select the intefrated data data from silver layer into gold.dim_customers

The query is stated below
*/

SELECT
	RANK() OVER (ORDER BY cci.cst_id ASC) AS customer_key,
	cci.cst_id AS customer_id,
	cci.cst_key AS customer_number,
	cci.cst_firstname AS fist_name,
	cci.cst_lastname AS last_name,
	CASE
		WHEN cci.cst_gndr = 'n/a' AND eca.gen IS NOT NULL THEN eca.gen
		WHEN cci.cst_gndr = 'n/a' AND eca.gen IS NULL THEN 'n/a'
		ELSE cci.cst_gndr
	END AS gender,
	eca.bdate AS birth_date,
	ela.cntry AS country,
	cci.cst_create_date AS create_date
FROM silver.crm_cust_info AS cci
LEFT JOIN silver.erp_cust_az12 as eca
ON cci.cst_key = eca.cid
LEFT JOIN silver.erp_loc_a101 as ela
ON ela.cid = cci.cst_key