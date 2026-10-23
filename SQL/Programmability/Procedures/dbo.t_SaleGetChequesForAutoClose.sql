SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGetChequesForAutoClose] (@CRID int, @WorkTimeBegin datetime,  @WorkTimeEnd datetime)
AS
/* Возвращает список чеков для автоматического закрытия */ 
BEGIN
  SELECT ChID FROM t_SaleTemp WHERE DocState = 10
END
GO