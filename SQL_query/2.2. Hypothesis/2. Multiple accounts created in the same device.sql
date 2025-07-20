WITH user_info AS (
    SELECT 
        up.userID,
        t.deviceID,
        t.userIP,
        up.created_date
    FROM 
        [transaction] t
    JOIN campaign_info c ON t.campaignID = c.campaignID
    JOIN user_profile up ON t.userID = up.userID
    WHERE 
        c.campaigncode = 'ZPI_220801_115'
        AND t.deviceID IS NOT NULL
),
user_count_per_device_per_device AS (
    SELECT 
        deviceID,
        COUNT(DISTINCT userID) AS user_count_per_device
    FROM user_info
    GROUP BY deviceID
    HAVING COUNT(DISTINCT userID) > 1
),
deduplicated_users AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY userID ORDER BY created_date) AS rn,
           LAG(created_date) OVER (PARTITION BY deviceID ORDER BY created_date) AS pev_created_date
    FROM user_info
),
user_with_gap AS (
    SELECT *,
           DATEDIFF(day, pev_created_date, created_date) AS gap_with_pev_created_date
    FROM deduplicated_users
),
min_gap_per_device AS (
    SELECT 
        deviceID,
        MIN(gap_with_pev_created_date) AS min_gap
    FROM user_with_gap
    GROUP BY deviceID
)
SELECT 
    d.userID, 
    d.deviceID, 
    d.userIP, 
    d.created_date, 
    u.user_count_per_device,
    d.pev_created_date,
    d.gap_with_pev_created_date,
    m.min_gap
FROM 
    user_with_gap d
JOIN 
    user_count_per_device_per_device u ON d.deviceID = u.deviceID
JOIN 
    min_gap_per_device m ON d.deviceID = m.deviceID
WHERE 
    d.rn = 1
    AND m.min_gap = 0
ORDER BY 
    u.user_count_per_device, d.deviceID, d.created_date;
