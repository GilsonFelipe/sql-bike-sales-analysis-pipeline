/*
==============================================================
CREATING DATABASE AND SCHEMAS
==============================================================

1. Script Purpose:
   This script creates a new database called 'DataWarehouse' after checking if it already exists. 
   If it does, the database will be dropped and recreated. It also creates three schemas: bronze, silver, and gold.

2. Warning Message:
   Running this script will permanently delete the existing 'DataWarehouse' database and all its contents.
   Ensure you have a backup before proceeding.
*/

USE master;
GO

-- DROP 'Data_Warehouse' DATABASE IF IT EXIST

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Data_Warehouse')
BEGIN
	ALTER DATABASE Data_Warehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE Data_Warehouse;
END;
GO

-- CREATE 'Data_Warehouse' DATABASE

CREATE DATABASE Data_Warehouse;
GO

-- USE 'Data_Warehouse' DATABASE

USE Data_Warehouse;
GO

-- CREATE SCHEMAS

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO