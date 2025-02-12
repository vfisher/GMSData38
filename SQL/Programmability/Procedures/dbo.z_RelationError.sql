SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_RelationError] (@MainTable varchar(250), @ForeignTable varchar(250), @RelationType int) AS
/* Возбуждает ошибку при нарушении ссылочной целостности в триггере */
Begin
  Declare @ErrMsg varchar(250), @MainDesc varchar(250), @ForeignDesc varchar(250)

  SELECT @MainDesc = dbo.zf_GetTableDesc4Name (@MainTable)
  SELECT @ForeignDesc = dbo.zf_GetTableDesc4Name (@ForeignTable)

  SELECT @MainDesc = @MainDesc + ' (' + @MainTable + ')'
  SELECT @ForeignDesc = @ForeignDesc + ' (' + @ForeignTable + ')'

  IF      @RelationType = 0 Select @ErrMsg = FORMATMESSAGE(dbo.zf_Translate('Невозможно добавление данных в таблицу ''%s''. Отсутствуют данные в главной таблице ''%s''.'), @ForeignDesc, @MainDesc)
  ELSE IF @RelationType = 1 Select @ErrMsg = FORMATMESSAGE(dbo.zf_Translate('Невозможно изменение данных в таблице ''%s''. Отсутствуют данные в главной таблице ''%s''.'), @ForeignDesc, @MainDesc)
  ELSE IF @RelationType = 2 Select @ErrMsg = FORMATMESSAGE(dbo.zf_Translate('Невозможно изменение данных в таблице ''%s''. Существуют данные в подчиненной таблице ''%s''.'), @MainDesc, @ForeignDesc)
  ELSE IF @RelationType = 3 Select @ErrMsg = FORMATMESSAGE(dbo.zf_Translate('Невозможно удаление данных в таблице ''%s''. Существуют данные в подчиненной таблице ''%s''.'), @MainDesc, @ForeignDesc)
  RAISERROR (@ErrMsg, 18, 1)
  IF @@TranCount > 0 Rollback Transaction
End
GO