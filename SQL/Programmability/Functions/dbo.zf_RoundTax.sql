SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_RoundTax](@Num numeric(19, 9))
/* Округляет число как НДС цены */
RETURNS numeric(19, 9)
Begin
  RETURN dbo.zf_RoundAs(@Num, 'z_RoundTax')
End 
GO