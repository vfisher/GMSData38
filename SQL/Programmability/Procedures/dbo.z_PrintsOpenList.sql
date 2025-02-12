SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_PrintsOpenList](@appCodeStr varchar(200))AS/* Возвращает список печатных форм */BEGIN  SELECT * FROM z_AppPrints WHERE AppCode IN (100, @appCodeStr) ORDER BY AppCode, FileDescEND
GO