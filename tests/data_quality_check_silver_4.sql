-- Verify the Primary and Foreign Key

SELECT
cid,
bdate,
gen
FROM bronze.erp_cust_az12;

SELECT *
FROM silver.crm_cust_info
WHERE cst_key LIKE 'AW%';

-- We found unmatching data between cid from erp cst_key from crm 
-- We did a transformation to prevent the previous issue. If nothing is returned, than there are no problems
SELECT
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
	ELSE cid
END AS cid, 
bdate,
gen
FROM bronze.erp_cust_az12
WHERE CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
	ELSE cid
END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info);

-- bdate column
-- Verify type
-- Verify invalid date intervals
SELECT DISTINCT
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE();

-- gen column
-- Check Data Standardization & Consistency
SELECT DISTINCT gen
FROM bronze.erp_cust_az12;
-- We verified there are F, M, Male, Female, 'empty' and NULL rows
-- The transformation that we have to do is a standardization only to Female, Male and NULL


-- Quality Check of the Silver Table
-- Verify invalid date intervals
SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE(); -- Will return old customers

-- Check Data Standardization & Consistency
SELECT DISTINCT gen
FROM silver.erp_cust_az12;

SELECT * FROM silver.erp_cust_az12;