SELECT 
MONTH(sale_date) AS sale_month, 
sum(total_sales) AS total_sales,
lag(sum(total_sales)) over (order by MONTH(sale_date)) as prev_month_sales

FROM MonthlySales group by MONTH(sale_date);


select 
MONTH(sale_date) AS sale_month,SUM(total_sales) AS total_sales,
lag(SUM(total_sales)) over (order by MONTH(sale_date)) as prev_month_sales,
lead(SUM(total_sales)) over (order by MONTH(sale_date)) as next_month_sales,
(SUM(total_sales) - lag(SUM(total_sales)) over (order by MONTH(sale_date))) as month_over_month_change

from MonthlySales GROUP BY MONTH(sale_date);