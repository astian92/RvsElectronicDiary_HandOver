/*
   11 април 2016 г.21:17:10
   User: Astian
   Server: 77.78.32.78\MINC
   Database: DB_9BCA69_RedDb
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Tests
	DROP CONSTRAINT FK_Tests_AcredetationLevels
GO
ALTER TABLE dbo.AcredetationLevels SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Tests
	DROP CONSTRAINT FK_Tests_TestCategories
GO
ALTER TABLE dbo.TestCategories SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Tests
	(
	Id uniqueidentifier NOT NULL,
	TestCategoryId uniqueidentifier NOT NULL,
	Type uniqueidentifier NULL,
	Name nvarchar(150) NOT NULL,
	TestMethods nvarchar(150) NULL,
	AcredetationLevelId uniqueidentifier NOT NULL,
	Temperature nvarchar(50) NULL,
	UnitName nvarchar(60) NULL,
	MethodValue nvarchar(400) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Tests SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.Tests)
	 EXEC('INSERT INTO dbo.Tmp_Tests (Id, TestCategoryId, Name, TestMethods, AcredetationLevelId, Temperature, UnitName)
		SELECT Id, TestCategoryId, Name, TestMethods, AcredetationLevelId, Temperature, UnitName FROM dbo.Tests WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.ProductTests
	DROP CONSTRAINT FK_ProductTests_Tests
GO
DROP TABLE dbo.Tests
GO
EXECUTE sp_rename N'dbo.Tmp_Tests', N'Tests', 'OBJECT' 
GO
ALTER TABLE dbo.Tests ADD CONSTRAINT
	PK__Tests__3214EC07452D85B3 PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Tests ADD CONSTRAINT
	FK_Tests_TestCategories FOREIGN KEY
	(
	TestCategoryId
	) REFERENCES dbo.TestCategories
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Tests ADD CONSTRAINT
	FK_Tests_AcredetationLevels FOREIGN KEY
	(
	AcredetationLevelId
	) REFERENCES dbo.AcredetationLevels
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ProductTests ADD CONSTRAINT
	FK_ProductTests_Tests FOREIGN KEY
	(
	TestId
	) REFERENCES dbo.Tests
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.ProductTests SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
