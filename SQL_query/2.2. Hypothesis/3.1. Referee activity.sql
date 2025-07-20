WITH raw_data AS (
    SELECT 
        r.refereeID,
        COUNT(t.userID) AS activity_within_7_days
    FROM referral_mapcard r
    LEFT JOIN [transaction] t
        ON r.refereeID = t.userID
        AND t.reqDate BETWEEN r.reqDate AND DATEADD(DAY, 7, r.reqDate)
    JOIN campaign_info c ON t.campaignID = c.campaignID
    WHERE c.campaigncode = 'ZPI_220801_115'
    GROUP BY r.refereeID
),
percentile_cte AS (
    SELECT DISTINCT
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY activity_within_7_days) 
        OVER () AS p95_activity
    FROM raw_data
)

SELECT 
    r.refereeID,
    r.activity_within_7_days,
    p.p95_activity
FROM raw_data r
CROSS JOIN percentile_cte p
WHERE r.activity_within_7_days > p.p95_activity
ORDER BY r.refereeID;
