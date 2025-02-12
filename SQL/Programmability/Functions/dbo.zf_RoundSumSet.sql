SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_RoundSumSet](@Num numeric(19, 9))
/* Округляет число как сумму комплектующих */
RETURNS numeric(19, 9)
Begin
  RETURN dbo.zf_RoundAs(@Num, 't_RoundSDocSum')
End
GO