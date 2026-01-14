-- Query 1: Find customers that have a matching department
-- (WHERE EXISTS checks if at least one row exists in the subquery)
SELECT * 
FROM Customers c 
WHERE EXISTS (
    SELECT 1 
    FROM Departments_List d 
    WHERE c.CustomerID = d.DeptID
);

-- Query 2: Display all customers
SELECT * FROM Customers;

-- Query 3: Display all departments
SELECT * FROM Departments_List;