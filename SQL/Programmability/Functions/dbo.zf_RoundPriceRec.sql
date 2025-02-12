SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_RoundPriceRec](@Num numeric(19, 9))
/* Округляет число как цену прихода */
RETURNS numeric(19, 9)
Begin
  RETURN dbo.zf_RoundAs(@Num, 'z_RoundPriceRec')
End 
GO