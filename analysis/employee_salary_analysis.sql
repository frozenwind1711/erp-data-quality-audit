-- ============================================
-- Sprint 1 Showcase — AdventureWorks ERP
-- Author: frozenwind1711
-- ============================================

-- ============================================
-- S1: Employee Salary Analysis
-- Concept: CTE, ROW_NUMBER, AVG OVER, CASE WHEN
-- Business: HR salary benchmarking by job title
-- ============================================

WITH LatestPay AS (
    SELECT
        ps.FirstName || ' ' || NVL(ps.MiddleName || ' ', '') || ps.LastName AS FullName
        , DECODE(ps.Gender, 'F', 'Female', 'M', 'Male')                     AS Gender
        , hre.JobTitle
        , eph.Rate
        , CASE
            WHEN eph.Rate < 20  THEN 'Entry'
            WHEN eph.Rate < 50  THEN 'Mid'
            WHEN eph.Rate < 100 THEN 'Senior'
            ELSE 'Executive'
          END                                                                 AS SalaryBand
        , DECODE(hre.MaritalStatus, 'S', 'Single', 'M', 'Married')          AS MaritalStatus
        , ROW_NUMBER() OVER (
            PARTITION BY eph.BusinessEntityID
            ORDER BY eph.StartDate DESC
          )                                                                   AS rn
    FROM HumanResources.EmployeePayHistory eph
    JOIN HumanResources.Employee hre ON hre.BusinessEntityID = eph.BusinessEntityID
    JOIN Person.Person ps             ON ps.BusinessEntityID  = hre.BusinessEntityID
    WHERE hre.CurrentFlag = 1
)
, Avg_RateBy_Title AS (
    SELECT
        hre.JobTitle
        , AVG(eph.Rate) AS AvgRateByTitle
    FROM HumanResources.Employee hre
    JOIN HumanResources.EmployeePayHistory eph
        ON eph.BusinessEntityID = hre.BusinessEntityID
    GROUP BY hre.JobTitle
)
SELECT
    lp.FullName
    , lp.Gender
    , lp.JobTitle
    , lp.Rate
    , lp.SalaryBand
    , ROUND(art.AvgRateByTitle, 2) AS AvgRateByTitle
    , CASE
        WHEN lp.Rate < art.AvgRateByTitle THEN 'Below'
        WHEN lp.Rate = art.AvgRateByTitle THEN 'Equal'
        ELSE 'Above'
      END                          AS VsAvg
FROM LatestPay lp
JOIN Avg_RateBy_Title art ON art.JobTitle = lp.JobTitle
WHERE lp.rn = 1
ORDER BY lp.JobTitle, lp.Rate DESC