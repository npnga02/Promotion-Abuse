WITH card_stats AS (
    SELECT 
        bimID,
        bankname,
        COUNT(DISTINCT m.userID) AS user_count,
        SUM(CASE WHEN requestStatus <> 1 THEN 1 ELSE 0 END) AS failed_requests
    FROM map_card m
    JOIN [transaction] t ON m.userID = t.userID
    JOIN campaign_info c ON t.campaignID = c.campaignID
    WHERE c.campaigncode = 'ZPI_220801_115'
    GROUP BY bimID, bankname
)
SELECT 
    DISTINCT m.userID,
    m.bimID,
    m.bankname,
    cs.user_count,
    cs.failed_requests
FROM map_card m
JOIN card_stats cs ON m.bimID = cs.bimID AND m.bankname = cs.bankname
WHERE cs.user_count > 1
ORDER BY cs.user_count DESC, cs.failed_requests DESC, m.bimID;
