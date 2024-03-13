SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetUserCode]()/* Возвращает код пользователя GMS по имени текущего пользователя SQL Server */RETURNS int ASBegin  RETURN(SELECT UserID FROM r_Users WITH(NOLOCK) WHERE UserName = SUSER_SNAME())End
GO
