-- تاریخچه سفارشات
SELECT 
    soh.SalesOrderID,
    soh.OrderDate,
    soh.ShipDate,
    soh.Status AS OrderStatus
FROM Sales.SalesOrderHeader soh
ORDER BY soh.OrderDate DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT soh.SalesOrderID, soh.OrderDate, soh.ShipDate, soh.Status AS OrderStatus FROM Sales.SalesOrderHeader soh ORDER BY soh.OrderDate DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\order date\order_history.csv" -s "," -W -w 700';




-- سفارشات بر اساس وضعیت
SELECT 
    soh.Status AS OrderStatus,
    COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader soh
GROUP BY soh.Status
ORDER BY OrderCount DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT soh.Status AS OrderStatus, COUNT(soh.SalesOrderID) AS OrderCount FROM Sales.SalesOrderHeader soh GROUP BY soh.Status ORDER BY OrderCount DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\order date\order_status.csv" -s "," -W -w 700';




-- سفارشات بر اساس تاریخ سفارش
SELECT 
    YEAR(soh.OrderDate) AS Year,
    MONTH(soh.OrderDate) AS Month,
    COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader soh
GROUP BY YEAR(soh.OrderDate), MONTH(soh.OrderDate)
ORDER BY Year, Month;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT YEAR(soh.OrderDate) AS Year, MONTH(soh.OrderDate) AS Month, COUNT(soh.SalesOrderID) AS OrderCount FROM Sales.SalesOrderHeader soh GROUP BY YEAR(soh.OrderDate), MONTH(soh.OrderDate) ORDER BY Year, Month" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\order date\orders_by_date.csv" -s "," -W -w 700';




-- سفارشات دیر شده
SELECT 
    soh.SalesOrderID,
    soh.OrderDate,
    soh.ShipDate,
    DATEDIFF(DAY, soh.OrderDate, soh.ShipDate) AS DeliveryDays
FROM Sales.SalesOrderHeader soh
WHERE soh.ShipDate IS NOT NULL AND DATEDIFF(DAY, soh.OrderDate, soh.ShipDate) > 10
ORDER BY DeliveryDays DESC;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT soh.SalesOrderID, soh.OrderDate, soh.ShipDate, DATEDIFF(DAY, soh.OrderDate, soh.ShipDate) AS DeliveryDays FROM Sales.SalesOrderHeader soh WHERE soh.ShipDate IS NOT NULL AND DATEDIFF(DAY, soh.OrderDate, soh.ShipDate) > 10 ORDER BY DeliveryDays DESC" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\order date\late_orders.csv" -s "," -W -w 700';




-- میانگین زمان ارسال سفارشات
SELECT 
    AVG(DATEDIFF(DAY, soh.OrderDate, soh.ShipDate)) AS AverageDeliveryDays
FROM Sales.SalesOrderHeader soh
WHERE soh.ShipDate IS NOT NULL;

-- ذخیره نتایج در فایل CSV
EXEC xp_cmdshell 'sqlcmd -S DESKTOP-JR93J5N -d AdventureWorks2022 -Q "SELECT AVG(DATEDIFF(DAY, soh.OrderDate, soh.ShipDate)) AS AverageDeliveryDays FROM Sales.SalesOrderHeader soh WHERE soh.ShipDate IS NOT NULL" -o "E:\data analysis project\AdventureWorks2022SQLProject\reports\order date\average_delivery_time.csv" -s "," -W -w 700';





