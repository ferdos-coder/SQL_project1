-- ۱. فروش هر کارمند
SELECT 
    sp.BusinessEntityID,
    CONCAT(p.FirstName, ' ', p.LastName) AS SalesPersonName,
    FORMAT(SUM(soh.TotalDue), 'C') AS TotalSales,
    COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
GROUP BY sp.BusinessEntityID, p.FirstName, p.LastName
ORDER BY TotalSales DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT sp.BusinessEntityID, CONCAT(p.FirstName, '' '', p.LastName) AS SalesPersonName, FORMAT(SUM(soh.TotalDue), ''C'') AS TotalSales, COUNT(soh.SalesOrderID) AS OrderCount FROM Sales.SalesOrderHeader soh JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID GROUP BY sp.BusinessEntityID, p.FirstName, p.LastName ORDER BY TotalSales DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\sales person\employee_sales.csv" -s "," -W -w 700';




-- ۲. کارمندان با بیشترین فروش
SELECT TOP 10
    sp.BusinessEntityID,
    CONCAT(p.FirstName, ' ', p.LastName) AS SalesPersonName,
    FORMAT(SUM(soh.TotalDue), 'C') AS TotalSales,
    COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
GROUP BY sp.BusinessEntityID, p.FirstName, p.LastName
ORDER BY TotalSales DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT TOP 10 sp.BusinessEntityID, CONCAT(p.FirstName, '' '', p.LastName) AS SalesPersonName, FORMAT(SUM(soh.TotalDue), ''C'') AS TotalSales, COUNT(soh.SalesOrderID) AS OrderCount FROM Sales.SalesOrderHeader soh JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID GROUP BY sp.BusinessEntityID, p.FirstName, p.LastName ORDER BY TotalSales DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\sales person\top_employees.csv" -s "," -W -w 700';




-- ۳. فروش کارمندان بر اساس منطقه
SELECT 
    t.Name AS TerritoryName,
    sp.BusinessEntityID,
    CONCAT(p.FirstName, ' ', p.LastName) AS SalesPersonName,
    FORMAT(SUM(soh.TotalDue), 'C') AS TotalSales,
    COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
JOIN Sales.SalesTerritory t ON soh.TerritoryID = t.TerritoryID
GROUP BY t.Name, sp.BusinessEntityID, p.FirstName, p.LastName
ORDER BY TotalSales DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT t.Name AS TerritoryName, sp.BusinessEntityID, CONCAT(p.FirstName, '' '', p.LastName) AS SalesPersonName, FORMAT(SUM(soh.TotalDue), ''C'') AS TotalSales, COUNT(soh.SalesOrderID) AS OrderCount FROM Sales.SalesOrderHeader soh JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID JOIN Sales.SalesTerritory t ON soh.TerritoryID = t.TerritoryID GROUP BY t.Name, sp.BusinessEntityID, p.FirstName, p.LastName ORDER BY TotalSales DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\sales person\employee_sales_by_territory.csv" -s "," -W -w 700';




-- ۴. عملکرد کارمندان بر اساس محصولات
SELECT 
    sp.BusinessEntityID,
    CONCAT(p.FirstName, ' ', p.LastName) AS SalesPersonName,
    p2.ProductID,
    p2.Name AS ProductName,
    FORMAT(SUM(sod.LineTotal), 'C') AS TotalSales,
    SUM(sod.OrderQty) AS TotalQuantitySold
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
JOIN Production.Product p2 ON sod.ProductID = p2.ProductID
GROUP BY sp.BusinessEntityID, p.FirstName, p.LastName, p2.ProductID, p2.Name
ORDER BY TotalSales DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT sp.BusinessEntityID, CONCAT(p.FirstName, '' '', p.LastName) AS SalesPersonName, p2.ProductID, p2.Name AS ProductName, FORMAT(SUM(sod.LineTotal), ''C'') AS TotalSales, SUM(sod.OrderQty) AS TotalQuantitySold FROM Sales.SalesOrderDetail sod JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID JOIN Production.Product p2 ON sod.ProductID = p2.ProductID GROUP BY sp.BusinessEntityID, p.FirstName, p.LastName, p2.ProductID, p2.Name ORDER BY TotalSales DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\sales person\employee_sales_by_product.csv" -s "," -W -w 700';




-- ۵. کارمندان بر اساس تاریخ استخدام
SELECT 
    sp.BusinessEntityID,
    CONCAT(p.FirstName, ' ', p.LastName) AS SalesPersonName,
    e.HireDate AS HireDate,
    FORMAT(SUM(soh.TotalDue), 'C') AS TotalSales,
    COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN HumanResources.Employee e ON sp.BusinessEntityID = e.BusinessEntityID
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
GROUP BY sp.BusinessEntityID, p.FirstName, p.LastName, e.HireDate
ORDER BY HireDate DESC;


-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT sp.BusinessEntityID, CONCAT(p.FirstName, '' '', p.LastName) AS SalesPersonName, sp.HireDate AS HireDate, FORMAT(SUM(soh.TotalDue), ''C'') AS TotalSales, COUNT(soh.SalesOrderID) AS OrderCount FROM Sales.SalesOrderHeader soh JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID GROUP BY sp.BusinessEntityID, p.FirstName, p.LastName, sp.HireDate ORDER BY HireDate DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\sales person\employee_hire_date.csv" -s "," -W -w 700';







