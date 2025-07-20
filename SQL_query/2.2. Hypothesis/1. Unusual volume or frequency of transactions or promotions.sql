-- Step 1: Count percentile 95%
WITH percentiles AS (
    SELECT
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY discount_transactions_per_day) OVER () AS p95_discount_txn,
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY distinct_campaigns_per_day) OVER () AS p95_campaigns,
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY cashback_events) OVER () AS p95_cashbacks
    FROM (
        SELECT 
            t.userID,
            CAST(t.ReqDate AS DATE) AS transaction_date,
            COUNT(t.transID) AS discount_transactions_per_day,
            COUNT(DISTINCT t.campaignID) AS distinct_campaigns_per_day,
            SUM(CASE WHEN t.cashbackTime IS NOT NULL THEN 1 ELSE 0 END) AS cashback_events
        FROM
            [transaction] t
        JOIN
            [campaign_info] c ON t.campaignID = c.campaignID
        WHERE
            c.campaigncode = 'ZPI_220801_115'
        GROUP BY
            t.userID, CAST(t.ReqDate AS DATE)
    ) AS daily_stats
)
SELECT
    p.p95_discount_txn,
    p.p95_campaigns,
    p.p95_cashbacks
FROM
    percentiles p;
-- Step 2: Extract abuser list
SELECT
    t.userID,
    CAST(t.ReqDate AS DATE) AS transaction_date,
    COUNT(t.transID) AS discount_transactions_per_day,
    COUNT(DISTINCT t.campaignID) AS distinct_campaigns_per_day,
    SUM(CASE WHEN t.cashbackTime IS NOT NULL THEN 1 ELSE 0 END) AS cashback_events
FROM
    [transaction] t
JOIN
    [campaign_info] c ON t.campaignID = c.campaignID
WHERE
    c.campaigncode = 'ZPI_220801_115'
GROUP BY
    t.userID, CAST(t.ReqDate AS DATE)
HAVING
    COUNT(t.transID) > 7 OR
    COUNT(DISTINCT t.campaignID) > 3 OR
    SUM(CASE WHEN t.cashbackTime IS NOT NULL THEN 1 ELSE 0 END) > 4