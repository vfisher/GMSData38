SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_BookingDeleteMasterRecord](@ChID bigint)
/* Удаляет запись в заголовке документа Услуги (при закрытии диалога заказа) */
AS
BEGIN
  DECLARE @SaleTempChID bigint	
  DECLARE @DocCode INT
  SELECT @DocCode = DocCode FROM t_Booking WHERE ChID = @ChID

  IF @DocCode NOT IN (1011, 11035)
    BEGIN
      RAISERROR ('Неверный код связанного документа.', 16, 1)
      RETURN
    END

  /* Защита от удаления документов, имеющих детальную часть */
  IF EXISTS(SELECT TOP 1 1 FROM t_BookingD WHERE ChID = @ChID) RETURN

  IF @DocCode = 1011
    BEGIN                            
      SELECT @SaleTempChID = d.ChID FROM t_Booking m WITH (NOLOCK) JOIN t_SaleTemp d ON m.DocChID = d.ChID WHERE m.DocCode = 1011 
      IF EXISTS(SELECT TOP 1 1 FROM t_SaleTempD WHERE ChID = @SaleTempChID) RETURN 
    END 
  ELSE IF @DocCode = 11035
    IF EXISTS(SELECT TOP 1 1 FROM t_Booking m WITH(NOLOCK) JOIN t_Sale d ON m.DocChID = d.ChID WHERE m.DocCode = 11035) RETURN

  DELETE FROM t_SaleTemp WHERE ChID = @SaleTempChID
  DELETE FROM t_Booking WHERE ChID = @ChID
END
GO
