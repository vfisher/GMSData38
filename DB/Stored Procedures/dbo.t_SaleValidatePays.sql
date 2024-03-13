SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleValidatePays] @IsRet bit, @ChID bigint, @CanContinue bit OUTPUT, @Msg varchar(200) OUTPUT
/* Проверяет корректность оплат по чеку */
AS
BEGIN
  SET @CanContinue = 1
  SET @Msg = ''

  IF 
    CAST(@IsRet AS bit) = 0 AND ISNULL((SELECT SUM(SumCC_wt) FROM t_SaleTempPays WHERE ChID = @ChID AND PayFormCode = 1), 0) < 0 OR
    CAST(@IsRet AS bit) = 1 AND ISNULL((SELECT SUM(SumCC_wt) FROM t_CRRetPays    WHERE ChID = @ChID AND PayFormCode = 1) , 0) < 0
    BEGIN
      SET @CanContinue = 0
      SET @Msg = 'Сдача не может быть больше суммы наличными'
    END

  /* Проверка доступности суммы для оплаты возврата */
  IF CAST(@IsRet AS bit) = 1 
    BEGIN
      DECLARE @CRID int
	  DECLARE @ParamsIn varchar(max) 
	  DECLARE @ParamsOut varchar(max)

      DECLARE @SumCash numeric(21, 9)
      DECLARE @InitialBalance numeric(21, 9)
      DECLARE @NoExpMode bit

      SELECT @CRID = CRID FROM t_CRRet WHERE ChID = @ChID
      SET @NoExpMode = ISNULL((SELECT TOP 1 NoExpMode FROM r_WPRoles WITH (NOLOCK) WHERE WPRoleID IN (SELECT WPRoleID FROM r_WPs WITH (NOLOCK) WHERE CRID = @CRID)),0)
	  SET @ParamsIn = (SELECT @CRID AS CRID FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)

	  EXEC t_GetCRBalance @ParamsIn, @ParamsOut OUTPUT

	  SET @SumCash = JSON_VALUE(@ParamsOut, '$.SumCash')
	  SET @InitialBalance = JSON_VALUE(@ParamsOut, '$.InitialBalance')

      /* Поскольку @SumCash уже учитывает возврат, то достаточно проверить на отрицательность */
      IF (@SumCash + CASE WHEN @NoExpMode = 1 THEN @InitialBalance ELSE 0 END) < 0
        BEGIN
          SET @CanContinue = 0
          SET @Msg = 'В кассе недостаточно средств для оплаты возврата'
        END
    END
END
GO
