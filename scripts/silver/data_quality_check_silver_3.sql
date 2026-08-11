-- Quality Checks

-- Verify sls_ord_num for blank spaces
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
WHERE sls_ord_num != TRIM(sls_ord_num)


--  Verify integrity between two columns: sls_prd_key and prd_key(silver.crm_prd_info)

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
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info);

--  Verify integrity between two columns: sls_cust_id and prd_key(silver.crm_cust_info)

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
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);

-- Check for Invalid Dates
-- sls_order_d
SELECT
NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0
OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101;


-- sls_ship_dt
SELECT
NULLIF(sls_ship_dt,0) sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0
OR LEN(sls_ship_dt) != 8
OR sls_ship_dt > 20500101
OR sls_ship_dt < 19000101;

-- sls_due_dt
SELECT
NULLIF(sls_due_dt,0) sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101;

-- Verify if order and ship dates are cronologically valid
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Verify sls_sales, sls_quantity, sls_price
-- Business Rules:
-- Sum of Sales = Quantity * Prices
-- Negative, Zeros, Nulls are not allowed
-- We have to check the data consistensy in theses columns
-- Check Data Consistency: Between Sales, Quantity, and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, zero, or negative

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;
-- We discouvered that the sls_sales column and sls_price are problematic, there's null and negative rows
-- In the enterprises, the best approach is to ask the businesse people responsible for the source system
-- The will usually give two soulutions : they would fix the data issues direct in source system
-- Or they will not fix and the data issues will be fixed in the data warehouse

-- Rules to deal with the sales consistency
-- If sales is negative, zero, or null, derive it using Quantity and Price
-- If Price is zero or null, calculate it using sales and quantity
-- If price is negative, convert it to a positive value

SELECT DISTINCT
sls_sales AS old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
	THEN sls_quantity * ABS(sls_price)
   ELSE sls_sales
END AS sls_sales,
CASE WHEN sls_price IS NULL OR sls_price <= 0
	THEN sls_sales/ NULLIF(sls_quantity,0)
	ELSE sls_price
END AS sls_price

FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- Check Health of the Silver Layer 

-- Verify sls_ord_num for blank spaces
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
FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)


--  Verify integrity between two columns: sls_prd_key and prd_key(silver.crm_prd_info)

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
FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info);

--  Verify integrity between two columns: sls_cust_id and prd_key(silver.crm_cust_info)

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
FROM silver.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);

-- Check for Invalid Date

-- Verify if order and ship dates are cronologically valid
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Verify sls_sales, sls_quantity, sls_price
-- Business Rules:
-- Sum of Sales = Quantity * Prices
-- Negative, Zeros, Nulls are not allowed
-- We have to check the data consistensy in theses columns
-- Check Data Consistency: Between Sales, Quantity, and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, zero, or negative

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;
-- We discouvered that the sls_sales column and sls_price are problematic, there's null and negative rows
-- In the enterprises, the best approach is to ask the businesse people responsible for the source system
-- The will usually give two soulutions : they would fix the data issues direct in source system
-- Or they will not fix and the data issues will be fixed in the data warehouse

-- Rules to deal with the sales consistency
-- If sales is negative, zero, or null, derive it using Quantity and Price
-- If Price is zero or null, calculate it using sales and quantity
-- If price is negative, convert it to a positive value

SELECT DISTINCT
sls_sales AS old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
	THEN sls_quantity * ABS(sls_price)
   ELSE sls_sales
END AS sls_sales,
CASE WHEN sls_price IS NULL OR sls_price <= 0
	THEN sls_sales/ NULLIF(sls_quantity,0)
	ELSE sls_price
END AS sls_price

FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

SELECT * FROM silver.crm_sales_details;