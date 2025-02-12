SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetPriceCCPP] @ProdID int, @PPID int, @RateMC numeric(19, 9), @Discount numeric(19,9), @Result numeric(19, 9) OUTPUT
/* Возвращает цену продажи для указанного товара, для указанного курса документа, для указанной скидки и указанной КЦП с учетом опции "Пересчитывать цены в Валюте Страны по курсу документа"*/
AS
BEGIN
  IF ((dbo.zf_Var('t_RecalcPriceCC') = '1') OR (dbo.zf_GetCurrCC() <> (SELECT CurrID FROM t_PInP WHERE ProdID = @ProdID AND PPID = @PPID)))
    SET @Result = CAST((SELECT PriceMC / dbo.zf_GetRateMC(CurrID) FROM t_PInP WHERE ProdID = @ProdID AND PPID = @PPID) AS NUMERIC(24, 12)) * @RateMC
  ELSE  
    SET @Result = (SELECT PriceMC FROM t_PInP WHERE ProdID = @ProdID AND PPID = @PPID)
  SET @Result = dbo.zf_GetPriceWithDiscount(@Result, @Discount)

  SELECT @Result = ISNULL(dbo.zf_RoundPriceSale(@Result), 0)
END
GO