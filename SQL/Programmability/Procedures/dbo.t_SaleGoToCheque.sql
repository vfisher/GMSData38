SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGoToCheque](@CRID int, @ChID bigint, @Continue int OUTPUT, @Msg varchar(200) OUTPUT)
/* Переходит к отложенному чеку */
AS
BEGIN
  /*
    @Continue
    0 - прервать процедуру
    1 - перейти к чеку
  */
  SET @Continue = 1
  SET @Msg = ''     /* Сообщение, выводимое на клиенте в независимости от остальных возвращаемых параметров */

  /* Для перехода к чеку другой кассы обязательно заапдейтить t_SaleTemp.CRID*/ 

  /* !!! Если неизвестен результат оплаты терминала (DocState = 20) - не обновлять на 0 !!! */
  UPDATE t_SaleTemp SET DocState = 0, DocTime = GetDate() WHERE ChID = @ChID AND DocState <> 20
END
GO