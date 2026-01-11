-- Month Over Month Sales Performance Analysis
-- Dataset: Monthly Sales Table

-- Create the Sales table
CREATE TABLE MonthlySales (
    sale_id INT PRIMARY KEY,
    sale_date DATE,
    total_sales DECIMAL(12, 2)
);

-- Insert sample data
INSERT INTO MonthlySales (sale_id, sale_date, total_sales) VALUES
(1, '2025-01-15', 50000.00),
(2, '2025-02-15', 55000.00),
(3, '2025-03-15', 48000.00),
(4, '2025-04-15', 62000.00),
(5, '2025-05-15', 58000.00),
(6, '2025-06-15', 70000.00),
(7, '2025-07-15', 75000.00),
(8, '2025-08-15', 68000.00),
(9, '2025-09-15', 72000.00),
(10, '2025-10-15', 80000.00),
(11, '2025-11-15', 85000.00),
(12, '2025-12-15', 95000.00);

-- Extract month and year using functions:
-- MONTH(sale_date) - returns month number
-- YEAR(sale_date) - returns year

-- Query: Month Over Month Percentage Change in Sales
-- Using LAG() to get previous month's sales and calculate percentage change

SELECT 
    sale_year,
    sale_month,
    total_sales AS current_month_sales,
    LAG(total_sales) OVER (ORDER BY sale_year, sale_month) AS previous_month_sales,
    total_sales - LAG(total_sales) OVER (ORDER BY sale_year, sale_month) AS sales_difference,
    ROUND(
        ((total_sales - LAG(total_sales) OVER (ORDER BY sale_year, sale_month)) 
        / LAG(total_sales) OVER (ORDER BY sale_year, sale_month)) * 100, 
        2
    ) AS percentage_change
FROM MonthlySales
ORDER BY sale_year, sale_month;

-- Alternative: Using CTE for cleaner code
WITH SalesWithPrevious AS (
    SELECT 
        sale_year,
        sale_month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY sale_year, sale_month) AS prev_month_sales
    FROM MonthlySales
)
SELECT 
    sale_year,
    sale_month,
    total_sales AS current_month_sales,
    prev_month_sales AS previous_month_sales,
    total_sales - prev_month_sales AS sales_difference,
    ROUND(((total_sales - prev_month_sales) / prev_month_sales) * 100, 2) AS percentage_change
FROM SalesWithPrevious
ORDER BY sale_year, sale_month;


select 
*,
MONTH(sale_date) AS sale_month,
YEAR(sale_date) AS sale_year ,
lag(total_sales) over(ORDER BY YEAR(sale_date), MONTH(sale_date)) AS previous_month_sales,
total_sales - lag(total_sales) over(ORDER BY YEAR(sale_date), MONTH(sale_date)) AS sales_difference
from MonthlySales;