SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetTaxPercent](@TaxTypeID INT)/* Возвращает ставку налога на сейчас */RETURNS numeric(21, 9) ASBegin  RETURN dbo.zf_GetTaxPercentByDate(@TaxTypeID, (SELECT Now FROM vz_Now))End
GO
