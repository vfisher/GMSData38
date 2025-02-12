SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetTaxPercentByDate](@TaxTypeID INT, @Date smallDATETIME)/* Возвращает ставку налога на указанную дату */RETURNS numeric(21, 9) ASBegin  DECLARE @TaxPercent numeric(21, 9)  SELECT TOP 1 @TaxPercent = TaxPercent FROM r_TaxRates  WHERE TaxTypeID = @TaxTypeID AND ChDate <= ISNULL(@Date, 0)  ORDER BY ChDate DESC  RETURN @TaxPercentEND
GO