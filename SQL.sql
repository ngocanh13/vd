USE AdventureWorks2022
GO
CREATE PROCEDURE sp_DisplayEmployeesHireYear
	@HIreyear INT 
AS
SELECT * FROM HumanResources.Employee
WHERE DATEPART(YY, Hiredate) =@HIreyear
GO 
EXECUTE sp_DisplayEmployeesHireYear 2003
go
CREATE PROCEDURE SP_EmployeeHireYearcount
	@HireYear int,
	@Count int OUTPUT
AS

SELECT @Count=COUNT(*) FROM HumanResources.Employee
WHERE DATEPART(YY, HireDate)=@HireYear
go

DECLARE @Number int 
EXECUTE SP_EmployeeHireYearcount 20003, @NUmber OUTPUT
PRINT @Number
GO

CREATE PROCEDURE SP_EmployeesHireYearCount2
	@HireYear int
AS
DECLARE @Count int
SELECT @Count=COUNT(*) FROM HumanResources.Employee
WHERE DATEPART(YY, HireDate)=@HireYear
RETURN @Count
go

DECLARE @Number int
EXECUTE @Number = SP_EmployeesHireYearCount2 2003
PRINT @Number 
go

CREATE TABLE #Students
(
	RollNo VARCHAR(6) CONSTRAINT PK_Students PRIMARY KEY,
	FullName nvarchar(100),
	Birthday datetime constraint DF_Studensbirthday DEFAULT
	DATEADD(yy, -18, GETDATE())
)
GO
CREATE PROCEDURE #spInsertStudents
@rollNo varchar(6),
@fullName nvarchar(100),
@birthday datetime
AS BEGIN
IF(@birthday IS NULL)
SET @birthday=DATEADD(YY, -18, GETDATE())
INSERT INTO #Students(RollNo, FullName, Birthday)
VALUES(@rollNo, @fullName, @birthday)
END
GO

EXEC #spStudents 'A12345', 'abc', NULL
EXEC #spStudents 'A54321', 'abc', '12/24/2011'
SELECT * FROM #Students
go

CREATE PROCEDURE #spDeleteStudents
	@rollNo varchar(6)
AS BEGIN
	DELETE FROM #Students WHERE RollNo=@rollNo
END

EXECUTE #spDeleteStudents 'A12345'
GO

CREATE PROCEDURE Cal_Square @num int=0 AS
BEGIN
RETURN (@num * @num);
END
GO

DECLARE @square int;
EXEC @square = Cal_Square 10;
PRINT @square;
GO

SELECT 
OBJECT_DEFINITION(OBJECT_ID('HumanResources.uspUpdateEmployeePersonalInfo')) AS DEFINITION

SELECT definition FROM sys.sql_modules
WHERE 
object_id=OBJECT_ID('HumanResources.uspUpdateEmployeePersonalInfo')
GO

sp_depends 'HumanResources.uspUpdateEmployeePersonalInfo'
GO
USE AdventureWorks2022
GO
CREATE PROCEDURE sp_DisplayEmployees AS
SELECT * FROM HumanResources.Employee
GO


ALTER PROCEDURE sp_DisplayEmployees AS
SELECT * FROM HumanResources.Employee
WHERE Gender='F'
GO
EXEC sp_DisplayEmployees
GO

DROP PROCEDURE sp_DisplayEmployees
GO

CREATE PROCEDURE sp_EmployeeHire
AS
BEGIN
	EXECUTE sp_DisplayEmployeesHireYear 1999
	DECLARE @Number int
	EXECUTE sp_EmployeesHireYearCount 1999, @Number OUTPUT
	PRINT N'Số nhân viên vào làm năm 1999 là: ' + 
CONVERT(varchar(3),@Number)
END
GO

EXEC sp_EmployeeHire 
GO
ALTER PROCEDURE sp_EmployeeHire
@HireYear int

AS
BEGIN
	BEGIN TRY
		EXECUTE sp_DisplayEmployeesHireYear @HireYear
		DECLARE @Number int
		EXECUTE sp_EmployeesHireYearCount @HireYear, @Number OUTPUT, 
'123'
	PRINT N'Số nhân viên vào làm năm là: ' + 
CONVERT(varchar(3),@Number)
	END TRY
	BEGIN CATCH
		PRINT N'Có lỗi xảy ra trong khi thực hiện thủ tục lưu trữ'
	END CATCH
	PRINT N'Kết thúc thủ tục lưu trữ'
END
GO

EXEC sp_EmployeeHire 1999
GO
ALTER PROCEDURE sp_EmployeeHire
@HireYear int
AS
BEGIN
	EXECUTE sp_DisplayEmployeesHireYear @HireYear
	DECLARE @Number int
	EXECUTE sp_EmployeesHireYearCount @HireYear, @Number OUTPUT, 
'123'
	IF @@ERROR <> 0
PRINT N'Có lỗi xảy ra trong khi thực hiện thủ tục lưu trữ'
PRINT N'Số nhân viên vào làm năm là: ' + 
CONVERT(varchar(3),@Number)
END
GO
EXEC sp_EmployeeHire 1999
