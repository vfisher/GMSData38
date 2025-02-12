SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetTax](@Sum numeric(19, 9), @TaxPercent numeric(19, 9))
/* Возвращает сумму внешнего налога для указанной сумы и процента налога */
RETURNS numeric(19, 9) AS
Begin
  RETURN @Sum * @TaxPercent / 100
End 
GO