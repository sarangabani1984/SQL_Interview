-- =====================================================
-- SQL JOIN TYPES PRACTICE DATASET
-- =====================================================

-- Drop tables if they exist
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS OrderDetails;

-- =====================================================
-- CREATE TABLES
-- =====================================================

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50),
    Country VARCHAR(50)
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2)
);

-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT
);

-- =====================================================
-- INSERT SAMPLE DATA
-- =====================================================

-- Insert Customers (Note: Some customers have no orders)
INSERT INTO Customers (CustomerID, CustomerName, City, Country) VALUES
(1, 'John Smith', 'New York', 'USA'),
(2, 'Maria Garcia', 'Madrid', 'Spain'),
(3, 'David Chen', 'Beijing', 'China'),
(4, 'Emma Wilson', 'London', 'UK'),
(5, 'Raj Patel', 'Mumbai', 'India'),
(6, 'Sophie Martin', 'Paris', 'France'),      -- No orders
(7, 'Ahmed Hassan', 'Cairo', 'Egypt'),        -- No orders
(8, 'Yuki Tanaka', 'Tokyo', 'Japan');         -- No orders

-- Insert Orders (Note: Some orders have CustomerID that doesn't exist in Customers)
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
(101, 1, '2024-01-15', 250.00),
(102, 2, '2024-01-18', 175.50),
(103, 1, '2024-02-01', 320.00),
(104, 3, '2024-02-10', 450.75),
(105, 4, '2024-02-15', 125.00),
(106, 5, '2024-03-01', 550.25),
(107, 99, '2024-03-05', 200.00),   -- CustomerID 99 doesn't exist
(108, 100, '2024-03-10', 300.00);  -- CustomerID 100 doesn't exist

-- Insert Products (Some products not in any order)
INSERT INTO Products (ProductID, ProductName, Category, Price) VALUES
(1, 'Laptop', 'Electronics', 999.99),
(2, 'Mouse', 'Electronics', 29.99),
(3, 'Keyboard', 'Electronics', 79.99),
(4, 'Monitor', 'Electronics', 299.99),
(5, 'Desk Chair', 'Furniture', 199.99),
(6, 'Standing Desk', 'Furniture', 499.99),  -- Not in any order
(7, 'Webcam', 'Electronics', 89.99);        -- Not in any order

-- Insert OrderDetails
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity) VALUES
(1, 101, 1, 1),
(2, 101, 2, 2),
(3, 102, 3, 1),
(4, 103, 4, 1),
(5, 104, 5, 2),
(6, 105, 2, 3),
(7, 106, 1, 1),
(8, 106, 3, 1);

-- =====================================================
-- 1. INNER JOIN
-- Returns only matching rows from both tables
-- =====================================================

SELECT 
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;

-- Result: Only customers who have placed orders (excludes Sophie, Ahmed, Yuki)
--         Also excludes orders with CustomerID 99 and 100


-- =====================================================
-- 2. LEFT JOIN (LEFT OUTER JOIN)
-- Returns all rows from left table + matching rows from right table
-- =====================================================

SELECT 
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- Result: ALL customers, including those without orders (Sophie, Ahmed, Yuki with NULL order details)


-- =====================================================
-- 3. RIGHT JOIN (RIGHT OUTER JOIN)
-- Returns all rows from right table + matching rows from left table
-- =====================================================

SELECT 
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.CustomerID AS OrderCustomerID,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- Result: ALL orders, including those with non-existent CustomerIDs (99, 100 with NULL customer details)


-- =====================================================
-- 4. FULL OUTER JOIN (FULL JOIN)
-- Returns all rows from both tables
-- =====================================================

SELECT 
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.CustomerID AS OrderCustomerID,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
FULL OUTER JOIN Orders o ON c.CustomerID = o.CustomerID;

-- Result: ALL customers AND ALL orders
--         Includes customers without orders (NULL on order side)
--         Includes orders without valid customers (NULL on customer side)


-- =====================================================
-- 5. LEFT ANTI JOIN
-- Returns rows from left table that have NO match in right table
-- =====================================================

-- Method 1: Using NOT EXISTS
SELECT 
    c.CustomerID,
    c.CustomerName,
    c.City,
    c.Country
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID
);

-- Method 2: Using LEFT JOIN with NULL check
SELECT 
    c.CustomerID,
    c.CustomerName,
    c.City,
    c.Country
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- Method 3: Using NOT IN
SELECT 
    c.CustomerID,
    c.CustomerName,
    c.City,
    c.Country
FROM Customers c
WHERE c.CustomerID NOT IN (
    SELECT DISTINCT CustomerID FROM Orders WHERE CustomerID IS NOT NULL
);

