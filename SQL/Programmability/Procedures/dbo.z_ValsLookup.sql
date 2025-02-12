SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_ValsLookup](@ExprStr varchar(250), @Vals varchar(4000), @out varchar(250) OUT) /* Рассчитывает значение выражения по данным набора Vals */AS  DECLARE @SQL nvarchar(4000)  SET @out = NULL  SET @SQL = N'SELECT TOP 1 @out = CAST(' + @ExprStr + ' AS varchar(250)) FROM ' + @Vals  EXEC sp_executesql @SQL, N'@out varchar(250) OUT', @out OUT
GO