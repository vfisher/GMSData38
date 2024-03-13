SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleLoadCustomPays](@DocCode int, @ChID bigint)
/* Возвращает список оплат для формы закрытия чека */
AS
BEGIN
  DECLARE @pays TABLE(PayFormCode int, SumCC_wt numeric (21, 9), PosPayID int, Msg varchar(250))

  SELECT * FROM @pays
END
GO
