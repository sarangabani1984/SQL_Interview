

-- Query to find the second highest salary using TOP and ORDER BY
SELECT TOP 1 salary
FROM (
    SELECT TOP 2 salary
    FROM Employee
    ORDER BY salary DESC
) AS temp
ORDER BY salary ASC;

select 
category, 
MAX(price) OVER(PARTITION BY category) ,
MIN(price) OVER(PARTITION BY category) ,
AVG(price) OVER(PARTITION BY category) ,
SUM(price) OVER(PARTITION BY category)
from products;