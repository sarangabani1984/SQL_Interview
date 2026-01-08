

-- Query to find the second highest salary using TOP and ORDER BY
SELECT TOP 1 salary
FROM (
    SELECT TOP 2 salary
    FROM Employee
    ORDER BY salary DESC
) AS temp
ORDER BY salary ASC;

