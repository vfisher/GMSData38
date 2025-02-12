SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_CorrectPriceForTax](@PriceCC numeric(19, 9), @TaxPercent numeric(19, 9))
/* Корректирует цену для НДС */
RETURNS numeric(19, 9) AS
Begin
  RETURN (dbo.zf_RoundPriceSale(@PriceCC / ((100 + @TaxPercent) / @TaxPercent)) * ((100 + @TaxPercent) / @TaxPercent))
End 
GO