CREATE DATABASE ProductOrdersDB;

-- Select Database
USE ProductOrdersDB;
CREATE TABLE ProductOrders (
    OrderID INT,
    OrderDate DATE,
    CustomerID INT,
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    SalesAmount DECIMAL(12,2),
    PRIMARY KEY (OrderID, ProductID)
);

-- Insert Sample Data
INSERT INTO ProductOrders VALUES
(1,'2026-01-05',1001,101,'Laptop','Electronics',2,60000,120000),
(1,'2026-01-05',1001,102,'Mobile','Electronics',1,25000,25000),
(2,'2026-01-10',1002,103,'Printer','Electronics',3,12000,36000),
(3,'2026-01-15',1003,104,'Desk','Furniture',2,8000,16000),
(3,'2026-01-15',1003,105,'Chair','Furniture',4,3000,12000),
(4,'2026-02-05',1004,101,'Laptop','Electronics',1,60000,60000),
(4,'2026-02-05',1004,103,'Printer','Electronics',2,12000,24000),
(5,'2026-02-10',1005,102,'Mobile','Electronics',3,25000,75000),
(5,'2026-02-10',1005,104,'Desk','Furniture',1,8000,8000),
(6,'2026-03-01',1006,105,'Chair','Furniture',5,3000,15000),
(7,'2026-03-05',1007,101,'Laptop','Electronics',2,60000,120000),
(8,'2026-03-12',1008,102,'Mobile','Electronics',4,25000,100000);

-- Verify Data
SELECT * FROM ProductOrders;
-- 1. Generate ROW_NUMBER() for products ordered by SalesAmount descending
SELECT ProductName,
       SalesAmount,
       ROW_NUMBER() OVER(ORDER BY SalesAmount DESC) AS RowNum
FROM ProductOrders;
-- 2. Assign RANK() to products based on total sales
SELECT ProductName,
       TotalSales,
       RANK() OVER(ORDER BY TotalSales DESC) AS SalesRank
FROM
(
    SELECT ProductName,
           SUM(SalesAmount) AS TotalSales
    FROM ProductOrders
    GROUP BY ProductName
) t;
-- 3. Assign DENSE_RANK() to products based on quantity sold
SELECT ProductName,
       TotalQuantity,
       DENSE_RANK() OVER(ORDER BY TotalQuantity DESC) AS QuantityRank
FROM
(
    SELECT ProductName,
           SUM(Quantity) AS TotalQuantity
    FROM ProductOrders
    GROUP BY ProductName
) t;
-- 4. Find the Top 3 selling products
SELECT *
FROM
(
    SELECT ProductName,
           SUM(SalesAmount) AS TotalSales,
           DENSE_RANK() OVER(ORDER BY SUM(SalesAmount) DESC) AS rnk
    FROM ProductOrders
    GROUP BY ProductName
) t
WHERE rnk <= 3;
-- 5. Display previous SalesAmount using LAG()
SELECT OrderID,
       ProductName,
       SalesAmount,
       LAG(SalesAmount) OVER(ORDER BY OrderDate) AS PreviousSales
FROM ProductOrders;
-- 6. Display next SalesAmount using LEAD()
SELECT OrderID,
       ProductName,
       SalesAmount,
       LEAD(SalesAmount) OVER(ORDER BY OrderDate) AS NextSales
FROM ProductOrders;
-- 7. Calculate running total of SalesAmount by OrderDate
SELECT OrderDate,
       ProductName,
       SalesAmount,
       SUM(SalesAmount) OVER(ORDER BY OrderDate) AS RunningTotal
FROM ProductOrders;
-- 8. Calculate cumulative sales for each product
SELECT ProductName,
       OrderDate,
       SalesAmount,
       SUM(SalesAmount)
       OVER(PARTITION BY ProductName ORDER BY OrderDate) AS CumulativeSales
FROM ProductOrders;
-- 9. Show highest sales in each category using FIRST_VALUE()
SELECT Category,
       ProductName,
       SalesAmount,
       FIRST_VALUE(SalesAmount)
       OVER(PARTITION BY Category ORDER BY SalesAmount DESC) AS HighestSales
FROM ProductOrders;
-- 10. Show lowest sales in each category using LAST_VALUE()
SELECT Category,
       ProductName,
       SalesAmount,
       LAST_VALUE(SalesAmount)
       OVER(
            PARTITION BY Category
            ORDER BY SalesAmount
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND UNBOUNDED FOLLOWING
       ) AS LowestSales
FROM ProductOrders;
-- 11. Calculate difference between current and previous sales
SELECT ProductName,
       SalesAmount,
       SalesAmount -
       LAG(SalesAmount) OVER(ORDER BY OrderDate) AS SalesDifference
FROM ProductOrders;
-- 12. Calculate 3-order moving average sales
SELECT OrderID,
       ProductName,
       SalesAmount,
       AVG(SalesAmount)
       OVER(
            ORDER BY OrderDate
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS MovingAverage
FROM ProductOrders;
-- 13. Show percentage contribution of each product to total sales
SELECT ProductName,
       SalesAmount,
       ROUND(
             SalesAmount * 100 /
             SUM(SalesAmount) OVER(),
             2
       ) AS PercentageContribution
FROM ProductOrders;
-- 14. Find products whose sales exceed category average
SELECT *
FROM
(
    SELECT ProductName,
           Category,
           SalesAmount,
           AVG(SalesAmount)
           OVER(PARTITION BY Category) AS CategoryAvg
    FROM ProductOrders
) t
WHERE SalesAmount > CategoryAvg;
-- 15. Divide products into quartiles using NTILE(4)
SELECT ProductName,
       SalesAmount,
       NTILE(4) OVER(ORDER BY SalesAmount DESC) AS Quartile
FROM ProductOrders;
-- 16. Find second highest selling product
SELECT ProductName,
       TotalSales
FROM
(
    SELECT ProductName,
           SUM(SalesAmount) AS TotalSales,
           DENSE_RANK() OVER(ORDER BY SUM(SalesAmount) DESC) AS rnk
    FROM ProductOrders
    GROUP BY ProductName
) t
WHERE rnk = 2;
-- 17. Compare each product with category leader sales
SELECT ProductName,
       Category,
       SalesAmount,
       FIRST_VALUE(SalesAmount)
       OVER(PARTITION BY Category ORDER BY SalesAmount DESC) AS CategoryLeaderSales
FROM ProductOrders;
-- 18. Calculate month-over-month sales growth
SELECT SalesMonth,
       TotalSales,
       TotalSales -
       LAG(TotalSales) OVER(ORDER BY SalesMonth) AS Growth
FROM
(
    SELECT DATE_FORMAT(OrderDate,'%Y-%m') AS SalesMonth,
           SUM(SalesAmount) AS TotalSales
    FROM ProductOrders
    GROUP BY DATE_FORMAT(OrderDate,'%Y-%m')
) t;
-- 19. Identify products with consecutive sales increases using LAG()


SELECT *
FROM
(
    SELECT ProductName,
           OrderDate,
           SalesAmount,
           LAG(SalesAmount)
           OVER(PARTITION BY ProductName ORDER BY OrderDate) AS PreviousSales
    FROM ProductOrders
) t
WHERE SalesAmount > PreviousSales;
-- 20. Create a sales leaderboard using DENSE_RANK()
SELECT ProductName,
       SUM(SalesAmount) AS TotalSales,
       DENSE_RANK()
       OVER(ORDER BY SUM(SalesAmount) DESC) AS LeaderBoardRank
FROM ProductOrders
GROUP BY ProductName;