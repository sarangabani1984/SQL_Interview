
select C.*, O.OrderID, O.OrderDate
from customers C
INNER JOIN orders O
ON C.CustomerID = O.CustomerID ;
