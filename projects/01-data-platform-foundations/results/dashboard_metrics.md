# Dashboard Metrics

## Overview

This document defines the business-facing dashboard metrics supported by the **Data Platform Foundations** project.

The goal of this layer is to translate curated analytics tables into clear, reusable KPIs for reporting, trend analysis, and executive decision-making.

These metrics are intended to be consumed by:
- BI dashboards
- executive reporting
- analyst self-service workflows
- portfolio case study reviews

---

## Source Tables

The following analytics tables support the dashboard layer:

- `analytics.fact_sales_transactions`
- `analytics.dim_customer`
- `analytics.dim_product`
- `analytics.dim_date`
- `analytics.monthly_sales_summary`

---

## Core KPI Definitions

### 1. Total Revenue

**Definition**  
Sum of net sales across all transactions.

**Business Meaning**  
Represents overall realized revenue after accounting for returns or cancellations.

**Source Logic**  
`SUM(net_sales_amount)`

**Primary Source Table**  
`analytics.fact_sales_transactions`

---

### 2. Gross Revenue

**Definition**  
Sum of gross sales before return adjustment.

**Business Meaning**  
Measures top-line sales activity before subtracting returns.

**Source Logic**  
`SUM(gross_sales_amount)`

**Primary Source Table**  
`analytics.fact_sales_transactions`

---

### 3. Total Orders

**Definition**  
Count of distinct invoices.

**Business Meaning**  
Measures how many unique order events occurred.

**Source Logic**  
`COUNT(DISTINCT invoice_no)`

**Primary Source Table**  
`analytics.fact_sales_transactions`

---

### 4. Active Customers

**Definition**  
Count of distinct customers who placed at least one order.

**Business Meaning**  
Measures customer activity for the reporting period.

**Source Logic**  
`COUNT(DISTINCT customer_id)`

**Primary Source Table**  
`analytics.fact_sales_transactions`

---

### 5. Average Order Value

**Definition**  
Average revenue per order.

**Business Meaning**  
Shows the average commercial value of each order.

**Source Logic**  
`SUM(net_sales_amount) / COUNT(DISTINCT invoice_no)`

**Primary Source Table**  
`analytics.fact_sales_transactions`

---

### 6. Total Units Sold

**Definition**  
Total quantity sold excluding return rows.

**Business Meaning**  
Measures product volume sold to customers.

**Source Logic**  
`SUM(CASE WHEN is_return = 0 THEN quantity ELSE 0 END)`

**Primary Source Table**  
`analytics.fact_sales_transactions`

---

### 7. Total Units Returned

**Definition**  
Total quantity associated with return transactions.

**Business Meaning**  
Measures product volume returned or cancelled.

**Source Logic**  
`SUM(CASE WHEN is_return = 1 THEN ABS(quantity) ELSE 0 END)`

**Primary Source Table**  
`analytics.fact_sales_transactions`

---

### 8. Return Rate

**Definition**  
Proportion of return transactions relative to total orders.

**Business Meaning**  
Monitors return behavior and potential product or fulfillment issues.

**Source Logic**  
`return_transaction_count / total_orders`

**Primary Source Table**  
`analytics.monthly_sales_summary`

---

### 9. Top Products by Revenue

**Definition**  
Products ranked by net revenue contribution.

**Business Meaning**  
Identifies highest-performing products for commercial analysis.

**Source Logic**  
Rank `SUM(net_sales_amount)` by `stock_code` or `product_description`

**Primary Source Tables**  
- `analytics.fact_sales_transactions`
- `analytics.dim_product`

---

### 10. Sales by Country

**Definition**  
Revenue grouped by customer country.

**Business Meaning**  
Supports geographic performance analysis and international trend monitoring.

**Source Logic**  
`SUM(net_sales_amount) GROUP BY country`

**Primary Source Table**  
`analytics.fact_sales_transactions`

---

### 11. Customer Segment Distribution

**Definition**  
Count of customers by customer segment.

**Business Meaning**  
Shows how the customer base is distributed across value tiers.

**Source Logic**  
`COUNT(*) GROUP BY customer_segment`

**Primary Source Table**  
`analytics.dim_customer`

---

### 12. Monthly Revenue Trend

**Definition**  
Net revenue by reporting month.

**Business Meaning**  
Shows business growth, seasonality, and trend direction over time.

**Source Logic**  
Use `analytics.monthly_sales_summary`

**Primary Source Table**  
`analytics.monthly_sales_summary`

---

## Suggested Dashboard Views

### Executive KPI Summary
Recommended tiles:
- Total Revenue
- Total Orders
- Active Customers
- Average Order Value
- Return Rate

### Revenue Trend Dashboard
Recommended charts:
- Monthly revenue line chart
- Gross vs net revenue comparison
- Monthly orders trend

### Product Performance Dashboard
Recommended charts:
- Top 10 products by revenue
- Top 10 products by units sold
- Products with highest return rate

### Customer Dashboard
Recommended charts:
- Customer segment distribution
- Top customers by total spend
- Active customers by month

### Geographic Dashboard
Recommended charts:
- Sales by country
- Orders by country
- Revenue share by country

---

## Example SQL Snippets

### Monthly Revenue Trend

```sql
SELECT
    month_start_date,
    net_revenue
FROM analytics.monthly_sales_summary
ORDER BY month_start_date;

--### Top Products by Revenue

SELECT
    stock_code,
    product_description,
    net_revenue
FROM analytics.dim_product
ORDER BY net_revenue DESC
LIMIT 10;

--### Customer Segmentation Distribution 

SELECT
    customer_segment,
    COUNT(*) AS customer_count
FROM analytics.dim_customer
GROUP BY customer_segment
ORDER BY customer_count DESC;

---### Sales by Country
SELECT
    country,
    SUM(net_sales_amount) AS total_revenue
FROM analytics.fact_sales_transactions
GROUP BY country
ORDER BY total_revenue DESC;




