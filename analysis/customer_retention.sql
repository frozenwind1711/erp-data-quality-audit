-- ============================================
-- S4: Customer Retention — New vs Returning
-- Concept: Window Function MIN() OVER, CTE, CASE WHEN
-- Business: Monthly new vs returning customer analysis
-- ============================================

WITH Customer_FirstPurchase AS (
    SELECT
        CustomerID
        , MIN(OrderDate) AS FirstPurchaseDate
    FROM Sales.SalesOrderHeader
    WHERE Status = 5
    GROUP BY CustomerID
)
, Customer_Revenue AS (
    SELECT
        soh.CustomerID
        , EXTRACT(YEAR  FROM soh.OrderDate) AS OrderYear
        , EXTRACT(MONTH FROM soh.OrderDate) AS OrderMonth
        , soh.TotalDue                       AS CustomerRevenue
        , cfp.FirstPurchaseDate
    FROM Sales.SalesOrderHeader soh
    JOIN Customer_FirstPurchase cfp 
        ON cfp.CustomerID = soh.CustomerID
    WHERE soh.Status = 5
      AND soh.OrderDate >= DATE '2013-01-01'
      AND soh.OrderDate <  DATE '2014-01-01'
)
, Customer_Monthly_Revenue AS (
    SELECT
        cr.CustomerID
        , cr.OrderYear
        , cr.OrderMonth
        , cr.FirstPurchaseDate
        , CASE
            WHEN EXTRACT(YEAR  FROM cr.FirstPurchaseDate) * 12
               + EXTRACT(MONTH FROM cr.FirstPurchaseDate)
               < cr.OrderYear * 12 + cr.OrderMonth
            THEN 'Returning'
            ELSE 'New'
          END AS CustomerType
        , SUM(cr.CustomerRevenue) AS CustomerMonthlyRevenue
    FROM Customer_Revenue cr
    GROUP BY
        cr.CustomerID
        , cr.OrderYear
        , cr.OrderMonth
        , cr.FirstPurchaseDate
)
SELECT
    OrderYear
    , OrderMonth
    , CustomerType
    , COUNT(DISTINCT CustomerID) AS CustomerCount
    , SUM(CustomerMonthlyRevenue) AS TotalRevenue
FROM Customer_Monthly_Revenue
GROUP BY OrderYear, OrderMonth, CustomerType
ORDER BY OrderYear, OrderMonth, CustomerType