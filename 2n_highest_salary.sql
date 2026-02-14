-- =====================================================
-- FIND THE SECOND HIGHEST SALARY - INTERVIEW QUESTION
-- =====================================================

-- Step 1: Create the Employee table
-- USE sql_masterclass;

DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    salary DECIMAL(10, 2)
);

-- Step 2: Insert sample data
INSERT INTO Employee (id, name, salary) VALUES
(1, 'Alice', 70000.00),
(2, 'Bob', 60000.00),
(3, 'Charlie', 80000.00),  -- Highest
(4, 'David', 75000.00),    -- Second Highest
(5, 'Eve', 60000.00),
(6, 'Frank', 72000.00),
(7, 'Grace', 55000.00);

-- ============================================
-- METHOD 1: Using ROW_NUMBER() OVER (Best Practice)
-- ============================================
SELECT * FROM (
    SELECT 
        id,
        name,
        salary,
        ROW_NUMBER() OVER (ORDER BY salary DESC) AS salary_rank
    FROM Employee
) AS ranked_employees
WHERE salary_rank = 2;

-- ============================================
-- METHOD 2: Using MAX with Subquery
-- ============================================
SELECT MAX(salary) AS second_highest_salary
FROM Employee 
WHERE salary < (SELECT MAX(salary) FROM Employee);

-- ============================================
-- METHOD 3: Using TOP with ORDER BY
-- ============================================
SELECT TOP 1 salary
FROM (
    SELECT TOP 2 salary
    FROM Employee
    ORDER BY salary DESC
) AS temp
ORDER BY salary ASC;

-- ============================================
-- METHOD 4: Using OFFSET and FETCH (SQL Server 2012+)
-- ============================================
SELECT DISTINCT salary
FROM Employee
ORDER BY salary DESC
OFFSET 1 ROW
FETCH NEXT 1 ROW ONLY;

-- ============================================
-- Display all employee data
-- ============================================
SELECT * FROM Employee
ORDER BY salary DESC;