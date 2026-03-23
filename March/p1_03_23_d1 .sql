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

-- View the created data
SELECT * FROM Products ORDER BY Category, Price;