SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_TableLookup](@ExprStr varchar(250), @TableCode int, @FilterStr varchar(4000), @out varchar(250) OUT) /* Рассчитывает значение выражения по данным таблицы с фильтром */AS  DECLARE @SQL nvarchar(4000)  SET @out = NULL  SET @SQL = N'SELECT TOP 1 @out = CAST(' + @ExprStr + ' AS varchar(250)) FROM ' + (SELECT TableName FROM z_Tables WHERE TableCode = @TableCode)  IF @FilterStr <> '' SET @SQL = @SQL + ' WHERE ' + @FilterStr  EXEC sp_executesql @SQL, N'@out varchar(250) OUT', @out OUT
GO