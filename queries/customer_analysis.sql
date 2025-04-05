-- ۱. تعداد سفارشات هر مشتری
SELECT 
    c.CustomerID,
    CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
    COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY c.CustomerID, p.FirstName, p.LastName
ORDER BY OrderCount DESC;


-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT c.CustomerID, CONCAT(p.FirstName, '' '', p.LastName) AS CustomerName, COUNT(soh.SalesOrderID) AS OrderCount FROM Sales.SalesOrderHeader soh JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID JOIN Person.Person p ON c.PersonID = p.BusinessEntityID GROUP BY c.CustomerID, p.FirstName, p.LastName ORDER BY OrderCount DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\customer_report\customer_order_count.csv" -s "," -W -w 700';


-- ۲. مشتریان با بیشترین هزینه
SELECT TOP 10
    c.CustomerID,
    CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
    FORMAT(SUM(soh.TotalDue), 'C') AS TotalSpent,
    COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY c.CustomerID, p.FirstName, p.LastName
ORDER BY TotalSpent DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT TOP 10 c.CustomerID, CONCAT(p.FirstName, '' '', p.LastName) AS CustomerName, FORMAT(SUM(soh.TotalDue), ''C'') AS TotalSpent, COUNT(soh.SalesOrderID) AS OrderCount FROM Sales.SalesOrderHeader soh JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID JOIN Person.Person p ON c.PersonID = p.BusinessEntityID GROUP BY c.CustomerID, p.FirstName, p.LastName ORDER BY TotalSpent DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\customer_report\top_customers.csv" -s "," -W -w 700';




-- ۳. دسته‌بندی مشتریان بر اساس میزان خرید
WITH CustomerSpending AS (
    SELECT 
        c.CustomerID,
        CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
        FORMAT(SUM(soh.TotalDue), 'C') AS TotalSpent
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    GROUP BY c.CustomerID, p.FirstName, p.LastName
)
SELECT 
    CustomerName,
    TotalSpent,
    CASE 
        WHEN TRY_CAST(REPLACE(TotalSpent, ',', '') AS DECIMAL(18, 2)) > 10000 THEN 'VIP'
        WHEN TRY_CAST(REPLACE(TotalSpent, ',', '') AS DECIMAL(18, 2)) BETWEEN 5000 AND 10000 THEN 'Premium'
        ELSE 'Regular'
    END AS CustomerCategory
FROM CustomerSpending
ORDER BY TotalSpent DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "WITH CustomerSpending AS (SELECT c.CustomerID, CONCAT(p.FirstName, '' '', p.LastName) AS CustomerName, FORMAT(SUM(soh.TotalDue), ''C'') AS TotalSpent FROM Sales.SalesOrderHeader soh JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID JOIN Person.Person p ON c.PersonID = p.BusinessEntityID GROUP BY c.CustomerID, p.FirstName, p.LastName) SELECT CustomerName, TotalSpent, CASE WHEN TRY_CAST(REPLACE(TotalSpent, '','', '') AS DECIMAL(18, 2)) > 10000 THEN ''VIP'' WHEN TRY_CAST(REPLACE(TotalSpent, '','', '') AS DECIMAL(18, 2)) BETWEEN 5000 AND 10000 THEN ''Premium'' ELSE ''Regular'' END AS CustomerCategory FROM CustomerSpending ORDER BY TotalSpent DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\customer_report\customer_categories.csv" -s "," -W -w 700';




-- ۴. مشتریان بر اساس منطقه
SELECT 
    a.AddressLine1 AS AddressName,
    c.CustomerID,
    CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
    COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.BusinessEntityAddress bea ON p.BusinessEntityID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
GROUP BY a.AddressLine1, c.CustomerID, p.FirstName, p.LastName
ORDER BY OrderCount DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT a.Name AS AddressName, c.CustomerID, CONCAT(p.FirstName, '' '', p.LastName) AS CustomerName, COUNT(soh.SalesOrderID) AS OrderCount FROM Sales.SalesOrderHeader soh JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID JOIN Person.Person p ON c.PersonID = p.BusinessEntityID JOIN Sales.CustomerAddress ca ON c.CustomerID = ca.CustomerID JOIN Person.Address a ON ca.AddressID = a.AddressID GROUP BY a.Name, c.CustomerID, p.FirstName, p.LastName ORDER BY OrderCount DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\customer_report\customer_by_address.csv" -s "," -W -w 700';




-- ۵. مشتریان بر اساس تاریخ ثبت‌نام
SELECT 
    c.CustomerID,
    CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
    c.ModifiedDate AS RegistrationDate,
    COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY c.CustomerID, p.FirstName, p.LastName, c.ModifiedDate
ORDER BY RegistrationDate DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT c.CustomerID, CONCAT(p.FirstName, '' '', p.LastName) AS CustomerName, c.ModifiedDate AS RegistrationDate, COUNT(soh.SalesOrderID) AS OrderCount FROM Sales.SalesOrderHeader soh JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID JOIN Person.Person p ON c.PersonID = p.BusinessEntityID GROUP BY c.CustomerID, p.FirstName, p.LastName, c.ModifiedDate ORDER BY RegistrationDate DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\customer_report\customer_registration.csv" -s "," -W -w 700';