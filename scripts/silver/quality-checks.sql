-- Data Quility Checks (Examples):

-- Check 1: Checking for duplicate primary keys (must be unique and not null)
SELECT cst_id,
COUNT (*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

SELECT *
FROM bronze.crm_cust_info
WHERE cst_id = 29466;

-- Fix
-- Ranking the rows based on the creation date to keep only the last updated row
SELECT * FROM (
SELECT *,
RANK() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
FROM bronze.crm_cust_info
)t
WHERE flag_last = 1;

-- Check 2: Checking for spaces
SELECT cst_firstname
from bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Fix
-- We just need trim all the columns while loading the date into silver layer tables
SELECT TRIM(cst_firstname)
FROM bronze.crm_cust_info

-- Check 3: Checking for consistency in low cardinality columns
-- And standardizing the values as an when needed
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;

-- Standardizing
SELECT
CASE UPPER(cst_gndr)
	WHEN 'F' THEN 'Female'
	WHEN 'M' THEN 'Male'
	ELSE 'n/a'
END cst_gndr
FROM bronze.crm_cust_info
/*
SELECT
CASE WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
	WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
	ELSE 'n/a'
END cst_gndr
FROM bronze.crm_cust_info
*/
