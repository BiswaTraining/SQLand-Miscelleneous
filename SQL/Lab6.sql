CREATE TABLE BankAccounts.BankAccounts(
	AccountID  INT PRIMARY KEY IDENTITY(1,1),
	CustomerName VARCHAR(100) NOT NULL,
	AccountType  VARCHAR(10) NOT NULL CHECK (AccountType IN('Current ','Saving')),
	BALANCE MONEY CHECK (BALANCE>0),
	LastModified DATE DEFAULT GETDATE()
)


INSERT INTO BankAccounts.BankAccounts (CustomerName,AccountType,BALANCE) VALUES
('ARNAV','Saving',5000),
('ADITYA','Saving',10000),
('RAHUL','Saving',5000),
('ROHAN','Saving',10000),
('RAJEEV','Current',150000),
('SATYAM','Current',150000),
('SANJEEV','Current',2500000),
('SRIKANT','Current',2500000)

CREATE TABLE BankAccounts.BankTransactions(
	TransactionID INT PRIMARY KEY IDENTITY(1,1),
	AccountID INT REFERENCES BankAccounts.BankAccounts(AccountID) NOT NULL,
	TransactionDate DATE CHECK (TransactionDate<=GETDATE()),
	TransactionType VARCHAR(10) NOT NULL CHECK (TransactionType IN('Debit ','Credit')),
	TransactionAmount MONEY CHECK (TransactionAmount>0)
)


CREATE TRIGGER update_bankAccount
ON BankAccounts.BankTransactions
AFTER INSERT	
AS
BEGIN
	IF(SELECT TransactionType FROM inserted)='Credit'
		UPDATE BankAccounts.BankAccounts SET BALANCE=BALANCE+(SELECT TransactionAmount FROM inserted) WHERE AccountID=(SELECT AccountID FROM inserted)
	ELSE
		UPDATE BankAccounts.BankAccounts SET BALANCE=BALANCE-(SELECT TransactionAmount FROM inserted) WHERE AccountID=(SELECT AccountID FROM inserted)
	Print 'Balance updated in account table for the customer!'
END

INSERT INTO BankAccounts.BankTransactions (AccountID,TransactionDate,TransactionType,TransactionAmount) 
VALUES (1,'02-APR-2022','Debit',1000);

INSERT INTO BankAccounts.BankTransactions (AccountID,TransactionDate,TransactionType,TransactionAmount) 
VALUES (2,'02-APR-2022','Credit',1000);




SELECT * FROM BankAccounts.BankAccounts
SELECT * FROM BankAccounts.BankTransactions
--SELECT TransactionAmount FROM inserted;
--SELECT TransactionAmount FROM deleted;
--Select * from BankAccounts.BankTransactions

--Delete from BankAccounts.BankTransactions where TransactionID=1 or TransactionID=2

--commit