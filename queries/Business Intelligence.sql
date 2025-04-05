-- ۱. فروش بر اساس محصولات
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    FORMAT(SUM(sod.LineTotal), 'C') AS TotalSales
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY TotalSales DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT p.ProductID, p.Name AS ProductName, FORMAT(SUM(sod.LineTotal), ''C'') AS TotalSales FROM Sales.SalesOrderDetail sod JOIN Production.Product p ON sod.ProductID = p.ProductID GROUP BY p.ProductID, p.Name ORDER BY TotalSales DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\Business Intelligence\bi_sales_by_product.csv" -s "," -W -w 700';




-- ۲. فروش بر اساس مشتریان
SELECT 
    c.CustomerID,
    CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
    FORMAT(SUM(soh.TotalDue), 'C') AS TotalSpent
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY c.CustomerID, p.FirstName, p.LastName
ORDER BY TotalSpent DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT c.CustomerID, CONCAT(p.FirstName, '' '', p.LastName) AS CustomerName, FORMAT(SUM(soh.TotalDue), ''C'') AS TotalSpent FROM Sales.SalesOrderHeader soh JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID JOIN Person.Person p ON c.PersonID = p.BusinessEntityID GROUP BY c.CustomerID, p.FirstName, p.LastName ORDER BY TotalSpent DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\Business Intelligence\bi_sales_by_customer.csv" -s "," -W -w 700';





-- ۳. فروش بر اساس مناطق
SELECT 
    t.Name AS TerritoryName,
    FORMAT(SUM(soh.TotalDue), 'C') AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory t ON soh.TerritoryID = t.TerritoryID
GROUP BY t.Name
ORDER BY TotalSales DESC;


-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT t.Name AS TerritoryName, FORMAT(SUM(soh.TotalDue), ''C'') AS TotalSales FROM Sales.SalesOrderHeader soh JOIN Sales.SalesTerritory t ON soh.TerritoryID = t.TerritoryID GROUP BY t.Name ORDER BY TotalSales DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\Business Intelligence\bi_sales_by_territory.csv" -s "," -W -w 700';




-- ۴. فروش ماهانه
SELECT 
    YEAR(soh.OrderDate) AS Year,
    MONTH(soh.OrderDate) AS Month,
    FORMAT(SUM(soh.TotalDue), 'C') AS MonthlySales
FROM Sales.SalesOrderHeader soh
GROUP BY YEAR(soh.OrderDate), MONTH(soh.OrderDate)
ORDER BY Year, Month;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT YEAR(soh.OrderDate) AS Year, MONTH(soh.OrderDate) AS Month, FORMAT(SUM(soh.TotalDue), ''C'') AS MonthlySales FROM Sales.SalesOrderHeader soh GROUP BY YEAR(soh.OrderDate), MONTH(soh.OrderDate) ORDER BY Year, Month" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\Business Intelligence\bi_monthly_sales.csv" -s "," -W -w 700';




-- ۵. فروش سالانه
SELECT 
    YEAR(soh.OrderDate) AS Year,
    FORMAT(SUM(soh.TotalDue), 'C') AS AnnualSales
FROM Sales.SalesOrderHeader soh
GROUP BY YEAR(soh.OrderDate)
ORDER BY Year;

-- ۵. فروش سالانه
SELECT 
    YEAR(soh.OrderDate) AS Year,
    FORMAT(SUM(soh.TotalDue), 'C') AS AnnualSales
FROM Sales.SalesOrderHeader soh
GROUP BY YEAR(soh.OrderDate)
ORDER BY Year;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT YEAR(soh.OrderDate) AS Year, FORMAT(SUM(soh.TotalDue), ''C'') AS AnnualSales FROM Sales.SalesOrderHeader soh GROUP BY YEAR(soh.OrderDate) ORDER BY Year" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\Business Intelligence\bi_annual_sales.csv" -s "," -W -w 700';




-- ۶. موجودی بر اساس محصولات
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    SUM(pch.Quantity) AS TotalStock
FROM Production.Product p
JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY TotalStock DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT p.ProductID, p.Name AS ProductName, SUM(pch.Quantity) AS TotalStock FROM Production.Product p JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID GROUP BY p.ProductID, p.Name ORDER BY TotalStock DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\Business Intelligence\bi_inventory_by_product.csv" -s "," -W -w 700';





-- ۷. موجودی بر اساس انبارها
SELECT 
    l.Name AS WarehouseName,
    p.Name AS ProductName,
    pch.Quantity AS Stock
FROM Production.ProductInventory pch
JOIN Production.Product p ON pch.ProductID = p.ProductID
JOIN Production.Location l ON pch.LocationID = l.LocationID
ORDER BY WarehouseName, Stock DESC;


-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT l.Name AS WarehouseName, p.Name AS ProductName, pch.Quantity AS Stock FROM Production.ProductInventory pch JOIN Production.Product p ON pch.ProductID = p.ProductID JOIN Production.Location l ON pch.LocationID = l.LocationID ORDER BY WarehouseName, Stock DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\Business Intelligence\bi_inventory_by_warehouse.csv" -s "," -W -w 700';




-- ۸. موجودی فعلی
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    pch.Quantity AS CurrentStock
FROM Production.ProductInventory pch
JOIN Production.Product p ON pch.ProductID = p.ProductID
ORDER BY CurrentStock ASC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT p.ProductID, p.Name AS ProductName, pch.Quantity AS CurrentStock FROM Production.ProductInventory pch JOIN Production.Product p ON pch.ProductID = p.ProductID ORDER BY CurrentStock ASC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\Business Intelligence\bi_current_inventory.csv" -s "," -W -w 700';




-- ۹. تاریخچه حرکت موجودی
SELECT 
    th.TransactionDate,
    th.TransactionType,
    th.Quantity
FROM Production.TransactionHistory th
ORDER BY th.TransactionDate DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT th.TransactionDate, th.TransactionType, th.Quantity FROM Production.TransactionHistory th ORDER BY th.TransactionDate DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\Business Intelligence\bi_inventory_transaction_history.csv" -s "," -W -w 700';




-- ۱۰. هزینه‌ها بر اساس محصولات
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    p.StandardCost AS UnitCost,
    SUM(pch.Quantity * p.StandardCost) AS TotalCost
FROM Production.Product p
JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID
GROUP BY p.ProductID, p.Name, p.StandardCost
ORDER BY TotalCost DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT p.ProductID, p.Name AS ProductName, p.StandardCost AS UnitCost, SUM(pch.Quantity * p.StandardCost) AS TotalCost FROM Production.Product p JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID GROUP BY p.ProductID, p.Name, p.StandardCost ORDER BY TotalCost DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\Business Intelligence\bi_costs_by_product.csv" -s "," -W -w 700';




-- ۱۱. درآمد بر اساس مشتریان
SELECT 
    c.CustomerID,
    CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
    FORMAT(SUM(soh.TotalDue), 'C') AS TotalRevenue
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY c.CustomerID, p.FirstName, p.LastName
ORDER BY TotalRevenue DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT c.CustomerID, CONCAT(p.FirstName, '' '', p.LastName) AS CustomerName, FORMAT(SUM(soh.TotalDue), ''C'') AS TotalRevenue FROM Sales.SalesOrderHeader soh JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID JOIN Person.Person p ON c.PersonID = p.BusinessEntityID GROUP BY c.CustomerID, p.FirstName, p.LastName ORDER BY TotalRevenue DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\Business Intelligence\bi_revenue_by_customer.csv" -s "," -W -w 700';

