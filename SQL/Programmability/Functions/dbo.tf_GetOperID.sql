SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetOperID]()/* Возвращает код оператора, соответствующего текущему пользователю GMS */RETURNS int ASBEGIN  RETURN (SELECT TOP 1 OperID FROM r_Opers o WITH(NOLOCK), r_Users u WITH(NOLOCK) WHERE o.EmpID = u.EmpID AND u.UserID = dbo.zf_GetUserCode())END
GO