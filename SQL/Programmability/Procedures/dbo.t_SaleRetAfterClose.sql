SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleRetAfterClose](@ParamsIn varchar(max), @ParamsOut varchar(max) OUTPUT)
/* Процедура после закрытия чека */
AS          
BEGIN
  DECLARE
    @AppCode int,
    @ChID bigint,
    @PersonID BIGINT,    /* Код клиента */
    @Continue bit,       /* Продолжать ли процедуру закрытия чека */
    @Msg varchar(200),   /* Сообщение, выводимое на клиенте в независимости от остальных возвращаемых параметров */
    @Result int,          /* Result AND (Not Continue) - Считать чек закрытым и не продолжать процедуру закрытия
                            Result AND Continue - Продолжить процедуру закрытия чека */
	@CashType int						

  SET @ParamsOut = '{}'
  SET @ChID = JSON_VALUE(@ParamsIn, '$.ChID')
  SET @PersonID = JSON_VALUE(@ParamsIn, '$.PersonID')
  SET @AppCode = JSON_VALUE(@ParamsIn, '$.AppCode')

  SET @CashType = ISNULL((SELECT CashType FROM r_CRs WITH(NOLOCK) WHERE CRID = (SELECT CRID FROM t_CRRet WITH(NOLOCK) WHERE ChID = @ChID)),0)
  
  SET @Msg = ''
  SET @Continue = CAST(1 AS bit)
  SET @Result = 1
  IF @AppCode <> 26000 OR (@AppCode = 26000 AND @CashType <> 39)
    UPDATE t_CRRet 
	SET StateCode = dbo.zf_Var('t_ChequeStateCode') 
	WHERE ChID = @ChID

  SET @ParamsOut = (SELECT @Continue AS [Continue], @Msg AS Msg FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
END
GO