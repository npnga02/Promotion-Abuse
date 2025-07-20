SELECT 
    REPLACE(userID, '"', '') AS userID,
    '1. Unusual volume or frequency of transactions or promotions' AS explanation
FROM [H1]

UNION 

SELECT userID, '2. Multiple accounts created in the same device'
FROM [H2]

UNION 

SELECT refereeID, '3. Suspicious referral patterns'
FROM [H3.1]

UNION 

SELECT referrer, '3. Suspicious referral patterns'
FROM [H3.2]

UNION ALL

SELECT sender, '4. Transfer network abuse'
FROM [H4]

UNION 

SELECT userID, '5. Unusual transaction patterns with bank cards'
FROM [H5]

ORDER BY userID;
