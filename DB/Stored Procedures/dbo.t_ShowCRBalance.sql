SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_ShowCRBalance] @CRID int
/* Возвращает баланс по кассе (для отображения пользователю) */
AS
BEGIN
  DECLARE @ParamsIn varchar(max) 
  DECLARE @ParamsOut varchar(max)
  DECLARE @SaleSumCash numeric(19, 9)
  DECLARE @SaleSumCCard numeric(19, 9)
  DECLARE @SaleSumCredit numeric(19, 9)
  DECLARE @SaleSumCheque numeric(19, 9)
  DECLARE @SaleSumOther numeric(19, 9)
  DECLARE @MRec numeric(19, 9)
  DECLARE @MExp numeric(19, 9)
  DECLARE @SumCash numeric(19, 9)
  DECLARE @InitialBalance numeric(19, 9)
  DECLARE @CashBack numeric(19, 9)

  DECLARE @CashType int, @NoExpMode bit
  SET @CashType = ISNULL((SELECT TOP 1 CashType FROM r_CRs WITH (NOLOCK) WHERE CRID = @CRID),0)
  SET @NoExpMode = ISNULL((SELECT TOP 1 NoExpMode FROM r_WPRoles WITH (NOLOCK) WHERE WPRoleID IN (SELECT WPRoleID FROM r_WPs WITH (NOLOCK) WHERE CRID = @CRID)),0)

  SET @ParamsIn = (SELECT @CRID AS CRID FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)

  EXEC t_GetCRBalance @ParamsIn, @ParamsOut OUTPUT

  SET @MRec = JSON_VALUE(@ParamsOut, '$.MRec')
  SET @MExp = JSON_VALUE(@ParamsOut, '$.MExp')
  SET @SaleSumCash = JSON_VALUE(@ParamsOut, '$.SaleSumCash')
  SET @SaleSumCCard = JSON_VALUE(@ParamsOut, '$.SaleSumCCard')
  SET @SaleSumCredit = JSON_VALUE(@ParamsOut, '$.SaleSumCredit')
  SET @SaleSumCheque = JSON_VALUE(@ParamsOut, '$.SaleSumCheque')
  SET @SaleSumOther = JSON_VALUE(@ParamsOut, '$.SaleSumOther')
  SET @InitialBalance = JSON_VALUE(@ParamsOut, '$.InitialBalance')
  SET @CashBack = JSON_VALUE(@ParamsOut, '$.CashBack')
  SET @SumCash = JSON_VALUE(@ParamsOut, '$.SumCash')

  /*  10 - TCashRegMariy_MT3, 18 - TCashRegMariy_MT7, 39 - TCashRegInet (ПРРО) */
  IF (@CashType = 10) OR (@CashType = 18) OR (@CashType = 39 AND @NoExpMode = 1)
    SELECT
      @MRec AS 'Служебные вносы'
      ,@MExp AS 'Служебные выносы'
      ,@SaleSumCash AS 'Выручка (наличные)'
      ,@SaleSumCCard AS 'Выручка (платежные карты)'
      ,@SaleSumCredit AS 'Выручка (кредит)'
      ,@SaleSumCheque AS 'Выручка (чеки)'
      ,@SaleSumOther AS 'Выручка (другое)'
      ,(@SaleSumCCard + @SaleSumCredit + @SaleSumCheque + @SaleSumOther) AS 'Выручка (безналичные оплаты)'
      ,@InitialBalance AS 'Остаток на начало смены'
      ,@CashBack AS 'Выдано наличных'
      ,@SumCash + CASE WHEN @CashType = 39 THEN @InitialBalance ELSE 0 END AS 'Наличность в кассе'
  ELSE
    SELECT
       @MRec AS 'Служебные вносы'
      ,@MExp AS 'Служебные выносы'
      ,@SaleSumCash AS 'Выручка (наличные)'
      ,@SaleSumCCard AS 'Выручка (платежные карты)'
      ,@SaleSumCredit AS 'Выручка (кредит)'
      ,@SaleSumCheque AS 'Выручка (чеки)'
      ,@SaleSumOther AS 'Выручка (другое)'
      ,(@SaleSumCCard + @SaleSumCredit + @SaleSumCheque + @SaleSumOther) AS 'Выручка (безналичные оплаты)'
      ,@CashBack AS 'Выдано наличных'
      ,@SumCash AS 'Наличность в кассе'
END
GO
