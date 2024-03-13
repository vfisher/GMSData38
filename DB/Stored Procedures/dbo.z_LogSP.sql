SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_LogSP](@ObjName varchar(200), @UserAction tinyint)
AS
/* Выполняет логирование действий пользователя во время установки сервис пака */
/* 0 - Не заменять
   1 - Не заменять (для всех)
   2 - Заменить
   3 - Заменить (для всех) */
BEGIN
  DECLARE @AChID bigint
  EXEC z_NewChID 'z_LogTools', @AChID OUTPUT

  INSERT INTO dbo.z_LogTools (ChID, DocDate, RepToolCode, Note1, Note2, Note3, UserCode)
  VALUES (@AChID, GETDATE(), 50203, @ObjName, CAST(@UserAction AS varchar(3)), '', dbo.zf_GetUserCode())
END
GO
