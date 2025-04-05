-- روش‌های پرداخت
SELECT 
    cc.CardType AS PaymentMethod,
    COUNT(sop.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader sop
JOIN Sales.CreditCard cc ON sop.CreditCardID = cc.CreditCardID
GROUP BY cc.CardType
ORDER BY OrderCount DESC;


-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT p.Name AS PaymentMethod, COUNT(sop.SalesOrderID) AS OrderCount FROM Sales.SalesOrderHeader sop JOIN Sales.SalesOrderHeaderCreditCard sohcc ON sop.SalesOrderID = sohcc.SalesOrderID JOIN Sales.CreditCard cc ON sohcc.CreditCardID = cc.CreditCardID JOIN Sales.PaymentMethod p ON cc.CreditCardID = p.CreditCardID GROUP BY p.Name ORDER BY OrderCount DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\payment method\payment_method.csv" -s "," -W -w 700';




-- پرداخت‌های نقدی
SELECT 
    COUNT(sop.SalesOrderID) AS CashOrderCount,
    FORMAT(SUM(sop.TotalDue), 'C') AS TotalCashSales
FROM Sales.SalesOrderHeader sop
WHERE sop.CreditCardID IS NULL;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT COUNT(sop.SalesOrderID) AS CashOrderCount, FORMAT(SUM(sop.TotalDue), ''C'') AS TotalCashSales FROM Sales.SalesOrderHeader sop WHERE sop.CreditCardID IS NULL" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\payment method\cash_payments.csv" -s "," -W -w 700';




-- پرداخت‌های کارت اعتباری
SELECT 
    cc.CardType AS CreditCardType,
    COUNT(soh.SalesOrderID) AS OrderCount,
    FORMAT(SUM(soh.SubTotal), 'C') AS TotalCreditCardSales
FROM Sales.SalesOrderHeader soh
JOIN Sales.CreditCard cc ON soh.CreditCardID = cc.CreditCardID
GROUP BY cc.CardType
ORDER BY OrderCount DESC;

EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT cc.CardType AS CreditCardType, COUNT(soh.SalesOrderID) AS OrderCount, FORMAT(SUM(soh.SubTotal), ''C'') AS TotalCreditCardSales FROM Sales.SalesOrderHeader soh JOIN Sales.CreditCard cc ON soh.CreditCardID = cc.CreditCardID GROUP BY cc.CardType ORDER BY OrderCount DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\payment method\credit_card_payments.csv" -s "," -W -w 700';




-- پرداخت‌های ماهانه
SELECT 
    YEAR(sop.OrderDate) AS Year,
    MONTH(sop.OrderDate) AS Month,
    FORMAT(SUM(sop.TotalDue), 'C') AS MonthlySales
FROM Sales.SalesOrderHeader sop
GROUP BY YEAR(sop.OrderDate), MONTH(sop.OrderDate)
ORDER BY Year, Month;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT YEAR(sop.OrderDate) AS Year, MONTH(sop.OrderDate) AS Month, FORMAT(SUM(sop.TotalDue), ''C'') AS MonthlySales FROM Sales.SalesOrderHeader sop GROUP BY YEAR(sop.OrderDate), MONTH(sop.OrderDate) ORDER BY Year, Month" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\payment method\monthly_payments.csv" -s "," -W -w 700';




-- پرداخت‌های بر اساس منطقه
SELECT 
    t.Name AS TerritoryName,
    FORMAT(SUM(sop.TotalDue), 'C') AS TotalSales
FROM Sales.SalesOrderHeader sop
JOIN Sales.SalesTerritory t ON sop.TerritoryID = t.TerritoryID
GROUP BY t.Name
ORDER BY TotalSales DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT t.Name AS TerritoryName, FORMAT(SUM(sop.TotalDue), ''C'') AS TotalSales FROM Sales.SalesOrderHeader sop JOIN Sales.SalesTerritory t ON sop.TerritoryID = t.TerritoryID GROUP BY t.Name ORDER BY TotalSales DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\payment method\payments_by_territory.csv" -s "," -W -w 700';




