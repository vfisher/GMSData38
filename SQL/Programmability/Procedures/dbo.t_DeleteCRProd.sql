SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_DeleteCRProd](@CRID smallint, @CashProdID int) AS
/* Удаляет заданый товар для данного ЭККА */
BEGIN
  DELETE FROM r_CRMP WHERE CRID = @CRID AND CRProdID = @CashProdID
END
GO