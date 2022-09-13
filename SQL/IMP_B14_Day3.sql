
----OVER CLAUSE -- applied on window functions (aggre, ranking)

-- list all the products with total cost for all products
SELECT ProductID, Name, Color, StandardCost, ProductSubCategoryID, 
SUM(StandardCost) OVER() AS [Total Cost] 
FROM Production.Product


-- list all the products with colorwise total cost 

SELECT ProductID, Name, Color, StandardCost, ProductSubCategoryID, 
SUM(StandardCost) OVER(PARTITION BY Color) AS [Total Cost] 
FROM Production.Product

-----------------

SELECT ProductID, Name, Color, StandardCost, ProductSubCategoryID FROM Production.Product

--Get the costliest product
SELECT Max(StandardCost) FROM Production.Product

SELECT ProductID, Name, Color, StandardCost, ProductSubCategoryID FROM Production.Product
ORDER BY StandardCost DESC
-----GET COSTLIEST PRODUCT
--Solution 1:: Subquery
SELECT ProductID, Name, Color, StandardCost, ProductSubCategoryID FROM Production.Product
WHERE StandardCost = 
(
	SELECT Max(StandardCost) FROM Production.Product
)

--Solution 2:: FETCH NEXT (not an appropriate solution)
SELECT ProductID, Name, Color, StandardCost, ProductSubCategoryID FROM Production.Product ORDER BY StandardCost DESC
OFFSET 0 ROWS
FETCH NEXT 5 rows only

-----GET 3rd COSTLIEST PRODUCT
/*
TOP N Analysis
Ranking functions
ROW_NUMBER	
RANK
DENSE_RANK
NTILE

** Sorting the data is mandatory while working with ranking functions
*/

SELECT ProductID, Name, Color, StandardCost, ProductSubCategoryID,
ROW_NUMBER()OVER(ORDER BY StandardCost DESC) AS [Row Number],
RANK()OVER(ORDER BY StandardCost DESC) AS [Rank],
DENSE_RANK()OVER(ORDER BY StandardCost DESC) AS [Dense Rank]
FROM Production.Product 

SELECT ProductID, Name, Color, StandardCost, ProductSubCategoryID,
DENSE_RANK()OVER(ORDER BY StandardCost DESC) AS [Dense Rank]
FROM Production.Product 

SELECT ProductID, Name, Color, StandardCost, ProductSubCategoryID,
DENSE_RANK()OVER(Partition BY ProductSubCategoryID ORDER BY StandardCost DESC) AS [Dense Rank]
FROM Production.Product 


--Get the costliest product or nth costliest product
---derived table
SELECT * FROM 
(
	SELECT ProductID, Name, Color, StandardCost, ProductSubCategoryID,
	DENSE_RANK()OVER(ORDER BY StandardCost DESC) AS [Dense Rank]
	FROM Production.Product
) AS Products
WHERE [Dense Rank] = 2

--OR Using CTE (Common Table Expression)
WITH Products_CTE AS
(
	SELECT ProductID, Name, Color, StandardCost, ProductSubCategoryID,
	DENSE_RANK()OVER(ORDER BY StandardCost DESC) AS [Dense Rank]
	FROM Production.Product
)
SELECT * FROM Products_CTE WHERE [Dense Rank] = 2

-------
SELECT BusinessEntityID, JobTitle,BirthDate,MaritalStatus,Gender,HireDate, SickLeaveHours
FROM HumanResources.Employee

--get the employees who have taken least number of leaves
SELECT * FROM 
(
	SELECT BusinessEntityID, JobTitle,BirthDate,MaritalStatus,Gender,HireDate, SickLeaveHours,
	DENSE_RANK()OVER(ORDER BY SickLeaveHours ASC) AS [Dense Rank]
	FROM HumanResources.Employee
)AS Employees
WHERE [Dense Rank]=1

--get the titlewise employees who have taken least number of leaves
SELECT * FROM 
(
	SELECT BusinessEntityID, JobTitle,BirthDate,MaritalStatus,Gender,HireDate, SickLeaveHours,
	DENSE_RANK()OVER(PARTITION BY JobTitle ORDER BY SickLeaveHours ASC) AS [Dense Rank]
	FROM HumanResources.Employee
)AS Employees
WHERE [Dense Rank]=1

--get the male and female employees who have taken least number of leaves
SELECT * FROM 
(
	SELECT BusinessEntityID, JobTitle,BirthDate,MaritalStatus,Gender,HireDate, SickLeaveHours,
	DENSE_RANK()OVER(PARTITION BY Gender ORDER BY SickLeaveHours ASC) AS [Dense Rank]
	FROM HumanResources.Employee
)AS Employees
WHERE [Dense Rank]=1

