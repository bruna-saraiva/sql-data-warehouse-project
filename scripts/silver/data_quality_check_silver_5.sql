-- Quality Checks
-- Comparing primary and foreign keys
SELECT
cid,
cntry
FROM bronze.erp_loc_a101;

SELECT cst_key FROM silver.crm_cust_info;

-- Verify if there is still unmatching data
SELECT
REPLACE(cid, '-', '') cid,
cntry
FROM bronze.erp_loc_a101
WHERE REPLACE(cid, '-', '')  NOT IN (SELECT cst_key FROM silver.crm_cust_info);

-- Data Standardization & Consistency
SELECT DISTINCT cntry
FROM bronze.erp_loc_a101
ORDER BY cntry;
-- Results: abreviation mixed with names, empty rows


-- Quality Check of Silver Layer
SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry;