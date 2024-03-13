SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetOurID](@AppPrefix char(1))
/* Возвращает код внутренней фирмы для текущего пользователя */
RETURNS INT AS
BEGIN
  RETURN (SELECT dbo.zf_UserVar(@AppPrefix + '_OurID'))
END
GO
