-- Data Quality Check Queries

-- Check For Nulls or Duplicates in Primary Key
-- Expectation: No Result
USE DataWarehouse
GO

SELECT
cst_id, count(*) as quantity_duplicate
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING count(*) > 1 or cst_id IS NULL;


-- Check for unwanted spaces
-- Expectation: No Result
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Check for unwanted spaces
-- Expectation: No Result
SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Check for unwanted spaces
-- Expectation: No Result -- First Quality Check indicated the Column is Clean
SELECT cst_gndr
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

-- Check for unwanted spaces
-- Expectation: No Result -- First Quality Check indicated the Column is Clean
SELECT cst_marital_status
FROM bronze.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);

-- Data Standardization & Consistency in gndr and marital columns
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info;

-- Verify if dates are real dates or are string


-- Verify id data were correctly cleaned and inserted in silver layer
SELECT
cst_id, count(*) as quantity_duplicate
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING count(*) > 1 or cst_id IS NULL;


-- Check for unwanted spaces
-- Expectation: No Result
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Check for unwanted spaces
-- Expectation: No Result
SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Check for unwanted spaces
-- Expectation: No Result -- First Quality Check indicated the Column is Clean
SELECT cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

-- Check for unwanted spaces
-- Expectation: No Result -- First Quality Check indicated the Column is Clean
SELECT cst_marital_status
FROM silver.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);

-- Data Standardization & Consistency in gndr and marital columns
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;

SELECT * FROM silver.crm_cust_info;