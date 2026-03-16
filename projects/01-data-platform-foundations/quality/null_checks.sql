-- ============================================================================
-- File: null_checks.sql
-- Purpose: Validate null rates across core analytics tables
-- Project: 01-data-platform-foundations
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS quality;

DROP TABLE IF EXISTS quality.null_checks_summary;

CREATE TABLE quality.null_checks_summary AS

SELECT
    'analytics.fact_sales_transactions' AS table_name,
    'invoice_no' AS column_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN invoice_no IS NULL THEN 1 ELSE 0 END) AS null_count
FROM analytics.fact_sales_transactions

UNION ALL

SELECT
    'analytics.fact_sales_transactions',
    'stock_code',
    COUNT(*),
    SUM(CASE WHEN stock_code IS NULL THEN 1 ELSE 0 END)
FROM analytics.fact_sales_transactions

UNION ALL

SELECT
    'analytics.fact_sales_transactions',
    'invoice_timestamp',
    COUNT(*),
    SUM(CASE WHEN invoice_timestamp IS NULL THEN 1 ELSE 0 END)
FROM analytics.fact_sales_transactions

UNION ALL

SELECT
    'analytics.fact_sales_transactions',
    'invoice_date',
    COUNT(*),
    SUM(CASE WHEN invoice_date IS NULL THEN 1 ELSE 0 END)
FROM analytics.fact_sales_transactions

UNION ALL

SELECT
    'analytics.fact_sales_transactions',
    'unit_price',
    COUNT(*),
    SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END)
FROM analytics.fact_sales_transactions

UNION ALL

SELECT
    'analytics.fact_sales_transactions',
    'customer_id',
    COUNT(*),
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END)
FROM analytics.fact_sales_transactions

UNION ALL

SELECT
    'analytics.fact_sales_transactions',
    'country',
    COUNT(*),
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END)
FROM analytics.fact_sales_transactions

UNION ALL

SELECT
    'analytics.fact_sales_transactions',
    'net_sales_amount',
    COUNT(*),
    SUM(CASE WHEN net_sales_amount IS NULL THEN 1 ELSE 0 END)
FROM analytics.fact_sales_transactions

UNION ALL

SELECT
    'analytics.dim_customer',
    'customer_id',
    COUNT(*),
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END)
FROM analytics.dim_customer

UNION ALL

SELECT
    'analytics.dim_customer',
    'first_purchase_date',
    COUNT(*),
    SUM(CASE WHEN first_purchase_date IS NULL THEN 1 ELSE 0 END)
FROM analytics.dim_customer

UNION ALL

SELECT
    'analytics.dim_customer',
    'last_purchase_date',
    COUNT(*),
    SUM(CASE WHEN last_purchase_date IS NULL THEN 1 ELSE 0 END)
FROM analytics.dim_customer

UNION ALL

SELECT
    'analytics.dim_customer',
    'total_orders',
    COUNT(*),
    SUM(CASE WHEN total_orders IS NULL THEN 1 ELSE 0 END)
FROM analytics.dim_customer

UNION ALL

SELECT
    'analytics.dim_customer',
    'total_spend',
    COUNT(*),
    SUM(CASE WHEN total_spend IS NULL THEN 1 ELSE 0 END)
FROM analytics.dim_customer

UNION ALL

SELECT
    'analytics.dim_customer',
    'country',
    COUNT(*),
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END)
FROM analytics.dim_customer

UNION ALL

SELECT
    'analytics.dim_customer',
    'customer_segment',
    COUNT(*),
    SUM(CASE WHEN customer_segment IS NULL THEN 1 ELSE 0 END)
FROM analytics.dim_customer

UNION ALL

SELECT
    'analytics.dim_product',
    'stock_code',
    COUNT(*),
    SUM(CASE WHEN stock_code IS NULL THEN 1 ELSE 0 END)
FROM analytics.dim_product

UNION ALL

SELECT
    'analytics.dim_product',
    'product_description',
    COUNT(*),
    SUM(CASE WHEN product_description IS NULL THEN 1 ELSE 0 END)
FROM analytics.dim_product

UNION ALL

SELECT
    'analytics.dim_product',
    'first_sale_date',
    COUNT(*),
    SUM(CASE WHEN first_sale_date IS NULL THEN 1 ELSE 0 END)
FROM analytics.dim_product

UNION ALL

SELECT
    'analytics.dim_product',
    'last_sale_date',
    COUNT(*),
    SUM(CASE WHEN last_sale_date IS NULL THEN 1 ELSE 0 END)
FROM analytics.dim_product

UNION ALL

SELECT
    'analytics.dim_product',
    'total_units_sold',
    COUNT(*),
    SUM(CASE WHEN total_units_sold IS NULL THEN 1 ELSE 0 END)
FROM analytics.dim_product

UNION ALL

SELECT
    'analytics.dim_product',
    'net_revenue',
    COUNT(*),
    SUM(CASE WHEN net_revenue IS NULL THEN 1 ELSE 0 END)
FROM analytics.dim_product

UNION ALL

SELECT
    'analytics.dim_product',
    'revenue_band',
    COUNT(*),
    SUM(CASE WHEN revenue_band IS NULL THEN 1 ELSE 0 END)
FROM analytics.dim_product

UNION ALL

SELECT
    'analytics.dim_date',
    'date_day',
    COUNT(*),
    SUM(CASE WHEN date_day IS NULL THEN 1 ELSE 0 END)
FROM analytics.dim_date

UNION ALL

SELECT
    'analytics.dim_date',
    'calendar_year',
    COUNT(*),
    SUM(CASE WHEN calendar_year IS NULL THEN 1 ELSE 0 END)
FROM analytics.dim_date

UNION ALL

SELECT
    'analytics.dim_date',
    'calendar_month',
    COUNT(*),
    SUM(CASE WHEN calendar_month IS NULL THEN 1 ELSE 0 END)
FROM analytics.dim_date

UNION ALL

SELECT
    'analytics.dim_date',
    'month_name',
    COUNT(*),
    SUM(CASE WHEN month_name IS NULL THEN 1 ELSE 0 END)
FROM analytics.dim_date

UNION ALL

SELECT
    'analytics.dim_date',
    'day_name',
    COUNT(*),
    SUM(CASE WHEN day_name IS NULL THEN 1 ELSE 0 END)
FROM analytics.dim_date;