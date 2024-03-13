SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaveMonIntExp](@ChID bigint OUTPUT, @OurID int, @CRID smallint, @DocTime datetime, @SumCC numeric(21,9),
  @OperID int, @CodeID1 smallint, @CodeID2 smallint, @CodeID3 smallint, @CodeID4 smallint, @CodeID5 smallint,
  @IntDocID varchar(50), @Notes varchar(200),
  @Continue int OUTPUT, @Msg varchar(200) OUTPUT)
/* Сохраняет служебный вынос */
AS
BEGIN
  /*
    @Continue
    0 - прервать процедуру
    1 - проводим только по базе
    2 - проводим по базе и по РРО
  */
  SET @Continue = 2
  SET @Msg = '' /* Сообщение, выводимое на клиенте в независимости от остальных возвращаемых параметров */
  DECLARE @DocID BIGINT, @StateCode INT 
  SET @StateCode = 0
  IF @DocTime IS NULL SET @DocTime = GETDATE()
  BEGIN TRANSACTION
  EXEC z_NewChID 't_MonIntExp', @ChID OUTPUT
  IF @@ERROR <> 0
    BEGIN
      SET @Continue = 0
      ROLLBACK TRANSACTION
      RETURN
    END
  EXEC z_NewDocID 11052, 't_MonIntExp', @OurID, @DocID OUTPUT
  IF @@ERROR <> 0
    BEGIN
      SET @Continue = 0
      ROLLBACK TRANSACTION
      RETURN
    END
  IF @IntDocID IS NULL SET @IntDocID = @DocID
  IF @Continue = 2 SET @StateCode = dbo.zf_Var('t_ChequeStateCode')
  INSERT INTO t_MonIntExp (ChID, OurID, DocID, CRID, SumCC, Notes, OperID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, DocDate, DocTime, IntDocID, StateCode)
  VALUES (@ChID, @OurID, @DocID, @CRID, @SumCC, @Notes, @OperID, @CodeID1, @CodeID2, @CodeID3, @CodeID4, @CodeID5, dbo.zf_GetDate(@DocTime), @DocTime, @IntDocID, @StateCode)
  COMMIT TRANSACTION
END
GO
