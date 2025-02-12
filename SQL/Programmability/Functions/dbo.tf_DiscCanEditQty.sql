SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_DiscCanEditQty](@DocCode int, @ChID bigint, @ProdID int, @DocDate smalldatetime)
/* Возможно ли изменение количества для данной позиции */
/* Сгенерирована 25.04.2019 16:26:29; Приложение: SPComm.exe (Версия 3.14.0.900, 25.04.2019 12:58:58); Версия БД: 3.17.0.0 */
RETURNS bit AS
BEGIN  DECLARE @OurID int
  DECLARE @StockID int

  SELECT @OurID = OurID, @StockID = StockID FROM t_SaleTemp WHERE ChID = @ChID

  RETURN 1
END
GO