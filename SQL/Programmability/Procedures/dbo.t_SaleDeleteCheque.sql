SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleDeleteCheque](@ChID bigint)
/* Удаляет указанный документ "Продажа товара оператором" */
AS
BEGIN
  DELETE FROM t_SaleTemp WHERE ChID = @ChID
END
GO