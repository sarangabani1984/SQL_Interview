-- Create the Employee table
CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    salary DECIMAL(10, 2)
);

-- Insert sample data
INSERT INTO Employee (id, name, salary) VALUES
(1, 'Alice', 70000.00),
(2, 'Bob', 60000.00),
(3, 'Charlie', 80000.00), -- Highest
(4, 'David', 75000.00), -- Second Highest
(5, 'Eve', 60000.00),
(6, 'Frank', 72000.00),
(7, 'Grace', 55000.00);

-- Query to verify data
SELECT * FROM Employee;
