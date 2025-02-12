SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleUpdateChequeState](@ChID bigint, @StateCode int)
/* Обновляет статус чека */
AS
BEGIN
  UPDATE t_Sale SET StateCode = @StateCode WHERE ChID = @ChID
END
GO