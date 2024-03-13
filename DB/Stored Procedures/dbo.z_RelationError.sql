SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_RelationError] (@MainTable varchar(250), @ForeignTable varchar(250), @RelationType int) AS
/* Возбуждает ошибку при нарушении ссылочной целостности в триггере */
Begin
  Declare @ErrMsg varchar(250), @MainDesc varchar(250), @ForeignDesc varchar(250)

  SELECT @MainDesc = dbo.zf_GetTableDesc4Name (@MainTable)
  SELECT @ForeignDesc = dbo.zf_GetTableDesc4Name (@ForeignTable)

  SELECT @MainDesc = @MainDesc + ' (' + @MainTable + ')'
  SELECT @ForeignDesc = @ForeignDesc + ' (' + @ForeignTable + ')'

  IF      @RelationType = 0 Select @ErrMsg = 'Невозможно добавление данных в таблицу ''' + @ForeignDesc + '''. Отсутствуют данные в главной таблице ''' + @MainDesc + '''.'
  ELSE IF @RelationType = 1 Select @ErrMsg = 'Невозможно изменение данных в таблице ''' + @ForeignDesc + '''. Отсутствуют данные в главной таблице ''' + @MainDesc + '''.'
  ELSE IF @RelationType = 2 Select @ErrMsg = 'Невозможно изменение данных в таблице ''' + @MainDesc + '''. Существуют данные в подчиненной таблице ''' + @ForeignDesc + '''.'
  ELSE IF @RelationType = 3 Select @ErrMsg = 'Невозможно удаление данных в таблице ''' + @MainDesc + '''. Существуют данные в подчиненной таблице ''' + @ForeignDesc + '''.'
  RAISERROR (@ErrMsg, 18, 1)
  IF @@TranCount > 0 Rollback Transaction
End
GO
