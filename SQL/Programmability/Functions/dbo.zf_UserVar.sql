SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_UserVar](@VarName varchar(250))
RETURNS varchar(250) AS
/*Возвращает значение переменной пользователя*/
BEGIN
  RETURN (SELECT VarValue FROM z_UserVars WITH(NOLOCK/*, FASTFIRSTROW */) WHERE UserCode = dbo.zf_GetUserCode() AND VarName = @VarName)
END
GO