/*
   Wednesday, April 5, 20173:51:29 PM
   User: 
   Server: .
   Database: RedDb2
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
ALTER TABLE dbo.Diary
	DROP CONSTRAINT FK_Diary_Clients
GO
ALTER TABLE dbo.Clients SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Diary
	(
	Id uniqueidentifier NOT NULL,
	Number int NOT NULL,
	AcceptanceDateAndTime datetime NOT NULL,
	LetterNumber nvarchar(50) NULL,
	LetterDate date NOT NULL,
	Contractor nvarchar(50) NULL,
	ClientId uniqueidentifier NOT NULL,
	Comment ntext NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Diary SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.Diary)
	 EXEC('INSERT INTO dbo.Tmp_Diary (Id, Number, AcceptanceDateAndTime, LetterNumber, LetterDate, Contractor, ClientId, Comment)
		SELECT Id, CONVERT(int, Number), AcceptanceDateAndTime, CONVERT(nvarchar(50), LetterNumber), LetterDate, Contractor, ClientId, Comment FROM dbo.Diary WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.Requests
	DROP CONSTRAINT FK_Requests_Diary
GO
ALTER TABLE dbo.Products
	DROP CONSTRAINT FK_Products_Diary
GO
DROP TABLE dbo.Diary
GO
EXECUTE sp_rename N'dbo.Tmp_Diary', N'Diary', 'OBJECT' 
GO
ALTER TABLE dbo.Diary ADD CONSTRAINT
	PK__Diary__3214EC076B08718B PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Diary ADD CONSTRAINT
	FK_Diary_Clients FOREIGN KEY
	(
	ClientId
	) REFERENCES dbo.Clients
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Products ADD CONSTRAINT
	FK_Products_Diary FOREIGN KEY
	(
	DiaryId
	) REFERENCES dbo.Diary
	(
	Id
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Products SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Requests ADD CONSTRAINT
	FK_Requests_Diary FOREIGN KEY
	(
	DiaryId
	) REFERENCES dbo.Diary
	(
	Id
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Requests SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
