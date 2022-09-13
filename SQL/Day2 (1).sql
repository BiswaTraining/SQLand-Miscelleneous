USE ImpactBatch14DB;

CREATE SCHEMA PatientAdministration;

CREATE TABLE PatientAdministration.Patient
(
	PatientID INT PRIMARY KEY IDENTITY(1001,1),
	PatientName VARCHAR(20) NOT NULL,
	BirthDate DATE NOT NULL CHECK (BirthDate<=GETDATE()),
	Gender VARCHAR(1) CHECK (Gender IN('M','F','O','U')),
	LastModified DATE DEFAULT GETDATE()
);

/*
CONSTRAINTS::
1. Primary Key - Unique + Not Null
2. Unique - Every value in a col. is unique (it can have one NULL value)
3. Check
4. NOT NULL
5. DEFAULT
6. FOREIGN KEY
*/
DROP TABLE PatientAdministration.Patient

INSERT INTO PatientAdministration.Patient (PatientName,BirthDate,Gender) VALUES
('Gary','12-Jan-2001','M')

INSERT INTO PatientAdministration.Patient (PatientName,BirthDate,Gender) VALUES
('Smith','30-Oct-2002','M'),
('Fiona','20-Feb-2005','F')

INSERT INTO PatientAdministration.Patient (PatientName,BirthDate,Gender) VALUES
('Raj','30-Oct-2009',NULL)

SELECT * FROM PatientAdministration.Patient

SET IDENTITY_INSERT PatientAdministration.Patient OFF

INSERT INTO PatientAdministration.Patient (PatientID,PatientName,BirthDate,Gender) VALUES
(1005,'Priya','01-Oct-2002','F')

INSERT INTO PatientAdministration.Patient (PatientName,BirthDate,Gender) VALUES
('Jignesh','12-June-2009',NULL)
--------------------------------------------------------------------------------------------------------------------
/*
Foreign Key
*/

CREATE TABLE PatientAdministration.PatientRelatives
(
	RelativeID INT Primary Key IDENTITY (1,1),
	RelativeName VARCHAR(20) NOT NULL,
	Relation VARCHAR(20),
	PatientID INT REFERENCES PatientAdministration.Patient(PatientID) ON DELETE CASCADE NOT NULL
)

INSERT INTO PatientAdministration.PatientRelatives (RelativeName,Relation,PatientID)
VALUES
('Pinky','Spouse',1001),
('Sumit','Father',1005)

INSERT INTO PatientAdministration.PatientRelatives (RelativeName,Relation,PatientID)
VALUES
('Pinky','Spouse',1010)

SELECT * FROM PatientAdministration.PatientRelatives
--------

SELECT * FROM PatientAdministration.Patient

UPDATE PatientAdministration.Patient SET Gender='M'
WHERE PAtientID=1008

DELETE FROM PatientAdministration.Patient 
WHERE PatientID = 1005

-----------------------------------------------------------------
USE AdventureWorks2019

/*
DQL -  SELECT Command
*/
-- get all the product details

SELECT * FROM [Production].[Product]
SELECT * FROM [Production].[ProductSubcategory]

--get id, name,number, color, standardcost for all the products
--- PROJECTION

SELECT ProductID,ProductNumber, Name,Color,StandardCost FROM [Production].[Product]

-- Get all the products costing more than 1000
-- FILTERING (WHERE CLAUSE)

SELECT ProductID,ProductNumber, Name,Color,StandardCost FROM [Production].[Product]
WHERE StandardCost >1000

-- Get all the products which are red, green or blue in color
SELECT ProductID,ProductNumber, Name,Color,StandardCost FROM [Production].[Product]
WHERE Color IN ('Red','Blue','Green')
--ALTERNATE QRY
SELECT ProductID,ProductNumber, Name,Color,StandardCost FROM [Production].[Product]
WHERE Color = 'Red' OR Color = 'Blue' OR Color = 'Green'

-- Get all the products which are red, green or blue in color and costing above 1000
SELECT ProductID,ProductNumber, Name,Color,StandardCost FROM [Production].[Product]
WHERE Color IN ('Red','Blue','Green') AND StandardCost > 1000

-- Get all the products which are red or green or costing more than 1500
SELECT ProductID,ProductNumber, Name,Color,StandardCost FROM [Production].[Product]
WHERE Color IN ('Red','Green') OR StandardCost > 1500 

-- Get all the products which are red, green and blue
SELECT ProductID,ProductNumber, Name,Color,StandardCost, ProductSubcategoryID FROM [Production].[Product]
WHERE Color IN ('Red','Blue','Green')

