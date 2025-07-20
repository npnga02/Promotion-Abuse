SELECT 
    r.userID AS referrer,
    COUNT(r.refereeID) AS referee_count
FROM referral_mapcard r
JOIN [transaction] t ON r.refereeID = t.userID
JOIN campaign_info c ON t.campaignID = c.campaignID
WHERE c.campaigncode = 'ZPI_220801_115'
GROUP BY r.userID
HAVING COUNT(r.refereeID) > 10
ORDER BY referee_count;
