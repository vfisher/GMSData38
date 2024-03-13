SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetTaxID](@TaxPercent numeric(21,9), @DocDate smalldatetime)/* Возвращает налоговую группу */RETURNS int ASBEGIN  RETURN(SELECT TOP 1 m.TaxID  	     FROM r_Taxes m  	     JOIN r_TaxRates d ON m.TaxTypeID = d.TaxTypeID  	     WHERE d.TaxPercent = @TaxPercent AND d.ChDate <= @DocDate AND m.TaxID IS NOT NULL  	     ORDER BY d.ChDate DESC, d.TaxTypeID ASC)END
GO