--------------------------------------------------------------------
-- Get all the black products belonging to sub category 6 and 12 
SELECT ProductID,ProductNumber, Name,Color,StandardCost, ProductSubcategoryID FROM [Production].[Product]
WHERE ProductSubcategoryID IN (6,12) AND Color = 'Black'

--Get all the products not belonging to subcategory no 12
SELECT ProductID,ProductNumber, Name,Color,StandardCost, ProductSubcategoryID FROM [Production].[Product]
WHERE ProductSubcategoryID  NOT IN (12)
--OR
SELECT ProductID,ProductNumber, Name,Color,StandardCost, ProductSubcategoryID FROM [Production].[Product]
WHERE ProductSubcategoryID <> 12

-- Handling NULL Values
-- Get all the products which do not have a color
SELECT ProductID,ProductNumber, Name,Color,StandardCost, ProductSubcategoryID FROM [Production].[Product]
WHERE Color IS NULL

-- Get all the products which have a color
SELECT ProductID,ProductNumber, Name,Color,StandardCost, ProductSubcategoryID FROM [Production].[Product]
WHERE Color IS NOT NULL

-- Get all the products which do not have a color as well as Product Sub Category
SELECT ProductID,ProductNumber, Name,Color,StandardCost, ProductSubcategoryID FROM [Production].[Product]
WHERE Color IS NULL AND ProductSubcategoryID IS NULL

--Get all the products which start with letter Ch
SELECT ProductID,ProductNumber, Name,Color,StandardCost, ProductSubcategoryID FROM [Production].[Product]
WHERE Name Like 'Ch%'

--Get all the products which have word 'ball' in its name
SELECT ProductID,ProductNumber, Name,Color,StandardCost, ProductSubcategoryID FROM [Production].[Product]
WHERE Name Like '%ball%'

--Get all the products which start with letter a to c
SELECT ProductID,ProductNumber, Name,Color,StandardCost, ProductSubcategoryID FROM [Production].[Product]
WHERE Name Like '[a-c]%'

--Get all the black products costing more than or equal to 1000 and less than or equal to 2000
SELECT ProductID,ProductNumber, Name,Color,StandardCost, ProductSubcategoryID FROM [Production].[Product]
WHERE Color = 'Black' AND (StandardCost>=1000 AND StandardCost<=2000)
--OR
SELECT ProductID,ProductNumber, Name,Color,StandardCost, ProductSubcategoryID FROM [Production].[Product]
WHERE Color = 'Black' AND (StandardCost BETWEEN 1000 AND 2000)

--------------------------------
SELECT BusinessEntityID, NationalIDNumber, JobTitle, BirthDate,MaritalStatus,Gender,HireDate,SickLeaveHours 
FROM HumanResources.Employee

-- Get all the single employees
SELECT BusinessEntityID, NationalIDNumber, JobTitle, BirthDate,MaritalStatus,Gender,HireDate,SickLeaveHours 
FROM HumanResources.Employee
WHERE MaritalStatus = 'S'

-- Get all the single female employees
SELECT BusinessEntityID, NationalIDNumber, JobTitle, BirthDate,MaritalStatus,Gender,HireDate,SickLeaveHours 
FROM HumanResources.Employee
WHERE MaritalStatus = 'S' AND Gender = 'F'

-- Get all the single male employees taken sick leaves more than 50 hours
SELECT BusinessEntityID, NationalIDNumber, JobTitle, BirthDate,MaritalStatus,Gender,HireDate,SickLeaveHours 
FROM HumanResources.Employee
WHERE MaritalStatus = 'S' AND Gender = 'M' AND SickLeaveHours>50

-- Get all the employees born on 7th of Jan 1983
SELECT BusinessEntityID, NationalIDNumber, JobTitle, BirthDate,MaritalStatus,Gender,HireDate,SickLeaveHours 
FROM HumanResources.Employee
WHERE BirthDate = '7-Jan-1983'

-- Get all the employees born before 1980
SELECT BusinessEntityID, NationalIDNumber, JobTitle, BirthDate,MaritalStatus,Gender,HireDate,SickLeaveHours 
FROM HumanResources.Employee
WHERE YEAR(BirthDate) < 1980
--OR
SELECT BusinessEntityID, NationalIDNumber, JobTitle, BirthDate,MaritalStatus,Gender,HireDate,SickLeaveHours 
FROM HumanResources.Employee
WHERE YEAR(BirthDate) < '01-Jan-1980'
-----------------------------------------------------------------------------------------------------------------------

