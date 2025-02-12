SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_Var](@VarName varchar(200))
/* Возвращает значение переменной */
RETURNS varchar(200) AS
BEGIN
  RETURN (SELECT VarValue FROM z_Vars WITH(NOLOCK/*, FASTFIRSTROW */) WHERE VarName = @VarName)
END
GO