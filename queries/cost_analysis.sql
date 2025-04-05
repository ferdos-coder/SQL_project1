-- هزینه‌های تولید
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
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT p.ProductID, p.Name AS ProductName, p.StandardCost AS UnitCost, SUM(pch.Quantity * p.StandardCost) AS TotalCost FROM Production.Product p JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID GROUP BY p.ProductID, p.Name, p.StandardCost ORDER BY TotalCost DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\costs_report\production_costs.csv" -s "," -W -w 700';




-- هزینه‌های خرید
SELECT 
    v.BusinessEntityID,
    v.Name AS VendorName,
    FORMAT(SUM(poh.SubTotal), 'C') AS TotalPurchase
FROM Purchasing.PurchaseOrderHeader poh
JOIN Purchasing.Vendor v ON poh.VendorID = v.BusinessEntityID
GROUP BY v.BusinessEntityID, v.Name
ORDER BY TotalPurchase DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT v.BusinessEntityID, v.Name AS VendorName, FORMAT(SUM(poh.SubTotal), ''C'') AS TotalPurchase FROM Purchasing.PurchaseOrderHeader poh JOIN Purchasing.Vendor v ON poh.VendorID = v.BusinessEntityID GROUP BY v.BusinessEntityID, v.Name ORDER BY TotalPurchase DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\costs_report\purchase_costs.csv" -s "," -W -w 700';




-- هزینه‌های فروش
SELECT 
    sp.BusinessEntityID,
    CONCAT(p.FirstName, ' ', p.LastName) AS SalesPersonName,
    FORMAT(SUM(soh.TotalDue), 'C') AS TotalSales,
    SUM(sp.CommissionPct * soh.TotalDue) AS TotalCommissionCost
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
GROUP BY sp.BusinessEntityID, p.FirstName, p.LastName, sp.CommissionPct
ORDER BY TotalCommissionCost DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT sp.BusinessEntityID, CONCAT(p.FirstName, '' '', p.LastName) AS SalesPersonName, FORMAT(SUM(soh.TotalDue), ''C'') AS TotalSales, SUM(sp.CommissionPct * soh.TotalDue) AS TotalCommissionCost FROM Sales.SalesOrderHeader soh JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID GROUP BY sp.BusinessEntityID, p.FirstName, p.LastName, sp.CommissionPct ORDER BY TotalCommissionCost DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\costs_report\sales_costs.csv" -s "," -W -w 700';




-- هزینه‌های سالانه
SELECT 
    YEAR(poh.OrderDate) AS Year,
    FORMAT(SUM(poh.SubTotal), 'C') AS AnnualPurchaseCost
FROM Purchasing.PurchaseOrderHeader poh
GROUP BY YEAR(poh.OrderDate)
ORDER BY Year;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT YEAR(poh.OrderDate) AS Year, FORMAT(SUM(poh.SubTotal), ''C'') AS AnnualPurchaseCost FROM Purchasing.PurchaseOrderHeader poh GROUP BY YEAR(poh.OrderDate) ORDER BY Year" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\costs_report\annual_costs.csv" -s "," -W -w 700';





-- هزینه‌های بر اساس دسته‌بندی محصولات
SELECT 
    pc.Name AS ProductCategory,
    psc.Name AS ProductSubcategory,
    p.StandardCost AS UnitCost,
    SUM(pch.Quantity * p.StandardCost) AS TotalCost
FROM Production.Product p
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID
GROUP BY pc.Name, psc.Name, p.StandardCost
ORDER BY TotalCost DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT pc.Name AS ProductCategory, psc.Name AS ProductSubcategory, p.StandardCost AS UnitCost, SUM(pch.Quantity * p.StandardCost) AS TotalCost FROM Production.Product p JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID GROUP BY pc.Name, psc.Name, p.StandardCost ORDER BY TotalCost DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\costs_report\costs_by_category.csv" -s "," -W -w 700';






