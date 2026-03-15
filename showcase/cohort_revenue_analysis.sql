-- ============================================
-- S5: Cohort Revenue Analysis
-- Concept: Window Function MIN() OVER, MONTHS_BETWEEN, CTE, PIVOT
-- Business: Track revenue contribution by customer cohort month
-- ============================================

-- SECTION 1: Detail view
WITH Cohort_Month AS (
    SELECT
        soh.CustomerID
        , soh.OrderDate
        , soh.TotalDue
        , MIN(soh.OrderDate) OVER (
            PARTITION BY soh.CustomerID
        ) AS FirstPurchaseDate
    FROM Sales.SalesOrderHeader soh
)
, Month_Offset AS (
    SELECT
        cm.CustomerID
        , EXTRACT(MONTH FROM cm.FirstPurchaseDate) AS CohortMonth
        , EXTRACT(MONTH FROM cm.OrderDate)         AS OrderMonth
        , MONTHS_BETWEEN(
            TRUNC(cm.OrderDate,       'MM'),
            TRUNC(cm.FirstPurchaseDate,'MM')
          )                                        AS MonthOffset
    FROM Cohort_Month cm
)
SELECT
    mo.CohortMonth
    , mo.OrderMonth
    , mo.MonthOffset
    , COUNT(DISTINCT mo.CustomerID) AS CustomerCount
    , SUM(cm.TotalDue)              AS TotalRevenue
FROM Month_Offset mo
JOIN Cohort_Month cm ON mo.CustomerID = cm.CustomerID
WHERE cm.OrderDate >= DATE '2013-01-01'
  AND cm.OrderDate <  DATE '2014-01-01'
GROUP BY mo.CohortMonth, mo.OrderMonth, mo.MonthOffset
ORDER BY mo.CohortMonth, mo.MonthOffset
;

-- SECTION 2: Pivot view
WITH Cohort_Month AS (
    SELECT
        soh.CustomerID
        , soh.OrderDate
        , soh.TotalDue
        , MIN(soh.OrderDate) OVER (
            PARTITION BY soh.CustomerID
        ) AS FirstPurchaseDate
    FROM Sales.SalesOrderHeader soh
)
, Month_Offset AS (
    SELECT
        cm.CustomerID
        , EXTRACT(MONTH FROM cm.FirstPurchaseDate) AS CohortMonth
        , MONTHS_BETWEEN(
            TRUNC(cm.OrderDate,       'MM'),
            TRUNC(cm.FirstPurchaseDate,'MM')
          )                                        AS MonthOffset
        , cm.TotalDue
    FROM Cohort_Month cm
    WHERE cm.OrderDate >= DATE '2013-01-01'
      AND cm.OrderDate <  DATE '2014-01-01'
)
SELECT * FROM (
    SELECT CohortMonth, MonthOffset, TotalDue
    FROM Month_Offset
)
PIVOT (
    SUM(TotalDue)
    FOR MonthOffset IN (
        0  AS "M0"
        , 1  AS "M1"
        , 2  AS "M2"
        , 3  AS "M3"
        , 4  AS "M4"
        , 5  AS "M5"
        , 6  AS "M6"
        , 7  AS "M7"
        , 8  AS "M8"
        , 9  AS "M9"
        , 10 AS "M10"
        , 11 AS "M11"
        , 12 AS "M12"
    )
)
ORDER BY CohortMonth
;