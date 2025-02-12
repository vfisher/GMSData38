SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_OpenBookingCheque](@OurID int, @PersonID bigint, @StateCode int, @DocCode int, @DocChID bigint, @ChID bigint OUTPUT)
/* Создает заголовок в документе заказов */ 
AS
BEGIN
  SET NOCOUNT ON
  DECLARE @ADocID bigint

  BEGIN TRANSACTION

  EXEC sp_GetAppLock 't_CreateBooking_GetChID', 'Exclusive'
  EXEC z_NewChID 't_Booking', @ChID OUTPUT
  IF @@ERROR <> 0 GOTO Error

  EXEC z_NewDocID 11111, 't_Booking', @OurID, @ADocID OUTPUT
  IF @@ERROR <> 0 GOTO Error

  INSERT INTO dbo.t_Booking (ChID, DocDate, OurID, DocID, PersonID, StateCode, DocCode, DocChID)
  VALUES  ( @ChID,
            dbo.zf_GetDate(GetDate()),
            @OurID,
            @ADocID,
            @PersonID,
            @StateCode,
            @DocCode,
            @DocChID
          ) 
  EXEC sp_ReleaseAppLock 't_CreateBooking_GetChID'

  COMMIT TRANSACTION
  RETURN

  Error:
  EXEC sp_ReleaseAppLock 't_CreateBooking_GetChID'
  ROLLBACK TRANSACTION
END
GO