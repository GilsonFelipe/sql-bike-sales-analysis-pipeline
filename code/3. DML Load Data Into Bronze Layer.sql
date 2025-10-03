/*
===================================================================
Loading Bronze Layer
===================================================================

Script Purpose:
    This stored procedure loads data from source files into the bronze layer by:
    - Truncating all bronze tables
    - Inserting data using BULK INSERT

Parameters: None

Usage: EXEC bronze.procedure_load_bronze
*/

USE Data_Warehouse
GO

CREATE PROCEDURE bronze.procedure_load_bronze AS
BEGIN
	DECLARE
		@start_extract_table DATETIME,
		@end_extract_table	DATETIME,
		@start_extract_batch	DATETIME,
		@end_extract_batch	DATETIME
	BEGIN TRY
	
		SET @start_extract_batch = GETDATE()
		PRINT ('=========================================================================');
        PRINT ('Loading Bronze Layer');
        PRINT ('=========================================================================');

		/*=======================================================CRM DATA LOAD========================================================*/

		PRINT ('=========================================================================');
        PRINT ('CRM DATA LOAD');
        PRINT ('=========================================================================');

		-- bronze.crm_cust_info
		SET @start_extract_table = GETDATE()
		PRINT('>> Truncating bronze.crm_cust_info')
		TRUNCATE TABLE bronze.crm_cust_info

		PRINT('>> Inserting data into bronze.crm_cust_info')
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\harto\OneDrive\Dokumen\DATA ANALYST PORTOFOLIO PROJECT\1. ENDtoEnd Project Automotif Sales\datasets\source_crm\cust_info.csv'
		WITH(FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK)
		SET @end_extract_table = GETDATE()

		PRINT('Loading Success')
		PRINT('Load duration = ' + CAST(DATEDIFF(SECOND, @start_extract_table, @end_extract_table) AS NVARCHAR) + 'second')
		PRINT('***************************************************************************************************************')

		-- bronze.crm_prd_info

		SET @start_extract_table = GETDATE()
		PRINT('>> Truncating bronze.crm_prd_info')
		TRUNCATE TABLE bronze.crm_prd_info

		PRINT('>> Inserting data into bronze.crm_prd_info')
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\harto\OneDrive\Dokumen\DATA ANALYST PORTOFOLIO PROJECT\1. ENDtoEnd Project Automotif Sales\datasets\source_crm\prd_info.csv'
		WITH(FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK)
		SET @end_extract_table = GETDATE()

		PRINT('Loading Success')
		PRINT('Load duration = ' + CAST(DATEDIFF(SECOND, @start_extract_table, @end_extract_table) AS NVARCHAR) + 'second')
		PRINT('***************************************************************************************************************')

		-- bronze.crm_sales_details

		SET @start_extract_table = GETDATE()
		PRINT('>> Truncating bronze.crm_sales_details')
		TRUNCATE TABLE bronze.crm_sales_details

		PRINT('>> >> Inserting data into bronze.crm_sales_details')
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\harto\OneDrive\Dokumen\DATA ANALYST PORTOFOLIO PROJECT\1. ENDtoEnd Project Automotif Sales\datasets\source_crm\crm_sales_details.csv'
		WITH(FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK)
		SET @end_extract_table = GETDATE()

		PRINT('Loading Success')
		PRINT('Load duration = ' + CAST(DATEDIFF(SECOND, @start_extract_table, @end_extract_table) AS NVARCHAR) + 'second')
		PRINT('***************************************************************************************************************')

		/*=========================================================ERP DATA LOAD=================================================================*/

		PRINT('====================================================================================================================')
		PRINT('ERP DATA LOAD')
		PRINT('====================================================================================================================')

		-- bronze.erp_cust_az12

		SET @start_extract_table = GETDATE()
		PRINT('>> Truncating bronze.erp_cust_az12')
		TRUNCATE TABLE bronze.erp_cust_az12

		PRINT('>> Inserting data into bronze.erp_cust_az12')
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\harto\OneDrive\Dokumen\DATA ANALYST PORTOFOLIO PROJECT\1. ENDtoEnd Project Automotif Sales\datasets\source_erp\erp_CUST_AZ12.csv'
		WITH(FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK)
		SET @end_extract_table = GETDATE()

		PRINT('Loading Success')
		PRINT('Loading duration = ' + CAST(DATEDIFF(SECOND, @start_extract_table, @end_extract_table) AS NVARCHAR) + 'second')
		PRINT('***************************************************************************************************************')

		-- bronze.erp_loc_a101

		SET @start_extract_table = GETDATE()
		PRINT('>> Truncating bronze.erp_loc_a101')
		TRUNCATE TABLE bronze.erp_loc_a101

		PRINT('>> Inserting data into bronze.erp_loc_a101')
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\harto\OneDrive\Dokumen\DATA ANALYST PORTOFOLIO PROJECT\1. ENDtoEnd Project Automotif Sales\datasets\source_erp\erp_LOC_A101.csv'
		WITH(FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK)
		SET @end_extract_table = GETDATE()

		PRINT('Loading Success')
		PRINT('Loading duration = ' + CAST(DATEDIFF(SECOND, @start_extract_table, @end_extract_table) AS NVARCHAR) + 'second')
		PRINT('***************************************************************************************************************')

		-- bronze.erp_px_cat_giv2

		SET @start_extract_table = GETDATE()
		PRINT('>> Truncating bronze.erp_px_cat_giv2')
		TRUNCATE TABLE bronze.erp_px_cat_giv2

		PRINT('>> Insering data into bronze.erp_px_cat_giv2')
		BULK INSERT bronze.erp_px_cat_giv2
		FROM 'C:\Users\harto\OneDrive\Dokumen\DATA ANALYST PORTOFOLIO PROJECT\1. ENDtoEnd Project Automotif Sales\datasets\source_erp\erp_PX_CAT_G1V2.csv'
		WITH(FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK)
		SET @end_extract_table = GETDATE()

		PRINT('Loading Success')
		PRINT('Loading duration = ' + CAST(DATEDIFF(SECOND, @start_extract_table, @end_extract_table) AS NVARCHAR) + 'second')
		PRINT('***************************************************************************************************************')

		SET @end_extract_batch = GETDATE()
		PRINT ('=========================================================================');
        PRINT ('Loading Bronze Layer Is Complete');
		PRINT('Loading duration = ' + CAST(DATEDIFF(SECOND, @start_extract_batch, @end_extract_batch) AS NVARCHAR) + 'second')
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

EXEC bronze.procedure_load_bronze