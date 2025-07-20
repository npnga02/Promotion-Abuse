SELECT 
    ci.campaignID,
    ci.promotionName,
    ci.campaignCode,
    SUBSTRING(ci.promotionName, 
        CHARINDEX(']', ci.promotionName, CHARINDEX(']', ci.promotionName, CHARINDEX(']', ci.promotionName) + 1) + 1) + 1, 
        LEN(ci.promotionName)) AS promotion_name,
    COUNT(DISTINCT t.userID) AS bot_abuser_count,
    ci.promotion_type,
    SUM(CAST(t.discountAmount AS BIGINT)) AS total_bot_discount
FROM 
    RiskTrainee.dbo.[transaction] t
JOIN 
    ByCampaign.dbo.total_abuser a ON t.userID = a.userID
JOIN 
    RiskTrainee.dbo.campaign_info ci ON t.campaignID = ci.campaignID
WHERE 
    ci.campaignCode = 'ZPI_220801_115'
GROUP BY 
    ci.campaignID,
    ci.promotionName,
    ci.campaignCode,
    ci.promotion_type
ORDER BY 
    total_bot_discount DESC;
