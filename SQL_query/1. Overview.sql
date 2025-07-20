SELECT 
    t.transID,
    t.userID,
    t.appID,
    t.userChargeAmount,
    t.amount,
    t.reqDate,
    t.campaignID,
    t.discountAmount
FROM 
    [transaction] t
JOIN 
    campaign_info c ON t.campaignID = c.campaignID
WHERE 
    c.campaignCode = 'ZPI_220801_115';
