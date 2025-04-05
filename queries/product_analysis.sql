-- ۱. فروش هر محصول
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    FORMAT(SUM(sod.LineTotal), 'C') AS TotalSales,
    SUM(sod.OrderQty) AS TotalQuantitySold
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY TotalSales DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT p.ProductID, p.Name AS ProductName, FORMAT(SUM(sod.LineTotal), ''C'') AS TotalSales, SUM(sod.OrderQty) AS TotalQuantitySold FROM Sales.SalesOrderDetail sod JOIN Production.Product p ON sod.ProductID = p.ProductID GROUP BY p.ProductID, p.Name ORDER BY TotalSales DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\products_report\product_sales.csv" -s "," -W -w 700';




-- ۲. پرفروش‌ترین محصولات
SELECT TOP 10
    p.ProductID,
    p.Name AS ProductName,
    FORMAT(SUM(sod.LineTotal), 'C') AS TotalSales,
    SUM(sod.OrderQty) AS TotalQuantitySold
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY TotalSales DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT TOP 10 p.ProductID, p.Name AS ProductName, FORMAT(SUM(sod.LineTotal), ''C'') AS TotalSales, SUM(sod.OrderQty) AS TotalQuantitySold FROM Sales.SalesOrderDetail sod JOIN Production.Product p ON sod.ProductID = p.ProductID GROUP BY p.ProductID, p.Name ORDER BY TotalSales DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\products_report\top_products.csv" -s "," -W -w 700';




-- ۳. فروش محصولات بر اساس دسته‌بندی
SELECT 
    pc.Name AS Category,
    psc.Name AS SubCategory,
    p.Name AS ProductName,
    FORMAT(SUM(sod.LineTotal), 'C') AS TotalSales,
    SUM(sod.OrderQty) AS TotalQuantitySold
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name, psc.Name, p.Name
ORDER BY TotalSales DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT pc.Name AS Category, psc.Name AS SubCategory, p.Name AS ProductName, FORMAT(SUM(sod.LineTotal), ''C'') AS TotalSales, SUM(sod.OrderQty) AS TotalQuantitySold FROM Sales.SalesOrderDetail sod JOIN Production.Product p ON sod.ProductID = p.ProductID JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID GROUP BY pc.Name, psc.Name, p.Name ORDER BY TotalSales DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\products_report\product_categories.csv" -s "," -W -w 700';




-- ۴. موجودی فعلی محصولات
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    SUM(pch.Quantity) AS CurrentStock
FROM Production.Product p
JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY CurrentStock ASC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT p.ProductID, p.Name AS ProductName, SUM(pch.Quantity) AS CurrentStock FROM Production.Product p JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID GROUP BY p.ProductID, p.Name ORDER BY CurrentStock ASC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\products_report\product_inventory.csv" -s "," -W -w 700';




-- ۵. محصولات با کمترین موجودی
SELECT TOP 10
    p.ProductID,
    p.Name AS ProductName,
    SUM(pch.Quantity) AS CurrentStock
FROM Production.Product p
JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY CurrentStock ASC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT TOP 10 p.ProductID, p.Name AS ProductName, SUM(pch.Quantity) AS CurrentStock FROM Production.Product p JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID GROUP BY p.ProductID, p.Name ORDER BY CurrentStock ASC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\products_report\low_stock_products.csv" -s "," -W -w 700';




-- ۶. فروش محصولات بر اساس فروشنده
SELECT 
    sp.BusinessEntityID,
    CONCAT(p1.FirstName, ' ', p1.LastName) AS SalesPersonName,
    p.ProductID,
    p.Name AS ProductName,
    FORMAT(SUM(sod.LineTotal), 'C') AS TotalSales,
    SUM(sod.OrderQty) AS TotalQuantitySold
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN Person.Person p1 ON sp.BusinessEntityID = p1.BusinessEntityID
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY sp.BusinessEntityID, p1.FirstName, p1.LastName, p.ProductID, p.Name
ORDER BY TotalSales DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT sp.BusinessEntityID, CONCAT(p1.FirstName, '' '', p1.LastName) AS SalesPersonName, p.ProductID, p.Name AS ProductName, FORMAT(SUM(sod.LineTotal), ''C'') AS TotalSales, SUM(sod.OrderQty) AS TotalQuantitySold FROM Sales.SalesOrderDetail sod JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID JOIN Person.Person p1 ON sp.BusinessEntityID = p1.BusinessEntityID JOIN Production.Product p ON sod.ProductID = p.ProductID GROUP BY sp.BusinessEntityID, p1.FirstName, p1.LastName, p.ProductID, p.Name ORDER BY TotalSales DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\products_report\product_sales_by_salesperson.csv" -s "," -W -w 700';




-- ۷. فروش فصلی محصولات
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    CASE 
        WHEN MONTH(soh.OrderDate) IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH(soh.OrderDate) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(soh.OrderDate) IN (6, 7, 8) THEN 'Summer'
        ELSE 'Autumn'
    END AS Season,
    FORMAT(SUM(sod.LineTotal), 'C') AS TotalSales
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.ProductID, p.Name, 
    CASE 
        WHEN MONTH(soh.OrderDate) IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH(soh.OrderDate) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(soh.OrderDate) IN (6, 7, 8) THEN 'Summer'
        ELSE 'Autumn'
    END
ORDER BY TotalSales DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT p.ProductID, p.Name AS ProductName, CASE WHEN MONTH(soh.OrderDate) IN (12, 1, 2) THEN ''Winter'' WHEN MONTH(soh.OrderDate) IN (3, 4, 5) THEN ''Spring'' WHEN MONTH(soh.OrderDate) IN (6, 7, 8) THEN ''Summer'' ELSE ''Autumn'' END AS Season, FORMAT(SUM(sod.LineTotal), ''C'') AS TotalSales FROM Sales.SalesOrderDetail sod JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID JOIN Production.Product p ON sod.ProductID = p.ProductID GROUP BY p.ProductID, p.Name, CASE WHEN MONTH(soh.OrderDate) IN (12, 1, 2) THEN ''Winter'' WHEN MONTH(soh.OrderDate) IN (3, 4, 5) THEN ''Spring'' WHEN MONTH(soh.OrderDate) IN (6, 7, 8) THEN ''Summer'' ELSE ''Autumn'' END ORDER BY TotalSales DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\products_report\seasonal_product_sales.csv" -s "," -W -w 700';

