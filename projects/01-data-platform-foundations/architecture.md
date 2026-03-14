## System Overview

This project simulates a modern analytics data pipeline for retail transaction data.

The system ingests raw transactional records, performs structured transformations,
applies data quality validations, and produces analytics-ready datasets that
support dashboard reporting and business analysis.

## High-Level Architecture

The pipeline follows a layered data architecture:

Source Layer
Raw Ingestion Layer
Transformation Layer
Analytics Layer
Consumption Layer

Public Dataset
      │
      ▼
Raw Ingestion Layer
      │
      ▼
Data Cleaning & Transformation
      │
      ▼
Analytics Data Model
      │
      ▼
Dashboard / BI Layer


## Data Flow

1. Retail transaction dataset is downloaded from the UCI repository.
2. Raw data is ingested into the raw data layer.
3. SQL transformations standardize and clean the data.
4. Curated fact and dimension tables are generated.
5. Data quality checks validate the transformed datasets.
6. Analytics datasets are consumed by dashboard metrics.

## Data Layers

### Raw Layer

Stores source data with minimal transformation.
Purpose: preserve source fidelity.

Example table:
raw.online_retail_transactions

---

### Clean Layer

Applies data standardization and basic validation.

Examples:
clean.transactions

---

### Analytics Layer

Optimized for reporting and analysis.

Examples:
analytics.fact_sales
analytics.dim_customer
analytics.dim_product
analytics.monthly_sales_summary****


## Core Components

### Ingestion Pipeline
Responsible for loading the public dataset into the raw data layer.

Technologies:
Python
Pandas

---

### SQL Transformation Layer
Responsible for data standardization and creation of analytics-ready tables.

Technologies:
SQL
DuckDB / PostgreSQL

---

### Data Quality Framework
Applies validation checks to ensure dataset reliability.

Examples:
null checks
duplicate detection
row reconciliation

---

### Analytics Layer
Produces aggregated datasets used for dashboard reporting.


## Data Model

The analytics layer follows a simplified star schema.

Fact Tables
fact_sales_transactions

Dimension Tables
dim_customer
dim_product
dim_date

Aggregate Tables
monthly_sales_summary
country_sales_summary

## Data Quality Strategy

The system includes automated validation checks to ensure
data reliability.

Quality checks include:

- null value detection
- duplicate transaction detection
- negative quantity handling
- invalid unit price validation
- reconciliation between raw and transformed datasets

## Dashboard Metrics

The analytics layer supports the following business metrics:

Total Revenue
Net Revenue
Average Order Value
Monthly Sales
Top Products
Country-Level Sales
Return Rate

## Technology Stack

Python
SQL
Pandas
DuckDB / PostgreSQL
Jupyter Notebooks
Tableau / Power BI (optional)

## Design Decisions

Layered architecture was chosen to separate raw ingestion,
data transformation, and analytics consumption.

SQL transformations were used to ensure transparency and
reproducibility of analytics datasets.

Data quality checks were embedded into the transformation
layer to detect anomalies early in the pipeline.

## Future Improvements

- add orchestration with Apache Airflow
- automate data quality alerts
- expand dataset coverage
- integrate machine learning models
