SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_RoundAs](@Num numeric(19, 9), @PrecisionVar varchar(200))
/* Округляет число с точностью из переменной */
RETURNS numeric(19, 9)
Begin
  RETURN dbo.zf_Round(@Num, CAST(dbo.zf_Var(@PrecisionVar) AS numeric(19,9)))
End 
GO
