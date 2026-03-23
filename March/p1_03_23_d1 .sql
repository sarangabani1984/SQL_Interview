-- Question 4: Aggregate Filtering Logic (SQL - Medium)
-- Dataset: Products Table

-- Create the Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    Category VARCHAR(50) NOT NULL,
    Price FLOAT NOT NULL
);

-- Insert sample data
INSERT INTO Products (Category, Price) VALUES
('Electronics', 499.99),
('Electronics', 299.99),
('Electronics', 1299.99),
('Furniture', 199.99),
('Furniture', 399.99),
('Furniture', 549.99),
('Clothing', 29.99),
('Clothing', 49.99),
('Clothing', 79.99),
('Clothing', 99.99),
('Home & Garden', 89.99),
('Home & Garden', 149.99),
('Home & Garden', 199.99),
('Electronics', 199.99),
('Furniture', 699.99),
('Books', 12.99),
('Books', 18.99),
('Books', 24.99),
('Sports', 59.99),
('Sports', 89.99);

-- Query 1: Simple GROUP BY with HAVING
SELECT 
    Category, 
    AVG(Price) AS AveragePrice 
FROM Products 
GROUP BY Category 
HAVING AVG(Price) < 500;

-- Query 2: CTE approach (same result, cleaner logic)
WITH CTE AS (
    SELECT Category, AVG(Price) AS AveragePrice 
    FROM Products
    GROUP BY Category
)
SELECT * FROM CTE WHERE AveragePrice < 500;

-- =====================================================
-- Question 5: Departmental Ranking (SQL - Hard)
-- =====================================================

-- Create the Department_Salaries table
CREATE TABLE Department_Salaries (
    EmployeeID INT PRIMARY KEY IDENTITY(1001,1),
    DeptID INT NOT NULL,
    Salary INT NOT NULL
);

-- Insert sample data with multiple employees per department
INSERT INTO Department_Salaries (DeptID, Salary) VALUES
(1, 45000),
(1, 52000),
(1, 58000),
(1, 65000),
(2, 55000),
(2, 62000),
(2, 48000),
(2, 71000),
(2, 59000),
(3, 38000),
(3, 42000),
(3, 39000),
(4, 75000),
(4, 82000),
(4, 78000),
(4, 88000),
(4, 85000),
(5, 51000),
(5, 54000),
(5, 49000),
(1, 61000),
(2, 67000),
(3, 44000),
(4, 92000),
(5, 56000);

-- View all data
SELECT * FROM Department_Salaries ORDER BY DeptID, Salary DESC;

-- Example Query 1: Rank employees within each department by salary (DENSE_RANK)
WITH cte AS (
    SELECT 
        EmployeeID, 
        DeptID,
        DENSE_RANK() OVER(PARTITION BY DeptID ORDER BY Salary DESC) AS rnk
    FROM Department_Salaries
)
SELECT * FROM cte WHERE rnk = 2;

-- Example Query 2: Find top 2 paid employees per department
WITH RankedEmployees AS (
    SELECT 
        EmployeeID,
        DeptID,
        Salary,
        RANK() OVER (PARTITION BY DeptID ORDER BY Salary DESC) AS SalaryRank
    FROM Department_Salaries
)
SELECT * FROM RankedEmployees WHERE SalaryRank <= 2 ORDER BY DeptID, SalaryRank;

-- Example Query 3: Compare salary to department average
SELECT 
    EmployeeID,
    DeptID,
    Salary,
    AVG(Salary) OVER (PARTITION BY DeptID) AS DeptAvgSalary,
    Salary - AVG(Salary) OVER (PARTITION BY DeptID) AS DifFromAvg
FROM Department_Salaries
ORDER BY DeptID, Salary DESC;





