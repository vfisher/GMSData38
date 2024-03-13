SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_DiscDoc](@DocCode int, @ChID bigint)
/* Возвращает указанный документ (денормализовано: Мастер * Детали) */
/* Сгенерирована 25.04.2019 16:26:29; Приложение: SPComm.exe (Версия 3.14.0.900, 25.04.2019 12:58:58); Версия БД: 3.17.0.0 */
RETURNS @out table(SrcPosID int, CSrcPosID int, ProdID int, PurPriceCC_wt numeric(21, 9), PurSumCC_wt numeric(21, 9), PriceCC_wt numeric(21, 9), SumCC_wt numeric(21, 9), Qty numeric(21, 9), RateMC numeric(21, 9)) AS
BEGIN


  RETURN
END
GO
