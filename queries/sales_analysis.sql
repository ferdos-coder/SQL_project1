-- ۱. مجموع فروش کلی
SELECT FORMAT(SUM(TotalDue), 'C') AS TotalSales
FROM Sales.SalesOrderHeader;

-- ۲. فروش ماهانه به تفکیک سال و ماه
SELECT 
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    FORMAT(SUM(TotalDue), 'C') AS MonthlySales,
    COUNT(SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

-- ۳. فروش هر محصول (با نام محصول)
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    FORMAT(SUM(sod.LineTotal), 'C') AS TotalSales,
    SUM(sod.OrderQty) AS TotalQuantitySold
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY TotalSales DESC;

-- ۴. فروش بر اساس منطقه (Territory)
SELECT 
    t.Name AS TerritoryName,
    FORMAT(SUM(soh.TotalDue), 'C') AS TotalSales,
    COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory t ON soh.TerritoryID = t.TerritoryID
GROUP BY t.Name
ORDER BY TotalSales DESC;

-- ۵. فروش هر فروشنده (SalesPerson)
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


-- ۶. ۱۰ مشتری برتر بر اساس مجموع خرید
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


-- ۷. فروش فصلی
SELECT 
    CASE 
        WHEN MONTH(OrderDate) IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH(OrderDate) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(OrderDate) IN (6, 7, 8) THEN 'Summer'
        ELSE 'Autumn'
    END AS Season,
    FORMAT(SUM(TotalDue), 'C') AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY 
    CASE 
        WHEN MONTH(OrderDate) IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH(OrderDate) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(OrderDate) IN (6, 7, 8) THEN 'Summer'
        ELSE 'Autumn'
    END
ORDER BY TotalSales DESC;


USE master;
GO
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;


-- ذخیره نتایج کوئری ۱ در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT ''Total Sales'' AS ReportType, FORMAT(SUM(TotalDue), ''C'') AS TotalSales FROM Sales.SalesOrderHeader" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\sales_report\sales_report_1.csv" -s "," -W -w 700';

-- ذخیره نتایج کوئری ۲ در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT ''Monthly Sales'' AS ReportType, YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month, FORMAT(SUM(TotalDue), ''C'') AS MonthlySales, COUNT(SalesOrderID) AS OrderCount FROM Sales.SalesOrderHeader GROUP BY YEAR(OrderDate), MONTH(OrderDate) ORDER BY Year, Month" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\sales_report\sales_report_2.csv" -s "," -W -w 700';

-- ذخیره نتایج کوئری ۳ در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT ''Product Sales'' AS ReportType, p.ProductID, p.Name AS ProductName, FORMAT(SUM(sod.LineTotal), ''C'') AS TotalSales, SUM(sod.OrderQty) AS TotalQuantitySold FROM Sales.SalesOrderDetail sod JOIN Production.Product p ON sod.ProductID = p.ProductID GROUP BY p.ProductID, p.Name ORDER BY TotalSales DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\sales_report\sales_report_3.csv" -s "," -W -w 700';

-- ذخیره نتایج کوئری ۴ در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT ''Territory Sales'' AS ReportType, t.Name AS TerritoryName, FORMAT(SUM(soh.TotalDue), ''C'') AS TotalSales, COUNT(soh.SalesOrderID) AS OrderCount FROM Sales.SalesOrderHeader soh JOIN Sales.SalesTerritory t ON soh.TerritoryID = t.TerritoryID GROUP BY t.Name ORDER BY TotalSales DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\sales_report\sales_report_4.csv" -s "," -W -w 700';

-- ذخیره نتایج کوئری ۵ در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT ''SalesPerson Sales'' AS ReportType, sp.BusinessEntityID, CONCAT(p.FirstName, '' '', p.LastName) AS SalesPersonName, FORMAT(SUM(soh.TotalDue), ''C'') AS TotalSales, COUNT(soh.SalesOrderID) AS OrderCount FROM Sales.SalesOrderHeader soh JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID GROUP BY sp.BusinessEntityID, p.FirstName, p.LastName ORDER BY TotalSales DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\sales_report\sales_report_5.csv" -s "," -W -w 700';

-- ذخیره نتایج کوئری ۶ در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT ''Top Customers'' AS ReportType, c.CustomerID, CONCAT(p.FirstName, '' '', p.LastName) AS CustomerName, FORMAT(SUM(soh.TotalDue), ''C'') AS TotalSpent, COUNT(soh.SalesOrderID) AS OrderCount FROM Sales.SalesOrderHeader soh JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID JOIN Person.Person p ON c.PersonID = p.BusinessEntityID GROUP BY c.CustomerID, p.FirstName, p.LastName ORDER BY TotalSpent DESC OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\sales_report\sales_report_6.csv" -s "," -W -w 700';

-- ذخیره نتایج کوئری ۷ در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT ''Seasonal Sales'' AS ReportType, CASE WHEN MONTH(OrderDate) IN (12, 1, 2) THEN ''Winter'' WHEN MONTH(OrderDate) IN (3, 4, 5) THEN ''Spring'' WHEN MONTH(OrderDate) IN (6, 7, 8) THEN ''Summer'' ELSE ''Autumn'' END AS Season, FORMAT(SUM(TotalDue), ''C'') AS TotalSales FROM Sales.SalesOrderHeader GROUP BY CASE WHEN MONTH(OrderDate) IN (12, 1, 2) THEN ''Winter'' WHEN MONTH(OrderDate) IN (3, 4, 5) THEN ''Spring'' WHEN MONTH(OrderDate) IN (6, 7, 8) THEN ''Summer'' ELSE ''Autumn'' END ORDER BY TotalSales DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\sales_report\sales_report_7.csv" -s "," -W -w 700';

