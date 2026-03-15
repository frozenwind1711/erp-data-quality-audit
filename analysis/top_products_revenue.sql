-- ============================================
-- S3: Top Products Revenue
-- Concept: CTE, RANK(), SUM() OVER(), RevenuePct
-- Business: Top 10 products by revenue contribution
-- ============================================
WITH product_revenue AS (
    SELECT
        sol.ProductID
        , pr.ProductName
        , SUM(sol.LineTotal) as TotalRevenue
        , COUNT(DISTINCT sol.SalesOrderID) as OrderCount
    FROM
        Sales.SalesOrderHeader soh
        JOIN Sales.SalesOrderDetail sol ON soh.SalesOrderID = sol.SalesOrderID
        JOIN Production.Product pr ON sol.ProductID = pr.ProductID
    WHERE
        soh.Status = 5
        AND soh.OrderDate >= DATE '2013-01-01'
        AND soh.OrderDate < DATE '2014-01-01'
    GROUP BY
        sol.ProductID
        , pr.ProductName
)
, revenue AS (
    SELECT
        prev.*
        , RANK() OVER (ORDER BY prev.TotalRevenue DESC) AS RevenueRank
        , ROUND(prev.TotalRevenue / SUM(prev.TotalRevenue) OVER () * 100, 2) AS RevenuePct
    FROM product_revenue prev
)
SELECT revenue.*
FROM revenue
WHERE RevenueRank <= 10;