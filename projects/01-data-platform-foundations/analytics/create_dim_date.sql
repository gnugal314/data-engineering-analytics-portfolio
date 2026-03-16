-- ============================================================================
-- File: create_dim_date.sql
-- Purpose: Build analytics.dim_date from fact_sales_transactions
-- Project: 01-data-platform-foundations
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS analytics;

DROP TABLE IF EXISTS analytics.dim_date;

CREATE TABLE analytics.dim_date AS

WITH distinct_dates AS (
    SELECT DISTINCT
        invoice_date AS date_day
    FROM analytics.fact_sales_transactions
    WHERE invoice_date IS NOT NULL
),

date_enriched AS (
    SELECT
        date_day,

        EXTRACT(YEAR FROM date_day) AS calendar_year,
        EXTRACT(MONTH FROM date_day) AS calendar_month,
        EXTRACT(DAY FROM date_day) AS day_of_month,
        EXTRACT(QUARTER FROM date_day) AS calendar_quarter,
        EXTRACT(WEEK FROM date_day) AS week_of_year,
        EXTRACT(DOW FROM date_day) AS day_of_week_number,

        CASE EXTRACT(MONTH FROM date_day)
            WHEN 1 THEN 'January'
            WHEN 2 THEN 'February'
            WHEN 3 THEN 'March'
            WHEN 4 THEN 'April'
            WHEN 5 THEN 'May'
            WHEN 6 THEN 'June'
            WHEN 7 THEN 'July'
            WHEN 8 THEN 'August'
            WHEN 9 THEN 'September'
            WHEN 10 THEN 'October'
            WHEN 11 THEN 'November'
            WHEN 12 THEN 'December'
        END AS month_name,

        CASE EXTRACT(DOW FROM date_day)
            WHEN 0 THEN 'Sunday'
            WHEN 1 THEN 'Monday'
            WHEN 2 THEN 'Tuesday'
            WHEN 3 THEN 'Wednesday'
            WHEN 4 THEN 'Thursday'
            WHEN 5 THEN 'Friday'
            WHEN 6 THEN 'Saturday'
        END AS day_name,

        CASE
            WHEN EXTRACT(DOW FROM date_day) IN (0, 6) THEN 1
            ELSE 0
        END AS is_weekend,

        DATE_TRUNC('month', date_day) AS month_start_date,
        DATE_TRUNC('quarter', date_day) AS quarter_start_date,
        DATE_TRUNC('year', date_day) AS year_start_date

    FROM distinct_dates
)

SELECT
    date_day,
    calendar_year,
    calendar_month,
    day_of_month,
    calendar_quarter,
    week_of_year,
    day_of_week_number,
    month_name,
    day_name,
    is_weekend,
    month_start_date,
    quarter_start_date,
    year_start_date
FROM date_enriched
ORDER BY date_day;