SELECT 
    c.CustomerID,
    c.CustomerName,
    c.City,
    c.Country
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

SELECT 
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.CustomerID AS OrderCustomerID,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
FULL OUTER JOIN Orders o ON c.CustomerID = o.CustomerID;




