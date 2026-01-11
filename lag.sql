-- ============================================
-- LAG and LEAD Window Functions Example
-- ============================================

-- Query 1: Basic LAG to get previous month sales
SELECT 
    MONTH(sale_date) AS sale_month, 
    SUM(total_sales) AS total_sales,
    LAG(SUM(total_sales)) OVER (ORDER BY MONTH(sale_date)) AS prev_month_sales
FROM MonthlySales 
GROUP BY MONTH(sale_date);

select *, cast((month_over_month_change/prev_month_sales)* 100 as decimal(10,2)) as mom_percentage_change from (
-- Query 2: Complete Month-Over-Month Analysis with LAG and LEAD
SELECT 
    MONTH(sale_date) AS sale_month,
    SUM(total_sales) AS total_sales,
    LAG(SUM(total_sales)) OVER (ORDER BY MONTH(sale_date)) AS prev_month_sales,
    LEAD(SUM(total_sales)) OVER (ORDER BY MONTH(sale_date)) AS next_month_sales,
    SUM(total_sales) - LAG(SUM(total_sales)) OVER (ORDER BY MONTH(sale_date)) AS month_over_month_change
    
FROM MonthlySales 
GROUP BY MONTH(sale_date)) as t
