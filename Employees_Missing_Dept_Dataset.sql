-- Dataset to find employees whose department is not present in the department table

-- 1. Create Departments Table
CREATE TABLE dbo.Departments_List (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50)
);

-- 2. Create Employees Table
CREATE TABLE dbo.Employees_With_Dept (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    DeptID INT
);

-- 3. Insert Data into Departments
INSERT INTO dbo.Departments_List (DeptID, DeptName)
VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance');

-- 4. Insert Data into Employees
-- Note: Includes DeptIDs 99 and 100 which do not exist in Departments_List
INSERT INTO dbo.Employees_With_Dept (EmpID, EmpName, DeptID)
VALUES
(101, 'Ravi', 1),   -- Exists
(102, 'John', 2),   -- Exists
(103, 'Asha', 1),   -- Exists
(104, 'Kiran', 99), -- Missing Department
(105, 'Meena', 100); -- Missing Department

-- Question: How do you find employees whose department is not present in the department table?


SELECT d.*,l.DeptName,l.DeptID FROM dbo.Employees_With_Dept d
LEFT JOIN dbo.Departments_List l
ON d.DeptID = l.DeptID
WHERE l.DeptID IS NULL;




-- Solution 1: Using LEFT JOIN
SELECT E.EmpName, E.DeptID
FROM dbo.Employees_With_Dept E
LEFT JOIN dbo.Departments_List D ON E.DeptID = D.DeptID
WHERE D.DeptID IS NULL;

-- Solution 2: Using NOT EXISTS
SELECT EmpName, DeptID
FROM dbo.Employees_With_Dept E
WHERE NOT EXISTS (
    SELECT 1 
    FROM dbo.Departments_List D 
    WHERE D.DeptID = E.DeptID
);

-- Solution 3: Using NOT IN
SELECT EmpName, DeptID
FROM dbo.Employees_With_Dept
WHERE DeptID NOT IN (SELECT DeptID FROM dbo.Departments_List);
