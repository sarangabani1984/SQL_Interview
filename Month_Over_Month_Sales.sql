-- Month Over Month Sales Performance Analysis
-- Dataset: Monthly Sales Table with Multiple Sales per Month

-- ============================================
-- Table Information
-- ============================================
-- Table Name: MonthlySales
-- Description: Stores individual sales transactions for month-over-month analysis
--
-- Column Details:
-- +------------------+------------------+----------------------------------------------+
-- | Column Name      | Data Type        | Description                                  |
-- +------------------+------------------+----------------------------------------------+
-- | sale_id          | INT              | Primary Key - Unique identifier for each sale|
-- | sale_date        | DATE             | Date when the sale occurred                  |
-- | product_category | VARCHAR(50)      | Category of product sold (e.g., Electronics) |
-- | total_sales      | DECIMAL(12, 2)   | Sale amount with 2 decimal places            |
-- +------------------+------------------+----------------------------------------------+
--
-- Key Points:
-- - Multiple sales can occur on the same date or within the same month
-- - Requires aggregation (SUM, COUNT) to get monthly totals
-- - Uses LAG() and LEAD() window functions for month-over-month comparisons
drop TABLE if exists MonthlySales;
-- Create the Sales table
CREATE TABLE MonthlySales (
    sale_id INT PRIMARY KEY,            -- Unique identifier for each sale transaction
    sale_date DATE,                      -- Date of the sale
    product_category VARCHAR(50),        -- Product category (Electronics, Clothing, Furniture)
    total_sales DECIMAL(12, 2)           -- Sale amount in dollars (up to 9,999,999,999.99)
);

-- Insert sample data with multiple sales per month
INSERT INTO MonthlySales (sale_id, sale_date, product_category, total_sales) VALUES
-- January 2025 (3 sales)
(1, '2025-01-05', 'Electronics', 15000.00),
(2, '2025-01-15', 'Clothing', 20000.00),
(3, '2025-01-25', 'Electronics', 15000.00),
-- February 2025 (3 sales)
(4, '2025-02-08', 'Clothing', 18000.00),
(5, '2025-02-18', 'Electronics', 22000.00),
(6, '2025-02-28', 'Furniture', 15000.00),
-- March 2025 (2 sales)
(7, '2025-03-10', 'Electronics', 25000.00),
(8, '2025-03-20', 'Clothing', 23000.00),
-- April 2025 (4 sales)
(9, '2025-04-05', 'Furniture', 20000.00),
(10, '2025-04-12', 'Electronics', 18000.00),
(11, '2025-04-20', 'Clothing', 14000.00),
(12, '2025-04-28', 'Electronics', 10000.00),
-- May 2025 (3 sales)
(13, '2025-05-10', 'Clothing', 22000.00),
(14, '2025-05-18', 'Electronics', 20000.00),
(15, '2025-05-25', 'Furniture', 16000.00),
-- June 2025 (3 sales)
(16, '2025-06-05', 'Electronics', 28000.00),
(17, '2025-06-15', 'Clothing', 25000.00),
(18, '2025-06-25', 'Furniture', 17000.00);

-- ============================================
-- Step 1: View raw data
-- ============================================
SELECT * FROM MonthlySales;

-- ============================================
-- Step 2: Aggregate sales by Month using GROUP BY
-- ============================================
SELECT 
    YEAR(sale_date) AS sale_year,
    MONTH(sale_date) AS sale_month,
    COUNT(*) AS number_of_transactions,
    SUM(total_sales) AS monthly_total_sales
FROM MonthlySales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY sale_year, sale_month;

-- ============================================
-- Step 3: Month Over Month Analysis using LAG and LEAD
-- LAG() - Gets value from previous row
-- LEAD() - Gets value from next row
-- ============================================
WITH MonthlySalesAgg AS (
    SELECT 
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        COUNT(*) AS transaction_count,
        SUM(total_sales) AS monthly_total
    FROM MonthlySales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT 
    sale_year,
    sale_month,
    transaction_count,
    monthly_total AS current_month_sales,
    
    -- LAG: Previous month's sales
    LAG(monthly_total) OVER (ORDER BY sale_year, sale_month) AS previous_month_sales,
    
    -- LEAD: Next month's sales
    LEAD(monthly_total) OVER (ORDER BY sale_year, sale_month) AS next_month_sales,
    
    -- Sales difference from previous month
    monthly_total - LAG(monthly_total) OVER (ORDER BY sale_year, sale_month) AS diff_from_previous,
    
    -- Percentage change from previous month
    ROUND(
        ((monthly_total - LAG(monthly_total) OVER (ORDER BY sale_year, sale_month)) 
        / LAG(monthly_total) OVER (ORDER BY sale_year, sale_month)) * 100, 
        2
    ) AS pct_change_from_previous,
    
    -- Sales difference to next month
    LEAD(monthly_total) OVER (ORDER BY sale_year, sale_month) - monthly_total AS diff_to_next
FROM MonthlySalesAgg
ORDER BY sale_year, sale_month;

-- ============================================
-- Step 4: LAG and LEAD with different offsets
-- LAG(column, offset, default_value)
-- LEAD(column, offset, default_value)
-- ============================================
WITH MonthlySalesAgg AS (
    SELECT 
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        SUM(total_sales) AS monthly_total
    FROM MonthlySales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT 
    sale_year,
    sale_month,
    monthly_total AS current_month_sales,
    
    -- LAG with offset 1 (previous month)
    LAG(monthly_total, 1, 0) OVER (ORDER BY sale_year, sale_month) AS prev_1_month,
    
    -- LAG with offset 2 (2 months ago)
    LAG(monthly_total, 2, 0) OVER (ORDER BY sale_year, sale_month) AS prev_2_months,
    
    -- LEAD with offset 1 (next month)
    LEAD(monthly_total, 1, 0) OVER (ORDER BY sale_year, sale_month) AS next_1_month,
    
    -- LEAD with offset 2 (2 months ahead)
    LEAD(monthly_total, 2, 0) OVER (ORDER BY sale_year, sale_month) AS next_2_months
FROM MonthlySalesAgg
ORDER BY sale_year, sale_month;

-- ============================================
-- Step 5: Category-wise Monthly Sales with LAG/LEAD
-- Using PARTITION BY for category-level analysis
-- ============================================
WITH CategoryMonthlySales AS (
    SELECT 
        product_category,
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        SUM(total_sales) AS category_monthly_total
    FROM MonthlySales
    GROUP BY product_category, YEAR(sale_date), MONTH(sale_date)
)
SELECT 
    product_category,
    sale_year,
    sale_month,
    category_monthly_total AS current_sales,
    
    -- LAG within each category
    LAG(category_monthly_total) OVER (
        PARTITION BY product_category 
        ORDER BY sale_year, sale_month
    ) AS prev_month_category_sales,
    
    -- LEAD within each category
    LEAD(category_monthly_total) OVER (
        PARTITION BY product_category 
        ORDER BY sale_year, sale_month
    ) AS next_month_category_sales,
    
    -- Month-over-month change within category
    category_monthly_total - LAG(category_monthly_total) OVER (
        PARTITION BY product_category 
        ORDER BY sale_year, sale_month
    ) AS mom_change
FROM CategoryMonthlySales
ORDER BY product_category, sale_year, sale_month;