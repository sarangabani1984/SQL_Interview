drop TABLE IF EXISTS Employee;
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

INSERT INTO Employee (emp_id, emp_name, department, salary) VALUES
(1, 'Arun',    'IT',      80000),
(2, 'Bala',    'IT',      90000),
(3, 'Charan',  'IT',      90000),
(4, 'Divya',   'HR',      60000),
(5, 'Esha',    'HR',      75000),
(6, 'Farooq',  'HR',      75000),
(7, 'Gopal',   'Finance', 85000),
(8, 'Hari',    'Finance', 95000),
(9, 'Indu',    'Finance', 95000),
(10,'Jaya',    'Admin',   50000);

SELECT *
FROM (
    SELECT *, RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank
    FROM Employee
) AS ranked
WHERE salary_rank = 1;