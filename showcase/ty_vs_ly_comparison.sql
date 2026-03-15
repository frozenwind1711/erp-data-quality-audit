-- ============================================
-- S6: TY vs LY Sales Comparison
-- Concept: CTE JOIN, LAG(12) Window Function
-- Business: Year-over-year monthly revenue growth
-- ============================================
-- Cách 1: CTE từng năm và join lại
WITH TY_Revenue AS (
    -- monthly_revenue TY_Revenue Doanh thu 2013
    SELECT
        EXTRACT (YEAR FROM soh.OrderDate) AS OrderYear
        , EXTRACT (MONTH FROM soh.OrderDate) AS OrderMonth
        , SUM(soh.TotalDue) as ThisYearRevenue
    FROM Sales.SalesOrderHeader soh
    WHERE
        soh.Status = 5
        AND soh.OrderDate >= DATE '2013-01-01'
        AND soh.OrderDate < DATE '2014-01-01'   
)
, LY_Revenue AS (
    -- monthly_revenue LY_Revenue Doanh thu 2012
    SELECT
        EXTRACT (YEAR FROM soh.OrderDate) AS OrderYear
        , EXTRACT (MONTH FROM soh.OrderDate) AS OrderMonth
        , SUM(soh.TotalDue) as LastYearRevenue
    FROM Sales.SalesOrderHeader soh
    WHERE
        soh.Status = 5
        AND soh.OrderDate >= DATE '2012-01-01'
        AND soh.OrderDate < DATE '2013-01-01'
)
-- JOIN 2 năm và tính YoY
SELECT
    tyr.OrderMonth
    , tyr.ThisYearRevenue    AS TY_Revenue
    , lyr.LastYearRevenue    AS LY_Revenue
    , tyr.ThisYearRevenue - lyr.LastYearRevenue AS YoY_Diff
    , ROUND(((tyr.ThisYearRevenue - lyr.LastYearRevenue)
        / NULLIF(lyr.LastYearRevenue, 0)) * 100, 2) AS YoY_Growth
FROM TY_Revenue tyr
JOIN LY_Revenue lyr ON tyr.OrderMonth = lyr.OrderMonth
Order BY tyr.OrderYear, tyr.OrderMonth;

-- Cách 2: dùng window functions
WITH month_revenue AS (
    -- monthly_revenue
    SELECT
        EXTRACT (YEAR FROM soh.OrderDate) AS OrderYear
        , EXTRACT (MONTH FROM soh.OrderDate) AS OrderMonth
        , SUM(soh.TotalDue) as MonthlyRevenue
    FROM Sales.SalesOrderHeader soh
    WHERE
        soh.Status = 5
        AND soh.OrderDate >= DATE '2012-01-01'
        AND soh.OrderDate < DATE '2014-01-01'   
)
, lag_revenue AS (
    -- doanh thu năm trước cùng kỳ
    SELECT
        OrderYear
        , OrderMonth
        , MonthlyRevenue
        , LAG(MonthlyRevenue, 12) OVER (
            ORDER BY OrderYear, OrderMonth
        ) as LastYearRevenue
    FROM month_revenue
)
SELECT
    OrderYear
    , OrderMonth
    , MonthlyRevenue
    , LastYearRevenue
    , (MonthlyRevenue - LastYearRevenue) AS YoY_Diff
    , ROUND((MonthlyRevenue - LastYearRevenue) / NULLIF(LastYearRevenue,0) * 100, 2)
FROM lag_revenue
WHERE OrderYear = 2013
ORDER BY OrderMonth;