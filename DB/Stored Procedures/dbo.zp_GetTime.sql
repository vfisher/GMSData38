SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[zp_GetTime]AS/* Возвращает время без даты, как GETDATE */BEGIN  SELECT  CAST (CAST(DATEPART(hh, GETDATE()) AS varchar(2)) + ':' + CAST(DATEPART(mi, GETDATE()) AS varchar(2)) AS smalldatetime)END
GO
