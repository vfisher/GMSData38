SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_BackupCRJournalTextDoc]
    (@CRID smallint,
     @SerialID varchar(250),
     @FiscalID varchar(250),
     @TextData varchar(8000),
     @DocTypeID int,
     @DocSubtypeID int,
     @CRDocID varchar(50),
     @DocCode int,
     @DocChID bigint,
     @DocTime datetime,
     @IsFinished bit)
AS
/* Выполняет сохранение данных ЭКЛ чеков в текстовом виде */
BEGIN	
  SET NOCOUNT ON
  IF EXISTS(SELECT TOP 1 1 FROM t_CRJournalText WHERE CRDocID = @CRDocID AND SerialID = @SerialID AND FiscalID = @FiscalID AND TextData IS NULL)
    BEGIN
      UPDATE t_CRJournalText SET TextData = @TextData, IsFinished = @IsFinished, DocTypeID = @DocTypeID, DocSubtypeID = @DocSubtypeID, DocTime = @DocTime
      WHERE CRDocID = @CRDocID AND SerialID = @SerialID
      RETURN
    END
  ELSE IF NOT EXISTS(SELECT TOP 1 1 FROM t_CRJournalText WHERE CRDocID = @CRDocID AND SerialID = @SerialID AND FiscalID = @FiscalID)
    BEGIN
      DECLARE @ChID bigint
      BEGIN TRAN
      EXEC z_NewChID 't_CRJournalText', @ChID OUTPUT
      IF @@ERROR <> 0 GOTO Error

      INSERT INTO t_CRJournalText(ChID, CRID, SerialID, FiscalID, TextData, DocTypeID, DocSubtypeID, CRDocID, DocCode, DocChID, DocTime, IsFinished)
      SELECT @ChID, @CRID, @SerialID, @FiscalID, @TextData, @DocTypeID, @DocSubtypeID, @CRDocID, @DocCode, @DocChID, @DocTime, @IsFinished
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