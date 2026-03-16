-- ============================================================================
-- File: create_dim_product.sql
-- Purpose: Build analytics.dim_product from fact_sales_transactions
-- Project: 01-data-platform-foundations
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS analytics;

DROP TABLE IF EXISTS analytics.dim_product;

CREATE TABLE analytics.dim_product AS

WITH product_base AS (
    SELECT
        stock_code,
        product_description,
        country,
        invoice_date,
        quantity,
        is_return,
        gross_sales_amount,
        net_sales_amount
    FROM analytics.fact_sales_transactions
    WHERE stock_code IS NOT NULL
),

product_metrics AS (
    SELECT
        stock_code,
        MAX(product_description) AS product_description,
        MIN(invoice_date) AS first_sale_date,
        MAX(invoice_date) AS last_sale_date,
        COUNT(*) AS transaction_line_count,
        COUNT(DISTINCT country) AS countries_sold_count,
        SUM(CASE WHEN is_return = 0 THEN quantity ELSE 0 END) AS total_units_sold,
        SUM(CASE WHEN is_return = 1 THEN ABS(quantity) ELSE 0 END) AS total_units_returned,
        SUM(gross_sales_amount) AS gross_revenue,
        SUM(net_sales_amount) AS net_revenue,
        SUM(CASE WHEN is_return = 1 THEN 1 ELSE 0 END) AS return_transaction_count
    FROM product_base
    GROUP BY stock_code
),

product_enriched AS (
    SELECT
        stock_code,
        product_description,
        first_sale_date,
        last_sale_date,
        transaction_line_count,
        countries_sold_count,
        total_units_sold,
        total_units_returned,
        gross_revenue,
        net_revenue,
        return_transaction_count,

        CASE
            WHEN net_revenue >= 50000 THEN 'Top Revenue'
            WHEN net_revenue >= 10000 THEN 'High Revenue'
            WHEN net_revenue >= 1000 THEN 'Mid Revenue'
            ELSE 'Low Revenue'
        END AS revenue_band,

        CASE
            WHEN total_units_returned > total_units_sold * 0.25 THEN 'High Return Risk'
            WHEN total_units_returned > 0 THEN 'Some Returns'
            ELSE 'No Returns'
        END AS return_profile
    FROM product_metrics
)

SELECT
    stock_code,
    product_description,
    first_sale_date,
    last_sale_date,
    transaction_line_count,
    countries_sold_count,
    total_units_sold,
    total_units_returned,
    gross_revenue,
    net_revenue,
    return_transaction_count,
    revenue_band,
    return_profile
FROM product_enriched;