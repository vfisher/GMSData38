SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*----------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[zf_GetTableDesc4Name] (@TableName varchar(250))
/* Возвращает описание таблицы по ее имени */
RETURNS varchar(250) AS
Begin
  Declare @Desc varchar(250)

  SELECT @Desc = TableDesc FROM z_Tables WITH(NOLOCK) WHERE TableName = @TableName
  SELECT @Desc = ISNULL(@Desc, @TableName)
  RETURN(@Desc)
End
GO
