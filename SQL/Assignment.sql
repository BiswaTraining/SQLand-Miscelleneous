USE AdventureWorks2019;
SELECT BusinessEntityID,CONCAT(FirstName,+' '+MiddleName,+' '+LastName) as FullName,ModifiedDate FROM Person.Person
where ModifiedDate>'29-Dec-2000';

SELECT BusinessEntityID,CONCAT(FirstName,+' '+MiddleName,+' '+LastName) as FullName,ModifiedDate FROM Person.Person
where ModifiedDate<'01-Dec-2000' AND ModifiedDate>'31-Dec-2000';

select ProductID,Name from Production.Product
WHERE Name LIKE 'Chain%';

SELECT BusinessEntityID,FirstName,MiddleName,LastName FROM Person.Person
where MiddleName LIKE '%E%' OR MiddleName LIKE '%B%';

SELECT SalesOrderID,OrderDate,TotalDue FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '01-Sep-2001' AND '30-Sep-2001' AND TotalDue>1000;

SELECT * FROM Sales.SalesOrderHeader
 WHERE TotalDue>1000 AND (SalesPersonID=279 OR TerritoryID=6);

select ProductID,Name,Color from Production.Product
where Color<>'Blue';

SELECT BusinessEntityID,FirstName,MiddleName,LastName FROM Person.Person
ORDER BY LastName,FirstName,MiddleName;

SELECT CONCAT(AddressLine1,+'('+City+' '+PostalCode+')') as Address FROM Person.Address;

select ProductID,
ISNULL(Color,'No Color') AS [Color],
Name from Production.Product;

select CONCAT('"'+Name,+':'+
ISNULL(Color,'No Color')+'"') AS [Color] from Production.Product;

SELECT SpecialOfferID,ISNULL(MaxQty-MinQty,0) as DifferenceInQty,Description FROM Sales.SpecialOffer;

SELECT SpecialOfferID,Description,ISNULL(MaxQty,10)*DiscountPct AS DISCOUNT FROM Sales.SpecialOffer;

SELECT SUBSTRING(AddressLine1,1,10) FROM Person.Address;