--SUBQUERIES
/*
	A query inside another query. Also called as nested query.
*/
SELECT * FROM Production.ProductSubcategory

--Get all the Products that belong to subcategory named 'Road Bikes'  
--SINGLE ROW SUB QUERY: A subquery that returns single row and single scalar value.

SELECT * FROM Production.Product WHERE ProductSubcategoryID = 
(
	SELECT ProductSubcategoryID FROM Production.ProductSubcategory
	WHERE Name = 'Road Bikes'
)

SELECT * FROM Production.ProductCategory

--Get all the Products in Category named 'Bikes'

--MULTI ROW SUB QUERY -  Returns multiple rows for single column
SELECT * FROM Production.Product WHERE ProductSubcategoryID IN
(
	SELECT ProductSubcategoryID FROM Production.ProductSubcategory
	WHERE ProductCategoryID =
	(
		SELECT ProductCategoryID FROM Production.ProductCategory
		WHERE Name = 'Bikes'
	)
)

--MULTI COLUMN Subquery
Create table #BlackProducts
(
	ProdID INT,
	ProdName Varchar(50),
	Color VARCHAR(20)
)

INSERT INTO #BlackProducts
SELECT ProductID, Name, Color FROM Production.Product WHERE Color = 'Black'

SELECT * FROM #BlackProducts

----------------------
--Corelated subquery

SELECT * FROM PatientVisits
-- Get all the patientVisits if the VisitTime is greater than average VisitTime against it's purpose
SELECT * FROM PatientVisits VO WHERE VisitTime >
(
	SELECT AVG(VisitTime) FROM PatientVisits WHERE VisitPurpose = VO.VisitPurpose
)



Select ProductID,Name,Color,StandardCost FROM Production.Product
WHERE Color Is NOT NULL

-- Get all the Non NULL colored products which have standard cost greater than half of sum of standardcost against its respective color

SELECT ProductID,Name,Color,StandardCost FROM Production.Product PO
WHERE Color Is NOT NULL AND StandardCost >
(
	SELECT SUM(StandardCost)/2 FROM Production.Product WHERE Color = PO.Color
)

-------------------------------------------------------------------------------
--VIEW

SELECT * INTO MyProducts FROM Production.Product WHERE COLOR IS NOT NULL

SELECT * FROM MyProducts

CREATE VIEW V_MyProducts AS
SELECT * FROM MyProducts WHERE ProductID BETWEEN 700 AND 800

SELECT * FROM V_MyProducts

UPDATE V_MyProducts SET Color = 'White' WHERE ProductID = 680

-------------------------------

--SEQUENCE - It's a sequential no. generator
CREATE SEQUENCE MySeq AS INT
START WITH 101
INCREMENT BY 1
MAXVALUE 1000
MINVALUE 1
NO CYCLE
CACHE 10

SELECT NEXT VALUE FOR MySeq

SELECT current_value FROM sys.sequences WHERE name = 'MySeq'


Create  Table #A
(
	AID INT
)


Create  Table #B
(
	BID INT
)

INSERT INTO #A VALUES (NEXT VALUE FOR MySeq)

INSERT INTO #B VALUES (NEXT VALUE FOR MySeq)

SELECT * FROM #A

SELECT * FROM #B

---------------------------------------------------------------------
-- SYNONYM

Create Synonym atab FOR #A
SELECT * FROM atab

-------------------------------------------------------------------------
/* PL/SQL
	Stored Procedures
	UDFs
	Triggers
*/
--- Anonymous Blocks
-- Declare varibales and assigning values

DECLARE @empid INT;
DECLARE @empname VARCHAR(20);
DECLARE @empnamefromtable VARCHAR(50)
SET @empid = 1;
SET @empname = 'Rajesh';
SELECT @empnamefromtable = Concat(FirstName,' ', LastName) FROM Person.Person WHERE BusinessEntityID = @empid
--Print 'EMP ID: ' + @empid; -- error
--Print CONCAT('EMP ID: ',  @empid); -- OR
Print 'EMP ID: ' + Convert(VARCHAR(20),@empid);
Print 'USER ASSIGNED EMP NAME: ' + @empname;
Print 'EMP NAME IN TABLE: ' + @empnamefromtable;

