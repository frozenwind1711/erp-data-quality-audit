-- ============================================
-- S7: RFM Analysis
-- Concept: NTILE(4), CTE, CASE WHEN scoring
-- Business: Customer segmentation by Recency, Frequency, Monetary
-- ============================================
WITH sales_base AS (
    SELECT
        soh.CustomerID
        , TO_DATE(sysdate,  'YYYY-MM-DD') - TO_DATE(MAX(soh.OrderDate), 'YYYY-MM-DD') AS Recency
        , COUNT(DISTINCT soh.SalesOrderID) as Frequency
        , SUM(soh.TotalDue) as Monetary
    FROM Sales.SalesOrderHeader soh
    WHERE
        soh.Status = 5
        AND soh.OrderDate >= DATE '2013-01-01'
        AND soh.OrderDate < DATE '2014-01-01'
    GROUP BY soh.CustomerID
)
, rfm_analysis AS (
    SELECT
        CustomerID
        , NTILE(4) OVER (ORDER BY Recency DESC) AS R_Score
        , NTILE(4) OVER (ORDER BY Frequency) AS F_Score
        , NTILE(4) OVER (ORDER BY Monetary) AS M_Score
    FROM sales_base
)
SELECT
    CustomerID
    , CASE
        WHEN R_Score = 4 AND F_Score = 4 AND M_Score = 4 THEN 'Champion'
        WHEN R_Score >= 3 AND F_Score >= 3 AND M_Score >= 3 THEN 'Loyal'
        WHEN R_Score <= 2 AND F_Score >= 3 AND M_Score = 4 THEN 'High Value'
        WHEN R_Score <= 2 AND F_Score >= 3 AND M_Score >= 2 THEN 'At Risk'
        WHEN R_Score = 1 AND F_Score = 1 THEN 'Lost'
        ELSE 'Others'
    END as RFM_Segment
FROM rfm_analysis
ORDER BY RFM_Segment;