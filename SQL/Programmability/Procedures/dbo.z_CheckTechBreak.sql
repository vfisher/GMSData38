SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_CheckTechBreak](@NotificationType tinyint OUTPUT, @Message varchar(250) OUTPUT, @LockAdminApps bit OUTPUT)
/* Уведомляет пользователя о начале выполнения технических работ с БД */
/* @NotificationType:
     0 - нет действия
     1 - предупреждение для пользователя
     2 - блокировка работы приложения до окончания работ
   @Message - сообщение, выдаваемое пользователю при @NotificationType > 0
   @LockAdminApps - дополнительно блокировать административные приложения (Дизайнер, Мен. доступа, Мен. ПФ и т.д.)
 */
AS
BEGIN
  RETURN	
END
GO