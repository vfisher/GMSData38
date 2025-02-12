SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_GetIntDocID] (@TableCode int, @Vals varchar(3600))/* Возвращает доп. номер документа */AS DECLARE @SQL nvarchar(4000) SET @SQL = N'SELECT (CASE WHEN IntDocID = '''' THEN CAST(DocID as varchar(50)) ELSE IntDocID END) AS Col1 FROM ' + @Vals EXEC sp_executesql @SQL
GO