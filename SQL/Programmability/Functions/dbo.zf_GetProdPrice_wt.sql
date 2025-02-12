SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetProdPrice_wt](@Price numeric(19, 9), @ProdID int, @DocDate smalldatetime)/* Возвращает цену с НДС для товара */RETURNS numeric(19, 9) ASBegin  RETURN CASE (SELECT Count(1) FROM r_Prods WHERE ProdID = @ProdID)    WHEN 1 THEN      @Price + dbo.zf_GetTax(@Price, (SELECT ABS(PriceWithTax - 1) * dbo.zf_GetProdTaxPercent(@ProdID, @DocDate) FROM r_Prods WHERE ProdID = @ProdID))    ELSE      NULL    ENDEnd
GO