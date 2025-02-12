SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetPriceCCCost] @ProdID int, @PPID int, @RateMC numeric(19, 9), @Result numeric(19, 9) OUTPUT
/* Возвращает себестоимость для указанного товара, для указанного курса документа и указанной КЦП с учетом опции "Пересчитывать цены в Валюте Страны по курсу документа"*/
AS
BEGIN
  IF ((dbo.zf_Var('t_RecalcPriceCC') = '1') OR (dbo.zf_GetCurrCC() <> (SELECT CurrID FROM t_PInP WHERE ProdID = @ProdID AND PPID = @PPID)))
    SET @Result = (CAST((SELECT CostAC / dbo.zf_GetRateMC(CurrID) FROM t_PInP WHERE ProdID = @ProdID AND PPID = @PPID) AS NUMERIC(24, 12)) * @RateMC)
  ELSE  
    SET @Result = (SELECT CostAC FROM t_PInP WHERE ProdID = @ProdID AND PPID = @PPID)

  SELECT @Result = ISNULL(dbo.zf_RoundPriceRec(@Result), 0)
END
GO