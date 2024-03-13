SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_DocLookup](@ExprStr varchar(250), @DocCode int, @ChID bigint, @out varchar(250) OUT)
/* Рассчитывает значение выражения по данным заголовка документа с фильтром по коду регистрации */
AS
 DECLARE @TableCode int, @FilterStr varchar(250)
 SELECT @TableCode = TableCode FROM z_Tables WHERE DocCode = @DocCode AND IsDefault = 1
 SET @FilterStr = 'ChID = ' + CAST(@ChID AS varchar(20))
 EXEC z_TableLookup @ExprStr, @TableCode, @FilterStr, @out OUT
GO
