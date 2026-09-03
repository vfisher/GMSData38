SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleOnPOSPayCorrection](@DocCode int, @ChID bigint, @ParamsIN varchar(4000), @ParamsOUT varchar(4000) output)
AS
BEGIN
  RETURN
 /* Вернуть @ParamsOUT: {"interrupt_required": true} для прерывания процесса оплаты по терминалу */
END
GO