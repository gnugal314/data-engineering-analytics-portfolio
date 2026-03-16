-- ============================================================================
-- File: duplicate_checks.sql
-- Purpose: Identify duplicate records across core analytics tables
-- Project: 01-data-platform-foundations
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS quality;

DROP TABLE IF EXISTS quality.duplicate_checks_summary;

CREATE TABLE quality.duplicate_checks_summary AS

WITH fact_sales_duplicates AS (
    SELECT
        'analytics.fact_sales_transactions' AS table_name,
        'invoice_no, stock_code, customer_id, invoice_timestamp' AS duplicate_key,
        COUNT(*) AS duplicate_group_count,
        SUM(record_count) AS duplicate_row_count
    FROM (
        SELECT
            invoice_no,
            stock_code,
            customer_id,
            invoice_timestamp,
            COUNT(*) AS record_count
        FROM analytics.fact_sales_transactions
        GROUP BY
            invoice_no,
            stock_code,
            customer_id,
            invoice_timestamp
        HAVING COUNT(*) > 1
    ) d
),

dim_customer_duplicates AS (
    SELECT
        'analytics.dim_customer' AS table_name,
        'customer_id' AS duplicate_key,
        COUNT(*) AS duplicate_group_count,
        SUM(record_count) AS duplicate_row_count
    FROM (
        SELECT
            customer_id,
            COUNT(*) AS record_count
        FROM analytics.dim_customer
        GROUP BY customer_id
        HAVING COUNT(*) > 1
    ) d
),

dim_product_duplicates AS (
    SELECT
        'analytics.dim_product' AS table_name,
        'stock_code' AS duplicate_key,
        COUNT(*) AS duplicate_group_count,
        SUM(record_count) AS duplicate_row_count
    FROM (
        SELECT
            stock_code,
            COUNT(*) AS record_count
        FROM analytics.dim_product
        GROUP BY stock_code
        HAVING COUNT(*) > 1
    ) d
),

dim_date_duplicates AS (
    SELECT
        'analytics.dim_date' AS table_name,
        'date_day' AS duplicate_key,
        COUNT(*) AS duplicate_group_count,
        SUM(record_count) AS duplicate_row_count
    FROM (
        SELECT
            date_day,
            COUNT(*) AS record_count
        FROM analytics.dim_date
        GROUP BY date_day
        HAVING COUNT(*) > 1
    ) d
)

SELECT * FROM fact_sales_duplicates
UNION ALL
SELECT * FROM dim_customer_duplicates
UNION ALL
SELECT * FROM dim_product_duplicates
UNION ALL
SELECT * FROM dim_date_duplicates;