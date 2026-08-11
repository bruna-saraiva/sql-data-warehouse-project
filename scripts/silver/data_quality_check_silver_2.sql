-- Data Quality Check Queries

-- Check For Nulls or Duplicates in Primary Key
-- Expectation: No Result
USE DataWarehouse
GO

SELECT
prd_id, count(*) as quantity_duplicate
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING count(*) > 1 or prd_id IS NULL;

-- Check for unwanted spaces
-- Expectation: No Result
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for Nulls or Negative Numbers
-- Expectations : No result
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization & Consistency 
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- Check for Invalid Date Orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


-- Check complete table
SELECT *
FROM silver.crm_prd_info;
