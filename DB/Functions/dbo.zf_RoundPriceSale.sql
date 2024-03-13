SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_RoundPriceSale](@Num numeric(19, 9))
/* Округляет число как цену продажи */
RETURNS numeric(19, 9)
Begin
  RETURN dbo.zf_RoundAs(@Num, 'z_RoundPriceSale')
End 
GO
