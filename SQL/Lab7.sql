DROP Procedure convert_to_integer

CREATE PROCEDURE convert_to_integer
(
	@pStringToBeConverted VARCHAR(20)
)
AS
BEGIN 
	IF @pStringToBeConverted IS NOT NULL
	BEGIN TRY
		DECLARE @INTEGERVALUE INT;
		SET @INTEGERVALUE= CAST(@pStringToBeConverted AS INT)

		DECLARE @CNT INT;
		SET @CNT=1;

		WHILE(@CNT<=@INTEGERVALUE)
			BEGIN
				Print 'Hello'
				SET @CNT=@CNT+1
			END
	END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER(), ERROR_MESSAGE();
	END CATCH
	ELSE
	BEGIN
		Print 'Null cannot be converted to Integer. Kindly provide a valid data'
	END
END;


EXECUTE convert_to_integer 5----SUCCESS CASE
EXECUTE convert_to_integer '25'----SUCCESS CASE
EXECUTE convert_to_integer 'RAVI'----EXCEPTION CASE
EXECUTE convert_to_integer NULL-----NULL CASE


------------------------------------------------------------
CREATE TABLE EMPL(
EmpId INT PRIMARY KEY IDENTITY(1,1),
EmpName VARCHAR(50) NOT NULL,
EmpSalary MONEY
)

CREATE TRIGGER minimum_salary_check
ON EMPL
AFTER INSERT	
AS
BEGIN
	BEGIN TRY
		IF(SELECT EmpSalary FROM inserted)<10000
		RAISERROR('Salary must be greater than 10000!',16,0)
	END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER(), ERROR_MESSAGE()
	END CATCH
END

INSERT INTO EMPL (EmpName,EmpSalary) VALUES ('Rahul',25000);
INSERT INTO EMPL (EmpName,EmpSalary) VALUES ('ROHIT',5000);
Select * from EMPL





CREATE TABLE #EMPLOYEE(
EmpId INT PRIMARY KEY IDENTITY(1,1),
EmpName VARCHAR(30),
EmpSal MONEY 
)

DECLARE @name VARCHAR(10);
DECLARE @salary INT;
SET @name='Rohan';
SET @salary=5000;
BEGIN TRY
	IF @salary<10000
		RAISERROR('Salary must be greater than 10000!',16,0)
	ELSE
		INSERT INTO #EMPLOYEE (EmpName,EmpSal)values(@name,@salary)
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER(), ERROR_MESSAGE()
END CATCH

SELECT * FROM #EMPLOYEE