--get the male and female employees who have taken least number of leaves
SELECT * FROM 
(
	SELECT BusinessEntityID, JobTitle,BirthDate,MaritalStatus,Gender,HireDate, SickLeaveHours,
	DENSE_RANK()OVER(PARTITION BY Gender ORDER BY SickLeaveHours ASC) AS [Dense Rank]
	FROM HumanResources.Employee
)AS Employees
WHERE [Dense Rank]=1 AND MaritalStatus = 'S'
----------------------------------------------------------------
--NTILE
SELECT ProductID, Name, Color, StandardCost, ProductSubCategoryID,
NTILE(4)OVER(ORDER BY StandardCost DESC) AS [GR NO]
FROM Production.Product

SELECT ProductID, Name, Color, StandardCost, ProductSubCategoryID,
NTILE(4)OVER(PARTITION BY ProductSubCategoryID ORDER BY StandardCost DESC) AS [GR NO]
FROM Production.Product

------------------------------------------------------------------------------------------
----JOINS------
/*
Queries used to read data from multiple tables
Type::
INNER JOIN (Default)
OUTER JOIN
	LEFT
	RIGHT
	FULL
SELF JOIN
CROSS JOIN
*/
SELECT ProductID, Name, Color, StandardCost, ProductSubCategoryID
FROM Production.Product --WHERE ProductSubcategoryID IS NOT NULL

SELECT ProductSubCategoryID, Name
FROM Production.ProductSubcategory 

--- Get the details of products with the name of respective subcategory only if the product belongs to any subcategory (inner join)
SELECT PRD.ProductID,PRD.Name,PRD.Color,PRD.StandardCost,PSC.Name, PRD.ProductSubcategoryID FROM 
Production.Product PRD INNER JOIN Production.ProductSubcategory PSC
ON PRD.ProductSubcategoryID = PSC.ProductSubcategoryID


--- Get the details of products with the name of respective subcategory irrespective of the product belongs to any subcategory or not (outer join)
SELECT PRD.ProductID,PRD.Name,PRD.Color,PRD.StandardCost,PSC.Name, PRD.ProductSubcategoryID FROM 
Production.Product PRD LEFT OUTER JOIN Production.ProductSubcategory PSC
ON PRD.ProductSubcategoryID = PSC.ProductSubcategoryID

---------------------------
USE ImpactBatch14DB

SELECT * FROM PatientAdministration.Patient
SELECT * FROM PatientAdministration.PatientRelatives

--INSERT INTO PatientAdministration.PatientRelatives (RelativeName,Relation,PatientID) VALUES ('Rajendra','Father',1008)

SELECT P.PatientID,P.PatientName,PR.RelativeID, PR.RelativeName FROM PatientAdministration.Patient P
CROSS JOIN PatientAdministration.PatientRelatives PR
--------
USE AdventureWorks2019

---------------------------------------------
---get all the products with the names of their subcategory and category

SELECT PRD.ProductID, PRD.Name AS [Product Name], PSC.Name AS [Sub Category], PCT.Name AS [Category] , PRD.Color, PRD.StandardCost
FROM
Production.Product PRD LEFT OUTER JOIN Production.ProductSubcategory PSC
ON PRD.ProductSubcategoryID = PSC.ProductSubcategoryID
LEFT OUTER JOIN Production.ProductCategory PCT
ON PSC.ProductCategoryID = PCT.ProductCategoryID

----- get all the orders and the products that are the part of those orders
SELECT  SOH.SalesOrderID, SOH.OrderDate, SOH.CustomerID, PRD.Name AS [Product Name]
FROM Sales.SalesOrderHeader SOH INNER JOIN Sales.SalesOrderDetail SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Production.Product PRD
ON SOD.ProductID = PRD.ProductID
ORDER BY SOH.SalesOrderID

----- get all the orders and the products with the names of subcategory and category that are the part of those orders
SELECT  SOH.SalesOrderID, SOH.OrderDate, SOH.CustomerID, PRD.Name AS [Product Name], PSC.Name AS [Sub Category], PCT.Name AS [Category]
FROM Sales.SalesOrderHeader SOH INNER JOIN Sales.SalesOrderDetail SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Production.Product PRD
ON SOD.ProductID = PRD.ProductID
LEFT OUTER JOIN Production.ProductSubcategory PSC
ON PSC.ProductSubcategoryID = PRD.ProductSubcategoryID
LEFT OUTER JOIN Production.ProductCategory PCT
ON PCT.ProductCategoryID = PSC.ProductCategoryID
ORDER BY SOH.SalesOrderID


