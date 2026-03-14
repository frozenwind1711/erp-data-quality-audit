-- ============================================
-- S4: Customer Retention — New vs Returning
-- Concept: Window Function MIN() OVER, CTE, CASE WHEN
-- Business: Monthly new vs returning customer analysis
-- ============================================
WITH Customer_Revenue AS (
    SELECT
        soh.CustomerID
        , EXTRACT (YEAR FROM soh.OrderDate) as OrderYear
        , EXTRACT (MONTH FROM soh.OrderDate) as OrderMonth
        , soh.OrderDate
        , MIN(soh.OrderDate) OVER (PARTITION BY soh.CustomerID) AS FirstPurchaseDate
        , soh.TotalDue as CustomerRevenue
    FROM Sales.SalesOrderHeader soh
    WHERE
        soh.Status = 5
        AND soh.OrderDate >= DATE '2013-01-01'
        AND soh.OrderDate < DATE '2014-01-01'
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
        , SUM(cr.CustomerRevenue) as CustomerMonthlyRevenue
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
    , COUNT(DISTINCT CustomerID) as CustomerCount
    , CustomerType
    , SUM(CustomerMonthlyRevenue) as TotalRevenue
FROM Customer_Monthly_Revenue
GROUP BY OrderYear, OrderMonth, CustomerType
ORDER BY OrderYear, OrderMonth DESC;


