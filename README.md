# ERP Data Quality & Business Analytics — AdventureWorks

## Overview
A collection of production-level Oracle SQL queries simulating real-world 
ERP analytics workflows, built on AdventureWorks OLTP schema.

Designed to demonstrate end-to-end SQL capability for a BA → Data/Solution 
Architect transition, with patterns directly applicable to NetSuite/NSAW environments.

---

## Business Analytics (`/analysis`)

| Query | Business Use Case | Key Concepts |
|-------|------------------|--------------|
| [Employee Salary Analysis](analysis/employee_salary_analysis.sql) | HR salary benchmarking by job title | CTE, ROW_NUMBER, AVG OVER |
| [Sales Trend Analysis](analysis/sales_trend_analysis.sql) | Monthly revenue with YoY subtotals | ROLLUP, GROUPING(), Rolling Avg |
| [Top Products Revenue](analysis/top_products_revenue.sql) | Top 10 products by revenue share | RANK(), RevenuePct Window Function |
| [Customer Retention](analysis/customer_retention.sql) | New vs Returning customer by month | MIN() OVER, CTE multi-layer |
| [Cohort Revenue Analysis](analysis/cohort_revenue_analysis.sql) | Revenue tracking by customer cohort | MONTHS_BETWEEN, PIVOT |
| [TY vs LY Comparison](analysis/ty_vs_ly_comparison.sql) | Year-over-year sales growth | LAG(12), CTE JOIN approach |
| [RFM Analysis](analysis/rfm_analysis.sql) | Customer segmentation by value | NTILE(4), RFM scoring |
| [ABC Analysis](analysis/abc_analysis.sql) | Product classification by revenue | Cumulative %, SUM() OVER |

---

## Data Quality Audit (`/data_quality`)

| Query | What It Checks |
|-------|---------------|
| [NULL Audit](data_quality/01_null_audit.sql) | Critical columns with unexpected NULLs |
| [Duplicate Audit](data_quality/02_duplicate_audit.sql) | Duplicate records by business key |
| [Anomaly Audit](data_quality/03_anomaly_audit.sql) | Invalid values — negative amounts, illogical dates |
| [Referential Integrity](data_quality/04_referential_integrity.sql) | Orphan records across related tables |

---

## Tech Stack
- Oracle SQL
- AdventureWorks OLTP Schema
- Git / GitHub

## Background
5 years NetSuite ERP BA → transitioning to Solution Architect (Data Engineering)  
Sprint 1 of 4 — Oracle SQL Mastery