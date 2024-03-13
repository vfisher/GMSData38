SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_RoundTaxSum](@Num numeric(19, 9))
/* Округляет число как сумму НДС */
RETURNS numeric(19, 9)
Begin
  RETURN dbo.zf_RoundAs(@Num, 'z_RoundTaxSum')
End 
GO
