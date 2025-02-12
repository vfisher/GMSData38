SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetCommunalTaxRate](@Date datetime, @TaxRegionID int)/* Возвращает сумму коммунального налога для региона местных налогов */RETURNS numeric(21,9) ASBEGIN RETURN   ISNULL((SELECT TOP 1 CommunalTaxRate FROM r_TaxRegionRates WHERE TaxRegionID = @TaxRegionID AND SrcDate <= @Date ORDER BY SrcDate DESC), 0)END
GO