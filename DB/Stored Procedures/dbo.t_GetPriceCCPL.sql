SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetPriceCCPL](@ProdID int, @RateMC numeric(21, 9), @Discount numeric(21, 9), @PLID int, @Result numeric(21, 9) OUTPUT)
/*
  Возвращает цену ВС для указанного товара, для указанного курса документа, для указанной скидки и указанного прайс-листа
  с учетом опции "Пересчитывать цены в Валюте Страны по курсу документа"
*/
AS
BEGIN
  DECLARE @CurrID int
  SET @Result = NULL
  SELECT @CurrID = CurrID, @Result = PriceMC FROM r_ProdMP WHERE ProdID = @ProdID AND PLID = @PLID
  IF (dbo.zf_Var('t_RecalcPriceCC') = '1') OR (dbo.zf_GetCurrCC() <> @CurrID)
    SET @Result = CAST((@Result / dbo.zf_GetRateMC(@CurrID)) AS NUMERIC(24, 12)) * @RateMC

  IF (dbo.zf_Var('t_UseMultiCurrencies') = '1') 
    SET @Result = CAST((@Result * dbo.zf_GetRateCC(@CurrID)) AS NUMERIC(24, 12))    

  SET @Result = ISNULL(dbo.zf_RoundPriceSale(dbo.zf_GetPriceWithDiscount(@Result, @Discount)), 0)
END
GO