----IF ELSE
DECLARE @Num INT
SET @Num = 13
IF (@Num % 2) =0
	BEGIN
		Print 'Even Number';
	END
ELSE
	BEGIN
		Print 'Odd Number';
	END

----IF ELSE IF
DECLARE @Num INT;
SET @Num = 0;
IF @Num< 0
	BEGIN
		Print 'Negative Number';
	END
ELSE IF (@Num = 0)
	BEGIN
		Print 'ZERO';
	END
ELSE 
	BEGIN
		Print 'Positive Number';
	END
----------------------------------------------------------
--LOOP
DECLARE @Num INT;
SET @Num=1;
WHILE (@Num<=10)
BEGIN
	PRINT @Num;
	SET @Num = @Num + 1; 
END
--------------------------------------------------------------

--STORED PROCEDURES


CREATE TABLE #Employee
(
	EmpID INT PRIMARY KEY IDENTITY (1,1),
	EmpName VARCHAR(20),
	Gender VARCHAR(1)
)

CREATE TABLE #EmployeeSalary
(
	EmpID INT REFERENCES #Employee(EmpID),
	BasicSalary MONEY,
	HRA MONEY,
	DA MONEY
)

SELECT * FROM #Employee

SELECT * FROM #EmployeeSalary
--SP WITH INPUT Params
-- EX1: CREATE a SP to regiser new employee only if the data is valid. e.g Gender must be either M, F, O or U and Salary components must be >0
DROP Procedure sp_CreateNewEmployee

CREATE PROCEDURE sp_CreateNewEmployee
(
	@pEmpName VARCHAR(20),
	@pGender VARCHAR(1),
	@pBasicSalary MONEY,
	@pHRA MONEY,
	@pDA MONEY
)
AS
BEGIN
	IF @pGender IN ('M','F','O','U') AND @pBasicSalary > 0 AND @pHRA > 0 AND @pDA > 0
	BEGIN
		DECLARE @lastempid INT;
		INSERT INTO #Employee (EmpName,Gender) VALUES (@pEmpName,@pGender);
		SELECT @lastempid = MAX(EmpID) FROM #Employee
		INSERT INTO #EmployeeSalary (EmpID,BasicSalary,HRA,DA) VALUES (@lastempid,@pBasicSalary,@pHRA,@pDA);
		Print 'Record Saved!'
	END
	ELSE
	BEGIN
		Print 'Incorrect Data!'
	END
END;

EXECUTE sp_CreateNewEmployee 'Michell Parker','F',9990,100,999

-----------------------------------------------
--E2: Display name and total salary of employee by empid
--DROP Procedure sp_GetEmployeeByID
CREATE Procedure sp_GetEmployeeByID (@pEmpID INT) AS
BEGIN
	SELECT emp.EmpID,emp.EmpName, (sal.BasicSalary + sal.HRA + sal.DA) AS [Salary]
	FROM #Employee emp JOIN #EmployeeSalary sal ON emp.EmpID = sal.EmpID WHERE
	emp.EmpID = @pEmpID
END

EXEC sp_GetEmployeeByID 2
------------------------------------------------
--SP WITH OUTPUT PARAMS
--Ex1: return name and total salary of employee by empid using OUTPUT parmeters of procedure

CREATE PROCEDURE sp_GetEmployeeDetails (
	@pEmpID INT,
	@poEmpName VARCHAR(30) OUTPUT,
	@poSalary Money OUTPUT
)AS
BEGIN
	SELECT @poEmpName = emp.EmpName, 
		@poSalary = (sal.BasicSalary + sal.HRA + sal.DA) 
	FROM #Employee emp JOIN #EmployeeSalary sal ON emp.EmpID = sal.EmpID WHERE
	emp.EmpID = @pEmpID
END


DECLARE @resEmpName VARCHAR(30);
DECLARE @resSalary MONEY;
EXEC sp_GetEmployeeDetails 3,@resEmpName OUTPUT, @resSalary OUTPUT;
Print @resEmpName;
Print @resSalary;

