-- ============================================================================
-- File: create_dim_customer.sql
-- Purpose: Build analytics.dim_customer from fact_sales_transactions
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS analytics;

DROP TABLE IF EXISTS analytics.dim_customer;

CREATE TABLE analytics.dim_customer AS

WITH customer_metrics AS (

    SELECT
        customer_id,
        MIN(invoice_date) AS first_purchase_date,
        MAX(invoice_date) AS last_purchase_date,
        COUNT(DISTINCT invoice_no) AS total_orders,
        SUM(net_sales_amount) AS total_spend,
        MAX(country) AS country

    FROM analytics.fact_sales_transactions
    WHERE customer_id IS NOT NULL

    GROUP BY customer_id
),

customer_lifecycle AS (

    SELECT
        customer_id,
        first_purchase_date,
        last_purchase_date,
        total_orders,
        total_spend,
        country,

        CASE
            WHEN total_spend >= 5000 THEN 'VIP'
            WHEN total_spend >= 1000 THEN 'High Value'
            WHEN total_spend >= 250 THEN 'Mid Value'
            ELSE 'Low Value'
        END AS customer_segment

    FROM customer_metrics
)

SELECT
    customer_id,
    first_purchase_date,
    last_purchase_date,
    total_orders,
    total_spend,
    country,
    customer_segment

FROM customer_lifecycle;