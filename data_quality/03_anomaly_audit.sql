-- ============================================
-- ERP Data Quality Audit
-- 03: Anomaly Audit — Sales.SalesOrderHeader
-- Author: frozenwind1711
-- Date: 2026
-- ============================================

-- Anomalies: TotalDue <= 0, ShipDate < OrderDate, invalid Status
SELECT
    soh.SalesOrderID
    , soh.TotalDue
    , soh.OrderDate
    , soh.ShipDate
    , soh.Status
FROM Sales.SalesOrderHeader soh
WHERE
    soh.Status NOT IN (1,2,3,4,5,6)
    OR soh.ShipDate < soh.OrderDate
    OR soh.TotalDue <= 0
ORDER BY soh.SalesOrderID