/*
--Lab 4: Based on Stored Procedures
Q1.	An input string representing passenger data comes in a below format to a procedure. 
 Extract the data from the string and store in a temporary table. String format: “[P9001,John Roy,Male,12-Jan-2009]”
Q2.	Modify the Day 4 - Q1 to validate the below
	A.	No duplicate entry for a passenger must be attempted to insert in table
	B.	The Age of the passenger must be between 6 to 90 
*/
----------------------------------------------------------------------------------------------------------------------------
/*
	USER DEFINED FUNCTIONS: Will return values
	. returns SCALAR VALUES
	. returns TABLE Values 
*/
--Ex: Scalar valued function:::: Create a funtion to check a valid age from DOB. As per business need the valid age is b/w 10 to 50 

ALTER FUNCTION udf_ValidateAge 
( 
	@pDOB DATE
)RETURNS INT
AS
BEGIN
	DECLARE @res INT;
	--Assume 0 means valid age and 1 means invalid age
	IF DATEDIFF(YYYY, @pDOB,GETDATE()) BETWEEN 10 AND 50
		SET @res = 0;
	ELSE
		SET @res = 1;
	RETURN @res;
END

PRINT dbo.udf_ValidateAge ('9-Oct-1960')


CREATE FUNCTION dbo.UDFCalculateAge(@pDOB DATE)RETURNS INT AS
BEGIN
	RETURN  DATEDIFF(YYYY, @pDOB,GETDATE())
END

SELECT dbo.UDFCalculateAge('9-Oct-1960')

CREATE TABLE #Customer
(
	CustomerID INT PRIMARY KEY IDENTITY (1,1),
	CustomerName VARCHAR(20),
	DOB DATE,
	AGE INT 
)

DECLARE @pCustName VARCHAR(20);
DECLARE @pDOB DATE;
DECLARE @pAge INT;
SET @pCustName = 'Lancy';
SET @pDOB = '9-Oct-2015';
SELECT @pAge = dbo.UDFCalculateAge(@pDOB);
INSERT INTO #Customer (CustomerName, DOB, AGE) VALUES (@pCustName,@pDOB,@pAge);

SELECT * FROM #Customer


------------------------------------
--Tablevalued functs.
---1. Inline

CREATE FUNCTION dbo.ColorBasedProducts (@pColor VARCHAR(20)) RETURNS TABLE AS
RETURN SELECT * FROM Production.Product WHERE Color = @pColor

SELECT * FROM dbo.ColorBasedProducts ('Red')

---2. multi statement

ALTER FUNCTION dbo.ColorBasedProductsVer2
(
	@pColor VARCHAR(20)
) 
RETURNS @Prods TABLE
(
	ProdID INT,
	ProdName Varchar(50),
	Color VARCHAR(20),
	StandarCost MONEY
)
AS
BEGIN
	IF @pColor IS NULL
	BEGIN
		INSERT INTO @Prods
		SELECT ProductID, Name, ISNULL(Color,'N/A'), ROUND(StandardCost,2) FROM Production.Product WHERE Color IS NULL
	END
	ELSE
	BEGIN
		INSERT INTO @Prods
		SELECT ProductID, Name, Color, ROUND(StandardCost,2) FROM Production.Product WHERE Color = @pColor
	END
	RETURN;
END


SELECT * FROM dbo.ColorBasedProductsVer2 ('White')

-----------------------------------------------------------------------------------------------------
/*
Lab 5: USER Defined Functions
Q1.	Create a Function to check and print all the prime numbers between a range defined by user.
Q2.	Create a Function that takes CategoryName as a parameter and gets the products associated with that category.
*/

SET STATISTICS IO ON
SELECT * FROM MyProducts WHERE ProductID = 991
SET STATISTICS IO OFF

CREATE CLUSTERED INDEX idx_myprods_prodid ON MyProducts (ProductID)

SET STATISTICS IO ON
SELECT * FROM MyProducts WHERE ProductID = 991
SET STATISTICS IO OFF
-------------------------------------------------------------------------
