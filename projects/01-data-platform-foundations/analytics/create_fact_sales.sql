-- ============================================================================
-- File: create_fact_sales.sql
-- Purpose: Build analytics.fact_sales_transactions from ingested raw retail data
-- Project: 01-data-platform-foundations
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Assumptions
-- ----------------------------------------------------------------------------
-- Source table:
--   raw.online_retail_transactions
--
-- Expected fields:
--   InvoiceNo
--   StockCode
--   Description
--   Quantity
--   InvoiceDate
--   UnitPrice
--   CustomerID
--   Country
--
-- Notes:
-- - Negative Quantity values may represent returns/cancellations
-- - Invoice numbers beginning with 'C' may indicate cancellations
-- ----------------------------------------------------------------------------

CREATE SCHEMA IF NOT EXISTS analytics;

DROP TABLE IF EXISTS analytics.fact_sales_transactions;

CREATE TABLE analytics.fact_sales_transactions AS

WITH source_data AS (
    SELECT
        TRIM(CAST(InvoiceNo AS VARCHAR))      AS invoice_no,
        TRIM(CAST(StockCode AS VARCHAR))      AS stock_code,
        TRIM(CAST(Description AS VARCHAR))    AS product_description,
        CAST(Quantity AS INTEGER)             AS quantity,
        CAST(InvoiceDate AS TIMESTAMP)        AS invoice_timestamp,
        CAST(UnitPrice AS DECIMAL(18,2))      AS unit_price,
        TRIM(CAST(CustomerID AS VARCHAR))     AS customer_id,
        TRIM(CAST(Country AS VARCHAR))        AS country
    FROM raw.online_retail_transactions
),

standardized_data AS (
    SELECT
        invoice_no,
        stock_code,
        product_description,
        quantity,
        invoice_timestamp,
        CAST(invoice_timestamp AS DATE) AS invoice_date,
        unit_price,
        customer_id,
        country,

        CASE
            WHEN invoice_no LIKE 'C%' THEN 1
            WHEN quantity < 0 THEN 1
            ELSE 0
        END AS is_return,

        ABS(quantity) * unit_price AS gross_sales_amount,

        CASE
            WHEN invoice_no LIKE 'C%' OR quantity < 0
                THEN -1 * (ABS(quantity) * unit_price)
            ELSE quantity * unit_price
        END AS net_sales_amount
    FROM source_data
),

filtered_data AS (
    SELECT
        invoice_no,
        stock_code,
        product_description,
        quantity,
        invoice_timestamp,
        invoice_date,
        unit_price,
        customer_id,
        country,
        is_return,
        gross_sales_amount,
        net_sales_amount
    FROM standardized_data
    WHERE invoice_no IS NOT NULL
      AND stock_code IS NOT NULL
      AND invoice_timestamp IS NOT NULL
      AND unit_price IS NOT NULL
)

SELECT
    invoice_no,
    stock_code,
    product_description,
    quantity,
    invoice_timestamp,
    invoice_date,
    unit_price,
    customer_id,
    country,
    is_return,
    gross_sales_amount,
    net_sales_amount
FROM filtered_data;