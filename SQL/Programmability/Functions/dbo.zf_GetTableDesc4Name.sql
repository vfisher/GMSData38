SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetTableDesc4Name] (@TableName varchar(250))
/* Возвращает описание таблицы по ее имени */
RETURNS varchar(250) AS
Begin
  Declare @Desc varchar(250)
  SELECT @Desc = ISNULL(dbo.zf_TranslateMetadata(TableCode, /*mtTableDesc*/ 10), TableDesc) FROM z_Tables WITH(NOLOCK) WHERE TableName = @TableName
  SELECT @Desc = ISNULL(@Desc, @TableName)
  RETURN(@Desc)
End
GO