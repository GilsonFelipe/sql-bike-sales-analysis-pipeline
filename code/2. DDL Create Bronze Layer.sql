/*
=======================================================================
DDL Script: Create bronze Layer Tables
=======================================================================

Script Purpose:
   This script creates all required tables in the 'bronze' schema.

*/

USE Data_Warehouse
GO

-- CREATING 'bronze.crm_cust_info' TABLE

CREATE TABLE bronze.crm_cust_info(
	cst_id		int,
	cst_key		NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status	NVARCHAR(50),
	cst_gndr	NVARCHAR(50),
	cst_create_date	DATE
	)
GO

-- CREATING 'bronze.crm_prd_info' TABLE

CREATE TABLE bronze.crm_prd_info(
	prd_id INT,
	prd_key	NVARCHAR(50),
	prd_nm	NVARCHAR(50),
	prd_cost INT,
	prd_line	NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt	DATE
	)
GO

-- CREATING 'bronze.crm_sales_details' TABLE

CREATE TABLE bronze.crm_sales_details(
	sls_ord_num	NVARCHAR(50),
	sls_prd_key	NVARCHAR(50),
	sls_cust_id	INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales	INT,
	sls_quantity	INT,
	sls_price	INT
	)
GO

-- CREATING 'bronze.erp_cust_az12' TABLE

CREATE TABLE bronze.erp_cust_az12(
	cid NVARCHAR(50),
	bdate DATE,
	gen	NVARCHAR(50)
	)
GO

-- CREATING 'bronze.erp_loc_A101' TABLE

CREATE TABLE bronze.erp_loc_a101(
	cid NVARCHAR(50),
	cntry NVARCHAR(50)
	)
GO

-- CREATING 'bronze.erp_px_cat_giv2' TABLE

CREATE TABLE bronze.erp_px_cat_giv2(
	id	nvarchar(50),
	cat	nvarchar(50),
	subcat	nvarchar(50),
	maintanance	nvarchar(50)
	)
GO