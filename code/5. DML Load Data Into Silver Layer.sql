/*
===================================================================
Loading Silver Layer
===================================================================

Script Purpose:
    This stored procedure loads data from bronze layer into the silver layer by:
    - Truncating all silver tables
    - Inserting cleaned and transformed data

Parameters: None

Usage: EXEC silver.procedure_load_bronze
*/

USE Data_Warehouse
GO


CREATE PROCEDURE silver.procedure_load_silver AS
BEGIN
	DECLARE
		@start_extract_table DATETIME,
		@end_extract_table	DATETIME,
		@start_extract_batch	DATETIME,
		@end_extract_batch	DATETIME
	BEGIN TRY
		SET @start_extract_batch = GETDATE()
		PRINT ('=========================================================================');
        PRINT ('Loading Silver Layer');
        PRINT ('=========================================================================');

		/*=======================================================CRM DATA LOAD========================================================*/

		PRINT ('=========================================================================');
        PRINT ('CRM DATA LOAD');
        PRINT ('=========================================================================');

		-- silver.cem_cust_info
		SET @start_extract_table = GETDATE()
		PRINT('>> Truncating silver.crm_cust_info')
		TRUNCATE TABLE silver.crm_cust_info

		PRINT('>> Inserting data into silver.crm_cust_info')
		INSERT INTO silver.crm_cust_info(
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date)
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
		SET @end_extract_table = GETDATE()

		PRINT('Loading Success')
		PRINT('Load duration = ' + CAST(DATEDIFF(SECOND, @start_extract_table, @end_extract_table) AS NVARCHAR) + ' second')
		PRINT('***************************************************************************************************************')

		-- silver.crm_prd_info

		SET @start_extract_table = GETDATE()
		PRINT('>> Truncating silver.crm_prd_info')
		TRUNCATE TABLE silver.crm_prd_info

		PRINT('>> Inserting data into silver.crm_prd_info')
		INSERT INTO silver.crm_prd_info(
			prd_id,
			prd_cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt)
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
		SET @end_extract_table = GETDATE()

		PRINT('Loading Success')
		PRINT('Load duration = ' + CAST(DATEDIFF(SECOND, @start_extract_table, @end_extract_table) AS NVARCHAR) + 'second')
		PRINT('***************************************************************************************************************')

		-- silver.crm_sales_details

		SET @start_extract_table = GETDATE()
		PRINT('>> Truncating silver.crm_sales_details')
		TRUNCATE TABLE silver.crm_sales_details

		PRINT('>> Inserting data into silver.crm_sales_details')
		INSERT INTO silver.crm_sales_details(
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price)
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
		SET @end_extract_table = GETDATE()

		PRINT('Loading Success')
		PRINT('Load duration = ' + CAST(DATEDIFF(SECOND, @start_extract_table, @end_extract_table) AS NVARCHAR) + ' second')
		PRINT('***************************************************************************************************************')

		/*=======================================================ERP DATA LOAD========================================================*/

		PRINT ('=========================================================================');
        PRINT ('ERP DATA LOAD');
        PRINT ('=========================================================================');

		-- silver.erp_cust_az12

		SET @start_extract_table = GETDATE()
		PRINT('>> Truncating silver.erp_cust_az12')
		TRUNCATE TABLE silver.erp_cust_az12

		PRINT('>> Inserting data into silver.erp_cust_az12')
		INSERT INTO silver.erp_cust_az12(
			cid,
			bdate,
			gen)
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
		SET @end_extract_table = GETDATE()

		PRINT('Loading Success')
		PRINT('Load duration = ' + CAST(DATEDIFF(SECOND, @start_extract_table, @end_extract_table) AS NVARCHAR) + 'second')
		PRINT('***************************************************************************************************************')

		-- silver.erp_loc_a101

		SET @start_extract_table = GETDATE()
		PRINT('>> Truncating silver.erp_loc_a101')
		TRUNCATE TABLE silver.erp_loc_a101

		PRINT('>> Inserting data into silver.erp_loc_a101')
		INSERT INTO silver.erp_loc_a101(
			cid,
			cntry)
		SELECT
			REPLACE(cid, '-', '') AS cid,
			CASE
				WHEN cntry = 'DE' OR cntry = 'Germany' THEN 'Germany'
				WHEN cntry = 'USA' OR cntry = 'US' OR cntry = 'United States' THEN 'United States'
				WHEN cntry = '' OR cntry IS NULL THEN 'n/a'
				ELSE cntry
			END AS cntry
		FROM bronze.erp_loc_a101
		SET @end_extract_table = GETDATE()

		PRINT('Loading Success')
		PRINT('Load duration = ' + CAST(DATEDIFF(SECOND, @start_extract_table, @end_extract_table) AS NVARCHAR) + 'second')
		PRINT('***************************************************************************************************************')

		-- silver.erp_px_cat_g1v2

		SET @start_extract_table = GETDATE()
		PRINT('>> Truncating silver.erp_px_cat_g1v2')
		TRUNCATE TABLE silver.erp_px_cat_g1v2

		PRINT('>> Inserting data into silver.erp_px_cat_g1v2')
		INSERT INTO silver.erp_px_cat_g1v2(
			id,
			cat,
			subcat,
			maintanance)
		SELECT
			id,
			cat,
			subcat,
			maintanance
		FROM bronze.erp_px_cat_giv2
		SET @end_extract_table = GETDATE()

		PRINT('Loading Success')
		PRINT('Load duration = ' + CAST(DATEDIFF(SECOND, @start_extract_table, @end_extract_table) AS NVARCHAR) + 'second')
		PRINT('***************************************************************************************************************')

		SET @end_extract_batch = GETDATE()
		PRINT ('=========================================================================');
        PRINT ('Loading Silver Layer Is Complete');
		PRINT ('Loading duration = ' + CAST(DATEDIFF(SECOND, @start_extract_batch, @end_extract_batch) AS NVARCHAR) + 'second')
        PRINT ('=========================================================================');
	END TRY
	BEGIN CATCH
		PRINT '=========================================================================';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State  : ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=========================================================================';
	END CATCH
END

EXEC silver.procedure_load_silver