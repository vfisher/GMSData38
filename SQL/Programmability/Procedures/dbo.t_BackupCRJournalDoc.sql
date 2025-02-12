SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_BackupCRJournalDoc]
    (@CRID smallint,
     @SerialID varchar(250),
     @FiscalID varchar(250),
     @Data image,
     @DocTypeID int,
     @DocSubtypeID int,
     @XMLDocID bigint,
     @DocCode int,
     @DocChID bigint,
     @DocTime datetime,
     @IsFinished bit,
     @InetChequeNum varchar(50)
    )
AS
/* Выполняет сохранение данных ЭКЛ в XML */
BEGIN	
  SET NOCOUNT ON
  IF EXISTS(SELECT TOP 1 1 FROM t_CRJournal WHERE XMLDocID = @XMLDocID AND SerialID = @SerialID AND FiscalID = @FiscalID AND Data IS NULL)
    BEGIN
      UPDATE t_CRJournal SET Data = @Data, IsFinished = @IsFinished, DocTypeID = @DocTypeID, DocSubtypeID = @DocSubtypeID, DocTime = @DocTime, @InetChequeNum = @InetChequeNum
      WHERE XMLDocID = @XMLDocID AND SerialID = @SerialID AND FiscalID = @FiscalID
      RETURN
    END
  ELSE IF NOT EXISTS(SELECT TOP 1 1 FROM t_CRJournal WHERE XMLDocID = @XMLDocID AND SerialID = @SerialID AND FiscalID = @FiscalID)
    BEGIN
      DECLARE @ChID bigint
      BEGIN TRAN
      EXEC z_NewChID 't_CRJournal', @ChID OUTPUT
      IF @@ERROR <> 0 GOTO Error

      INSERT INTO t_CRJournal(ChID, CRID, SerialID, FiscalID, Data, DocTypeID, DocSubtypeID, XMLDocID, DocCode, DocChID, DocTime, IsFinished, InetChequeNum)
      VALUES (@ChID, @CRID, @SerialID, @FiscalID, @Data, @DocTypeID, @DocSubtypeID, @XMLDocID, @DocCode, @DocChID, @DocTime, @IsFinished, @InetChequeNum)
      IF @@ERROR <> 0 GOTO Error
      COMMIT TRAN
      RETURN
    END
  ELSE
	RETURN 

Error:
  ROLLBACK TRANSACTION

END
GO