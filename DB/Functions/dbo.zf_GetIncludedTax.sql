SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetIncludedTax](@Sum numeric(19, 9), @TaxPercent numeric(19, 9))
/* Возвращает сумму внутреннего налога для указанной суммы и процента налога */
RETURNS numeric(19, 9) AS
Begin
  RETURN CASE @TaxPercent WHEN 0 THEN 0 ELSE @Sum / (100 + @TaxPercent) * @TaxPercent END
End 
GO
