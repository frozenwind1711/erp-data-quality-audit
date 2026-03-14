-- ============================================
-- ERP Data Quality Audit
-- 02: Duplicate Audit — Sales.SalesOrderHeader
-- Author: frozenwind1711
-- Date: 2026
-- ============================================

-- Duplicate: cùng CustomerID + OrderDate + TotalDue xuất hiện > 1 lần
SELECT
    soh.CustomerID
    , soh.OrderDate
    , soh.TotalDue
    , COUNT(*) AS DuplicateCount
FROM Sales.SalesOrderHeader soh
GROUP BY
    soh.CustomerID
    , soh.OrderDate
    , soh.TotalDue
HAVING COUNT(*) > 1
ORDER BY DuplicateCount DESC;