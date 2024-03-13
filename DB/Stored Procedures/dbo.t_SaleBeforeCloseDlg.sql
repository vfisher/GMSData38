SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleBeforeCloseDlg](
   @ChID bigint,
   @CancelCheque bit,        /* Производится отмена всего чека */
   @Continue bit OUTPUT,     /* Продолжать ли процедуру закрытия чека */
   @Msg varchar(2000) OUTPUT, /* Сообщение, выводимое Торговым Клиентом независимо от остальных возвращаемых параметров */
   @Result int OUTPUT)       /* Result AND (NOT Continue) - Считать чек закрытым и не продолжать процедуру закрытия
                                Result AND Continue - Продолжить процедуру закрытия чека */
 /* Подготовка перед диалогом закрытия чека */
 AS
 BEGIN
   SET @Msg = ''
   SET @Continue = 1
   SET @Result = 1

   EXEC t_DiscBeforeClose 1011, @ChID, @CancelCheque, @Msg OUTPUT, @Continue OUTPUT
   IF @Continue = 0
     BEGIN
       SET @Result = 0
       RETURN
     END

   IF (SELECT COUNT(*) FROM t_SaleTempD WHERE ChID = @ChID) = 0
     BEGIN
       DELETE FROM t_SaleTemp WHERE ChID = @ChID
       SET @Continue = 0
       SET @Result = 1
     END
 END
GO