/* get all the orders including below details
	. products with the names of subcategory and category that are the part of those orders
	. name of customer who has placed the order
*/
SELECT  SOH.SalesOrderID, SOH.OrderDate, SOH.CustomerID, CONCAT(PER.FirstName, ' ',PER.LastName) AS [Customer Name], 
PRD.Name AS [Product Name], PSC.Name AS [Sub Category], PCT.Name AS [Category]
FROM Sales.SalesOrderHeader SOH INNER JOIN Sales.SalesOrderDetail SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Production.Product PRD
ON SOD.ProductID = PRD.ProductID
LEFT OUTER JOIN Production.ProductSubcategory PSC
ON PSC.ProductSubcategoryID = PRD.ProductSubcategoryID
LEFT OUTER JOIN Production.ProductCategory PCT
ON PCT.ProductCategoryID = PSC.ProductCategoryID
INNER JOIN Sales.Customer CST
ON SOH.CustomerID = CST.CustomerID
INNER JOIN Person.Person PER
ON CST.PersonID = PER.BusinessEntityID
ORDER BY SOH.SalesOrderID


/* get all the orders including below details
	. products with the names of subcategory and category that are the part of those orders
	. name of customer who has placed the order
	. name of territory and country from where orders are been placed
*/
SELECT  SOH.SalesOrderID, SOH.OrderDate, SOH.CustomerID, 
CONCAT(PER.FirstName, ' ',PER.LastName) AS [Customer Name], 
TRT.Name AS [Territory], CNT.Name  AS [Country],
PRD.Name AS [Product Name], PSC.Name AS [Sub Category], PCT.Name AS [Category]
FROM Sales.SalesOrderHeader SOH INNER JOIN Sales.SalesOrderDetail SOD 
ON SOH.SalesOrderID = SOD.SalesOrderID 
INNER JOIN Production.Product PRD
ON SOD.ProductID = PRD.ProductID
LEFT OUTER JOIN Production.ProductSubcategory PSC
ON PSC.ProductSubcategoryID = PRD.ProductSubcategoryID
LEFT OUTER JOIN Production.ProductCategory PCT
ON PCT.ProductCategoryID = PSC.ProductCategoryID
INNER JOIN Sales.Customer CST
ON SOH.CustomerID = CST.CustomerID
INNER JOIN Person.Person PER
ON CST.PersonID = PER.BusinessEntityID
INNER JOIN Sales.SalesTerritory TRT
ON TRT.TerritoryID = CST.TerritoryID
INNER JOIN Person.CountryRegion CNT
ON TRT.CountryRegionCode = CNT.CountryRegionCode
ORDER BY SOH.SalesOrderID


/* get all the orders including below details
	. products with the names of subcategory and category that are the part of those orders
	. name of customer who has placed the order
	. name of salesperson involved in processing the order 
*/
SELECT  SOH.SalesOrderID, SOH.OrderDate, SOH.CustomerID, CONCAT(PER.FirstName, ' ',PER.LastName) AS [Customer Name], 
CONCAT(PER_E.FirstName, ' ',PER_E.LastName) AS [Emp Name],
PRD.Name AS [Product Name], PSC.Name AS [Sub Category], PCT.Name AS [Category]
FROM Sales.SalesOrderHeader SOH INNER JOIN Sales.SalesOrderDetail SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Production.Product PRD
ON SOD.ProductID = PRD.ProductID
LEFT OUTER JOIN Production.ProductSubcategory PSC
ON PSC.ProductSubcategoryID = PRD.ProductSubcategoryID
LEFT OUTER JOIN Production.ProductCategory PCT
ON PCT.ProductCategoryID = PSC.ProductCategoryID
INNER JOIN Sales.Customer CST
ON SOH.CustomerID = CST.CustomerID
INNER JOIN Person.Person PER
ON CST.PersonID = PER.BusinessEntityID
INNER JOIN HumanResources.Employee EMP
ON EMP.BusinessEntityID = SOH.SalesPersonID
INNER JOIN Person.Person PER_E
ON EMP.BusinessEntityID = PER_E.BusinessEntityID
ORDER BY SOH.SalesOrderID



---Adiitional Condition in WHERE CLAUSE VS ON Clause

SELECT PRD.ProductID,PRD.Name,PRD.Color,PRD.StandardCost,PSC.Name AS [Category], PRD.ProductSubcategoryID FROM 
Production.Product PRD LEFT OUTER JOIN Production.ProductSubcategory PSC
ON PRD.ProductSubcategoryID = PSC.ProductSubcategoryID 
AND PRD.Name LIKE 'Mountain%'
ORDER BY PRD.Name

SELECT PRD.ProductID,PRD.Name,PRD.Color,PRD.StandardCost,PSC.Name AS [Category], PRD.ProductSubcategoryID FROM 
Production.Product PRD LEFT OUTER JOIN Production.ProductSubcategory PSC
ON PRD.ProductSubcategoryID = PSC.ProductSubcategoryID 
WHERE PRD.Name LIKE 'Mountain%'
ORDER BY PRD.Name


Use ImpactBatch14DB

CREATE SCHEMA ABC;
CREATE SCHEMA PQR;

--Subqueries
--objs: views, sequences
--- anonymous blocks : variables
----- SP, UDF, TRIGS, 
------- Normalization