-- Result: Customers who have NOT placed any orders (Sophie, Ahmed, Yuki)


-- =====================================================
-- 6. RIGHT ANTI JOIN
-- Returns rows from right table that have NO match in left table
-- =====================================================

-- Method 1: Using NOT EXISTS
SELECT 
    o.OrderID,
    o.CustomerID,
    o.OrderDate,
    o.TotalAmount
FROM Orders o
WHERE NOT EXISTS (
    SELECT 1 FROM Customers c WHERE c.CustomerID = o.CustomerID
);

-- Method 2: Using RIGHT JOIN with NULL check
SELECT 
    o.OrderID,
    o.CustomerID,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL;

-- Result: Orders with invalid/non-existent CustomerIDs (OrderID 107 and 108)


-- =====================================================
-- 7. FULL ANTI JOIN (Exclusive Full Join)
-- Returns rows from both tables that have NO match in the other table
-- =====================================================

-- Method 1: Using FULL OUTER JOIN with NULL checks on both sides
SELECT 
    c.CustomerID AS Customer_CustomerID,
    c.CustomerName,
    o.OrderID,
    o.CustomerID AS Order_CustomerID,
    o.TotalAmount
FROM Customers c
FULL OUTER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL OR o.OrderID IS NULL;

-- Method 2: Using UNION of LEFT ANTI and RIGHT ANTI
SELECT 
    c.CustomerID,
    c.CustomerName,
    NULL AS OrderID,
    NULL AS OrderDate,
    'Customer without Order' AS Type
FROM Customers c
WHERE NOT EXISTS (SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID)

UNION ALL

SELECT 
    NULL AS CustomerID,
    NULL AS CustomerName,
    o.OrderID,
    o.OrderDate,
    'Order without Customer' AS Type
FROM Orders o
WHERE NOT EXISTS (SELECT 1 FROM Customers c WHERE c.CustomerID = o.CustomerID);

-- Result: Customers without orders + Orders without valid customers


-- =====================================================
-- 8. CROSS JOIN (Cartesian Product)
-- Returns every combination of rows from both tables
-- =====================================================

SELECT 
    c.CustomerID,
    c.CustomerName,
    p.ProductID,
    p.ProductName
FROM Customers c
CROSS JOIN Products p
WHERE c.CustomerID <= 3 AND p.ProductID <= 3;  -- Limited for readability

-- Result: Every customer paired with every product


-- =====================================================
-- 9. SELF JOIN
-- Joining a table with itself
-- =====================================================

-- Find customers from the same country
SELECT 
    c1.CustomerName AS Customer1,
    c2.CustomerName AS Customer2,
    c1.Country
FROM Customers c1
INNER JOIN Customers c2 
    ON c1.Country = c2.Country 
    AND c1.CustomerID < c2.CustomerID;

-- Result: Pairs of customers from the same country


-- =====================================================
-- 10. MULTIPLE TABLE JOIN
-- Joining more than 2 tables
-- =====================================================

SELECT 
    c.CustomerName,
    o.OrderID,
    o.OrderDate,
    p.ProductName,
    od.Quantity,
    p.Price,
    (od.Quantity * p.Price) AS LineTotal
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
ORDER BY c.CustomerName, o.OrderID;


-- =====================================================
-- BONUS: Products LEFT ANTI JOIN (Products never ordered)
-- =====================================================

SELECT 
    p.ProductID,
    p.ProductName,
    p.Category,
    p.Price
FROM Products p
LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
WHERE od.OrderDetailID IS NULL;

-- Result: Products that have never been ordered (Standing Desk, Webcam)


-- =====================================================
-- SUMMARY OF JOIN TYPES
-- =====================================================
/*
+------------------+----------------------------------------------------+
| JOIN TYPE        | DESCRIPTION                                        |
+------------------+----------------------------------------------------+
| INNER JOIN       | Only matching rows from both tables                |
| LEFT JOIN        | All from LEFT + matching from RIGHT                |
| RIGHT JOIN       | All from RIGHT + matching from LEFT                |
| FULL OUTER JOIN  | All rows from BOTH tables                          |
| LEFT ANTI JOIN   | LEFT rows with NO match in RIGHT                   |
| RIGHT ANTI JOIN  | RIGHT rows with NO match in LEFT                   |
| FULL ANTI JOIN   | Rows from BOTH with NO match in the other          |
| CROSS JOIN       | Cartesian product (all combinations)               |
| SELF JOIN        | Table joined with itself                           |
+------------------+----------------------------------------------------+
*/
