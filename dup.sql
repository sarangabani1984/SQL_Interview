CREATE TABLE dbo.Employees_Duplicate_Test (
    EmpID INT IDENTITY(1,1) PRIMARY KEY,
    EmpName VARCHAR(50),
    Department VARCHAR(50),
    Email VARCHAR(100),
    Salary INT
);

INSERT INTO dbo.Employees_Duplicate_Test
(EmpName, Department, Email, Salary)
VALUES
('Ravi',  'IT', 'ravi@company.com', 60000),
('Ravi',  'IT', 'ravi@company.com', 60000),   -- exact duplicate
('Ravi',  'IT', 'ravi.it@company.com', 62000),

('John',  'HR', 'john@company.com', 55000),
('John',  'HR', 'john@company.com', 55000),   -- duplicate

('Meena', 'Finance', 'meena@company.com', 70000),

('Asha',  'IT', 'asha@company.com', 65000),
('Asha',  'IT', 'asha.it@company.com', 65000),
('Asha',  'IT', 'asha.it@company.com', 65000), -- duplicate

('Kiran', 'Sales', 'kiran@company.com', 50000);

-- How do you find duplicates in a table?
SELECT
    EmpName,
    Department,
    COUNT(*) AS cnt
FROM dbo.Employees_Duplicate_Test
GROUP BY
    EmpName,
    Department
HAVING COUNT(*) > 1;



-- How to delete duplicates but keep one record?
WITH CTE AS (
    SELECT
        EmpID,
        EmpName,
        Department,
        Salary,
        ROW_NUMBER() OVER (
            PARTITION BY EmpName, Department
            ORDER BY Salary DESC
        ) AS rn
    FROM dbo.Employees_Duplicate_Test
)
DELETE
FROM CTE
WHERE rn > 1;


SELECT * from dbo.Employees_Duplicate_Test;

-- How to find the second highest salary in a table?
