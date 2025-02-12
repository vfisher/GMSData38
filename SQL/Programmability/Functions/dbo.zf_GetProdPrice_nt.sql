SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetProdPrice_nt](@Price numeric(19, 9), @ProdID int, @DocDate smalldatetime)/* Возвращает цену без НДС для товара */RETURNS numeric(21, 9) ASBegin  RETURN CASE (SELECT Count(1) FROM r_Prods WHERE ProdID = @ProdID)    WHEN 1 THEN      @Price - dbo.zf_GetProdPrice_wtTax(@Price, @ProdID, @DocDate)    ELSE      NULL    ENDEnd
GO