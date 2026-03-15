-- ============================================
-- S2: Sales Trend Analysis
-- Concept: CTE, Window Function Rolling Avg, ROLLUP, GROUPING()
-- Business: Monthly revenue trend with subtotals
-- ============================================
WITH monthly_revenue AS (
    SELECT
        EXTRACT (YEAR FROM soh.OrderDate) as OrderYear
        , EXTRACT (MONTH FROM soh.OrderDate) as OrderMonth
        , SUM(soh.TotalDue) as TotalRevenue
        , COUNT(soh.SalesOrderID) as OrderCount
    FROM Sales.SalesOrderHeader soh
    WHERE
        soh.Status = 5
        AND soh.OrderDate >= DATE '2012-01-01'
        AND soh.OrderDate < DATE '2014-01-01'
    GROUP BY
        EXTRACT (YEAR FROM soh.OrderDate)
        , EXTRACT (MONTH FROM soh.OrderDate)
)
, rolling_rev AS (
    SELECT
        mr.*
        , AVG(mr.TotalRevenue) OVER (
            ORDER BY OrderYear, OrderMonth
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) as Rolling3M
    FROM monthly_revenue mr
)
SELECT
    rr.*
    , CASE
        WHEN GROUPING(OrderYear) = 1 THEN 'Grand Total'
        WHEN GROUPING(OrderMonth) = 1 THEN 'Yearl Subtotal'
        ELSE 'Details'
    END as RowType
FROM rolling_rev rr
GROUP BY ROLLUP(OrderYear, OrderMonth);