-- ============================================================================
-- File: reconciliation_checks.sql
-- Purpose: Reconcile counts and financial metrics across analytics layers
-- Project: 01-data-platform-foundations
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS quality;

DROP TABLE IF EXISTS quality.reconciliation_checks_summary;

CREATE TABLE quality.reconciliation_checks_summary AS

WITH fact_sales_reconciliation AS (
    SELECT
        'fact_sales_transactions_row_count' AS check_name,
        CAST(COUNT(*) AS DECIMAL(18,2)) AS actual_value,
        CAST(NULL AS DECIMAL(18,2)) AS comparison_value,
        'Row count in analytics.fact_sales_transactions' AS check_description
    FROM analytics.fact_sales_transactions
),

fact_sales_net_revenue AS (
    SELECT
        'fact_sales_transactions_net_revenue' AS check_name,
        CAST(SUM(net_sales_amount) AS DECIMAL(18,2)) AS actual_value,
        CAST(NULL AS DECIMAL(18,2)) AS comparison_value,
        'Net revenue total in analytics.fact_sales_transactions' AS check_description
    FROM analytics.fact_sales_transactions
),

monthly_summary_row_count AS (
    SELECT
        'monthly_sales_summary_row_count' AS check_name,
        CAST(COUNT(*) AS DECIMAL(18,2)) AS actual_value,
        CAST(NULL AS DECIMAL(18,2)) AS comparison_value,
        'Row count in analytics.monthly_sales_summary' AS check_description
    FROM analytics.monthly_sales_summary
),

monthly_summary_net_revenue AS (
    SELECT
        'monthly_sales_summary_net_revenue' AS check_name,
        CAST(SUM(net_revenue) AS DECIMAL(18,2)) AS actual_value,
        (
            SELECT CAST(SUM(net_sales_amount) AS DECIMAL(18,2))
            FROM analytics.fact_sales_transactions
        ) AS comparison_value,
        'Net revenue in monthly summary compared to fact table' AS check_description
    FROM analytics.monthly_sales_summary
),

monthly_summary_order_count AS (
    SELECT
        'monthly_sales_summary_total_orders' AS check_name,
        CAST(SUM(total_orders) AS DECIMAL(18,2)) AS actual_value,
        (
            SELECT CAST(COUNT(DISTINCT invoice_no) AS DECIMAL(18,2))
            FROM analytics.fact_sales_transactions
        ) AS comparison_value,
        'Monthly summary order count compared to distinct invoice count in fact table' AS check_description
    FROM analytics.monthly_sales_summary
),

customer_dimension_row_count AS (
    SELECT
        'dim_customer_row_count' AS check_name,
        CAST(COUNT(*) AS DECIMAL(18,2)) AS actual_value,
        (
            SELECT CAST(COUNT(DISTINCT customer_id) AS DECIMAL(18,2))
            FROM analytics.fact_sales_transactions
            WHERE customer_id IS NOT NULL
        ) AS comparison_value,
        'dim_customer row count compared to distinct customer_id count in fact table' AS check_description
    FROM analytics.dim_customer
),

product_dimension_row_count AS (
    SELECT
        'dim_product_row_count' AS check_name,
        CAST(COUNT(*) AS DECIMAL(18,2)) AS actual_value,
        (
            SELECT CAST(COUNT(DISTINCT stock_code) AS DECIMAL(18,2))
            FROM analytics.fact_sales_transactions
            WHERE stock_code IS NOT NULL
        ) AS comparison_value,
        'dim_product row count compared to distinct stock_code count in fact table' AS check_description
    FROM analytics.dim_product
),

date_dimension_row_count AS (
    SELECT
        'dim_date_row_count' AS check_name,
        CAST(COUNT(*) AS DECIMAL(18,2)) AS actual_value,
        (
            SELECT CAST(COUNT(DISTINCT invoice_date) AS DECIMAL(18,2))
            FROM analytics.fact_sales_transactions
            WHERE invoice_date IS NOT NULL
        ) AS comparison_value,
        'dim_date row count compared to distinct invoice_date count in fact table' AS check_description
    FROM analytics.dim_date
)

SELECT * FROM fact_sales_reconciliation
UNION ALL
SELECT * FROM fact_sales_net_revenue
UNION ALL
SELECT * FROM monthly_summary_row_count
UNION ALL
SELECT * FROM monthly_summary_net_revenue
UNION ALL
SELECT * FROM monthly_summary_order_count
UNION ALL
SELECT * FROM customer_dimension_row_count
UNION ALL
SELECT * FROM product_dimension_row_count
UNION ALL
SELECT * FROM date_dimension_row_count;