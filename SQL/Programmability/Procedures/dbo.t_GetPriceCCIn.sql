SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetPriceCCIn] @ProdID int, @PPID int, @RateMC numeric(19, 9), @Result numeric(19, 9) OUTPUT
/* Возвращает цену прихода для указанного товара, для указанного курса документа и указанной КЦП с учетом опции "Пересчитывать цены в Валюте Страны по курсу документа"*/
AS
BEGIN
  IF ((dbo.zf_Var('t_RecalcPriceCC') = '1') OR (dbo.zf_GetCurrCC() <> (SELECT CurrID FROM t_PInP WHERE ProdID = @ProdID AND PPID = @PPID)))
    SET @Result = CAST((SELECT PriceMC_In / dbo.zf_GetRateMC(CurrID) FROM t_PInP WHERE ProdID = @ProdID AND PPID = @PPID) AS NUMERIC(24, 12))  * @RateMC
  ELSE  
    SET @Result = (SELECT PriceMC_In FROM t_PInP WHERE ProdID = @ProdID AND PPID = @PPID)

  IF (dbo.zf_Var('t_UseMultiCurrencies') = '1')
    SET @Result = (SELECT PriceCC_In FROM t_PInP WHERE ProdID = @ProdID AND PPID = @PPID)  

  SELECT @Result = ISNULL(dbo.zf_RoundPriceRec(@Result), 0)
END
GO