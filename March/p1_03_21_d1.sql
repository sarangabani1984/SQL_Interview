use sarang;

-- Check table structure (SQL Server syntax)
EXEC sp_help 'Employees';

-- Find duplicates by FirstName
SELECT FirstName, COUNT(*) AS DuplicateCount FROM Employees GROUP BY FirstName HAVING COUNT(*) > 1;