# Project 01 — Enterprise Data Platform Foundations

## Overview

This project simulates a production-minded data engineering and analytics workflow using a publicly available retail transactions dataset.

The objective is to design and document an end-to-end analytics pipeline that demonstrates:

- ingestion of raw source data
- SQL-based transformations
- creation of analytics-ready datasets
- data quality validation
- business-facing dashboard metrics

This project is intentionally structured to mirror how a modern enterprise data platform team might design a foundational analytics workflow.

---

## Business Scenario

A retail analytics team needs a reliable reporting layer for sales, customer activity, product performance, and operational monitoring.

The source data arrives as transactional retail records. Analysts and business leaders need trusted metrics that can support:

- revenue reporting
- order trend analysis
- customer purchasing patterns
- product demand monitoring
- data quality exception tracking

The platform must support both technical review and business consumption.

---

## Public Dataset

This project uses the **UCI Online Retail dataset**.

Dataset summary:
- UK-based non-store online retail transaction data
- transaction period: **2010-12-01 through 2011-12-09**
- **541,909** records
- **6** core fields
- business-oriented transaction data suitable for analytics and clustering use cases

Suggested source reference:
- UCI Machine Learning Repository — Online Retail

---

## Project Goals

This project is designed to demonstrate the ability to:

1. ingest public source data into a raw landing layer
2. transform raw transactions into analytics-ready tables
3. apply data quality checks across critical business fields
4. expose reusable dashboard metrics for reporting
5. document architecture, assumptions, and engineering decisions clearly

---

## End-to-End Pipeline

### 1. Ingestion Pipeline

The ingestion layer is responsible for loading the raw retail transaction file into a raw zone.

**Ingestion objectives**
- preserve source fidelity
- standardize column names
- load source data into a raw table
- capture load metadata
- prepare data for downstream SQL transformations

**Example ingestion flow**
1. Download source file from public dataset repository
2. Store file in `/data/raw`
3. Load file into a raw relational table such as `raw.online_retail_transactions`
4. Append ingestion metadata:
   - load timestamp
   - source file name
   - batch id
5. Validate row count against source extract

**Example raw schema**
- InvoiceNo
- StockCode
- Description
- Quantity
- InvoiceDate
- UnitPrice
- CustomerID
- Country

---

### 2. SQL Transformations

The transformation layer converts raw transaction data into curated reporting structures.

**Transformation objectives**
- standardize types
- remove invalid records
- derive reusable business fields
- create reporting-friendly tables
- separate raw, cleaned, and analytics layers

**Example transformation steps**
- cast `InvoiceDate` to timestamp
- trim and standardize product descriptions
- filter invalid quantities and unit prices where appropriate
- identify cancellations / returns
- derive:
  - order date
  - year-month
  - gross sales amount
  - net sales amount
  - return indicator
- create cleaned transaction fact table

**Example derived calculation**
- `sales_amount = quantity * unit_price`

**Example curated tables**
- `analytics.fact_sales_transactions`
- `analytics.dim_product`
- `analytics.dim_customer`
- `analytics.dim_date`
- `analytics.agg_monthly_sales`
- `analytics.agg_country_sales`

---

### 3. Analytics Dataset

The analytics layer should expose trusted, reusable datasets for BI and reporting.

**Primary analytics datasets**
- **Fact Sales Transactions**
  - transaction-level sales facts
- **Customer Summary**
  - customer purchase frequency
  - recency
  - monetary value
- **Product Performance Summary**
  - units sold
  - revenue by product
- **Monthly Sales Summary**
  - monthly sales and order trends
- **Country Sales Summary**
  - sales by geography

**Example analytics use cases**
- identify top-selling products
- monitor monthly revenue trends
- compare country-level sales performance
- analyze customer purchasing behavior
- support executive KPI dashboards

---

### 4. Data Quality Checks

Data quality is treated as a core engineering responsibility, not a downstream cleanup task.

**Key data quality checks**
- null checks on critical fields
- duplicate detection
- invalid price detection
- invalid quantity detection
- timestamp parsing validation
- referential consistency checks
- anomaly checks on unusually large values
- reconciliation of raw vs curated row counts

**Example quality rules**
- `InvoiceNo` must not be null
- `StockCode` must not be null
- `InvoiceDate` must be parseable as a valid timestamp
- `UnitPrice` should not be negative for valid sale records
- zero or negative quantities must be classified correctly as returns or exceptions
- curated row counts must reconcile to transformation logic

**Suggested output**
- quality summary table
- failed-record exception table
- daily pipeline validation log

---

### 5. Dashboard Metrics

The dashboard layer should focus on business-facing metrics that are stable, interpretable, and traceable to curated tables.

**Core dashboard metrics**
- total revenue
- net revenue
- total orders
- total units sold
- average order value
- active customers
- returning customers
- top products by revenue
- sales by country
- monthly revenue trend
- return / cancellation rate
- data quality exception count

**Example executive questions this dashboard answers**
- How is revenue trending over time?
- Which products contribute most to revenue?
- Which countries are generating the highest sales?
- Are return rates increasing?
- Are there quality issues affecting trust in reporting?

---

## Proposed Repository Structure

```text
projects/
  01-data-platform-foundations/
    README.md
    problem-statement.md
    dataset.md
    architecture.md
    pipeline/
      README.md
      ingestion.py
      load_raw.sql
    analytics/
      create_fact_sales.sql
      create_dim_customer.sql
      create_monthly_sales.sql
    quality/
      null_checks.sql
      duplicate_checks.sql
      reconciliation_checks.sql
    notebooks/
      exploratory-analysis.ipynb
    results/
      dashboard-metrics.md
      data-quality-summary.md
