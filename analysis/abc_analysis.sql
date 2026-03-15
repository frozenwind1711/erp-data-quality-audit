-- ============================================
-- S8: ABC Analysis
-- Concept: CTE, Window Function SUM() OVER, Cumulative %
-- Business: Product classification by revenue contribution
-- ============================================
-- product_revenue
WITH product_revenue AS (
    SELECT
        sod.ProductID
        , pr.ProductName
        , SUM(sod.LineSubtotal) as ProductRevenue
    FROM Sales.SalesOrderDetail sod
    JOIN Production.Product pr ON pr.ProductID = sod.ProductID
    JOIN Sales.SalesOrderHeader soh ON soh.SalesOrderID = sod.SalesOrderID
    WHERE
        soh.Status = 5
        AND soh.OrderDate >= DATE '2013-01-01'
        AND soh.OrderDate < DATE '2014-01-01'
    GROUP BY
        sod.ProductID
        , pr.ProductName
)
, prod_temp AS (
    SELECT
        ProductID
        , ProductName
        , ROUND(ProductRevenue / SUM(ProductRevenue) OVER () * 100, 2) AS RevenuePct
    FROM product_revenue
)
, abc_analysis AS (
        SELECT
        ProductID
        , ProductName   
        , RevenuePct
        -- Tính cumulative % bằng Window Function
        , SUM(RevenuePct) OVER (ORDER BY RevenuePct DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
        AS CumulativePct
    FROM prod_temp
)
SELECT
    ProductID
    , ProductName
    , CASE
        WHEN CumulativePct <= 70 THEN 'A'
        WHEN CumulativePct <= 90 THEN 'B'
        ELSE 'C'
    END as ABC_Class
FROM abc_analysis
ORDER BY ABC_Class;