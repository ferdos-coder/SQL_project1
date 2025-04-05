-- تأمین‌کنندگان
SELECT 
    v.BusinessEntityID,
    v.Name AS VendorName
FROM Purchasing.Vendor v
ORDER BY v.Name;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT v.BusinessEntityID, v.Name AS VendorName FROM Purchasing.Vendor v ORDER BY v.Name" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\vendor report\vendors.csv" -s "," -W -w 700';




-- خرید از تأمین‌کنندگان
SELECT 
    v.BusinessEntityID,
    v.Name AS VendorName,
    FORMAT(SUM(poh.SubTotal), 'C') AS TotalPurchase,
    COUNT(poh.PurchaseOrderID) AS OrderCount
FROM Purchasing.PurchaseOrderHeader poh
JOIN Purchasing.Vendor v ON poh.VendorID = v.BusinessEntityID
GROUP BY v.BusinessEntityID, v.Name
ORDER BY TotalPurchase DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT v.BusinessEntityID, v.Name AS VendorName, FORMAT(SUM(poh.SubTotal), ''C'') AS TotalPurchase, COUNT(poh.PurchaseOrderID) AS OrderCount FROM Purchasing.PurchaseOrderHeader poh JOIN Purchasing.Vendor v ON poh.VendorID = v.BusinessEntityID GROUP BY v.BusinessEntityID, v.Name ORDER BY TotalPurchase DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\vendor report\vendor_purchases.csv" -s "," -W -w 700';




-- تأمین‌کنندگان با بیشترین خرید
SELECT TOP 10
    v.BusinessEntityID,
    v.Name AS VendorName,
    FORMAT(SUM(poh.SubTotal), 'C') AS TotalPurchase,
    COUNT(poh.PurchaseOrderID) AS OrderCount
FROM Purchasing.PurchaseOrderHeader poh
JOIN Purchasing.Vendor v ON poh.VendorID = v.BusinessEntityID
GROUP BY v.BusinessEntityID, v.Name
ORDER BY TotalPurchase DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT TOP 10 v.BusinessEntityID, v.Name AS VendorName, FORMAT(SUM(poh.SubTotal), ''C'') AS TotalPurchase, COUNT(poh.PurchaseOrderID) AS OrderCount FROM Purchasing.PurchaseOrderHeader poh JOIN Purchasing.Vendor v ON poh.VendorID = v.BusinessEntityID GROUP BY v.BusinessEntityID, v.Name ORDER BY TotalPurchase DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\vendor report\top_vendors.csv" -s "," -W -w 700';




-- خرید بر اساس تاریخ
SELECT 
    YEAR(poh.OrderDate) AS Year,
    MONTH(poh.OrderDate) AS Month,
    FORMAT(SUM(poh.SubTotal), 'C') AS MonthlyPurchase
FROM Purchasing.PurchaseOrderHeader poh
GROUP BY YEAR(poh.OrderDate), MONTH(poh.OrderDate)
ORDER BY Year, Month;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT YEAR(poh.OrderDate) AS Year, MONTH(poh.OrderDate) AS Month, FORMAT(SUM(poh.SubTotal), ''C'') AS MonthlyPurchase FROM Purchasing.PurchaseOrderHeader poh GROUP BY YEAR(poh.OrderDate), MONTH(poh.OrderDate) ORDER BY Year, Month" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\vendor report\monthly_purchases.csv" -s "," -W -w 700';




-- تأمین‌کنندگان بر اساس دسته‌بندی
SELECT 
    psc.Name AS ProductSubcategory,
    v.Name AS VendorName,
    FORMAT(SUM(poh.SubTotal), 'C') AS TotalPurchase
FROM Purchasing.PurchaseOrderHeader poh
JOIN Purchasing.PurchaseOrderDetail pod ON poh.PurchaseOrderID = pod.PurchaseOrderID
JOIN Production.Product p ON pod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Purchasing.Vendor v ON poh.VendorID = v.BusinessEntityID
GROUP BY psc.Name, v.Name
ORDER BY TotalPurchase DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT psc.Name AS ProductSubcategory, v.Name AS VendorName, FORMAT(SUM(poh.SubTotal), ''C'') AS TotalPurchase FROM Purchasing.PurchaseOrderHeader poh JOIN Purchasing.PurchaseOrderDetail pod ON poh.PurchaseOrderID = pod.PurchaseOrderID JOIN Production.Product p ON pod.ProductID = p.ProductID JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID JOIN Purchasing.Vendor v ON poh.VendorID = v.BusinessEntityID GROUP BY psc.Name, v.Name ORDER BY TotalPurchase DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\vendor report\vendor_purchases_by_category.csv" -s "," -W -w 700';




