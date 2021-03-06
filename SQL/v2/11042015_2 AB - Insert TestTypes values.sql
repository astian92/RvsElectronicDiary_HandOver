

Begin Transaction InsertTestTypes

Begin Try
	
	Insert into TestTypes
	Values (NEWID(), N'Микробиологично изпитване', N'МКБ') 

	Insert into TestTypes
	Values (NEWID(), N'Физикохимично и органолептично изпитване', N'ФЗХ') 

	Commit Transaction InsertTestTypes
End Try
Begin Catch
	Rollback Transaction InsertTestTypes

	Select 
		ERROR_LINE() as Line,
		ERROR_MESSAGE() as ErrorMsg,
		ERROR_NUMBER() as Number
End Catch