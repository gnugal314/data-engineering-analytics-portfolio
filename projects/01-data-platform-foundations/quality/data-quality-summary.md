# Data Quality Summary

## Overview

This document describes the data quality controls implemented in the **Data Platform Foundations** project.

The goal of the quality layer is to ensure that the analytics tables used for reporting and dashboards are:

- complete
- consistent
- free from duplicate keys
- logically reconciled across data layers

These validations run after core transformations and before data is used for reporting.

---

# Quality Validation Framework

The project includes three primary validation categories:

| Validation Type | Purpose |
|---|---|
| Null Checks | Detect missing values in critical columns |
| Duplicate Checks | Ensure dimensional keys and transaction identifiers remain unique |
| Reconciliation Checks | Validate metrics and row counts across data layers |

The validation scripts are stored in:

```
projects/01-data-platform-foundations/quality/
```

---

# Validation Scripts

## 1. Null Checks

File:

```
quality/null_checks.sql
```

Purpose:

Detects missing values in critical analytics fields.

Examples of monitored columns:

- `invoice_no`
- `stock_code`
- `invoice_timestamp`
- `customer_id`
- `country`
- `net_sales_amount`

Example output structure:

| table_name | column_name | total_rows | null_count |
|---|---|---|---|

Purpose:

Identify columns that could break reporting logic or indicate pipeline errors.

---

## 2. Duplicate Checks

File:

```
quality/duplicate_checks.sql
```

Purpose:

Ensures business keys remain unique.

Keys validated:

| Table | Expected Key |
|---|---|
| fact_sales_transactions | invoice_no + stock_code + customer_id + invoice_timestamp |
| dim_customer | customer_id |
| dim_product | stock_code |
| dim_date | date_day |

Example output:

| table_name | duplicate_key | duplicate_group_count | duplicate_row_count |
|---|---|---|---|

Purpose:

Detect accidental duplicate records introduced during transformation.

---

## 3. Reconciliation Checks

File:

```
quality/reconciliation_checks.sql
```

Purpose:

Ensures summary tables match the underlying fact tables.

Examples:

| Check | Description |
|---|---|
| fact_sales_transactions_row_count | verifies total fact row count |
| monthly_sales_summary_net_revenue | compares monthly summary revenue with fact table revenue |
| dim_customer_row_count | compares dimension rows with distinct customers in fact |
| dim_product_row_count | compares dimension rows with distinct products in fact |

Example output structure:

| check_name | actual_value | comparison_value | check_description |
|---|---|---|---|

Purpose:

Detects logic errors or transformation inconsistencies.

---

# Data Quality Expectations

The analytics layer expects the following conditions to hold true:

- critical business keys must not contain null values
- dimension tables should contain one record per key
- summary tables must reconcile with the fact table
- revenue totals must remain consistent across aggregation layers

Any violations should be investigated before data is consumed by dashboards.

---

# Operational Use

These validation scripts can be integrated into:

- ETL orchestration pipelines
- automated data quality monitoring
- CI/CD pipeline testing
- scheduled warehouse validation jobs

Typical workflow:

1. Run transformation pipelines
2. Execute quality validation scripts
3. Review validation outputs
4. Approve datasets for reporting

---

# Relationship to Reporting Layer

The reporting layer depends on the following validated tables:

```
analytics.fact_sales_transactions
analytics.dim_customer
analytics.dim_product
analytics.dim_date
analytics.monthly_sales_summary
```

If quality checks fail, reporting outputs should be considered **unverified**.

---

# Summary

The quality layer ensures the analytics platform produces trustworthy datasets.

By combining:

- null validation
- duplicate detection
- metric reconciliation

the platform maintains a strong foundation for reliable business intelligence and analytical reporting.