SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_CorrectPriceForTaxProd](@PriceCC numeric(19, 9), @ProdID int, @DocDate smalldatetime)/* Корректирует цену для НДС для указанного товара (при необходимости)*/RETURNS numeric(19, 9) ASBegin  RETURN    CASE      WHEN ((SELECT dbo.zf_Var('t_CorrectPriceForTax')) = '1') AND  EXISTS(SELECT * FROM r_Prods WHERE ProdID = @ProdID AND PriceWithTax = 1) THEN        (dbo.zf_CorrectPriceForTax(@PriceCC, dbo.zf_GetProdTaxPercent(@ProdID, @DocDate)))      ELSE        @PriceCC    ENDEnd
GO