-- replace the null value for color with 'undefined'
SELECT ProductID,ProductNumber, Name AS [Product Name],
ISNULL(Color,'Undefined') AS [Color],
StandardCost, ProductSubcategoryID FROM [Production].[Product]

--CASE
SELECT BusinessEntityID, NationalIDNumber, JobTitle, BirthDate,MaritalStatus,
CASE Gender
	WHEN 'M' THEN 'Male'
	WHEN 'F' THEN 'Female'
	ELSE 'Unknown'
END AS [Gender],
HireDate,SickLeaveHours 
FROM HumanResources.Employee

--Display the products in given format
-- ProductNumber**Name (StandardCost)
-- eg. AR-5381**Adjustable Race (0.00)
SELECT ProductNumber + '**' + Name + ' ('+ Convert(VARCHAR(20),StandardCost) + ')' AS [Products]
FROM [Production].[Product]
--OR
SELECT CONCAT (ProductNumber,'**',Name,' (',StandardCost,')') AS [Products]
FROM [Production].[Product]

------------------------------------------------------------------------------------------------------------------
---BUILT IN FUNCTIONS
/*
NUMERIC FUNCTS
STRING FUNCTS
DATE FUNCTS
AGGREGATE FUNCTS
*/

SELECT ProductID,ProductNumber, Name AS [Product Name],
ISNULL(Color,'Undefined') AS [Color],
StandardCost,
CEILING (StandardCost) AS [Ceiling],
FLOOR (StandardCost ) AS [Floor],
ROUND (StandardCost,2) AS [ROUND],
ProductSubcategoryID FROM [Production].[Product]

SELECT POWER(5,3), PI()
------------------------------------------------
SELECT ProductID,ProductNumber, UPPER(Name) AS [Product Name],
SUBSTRING (Name,2,5) AS [SubSTR],
ISNULL(Color,'Undefined') AS [Color],
StandardCost,ProductSubcategoryID FROM Production.Product

-------------------------

SELECT DATEADD(DD,730,GETDATE())

-- get the experience and AGE of all the employees
SELECT BusinessEntityID, NationalIDNumber, JobTitle, BirthDate,MaritalStatus,Gender,
HireDate,SickLeaveHours, 
DATEDIFF (YYYY,HireDate,GetDate()) AS [EXP. In YEARS],
DATEDIFF (YYYY,BirthDate,GetDate()) AS [AGE]
FROM HumanResources.Employee

-----------------------------------------------------------------------------------------------------

--SORTING
SELECT ProductID,ProductNumber, Name,Color,StandardCost FROM [Production].[Product]

--By Name in desc order
SELECT ProductID,ProductNumber, Name,Color,StandardCost FROM [Production].[Product]
ORDER BY Name DESC

--By Color, Standard Cost DESC
SELECT ProductID,ProductNumber, Name,Color,StandardCost FROM [Production].[Product]
ORDER BY Color, StandardCost DESC

------------------------------------------------------------------------------------------------------
-- Get total cost of all products
SELECT SUM(StandardCost) AS [Total Cost] FROM Production.Product
-- GET total products
SELECT COUNT(*) AS [Total Products] FROM Production.Product

/*
** Applying aggregation on the table looses access to individual rows and columns
*/

--The below command will fail
SELECT ProductID, SUM(StandardCost) AS [Total Cost] FROM Production.Product

--GROUP BY CLAUSE

--get colorwise sum of standard cost for the products
SELECT Color, SUM(StandardCost) AS [Total Cost] FROM Production.Product
GROUP BY Color

--get colorwise count of products
SELECT Color, Count(*) AS [Total Products] FROM Production.Product
GROUP BY Color

--get distinct count of employees based on gender
SELECT Gender, Count(*) AS [Total Employees]
FROM HumanResources.Employee
Group By Gender

--get distinct count of employees based on gender and Marital Status
SELECT Gender, MaritalStatus, Count(*) AS [Total Employees]
FROM HumanResources.Employee
Group By Gender,MaritalStatus

-----------------------------------------------------------------------------------------------------------


----OVER CLAUSE -- applied on window functions (aggre, ranking)

-- list all the products with total cost for all products
SELECT ProductID, Name, Color, StandardCost, ProductSubCategoryID, 
SUM(StandardCost) OVER() AS [Total Cost] 
FROM Production.Product


-- list all the products with colorwise total cost 

SELECT ProductID, Name, Color, StandardCost, ProductSubCategoryID, 
SUM(StandardCost) OVER(PARTITION BY Color) AS [Total Cost] 
FROM Production.Product















