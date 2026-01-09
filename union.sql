INSERT INTO dbo.Employees_HR VALUES
(1, 'Ravi', 'IT'),
(2, 'John', 'HR'),
(3, 'Meena', 'Finance'),
(4, 'Asha', 'IT');

INSERT INTO dbo.Employees_Payroll VALUES
(3, 'Meena', 'Finance'),  -- duplicate
(4, 'Asha', 'IT'),        -- duplicate
(5, 'Kiran', 'Sales'),
(6, 'Neha', 'HR');


SELECT * from dbo.Employees_HR 
UNION ALL
SELECT * from dbo.Employees_Payroll;


SELECT EmpName, Department from dbo.Employees_HR 
UNION 
SELECT EmpName, Department from dbo.Employees_Payroll;