-- موجودی فعلی محصولات
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    pch.LocationID,
    l.Name AS LocationName,
    pch.Quantity AS CurrentStock
FROM Production.Product p
JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID
JOIN Production.Location l ON pch.LocationID = l.LocationID
ORDER BY CurrentStock ASC;

EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT p.ProductID, p.Name AS ProductName, pch.LocationID, l.Name AS LocationName, pch.Quantity AS CurrentStock FROM Production.Product p JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID JOIN Production.Location l ON pch.LocationID = l.LocationID ORDER BY CurrentStock ASC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\inventory_management\inventory_current_stock.csv" -s "," -W -w 700';




-- محصولات با کمترین موجودی
SELECT TOP 10
    p.ProductID,
    p.Name AS ProductName,
    SUM(pch.Quantity) AS TotalStock
FROM Production.Product p
JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY TotalStock ASC;

EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT TOP 10 p.ProductID, p.Name AS ProductName, SUM(pch.Quantity) AS TotalStock FROM Production.Product p JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID GROUP BY p.ProductID, p.Name ORDER BY TotalStock ASC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\inventory_management\inventory_low_stock.csv" -s "," -W -w 700';




-- موجودی بر اساس انبار
SELECT 
    l.Name AS WarehouseName,
    p.Name AS ProductName,
    pch.Quantity AS Stock
FROM Production.ProductInventory pch
JOIN Production.Product p ON pch.ProductID = p.ProductID
JOIN Production.Location l ON pch.LocationID = l.LocationID
ORDER BY WarehouseName, Stock DESC;


EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT l.Name AS WarehouseName, p.Name AS ProductName, pch.Quantity AS Stock FROM Production.ProductInventory pch JOIN Production.Product p ON pch.ProductID = p.ProductID JOIN Production.Location l ON pch.LocationID = l.LocationID ORDER BY WarehouseName, Stock DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\inventory_management\inventory_by_warehouse.csv" -s "," -W -w 700';




-- ارزش مالی موجودی
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    FORMAT(p.StandardCost, 'C') AS UnitCost,
    SUM(pch.Quantity) AS TotalStock,
    FORMAT(SUM(pch.Quantity * p.StandardCost), 'C') AS InventoryValue
FROM Production.Product p
JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID
GROUP BY p.ProductID, p.Name, p.StandardCost
ORDER BY InventoryValue DESC;


EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT p.ProductID, p.Name AS ProductName, FORMAT(p.StandardCost, ''C'') AS UnitCost, SUM(pch.Quantity) AS TotalStock, FORMAT(SUM(pch.Quantity * p.StandardCost), ''C'') AS InventoryValue FROM Production.Product p JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID GROUP BY p.ProductID, p.Name, p.StandardCost ORDER BY InventoryValue DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\inventory_management\inventory_valuation.csv" -s "," -W -w 700';




-- محصولات نیازمند سفارش مجدد
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    p.ReorderPoint,
    SUM(pch.Quantity) AS CurrentStock
FROM Production.Product p
JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID
GROUP BY p.ProductID, p.Name, p.ReorderPoint
HAVING SUM(pch.Quantity) <= p.ReorderPoint
ORDER BY CurrentStock ASC;


EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT p.ProductID, p.Name AS ProductName, p.ReorderPoint, SUM(pch.Quantity) AS CurrentStock FROM Production.Product p JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID GROUP BY p.ProductID, p.Name, p.ReorderPoint HAVING SUM(pch.Quantity) <= p.ReorderPoint ORDER BY CurrentStock ASC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\inventory_management\inventory_reorder_list.csv" -s "," -W -w 700';




-- تاریخچه حرکت موجودی
SELECT 
    p.Name AS ProductName,
    th.TransactionDate,
    th.TransactionType,
    th.Quantity,
    th.ActualCost AS UnitCost
FROM Production.TransactionHistory th
JOIN Production.Product p ON th.ProductID = p.ProductID
ORDER BY th.TransactionDate DESC;


EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT p.Name AS ProductName, th.TransactionDate, th.TransactionType, th.Quantity, th.ActualCost AS UnitCost FROM Production.TransactionHistory th JOIN Production.Product p ON th.ProductID = p.ProductID ORDER BY th.TransactionDate DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\inventory_management\inventory_transaction_history.csv" -s "," -W -w 700';




-- موجودی قدیمی
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    MAX(th.TransactionDate) AS LastTransactionDate,
    DATEDIFF(MONTH, MAX(th.TransactionDate), GETDATE()) AS MonthsSinceLastActivity,
    SUM(pch.Quantity) AS CurrentStock
FROM Production.Product p
JOIN Production.TransactionHistory th ON p.ProductID = th.ProductID
JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID
GROUP BY p.ProductID, p.Name
HAVING DATEDIFF(MONTH, MAX(th.TransactionDate), GETDATE()) > 6
ORDER BY MonthsSinceLastActivity DESC;


EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT p.ProductID, p.Name AS ProductName, MAX(th.TransactionDate) AS LastTransactionDate, DATEDIFF(MONTH, MAX(th.TransactionDate), GETDATE()) AS MonthsSinceLastActivity, SUM(pch.Quantity) AS CurrentStock FROM Production.Product p JOIN Production.TransactionHistory th ON p.ProductID = th.ProductID JOIN Production.ProductInventory pch ON p.ProductID = pch.ProductID GROUP BY p.ProductID, p.Name HAVING DATEDIFF(MONTH, MAX(th.TransactionDate), GETDATE()) > 6 ORDER BY MonthsSinceLastActivity DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\inventory_management\inventory_slow_moving.csv" -s "," -W -w 700';




