SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleEditCustomPays](@DocCode int, @ChID bigint, @PayFormCode int)
AS
/* Заменяет добавляемую в чек форму оплаты на оплаты, возвращаемые данной процедурой */
BEGIN
  DECLARE @pays TABLE(PayFormCode int, SumCC_wt numeric (21, 9), PosPayID int, Msg varchar(250))

  SELECT * FROM @pays 
END
GO
