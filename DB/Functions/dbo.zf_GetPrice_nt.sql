SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetPrice_nt](@Price numeric(19, 9), @TaxPercent int)
/* Возвращает цену без налога */
RETURNS numeric(21, 9) AS
Begin
  RETURN @Price - dbo.zf_GetIncludedTax(@Price, @TaxPercent)
End 
GO
