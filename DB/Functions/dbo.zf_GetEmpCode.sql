SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetEmpCode]()
/* Возвращает код служащего для текущего пользователя */
RETURNS int AS
BEGIN
  RETURN (SELECT EmpID FROM r_Users WHERE UserID = dbo.zf_GetUserCode()) 
END
GO
