SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaveMonIntRec](@ParamsIn varchar(max), @ParamsOut varchar(max) OUTPUT)
/* Сохраняет служебный внос */
AS
BEGIN
  /*
    @Continue
    0 - прервать процедуру
    1 - проводим только по базе
    2 - проводим по базе и по РРО
  */

  DECLARE 
    @ChID bigint, @OurID int, @CRID smallint, @DocTime datetime, @SumCC numeric(21,9),
    @OperID int, @CodeID1 smallint, @CodeID2 smallint, @CodeID3 smallint, @CodeID4 smallint, @CodeID5 smallint,
    @IntDocID varchar(50), @Notes varchar(200), @AppCode int, @GUID uniqueidentifier, @CashType int,
    @Continue int, @Msg varchar(200)

  SET @ParamsOut = '{}'
  SET @OurID = JSON_VALUE(@ParamsIn, '$.OurID')
  SET @CRID = JSON_VALUE(@ParamsIn, '$.CRID')
  SET @DocTime = JSON_VALUE(@ParamsIn, '$.DocTime')
  SET @SumCC = JSON_VALUE(@ParamsIn, '$.SumCC')
  SET @OperID = JSON_VALUE(@ParamsIn, '$.OperID')
  SET @CodeID1 = JSON_VALUE(@ParamsIn, '$.CodeID1')
  SET @CodeID2 = JSON_VALUE(@ParamsIn, '$.CodeID2')
  SET @CodeID3 = JSON_VALUE(@ParamsIn, '$.CodeID3')
  SET @CodeID4 = JSON_VALUE(@ParamsIn, '$.CodeID4')
  SET @CodeID5 = JSON_VALUE(@ParamsIn, '$.CodeID5')
  SET @IntDocID = JSON_VALUE(@ParamsIn, '$.IntDocID')
  SET @Notes = JSON_VALUE(@ParamsIn, '$.Notes')
  SET @AppCode = JSON_VALUE(@ParamsIn, '$.AppCode')
  SET @GUID = JSON_VALUE(@ParamsIn, '$.GUID')

  SET @Continue = 2
  SET @Msg = '' /* Сообщение, выводимое на клиенте в независимости от остальных возвращаемых параметров */
  DECLARE @DocID BIGINT, @StateCode INT
  SET @StateCode = 0
  IF @DocTime IS NULL SET @DocTime = GETDATE()
  IF @GUID IS NULL SET @GUID = NEWID()
  SET @CashType = ISNULL((SELECT CashType FROM r_CRs WITH(NOLOCK) WHERE CRID = @CRID),0)

  BEGIN TRANSACTION
  EXEC z_NewChID 't_MonIntRec', @ChID OUTPUT
  IF @@ERROR <> 0
    BEGIN
      SET @Continue = 0
	  SET @ParamsOut = (SELECT @ChID AS ChID, @Continue AS [Continue], @Msg AS Msg FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
      ROLLBACK TRANSACTION
      RETURN SELECT @ParamsOut
    END
  EXEC z_NewDocID 11051, 't_MonIntRec', @OurID, @DocID OUTPUT
  IF @@ERROR <> 0
    BEGIN
      SET @Continue = 0
	  SET @ParamsOut = (SELECT @ChID AS ChID, @Continue AS [Continue], @Msg AS Msg FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
      ROLLBACK TRANSACTION
      RETURN SELECT @ParamsOut
    END
  IF @IntDocID IS NULL SET @IntDocID = @DocID

  IF @Continue = 2 AND ((@AppCode <> 26000) OR (@AppCode = 26000 AND @CashType <> 39)) SET @StateCode = dbo.zf_Var('t_ChequeStateCode')
  INSERT INTO t_MonIntRec (ChID, OurID, DocID, CRID, SumCC, Notes, OperID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, DocDate, DocTime, IntDocID, StateCode, GUID)
  VALUES (@ChID, @OurID, @DocID, @CRID, @SumCC, @Notes, @OperID, @CodeID1, @CodeID2, @CodeID3, @CodeID4, @CodeID5, dbo.zf_GetDate(@DocTime), @DocTime, @IntDocID, @StateCode, @GUID)
  COMMIT TRANSACTION
  SET @ParamsOut = (SELECT @ChID AS ChID, @Continue AS [Continue], @Msg AS Msg FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
END
GO
