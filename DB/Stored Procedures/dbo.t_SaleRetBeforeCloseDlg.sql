SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleRetBeforeCloseDlg] (@ChID bigint,
        @CancelCheque bit,          /* Произовдится отмена всего чека */
        @Continue bit OUTPUT,       /* Продолжать ли процедуру закрытия чека */
        @Msg varchar(200) OUTPUT,   /* Сообщение, выводимое на клиенте в независимости от остальных возвращаемых параметров */
        @Result int OUTPUT)         /* Result AND (Not Continue) - Считать чек закрытым и не продолжать процедуру закрытия
                                       Result AND Continue - Продолжить процедуру закрытия чека */ 
/* Подготовка перед диалогом закрытия возвратного чека */
AS          
Begin
  SET @Msg = ''
  IF (SELECT COUNT(*) FROM t_CRRetD WHERE ChID = @ChID) = 0
  BEGIN
    DELETE FROM t_CRRet WHERE ChID = @ChID
    SET @Continue = CAST(0 AS bit)
    SET @Result = 1
    RETURN
  END
  SET @Continue = CAST(1 AS bit)
  SET @Result = 1
End
GO
