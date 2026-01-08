-- Query to find the second highest salary using ROW_NUMBER()
SELECT * 
FROM (
    SELECT *, ROW_NUMBER() OVER (ORDER BY salary DESC) AS rnum 
    FROM Employee 
) AS ranked_employees
WHERE rnum = 2;

-- Query to find the second highest salary using MAX and subquery
SELECT MAX(salary) 
FROM Employee 
WHERE salary < (
    SELECT MAX(salary) 
    FROM Employee
);