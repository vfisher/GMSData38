SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleRetAfterClose](@ChID bigint,
        @PersonID BIGINT,              /* Код клиента */
        @Continue bit OUTPUT,       /* Продолжать ли процедуру закрытия чека */
        @Msg varchar(200) OUTPUT,   /* Сообщение, выводимое на клиенте в независимости от остальных возвращаемых параметров */
        @Result int OUTPUT)         /* Result AND (Not Continue) - Считать чек закрытым и не продолжать процедуру закрытия
                                       Result AND Continue - Продолжить процедуру закрытия чека */ 
/* Процедура после закрытия чека */
AS          
BEGIN
  SET @Msg = ''
  SET @Continue = CAST(1 AS bit)
  SET @Result = 1
  UPDATE t_CRRet SET StateCode = 22 WHERE ChID = @ChID
END
GO
