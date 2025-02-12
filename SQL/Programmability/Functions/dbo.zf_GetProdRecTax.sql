SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetProdRecTax](@ProdID int, @CompID int, @OurID int, @DocDate smalldatetime)/* Возвращает ставку НДС для товара в зависимости от поставщика */RETURNS numeric(21, 9) ASBEGIN  RETURN (SELECT dbo.zf_GetProdTaxPercent(@ProdID, @DocDate) * c.TaxPayer * o.TaxPayer FROM r_Comps c, r_Ours o WHERE c.CompID = @CompID AND o.OurID = @OurID)END
GO