-- ============================================
-- ERP Data Quality Audit
-- 04: Referential Integrity — SalesOrderDetail
-- Author: frozenwind1711
-- Date: 2026
-- ============================================

-- Orphan records: ProductID trong SalesOrderDetail
-- không tồn tại trong Production.Product
-- Dùng LEFT JOIN thay NOT IN để tránh NULL trap + perf tốt hơn
SELECT DISTINCT
    sod.SalesOrderID
    , sod.ProductID
FROM Sales.SalesOrderDetail sod
LEFT JOIN Production.Product pr
    ON sod.ProductID = pr.ProductID
WHERE pr.ProductID IS NULL
ORDER BY sod.SalesOrderID;