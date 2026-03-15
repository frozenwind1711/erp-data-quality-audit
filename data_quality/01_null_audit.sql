-- ============================================
-- ERP Data Quality Audit
-- 01: NULL Audit — Sales.SalesOrderHeader
-- Author: frozenwind1711
-- Date: 2026
-- ============================================

-- Tổng số rows
SELECT COUNT(*) AS TotalRows
FROM Sales.SalesOrderHeader;

-- NULL count per column
SELECT
    'CustomerID'  AS ColumnName, COUNT(*) - COUNT(CustomerID)  AS NullCount, ROUND((COUNT(*) - COUNT(CustomerID))  * 100 / COUNT(*), 2) AS NullPct FROM Sales.SalesOrderHeader UNION ALL
    'OrderDate'   AS ColumnName, COUNT(*) - COUNT(OrderDate)   AS NullCount, ROUND((COUNT(*) - COUNT(OrderDate))   * 100 / COUNT(*), 2) AS NullPct FROM Sales.SalesOrderHeader UNION ALL
    'ShipDate'    AS ColumnName, COUNT(*) - COUNT(ShipDate)    AS NullCount, ROUND((COUNT(*) - COUNT(ShipDate))    * 100 / COUNT(*), 2) AS NullPct FROM Sales.SalesOrderHeader UNION ALL
    'TotalDue'    AS ColumnName, COUNT(*) - COUNT(TotalDue)    AS NullCount, ROUND((COUNT(*) - COUNT(TotalDue))    * 100 / COUNT(*), 2) AS NullPct FROM Sales.SalesOrderHeader UNION ALL
    'Status'      AS ColumnName, COUNT(*) - COUNT(Status)      AS NullCount, ROUND((COUNT(*) - COUNT(Status))      * 100 / COUNT(*), 2) AS NullPct FROM Sales.SalesOrderHeader;