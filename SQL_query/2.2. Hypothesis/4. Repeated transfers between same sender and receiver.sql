SELECT 
    t.sender, 
    t.receiver, 
    t.amount, 
    t.reqDate
FROM 
    [transfer] t
JOIN 
    referral_mapcard r ON t.sender = r.userID
WHERE 
    EXISTS (
        SELECT 1
        FROM [transaction] tr
        JOIN campaign_info c ON tr.campaignID = c.campaignID
        WHERE c.campaigncode = 'ZPI_220801_115'
        AND tr.transID = t.transID
    )
ORDER BY t.sender, t.receiver, t.reqDate;
