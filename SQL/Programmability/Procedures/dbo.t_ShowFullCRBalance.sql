SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_ShowFullCRBalance] @ParamsIn VARCHAR(MAX)
/* Возвращает баланс по кассе (для отображения пользователю) */
AS
BEGIN
  /* Sample:
  SET @ParamsIn = {
 "ChequesCountCashBack": 0,
 "SaleRndSum": 0,
 "RetSumByTax_10_Levy2": 0,
 "SumPayCheque": 0,
 "RetSumByTax_8": 0,
 "RetSumByTax_7": 0,
 "RetSumByTax_6": 0,
 "RetSumByTax_5": 0,
 "RetSumByTax_4": 0,
 "RetSumByTax_3": 0,
 "RetSumByTax_2": 0,
 "RetSumByTax_1": 0,
 "SumPayCCard": 0,
 "TaxSum_10_Levy2": 0,
 "SumIncrease": 0,
 "SumPayCash": 42.5,
 "SumByTax_8": 0,
 "SumByTax_7": 0,
 "SumByTax_6": 0,
 "SumByTax_5": 0,
 "SumByTax_4": 0,
 "SumByTax_3": 0,
 "SumByTax_2": 0,
 "SumByTax_1": 42.5,
 "RetSumType2": 0,
 "RetSumType1": 0,
 "RetSumType0": 0,
 "SumOutMoney": 0,
 "SumCashBack": 0,
 "SumRem": 2293.86,
 "SumPayOther": 0,
 "QtyInMoney": 0,
 "RetSumByTax_9_Levy1": 0,
 "QtyAnnul": 0,
 "RetSumCheque": 0,
 "QtyReduction": 0,
 "FKCH3_Sum": 0,
 "FKCH3_Qty": 0,
 "SaleNoRndSum": 0,
 "SumPayCredit": 0,
 "SumSales_wt": 42.5,
 "RetSumCustom5": 0,
 "RetSumCustom4": 0,
 "RetSumCustom3": 0,
 "RetSumCustom2": 0,
 "RetSumCustom1": 0,
 "InitialBalance": 2251.36,
 "TaxSum_9_Levy1": 0,
 "RetTaxSum_10_Levy2": 0,
 "SumByTax_9_Levy1": 0,
 "SaleSumCCardCashBack": 0,
 "SaleSumCustom5": 0,
 "SaleSumCustom4": 0,
 "SaleSumCustom3": 0,
 "SaleSumCustom2": 0,
 "SaleSumCustom1": 0,
 "SumInMoney": 0,
 "RetTaxSum_9_Levy1": 0,
 "RetTaxSum_8": 0,
 "RetTaxSum_7": 0,
 "RetTaxSum_6": 0,
 "RetTaxSum_5": 0,
 "RetTaxSum_4": 0,
 "RetTaxSum_3": 0,
 "RetTaxSum_2": 0,
 "RetTaxSum_1": 0,
 "QtyCheque": 2,
 "RetSumOther": 0,
 "QtyIncrease": 0,
 "SumSales": 42.5,
 "SumByTax_10_Levy2": 0,
 "RetSumCredit": 0,
 "IsOfflineMode": false,
 "NoExpMode": false,
 "RetSumCash": 0,
 "RetSumCard": 0,
 "QtyOutMoney": 0,
 "SumReduction": 0,
 "SumAnnul": 0,
 "CRID": 21,
 "SaleSumType2": 0,
 "SaleSumType1": 0,
 "SaleSumType0": 42.5,
 "RetRndSum": 0,
 "TaxSum_8": 0,
 "TaxSum_7": 0,
 "TaxSum_6": 0,
 "TaxSum_5": 0,
 "TaxSum_4": 0,
 "TaxSum_3": 0,
 "TaxSum_2": 0,
 "TaxSum_1": 7.08,
 "RetNoRndSum": 0,
 "OperID": 1,
 "ZRepNum": 0,
 "WPID": 0
}
*/

/* From t_ShowCRBalance:
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
*/


  DECLARE @CRID int, @IsOfflineMode bit, @IsNoExpMode bit

  DECLARE @InitialBalanceCR numeric(19, 9), @SumRemCR numeric(19, 9)
  DECLARE @InitialBalanceDB numeric(19, 9), @SumRemDB numeric(19, 9)
  DECLARE @SaleSumType0CR numeric(21, 9), @SaleSumType1CR numeric(21, 9), @SaleSumType2CR numeric(21, 9), @RetSumType0CR numeric(21, 9), @RetSumType1CR numeric(21, 9), @RetSumType2CR numeric(21, 9)
  DECLARE @SaleSumType0DB numeric(21, 9), @SaleSumType1DB numeric(21, 9), @SaleSumType2DB numeric(21, 9), @RetSumType0DB numeric(21, 9), @RetSumType1DB numeric(21, 9), @RetSumType2DB numeric(21, 9)
  DECLARE @ChequesCountSaleCR int, @ChequesCountRetCR int, @ChequesCountCashBackCR int, @ChequesCountInMoneyCR int, @ChequesCountOutMoneyCR int, @ChequesCountTransferFundsCR int
  DECLARE @ChequesCountSaleDB int, @ChequesCountRetDB int, @ChequesCountCashBackDB int, @ChequesCountInMoneyDB int, @ChequesCountOutMoneyDB int, @ChequesCountTransferFundsDB int
  DECLARE @SumMonRecCR numeric(21, 9), @SumMonExpCR numeric(21, 9), @SumCashBackCR numeric(21, 9), @SumCashTransferFundsCR numeric(21, 9)
  DECLARE @SumMonRecDB numeric(21, 9), @SumMonExpDB numeric(21, 9), @SumCashBackDB numeric(21, 9), @SumCashTransferFundsDB numeric(21, 9) 

  DECLARE @SumByTax_0CR numeric(21, 9), @SumByTax_1CR numeric(21, 9), @SumByTax_2CR numeric(21, 9), @SumByTax_3CR numeric(21, 9), @SumByTax_4CR numeric(21, 9), @SumByTax_5CR numeric(21, 9), @SumByTax_6CR numeric(21, 9), @SumByTax_7CR numeric(21, 9)
  DECLARE @SumByTax_0DB numeric(21, 9), @SumByTax_1DB numeric(21, 9), @SumByTax_2DB numeric(21, 9), @SumByTax_3DB numeric(21, 9), @SumByTax_4DB numeric(21, 9), @SumByTax_5DB numeric(21, 9), @SumByTax_6DB numeric(21, 9), @SumByTax_7DB numeric(21, 9)

  DECLARE @RetSumByTax_0CR numeric(21, 9), @RetSumByTax_1CR numeric(21, 9), @RetSumByTax_2CR numeric(21, 9), @RetSumByTax_3CR numeric(21, 9), @RetSumByTax_4CR numeric(21, 9), @RetSumByTax_5CR numeric(21, 9), @RetSumByTax_6CR numeric(21, 9), @RetSumByTax_7CR numeric(21, 9)
  DECLARE @RetSumByTax_0DB numeric(21, 9), @RetSumByTax_1DB numeric(21, 9), @RetSumByTax_2DB numeric(21, 9), @RetSumByTax_3DB numeric(21, 9), @RetSumByTax_4DB numeric(21, 9), @RetSumByTax_5DB numeric(21, 9), @RetSumByTax_6DB numeric(21, 9), @RetSumByTax_7DB numeric(21, 9)

  DECLARE @TaxSum_0CR numeric(21, 9), @TaxSum_1CR numeric(21, 9), @TaxSum_2CR numeric(21, 9), @TaxSum_3CR numeric(21, 9), @TaxSum_4CR numeric(21, 9), @TaxSum_5CR numeric(21, 9), @TaxSum_6CR numeric(21, 9), @TaxSum_7CR numeric(21, 9)
  DECLARE @TaxSum_0DB numeric(21, 9), @TaxSum_1DB numeric(21, 9), @TaxSum_2DB numeric(21, 9), @TaxSum_3DB numeric(21, 9), @TaxSum_4DB numeric(21, 9), @TaxSum_5DB numeric(21, 9), @TaxSum_6DB numeric(21, 9), @TaxSum_7DB numeric(21, 9)

  DECLARE @RetTaxSum_0CR numeric(21, 9), @RetTaxSum_1CR numeric(21, 9), @RetTaxSum_2CR numeric(21, 9), @RetTaxSum_3CR numeric(21, 9), @RetTaxSum_4CR numeric(21, 9), @RetTaxSum_5CR numeric(21, 9), @RetTaxSum_6CR numeric(21, 9), @RetTaxSum_7CR numeric(21, 9)
  DECLARE @RetTaxSum_0DB numeric(21, 9), @RetTaxSum_1DB numeric(21, 9), @RetTaxSum_2DB numeric(21, 9), @RetTaxSum_3DB numeric(21, 9), @RetTaxSum_4DB numeric(21, 9), @RetTaxSum_5DB numeric(21, 9), @RetTaxSum_6DB numeric(21, 9), @RetTaxSum_7DB numeric(21, 9)

  DECLARE @SaleSumCashCR numeric(21, 9), @SaleSumCardCR numeric(21, 9), @SaleSumCreditCR numeric(21, 9), @SaleSumChequeCR numeric(21, 9), @SaleSumOtherCR numeric(21, 9), @SaleSumCCardCashBackCR numeric(21, 9)
  DECLARE @SaleSumCashDB numeric(21, 9), @SaleSumCardDB numeric(21, 9), @SaleSumCreditDB numeric(21, 9), @SaleSumChequeDB numeric(21, 9), @SaleSumOtherDB numeric(21, 9), @SaleSumCCardCashBackDB numeric(21, 9)
  DECLARE @SaleSumCustom1CR numeric(21, 9), @SaleSumCustom2CR numeric(21, 9), @SaleSumCustom3CR numeric(21, 9), @SaleSumCustom4CR numeric(21, 9), @SaleSumCustom5CR numeric(21, 9)
  DECLARE @SaleSumCustom1DB numeric(21, 9), @SaleSumCustom2DB numeric(21, 9), @SaleSumCustom3DB numeric(21, 9), @SaleSumCustom4DB numeric(21, 9), @SaleSumCustom5DB numeric(21, 9)
  DECLARE @RetSumCashCR numeric(21, 9), @RetSumCardCR numeric(21, 9), @RetSumCreditCR numeric(21, 9), @RetSumChequeCR numeric(21, 9), @RetSumOtherCR numeric(21, 9)
  DECLARE @RetSumCashDB numeric(21, 9), @RetSumCardDB numeric(21, 9), @RetSumCreditDB numeric(21, 9), @RetSumChequeDB numeric(21, 9), @RetSumOtherDB numeric(21, 9) 
  DECLARE @RetSumCustom1CR numeric(21, 9), @RetSumCustom2CR numeric(21, 9), @RetSumCustom3CR numeric(21, 9), @RetSumCustom4CR numeric(21, 9), @RetSumCustom5CR numeric(21, 9)
  DECLARE @RetSumCustom1DB numeric(21, 9), @RetSumCustom2DB numeric(21, 9), @RetSumCustom3DB numeric(21, 9), @RetSumCustom4DB numeric(21, 9), @RetSumCustom5DB numeric(21, 9)

  DECLARE @SaleRndSumCR numeric(21, 9), @SaleNoRndSumCR numeric(21, 9), @RetRndSumCR numeric(21, 9), @RetNoRndSumCR numeric(21, 9)
  DECLARE @SaleRndSumDB numeric(21, 9), @SaleNoRndSumDB numeric(21, 9), @RetRndSumDB numeric(21, 9), @RetNoRndSumDB numeric(21, 9)
  DECLARE @Cat1 varchar(250), @Cat2 varchar(250), @Name varchar(250)
   

  DECLARE @CashType int
  DECLARE @ParamsOut varchar(max)

  DROP TABLE IF EXISTS #Sale
  DROP TABLE IF EXISTS #SalePays
  DROP TABLE IF EXISTS #RetPays
  DROP TABLE IF EXISTS #Taxes
  DROP TABLE IF EXISTS #SaleTaxes
  DROP TABLE IF EXISTS #Rezult
  

  CREATE TABLE #Sale(Cat1 varchar(250), Cat2 varchar(250), [Name] varchar(250), ValueDB numeric(21,9), ValueCR numeric(21,9), Diff numeric(21,9))
  CREATE TABLE #SalePays(PayFormCode int, PayFormName varchar(250), CRPayFormCode int, SumDB numeric(21,9), SumCR numeric(21,9), Diff numeric(21,9))
  CREATE TABLE #RetPays(PayFormCode int, PayFormName varchar(250), CRPayFormCode int, SumDB numeric(21,9), SumCR numeric(21,9), Diff numeric(21,9))
  
  CREATE TABLE #Taxes(TaxTypeID int, TaxID int,	Letter varchar(1),	TaxPercent numeric(21,9), TaxName varchar(250), TaxPerName varchar(250))
  CREATE TABLE #SumSaleTaxes(Cat1 varchar(250), Cat2 varchar(250), [Name] varchar(250), ValueDB numeric(21,9), ValueCR numeric(21,9), Diff numeric(21,9))
  CREATE TABLE #SumRetTaxes(Cat1 varchar(250), Cat2 varchar(250), [Name] varchar(250), ValueDB numeric(21,9), ValueCR numeric(21,9), Diff numeric(21,9))
  CREATE TABLE #SaleTaxes(Cat1 varchar(250), Cat2 varchar(250), [Name] varchar(250), ValueDB numeric(21,9), ValueCR numeric(21,9), Diff numeric(21,9))
  CREATE TABLE #RetTaxes(Cat1 varchar(250), Cat2 varchar(250), [Name] varchar(250), ValueDB numeric(21,9), ValueCR numeric(21,9), Diff numeric(21,9))

  CREATE TABLE #Rezult(ID int identity, Cat1 varchar(250), Cat2 varchar(250), [Name] varchar(250), ValueDB numeric(21,9), ValueCR numeric(21,9), Diff numeric(21,9))

  /* Begin: CR */
  /* Код РРО */
  SET @CRID = JSON_VALUE(@ParamsIn, '$.CRID')
  /* Тип РРО */
  SET @CashType = (SELECT CashType FROM r_CRs WITH(NOLOCK) WHERE CRID = @CRID)
  /* Режим роботи РРО (онлайн/офлайн) */
  SET @IsOfflineMode = JSON_VALUE(@ParamsIn, '$.IsOfflineMode')
  /* Режим перехідного залишку */
  SET @IsNoExpMode = JSON_VALUE(@ParamsIn, '$.NoExpMode')
  /* Кількість чеків продажу */
  SET @ChequesCountSaleCR = JSON_VALUE(@ParamsIn, '$.QtyCheque')
  /* Кількість чеків повернень */
  SET @ChequesCountRetCR = JSON_VALUE(@ParamsIn, '$.QtyAnnul')
  /* Кількість чеків видачі готівки */
  SET @ChequesCountCashBackCR = JSON_VALUE(@ParamsIn, '$.ChequesCountCashBack')
  /* Кількість чеків службового внесення */
  SET @ChequesCountInMoneyCR = JSON_VALUE(@ParamsIn, '$.QtyInMoney')
  /* Кількість чеків службового винесення */
  SET @ChequesCountOutMoneyCR = JSON_VALUE(@ParamsIn, '$.QtyOutMoney')
  /*  Кількість чеків переказу коштів */
  SET @ChequesCountTransferFundsCR = JSON_VALUE(@ParamsIn, '$.FKCH3_Qty')

  /* Сума службового внесення */
  SET @SumMonRecCR = JSON_VALUE(@ParamsIn, '$.SumInMoney')
  /* Сума службового винесення */
  SET @SumMonExpCR = JSON_VALUE(@ParamsIn, '$.SumOutMoney')
  /* Баланс на момент відкриття зміни (впливає параметр NoExpMode (Довідник роомочих місць: Ролі)) */
  SET @InitialBalanceCR = JSON_VALUE(@ParamsIn, '$.InitialBalance')
  /* Сума видачі готівки */
  SET @SumCashBackCR = JSON_VALUE(@ParamsIn, '$.SumCashBack')
  /* Сума переказу коштів */
  SET @SumCashTransferFundsCR = JSON_VALUE(@ParamsIn, '$.FKCH3_Sum')
  
  /* Сума оплат (0-готівка) */
  SET @SaleSumType0CR = JSON_VALUE(@ParamsIn, '$.SaleSumType0')
  /* Сума оплат (1-безготівкова) */
  SET @SaleSumType1CR = JSON_VALUE(@ParamsIn, '$.SaleSumType1')
  /* Сума оплат (2-інше) */
  SET @SaleSumType2CR = JSON_VALUE(@ParamsIn, '$.SaleSumType2')

  /* Сума повернень (0-готівка) */
  SET @RetSumType0CR = JSON_VALUE(@ParamsIn, '$.RetSumType0')
  /* Сума повернень (1-безготівкова) */
  SET @RetSumType1CR = JSON_VALUE(@ParamsIn, '$.RetSumType1')
  /* Сума повернень (2-інше) */
  SET @RetSumType2CR = JSON_VALUE(@ParamsIn, '$.RetSumType2')


  /* Сума продажу (податок A) */
  SET @SumByTax_0CR = JSON_VALUE(@ParamsIn, '$.SumByTax_1')
  /* Сума продажу (податок B) */
  SET @SumByTax_1CR = JSON_VALUE(@ParamsIn, '$.SumByTax_2')
  /* Сума продажу (податок C) */
  SET @SumByTax_2CR = JSON_VALUE(@ParamsIn, '$.SumByTax_3')
  /* Сума продажу (податок D) */
  SET @SumByTax_3CR = JSON_VALUE(@ParamsIn, '$.SumByTax_4')
  /* Сума продажу (податок E) */
  SET @SumByTax_4CR = JSON_VALUE(@ParamsIn, '$.SumByTax_5')
  /* Сума продажу (податок F) */
  SET @SumByTax_5CR = JSON_VALUE(@ParamsIn, '$.SumByTax_6')
  /* Сума продажу (податок G) */
  SET @SumByTax_6CR = JSON_VALUE(@ParamsIn, '$.SumByTax_7')
  /* Сума продажу (податок H) */
  SET @SumByTax_7CR = JSON_VALUE(@ParamsIn, '$.SumByTax_8')

  /* Сума повернень (податок A) */
  SET @RetSumByTax_0CR = JSON_VALUE(@ParamsIn, '$.RetSumByTax_1')
  /* Сума повернень (податок B) */
  SET @RetSumByTax_1CR = JSON_VALUE(@ParamsIn, '$.RetSumByTax_2')
  /* Сума повернень (податок C) */
  SET @RetSumByTax_2CR = JSON_VALUE(@ParamsIn, '$.RetSumByTax_3')
  /* Сума повернень (податок D) */
  SET @RetSumByTax_3CR = JSON_VALUE(@ParamsIn, '$.RetSumByTax_4')
  /* Сума повернень (податок E) */
  SET @RetSumByTax_4CR = JSON_VALUE(@ParamsIn, '$.RetSumByTax_5')
  /* Сума повернень (податок F) */
  SET @RetSumByTax_5CR = JSON_VALUE(@ParamsIn, '$.RetSumByTax_6')
  /* Сума повернень (податок G) */
  SET @RetSumByTax_6CR = JSON_VALUE(@ParamsIn, '$.RetSumByTax_7')
  /* Сума повернень (податок H) */
  SET @RetSumByTax_7CR = JSON_VALUE(@ParamsIn, '$.RetSumByTax_8')

  /* Сума податку на продаж за групою A */
  SET @TaxSum_0CR = JSON_VALUE(@ParamsIn, '$.TaxSum_1')
  /* Сума податку на продаж за групою B */
  SET @TaxSum_1CR = JSON_VALUE(@ParamsIn, '$.TaxSum_2')
  /* Сума податку на продаж за групою C */
  SET @TaxSum_2CR = JSON_VALUE(@ParamsIn, '$.TaxSum_3')
  /* Сума податку на продаж за групою D */
  SET @TaxSum_3CR = JSON_VALUE(@ParamsIn, '$.TaxSum_4')
  /* Сума податку на продаж за групою E */
  SET @TaxSum_4CR = JSON_VALUE(@ParamsIn, '$.TaxSum_5')
  /* Сума податку на продаж за групою F */
  SET @TaxSum_5CR = JSON_VALUE(@ParamsIn, '$.TaxSum_6')
  /* Сума податку на продаж за групою G */
  SET @TaxSum_6CR = JSON_VALUE(@ParamsIn, '$.TaxSum_7')
  /* Сума податку на продаж за групою H */
  SET @TaxSum_7CR = JSON_VALUE(@ParamsIn, '$.TaxSum_8')
 
  /* Сума податку на повернення за групою А */ 
  SET @RetTaxSum_0CR = JSON_VALUE(@ParamsIn, '$.RetTaxSum_1')
  /* Сума податку на повернення за групою B */ 
  SET @RetTaxSum_1CR = JSON_VALUE(@ParamsIn, '$.RetTaxSum_2')
  /* Сума податку на повернення за групою C */ 
  SET @RetTaxSum_2CR = JSON_VALUE(@ParamsIn, '$.RetTaxSum_3')
  /* Сума податку на повернення за групою D */ 
  SET @RetTaxSum_3CR = JSON_VALUE(@ParamsIn, '$.RetTaxSum_4')
  /* Сума податку на повернення за групою E */ 
  SET @RetTaxSum_4CR = JSON_VALUE(@ParamsIn, '$.RetTaxSum_5')
  /* Сума податку на повернення за групою F */ 
  SET @RetTaxSum_5CR = JSON_VALUE(@ParamsIn, '$.RetTaxSum_6')
  /* Сума податку на повернення за групою G */ 
  SET @RetTaxSum_6CR = JSON_VALUE(@ParamsIn, '$.RetTaxSum_7')
  /* Сума податку на повернення за групою H */ 
  SET @RetTaxSum_7CR = JSON_VALUE(@ParamsIn, '$.RetTaxSum_8')
   
  /* Сума оплат (готівка) */
  SET @SaleSumCashCR = JSON_VALUE(@ParamsIn, '$.SumPayCash')
  /* Сума оплат (платіжна картка) */
  SET @SaleSumCardCR = JSON_VALUE(@ParamsIn, '$.SumPayCCard')
  /* Сума оплат (11 - Карткою з видачею готівки) */
  SET @SaleSumCCardCashBackCR = JSON_VALUE(@ParamsIn, '$.SaleSumCCardCashBack')
  /* Без суми оплати (11 - Карткою з видачею готівки) */ 
  SET @SaleSumCardCR = @SaleSumCardCR - @SaleSumCCardCashBackCR -- ПРРО 39
  /* Сума оплат (кредит) */
  SET @SaleSumCreditCR = JSON_VALUE(@ParamsIn, '$.SumPayCredit')
  /* Сума оплат (чек) */
  SET @SaleSumChequeCR = JSON_VALUE(@ParamsIn, '$.SumPayCheque')
  /* Сума оплат (інше) */
  SET @SaleSumOtherCR = JSON_VALUE(@ParamsIn, '$.SumPayOther')
  /* Сума оплат (налаштовується 1) */
  SET @SaleSumCustom1CR =  JSON_VALUE(@ParamsIn, '$.SaleSumCustom1')
  /* Сума оплат (налаштовується 2) */
  SET @SaleSumCustom2CR=   JSON_VALUE(@ParamsIn, '$.SaleSumCustom2')
  /* Сума оплат (налаштовується 3) */
  SET @SaleSumCustom3CR =  JSON_VALUE(@ParamsIn, '$.SaleSumCustom3')
  /* Сума оплат (налаштовується 4) */
  SET @SaleSumCustom4CR =  JSON_VALUE(@ParamsIn, '$.SaleSumCustom4')
  /* Сума оплат (налаштовується 5) */
  SET @SaleSumCustom5CR =  JSON_VALUE(@ParamsIn, '$.SaleSumCustom5')
 
  /* Сума повернень (готівка) */
  SET @RetSumCashCR = JSON_VALUE(@ParamsIn, '$.RetSumCash')
  /* Сума повернень (платіжна картка) */
  SET @RetSumCardCR = JSON_VALUE(@ParamsIn, '$.RetSumCard')
  /* Сума повернень (кредит) */
  SET @RetSumCreditCR = JSON_VALUE(@ParamsIn, '$.RetSumCredit')
  /* Сума повернень (чек) */
  SET @RetSumChequeCR = JSON_VALUE(@ParamsIn, '$.RetSumCheque')
  /* Сума повернень (інше) */
  SET @RetSumOtherCR = JSON_VALUE(@ParamsIn, '$.RetSumOther')
  /* Сума повернень (налаштовується 1) */
  SET @RetSumCustom1CR =  JSON_VALUE(@ParamsIn, '$.RetSumCustom1')
  /* Сума повернень (налаштовується 2) */
  SET @RetSumCustom2CR =  JSON_VALUE(@ParamsIn, '$.RetSumCustom2')
  /* Сума повернень (налаштовується 3) */
  SET @RetSumCustom3CR =  JSON_VALUE(@ParamsIn, '$.RetSumCustom3')
  /* Сума повернень (налаштовується 4) */
  SET @RetSumCustom4CR =  JSON_VALUE(@ParamsIn, '$.RetSumCustom4')
  /* Сума повернень (налаштовується 5) */
  SET @RetSumCustom5CR =  JSON_VALUE(@ParamsIn, '$.RetSumCustom5')
  
  /* Продажі: Заокруглення */
  SET @SaleRndSumCR = JSON_VALUE(@ParamsIn, '$.SaleRndSum')
  /* Продажі: Загальна сума без заокруглення */
  SET @SaleNoRndSumCR = JSON_VALUE(@ParamsIn, '$.SaleNoRndSum')
  /* Повернення: Заокруглення */
  SET @RetRndSumCR = JSON_VALUE(@ParamsIn, '$.RetRndSum')
  /* Повернення: Загальна сума без заокруглення */
  SET @RetNoRndSumCR = JSON_VALUE(@ParamsIn, '$.RetNoRndSum')
  /* Сума готівки в касі */
  SET @SumRemCR = JSON_VALUE(@ParamsIn, '$.SumRem')
  
  /* Не використані поля: 
     ZRepNum: int -- Номер Z-звіту (локальний номер РРО)
	 SumSales_wt: numeric(21,9)
     SumByTax_9_Levy1: numeric(21,9)     -- Обіг по групе М
     SumByTax_10_Levy2: numeric(21,9)    -- Обіг по групе Н
     RetSumByTax_9_Levy1: numeric(21,9)  // Оборот возврата по группе М
     RetSumByTax_10_Levy2: numeric(21,9) // Оборот возврата по группе Н
	 TaxSum_9_Levy1: numeric(21,9)       // Сумма акциза номер
     TaxSum_10_Levy2: numeric(21,9)      // Сумма акциза номер
     TaxSum_9_Levy1: numeric(21,9)       // Сумма акциза номер
     TaxSum_10_Levy2: numeric(21,9)      // Сумма акциза номер
     RetTaxSum_9_Levy1: numeric(21,9)    // Сумма акциза номер
     RetTaxSum_10_Levy2: numeric(21,9)   // Сумма акциза номер
	 CRPayForms: ISuperObject;           // Формы оплаты в РРО
	 SumSales: numeric(21,9);            // Сумма продаж
     SumIncrease: numeric(21,9);         // Сумма надбавок
     QtyIncrease: int;                   // Кол-во выполненых надбавок
     SumReduction: numeric(21,9);        // Сумма скидок
     QtyReduction: int;                  // Кол-во скидок
     SumAnnul: numeric(21,9);            // Сумма отмен продаж товаров
	 "TurnoverByPayForms": [
  {
   "SaleSum": 42.5,
   "RetSum": 0,
   "CRPayFormID": 0
  },{
   "SaleSum": 0,
   "RetSum": 0,
   "CRPayFormID": 1
  },{
   "SaleSum": 0,
   "RetSum": 0,
   "CRPayFormID": 2
  },{
   "SaleSum": 0,
   "RetSum": 0,
   "CRPayFormID": 3
  },{
   "SaleSum": 0,
   "RetSum": 0,
   "CRPayFormID": 4
  },{
   "SaleSum": 0,
   "RetSum": 0,
   "CRPayFormID": 5
  },{
   "SaleSum": 0,
   "RetSum": 0,
   "CRPayFormID": 6
  }],
  */
  /* End: CR */

    /* BEGIN: DB */
    DECLARE @ParamsInDB varchar(max), @ParamsOutDB varchar(max)
  
	SET @ParamsInDB = (SELECT @CRID AS CRID FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
	  
	EXEC dbo.t_GetCRBalance @ParamsInDB, @ParamsOutDB OUTPUT
	
	/* Кількість чеків продажу */
    SET @ChequesCountSaleDB = JSON_VALUE(@ParamsOutDB, '$.SaleOrdersCount')
    /* Кількість чеків повернень */
    SET @ChequesCountRetDB = JSON_VALUE(@ParamsOutDB, '$.RetOrdersCount')
    /* Кількість чеків видачі готівки */
    SET @ChequesCountCashBackDB = JSON_VALUE(@ParamsOutDB, '$.CashBackOrdersCount')
    /* Кількість чеків службового внесення */
    -- SET @ChequesCountInMoneyDB = JSON_VALUE(@ParamsOutDB, '$.QtyInMoney')
    /* Кількість чеків службового винесення */
    -- SET @ChequesCountOutMoneyDB = JSON_VALUE(@ParamsOutDB, '$.QtyOutMoney')
    /*  Кількість чеків переказу коштів */
    -- SET @ChequesCountTransferFundsDB = JSON_VALUE(@ParamsOutDB, '$.XXX') 

	/* Сума службового внесення */
    SET @SumMonRecDB = JSON_VALUE(@ParamsOutDB, '$.MRec')
    /* Сума службового винесення */
    SET @SumMonExpDB = JSON_VALUE(@ParamsOutDB, '$.MExp')
    /* Сума видачі готівки */
    SET @SumCashBackDB = JSON_VALUE(@ParamsOutDB, '$.CashBack')
    /* Сума переказу коштів */
    -- SET @SumCashTransferFundsDB = JSON_VALUE(@ParamsOutDB, '$.FKCH3_Sum') 

	/* Сума оплат (0-готівка) */
    SET @SaleSumType0DB = JSON_VALUE(@ParamsOutDB, '$.SaleSumType0')
    /* Сума оплат (1-безготівкова) */
    SET @SaleSumType1DB = JSON_VALUE(@ParamsOutDB, '$.SaleSumType1')
    /* Сума оплат (2-інше) */
    SET @SaleSumType2DB = JSON_VALUE(@ParamsOutDB, '$.SaleSumType2')

    /* Сума повернень (0-готівка) */
    SET @RetSumType0DB = JSON_VALUE(@ParamsOutDB, '$.RetSumType0')
    /* Сума повернень (1-безготівкова) */
    SET @RetSumType1DB = JSON_VALUE(@ParamsOutDB, '$.RetSumType1')
    /* Сума повернень (2-інше) */
    SET @RetSumType2DB = JSON_VALUE(@ParamsOutDB, '$.RetSumType2')

	/* Сума продажу (податок A) */
    SET @SumByTax_0DB = JSON_VALUE(@ParamsOutDB, '$.SaleSum_0')
    /* Сума продажу (податок B) */
    SET @SumByTax_1DB = JSON_VALUE(@ParamsOutDB, '$.SaleSum_1')
    /* Сума продажу (податок C) */
    SET @SumByTax_2DB = JSON_VALUE(@ParamsOutDB, '$.SaleSum_2')
    /* Сума продажу (податок D) */
    SET @SumByTax_3DB = JSON_VALUE(@ParamsOutDB, '$.SaleSum_3')
    /* Сума продажу (податок E) */
    SET @SumByTax_4DB = JSON_VALUE(@ParamsOutDB, '$.SaleSum_4')
    /* Сума продажу (податок F) */
    SET @SumByTax_5DB = JSON_VALUE(@ParamsOutDB, '$.SaleSum_5')
    /* Сума продажу (податок G) */
    SET @SumByTax_6DB = JSON_VALUE(@ParamsOutDB, '$.SaleSum_6')
    /* Сума продажу (податок H) */
    SET @SumByTax_7DB = JSON_VALUE(@ParamsOutDB, '$.SaleSum_7')

    /* Сума повернень (податок A) */
    SET @RetSumByTax_0DB = JSON_VALUE(@ParamsOutDB, '$.RetSum_0')
    /* Сума повернень (податок B) */
    SET @RetSumByTax_1DB = JSON_VALUE(@ParamsOutDB, '$.RetSum_1')
    /* Сума повернень (податок C) */
    SET @RetSumByTax_2DB = JSON_VALUE(@ParamsOutDB, '$.RetSum_2')
    /* Сума повернень (податок D) */
    SET @RetSumByTax_3DB = JSON_VALUE(@ParamsOutDB, '$.RetSum_3')
    /* Сума повернень (податок E) */
    SET @RetSumByTax_4DB = JSON_VALUE(@ParamsOutDB, '$.RetSum_4')
    /* Сума повернень (податок F) */
    SET @RetSumByTax_5DB = JSON_VALUE(@ParamsOutDB, '$.RetSum_5')
    /* Сума повернень (податок G) */
    SET @RetSumByTax_6DB = JSON_VALUE(@ParamsOutDB, '$.RetSum_6')
    /* Сума повернень (податок H) */
    SET @RetSumByTax_7DB = JSON_VALUE(@ParamsOutDB, '$.RetSum_7')


	/* Сума податку на продаж за групою A */
	SET @TaxSum_0DB = JSON_VALUE(@ParamsOutDB, '$.SaleTaxSum_0')
	/* Сума податку на продаж за групою B */
	SET @TaxSum_1DB = JSON_VALUE(@ParamsOutDB, '$.SaleTaxSum_1')
	/* Сума податку на продаж за групою C */
	SET @TaxSum_2DB = JSON_VALUE(@ParamsOutDB, '$.SaleTaxSum_2')
	/* Сума податку на продаж за групою D */
	SET @TaxSum_3DB = JSON_VALUE(@ParamsOutDB, '$.SaleTaxSum_3')
	/* Сума податку на продаж за групою E */
	SET @TaxSum_4DB = JSON_VALUE(@ParamsOutDB, '$.SaleTaxSum_4')
	/* Сума податку на продаж за групою F */
	SET @TaxSum_5DB = JSON_VALUE(@ParamsOutDB, '$.SaleTaxSum_5')
	/* Сума податку на продаж за групою G */
	SET @TaxSum_6DB = JSON_VALUE(@ParamsOutDB, '$.SaleTaxSum_6')
	/* Сума податку на продаж за групою H */
	SET @TaxSum_7DB = JSON_VALUE(@ParamsOutDB, '$.SaleTaxSum_7')

	/* Сума податку на повернення за групою А */ 
	SET @RetTaxSum_0DB = JSON_VALUE(@ParamsOutDB, '$.RetTaxSum_0')
	/* Сума податку на повернення за групою B */ 
	SET @RetTaxSum_1DB = JSON_VALUE(@ParamsOutDB, '$.RetTaxSum_1')
	/* Сума податку на повернення за групою C */ 
	SET @RetTaxSum_2DB = JSON_VALUE(@ParamsOutDB, '$.RetTaxSum_2')
	/* Сума податку на повернення за групою D */ 
	SET @RetTaxSum_3DB = JSON_VALUE(@ParamsOutDB, '$.RetTaxSum_3')
	/* Сума податку на повернення за групою E */ 
	SET @RetTaxSum_4DB = JSON_VALUE(@ParamsOutDB, '$.RetTaxSum_4')
	/* Сума податку на повернення за групою F */ 
	SET @RetTaxSum_5DB = JSON_VALUE(@ParamsOutDB, '$.RetTaxSum_5')
	/* Сума податку на повернення за групою G */ 
	SET @RetTaxSum_6DB = JSON_VALUE(@ParamsOutDB, '$.RetTaxSum_6')
	/* Сума податку на повернення за групою H */ 
	SET @RetTaxSum_7DB = JSON_VALUE(@ParamsOutDB, '$.RetTaxSum_7')

	/* Сума оплат (готівка) */
	SET @SaleSumCashDB = JSON_VALUE(@ParamsOutDB, '$.SaleSumCashFact')
	/* Сума оплат (готівка) без суми CashBack */
	SET @SaleSumCashDB = @SaleSumCashDB + @SumCashBackDB 
	/* Сума оплат (платіжна картка) */
	SET @SaleSumCardDB = JSON_VALUE(@ParamsOutDB, '$.SaleSumCCardFact')
	/* Сума оплат (11 - Карткою з видачею готівки) */
    SET @SaleSumCCardCashBackDB = JSON_VALUE(@ParamsOutDB, '$.SaleSumCCardOnlyCashBack')
	/* Сума оплат (платіжна картка) без суми оплати (11 - Карткою з видачею готівки) та суми кешбека */ 
    SET @SaleSumCardDB = @SaleSumCardDB - @SaleSumCCardCashBackDB - @SumCashBackDB -- ПРРО 39
	/* Сума оплат (кредит) */
	SET @SaleSumCreditDB = JSON_VALUE(@ParamsOutDB, '$.SaleSumCreditFact')
	/* Сума оплат (чек) */
	SET @SaleSumChequeDB = JSON_VALUE(@ParamsOutDB, '$.SaleSumChequeFact')
	/* Сума оплат (інше) */
	SET @SaleSumOtherDB = JSON_VALUE(@ParamsOutDB, '$.SaleSumOtherFact')
	/* Сума оплат (налаштовується 1) */
	SET @SaleSumCustom1DB =  JSON_VALUE(@ParamsOutDB, '$.SaleSumCustom1Fact')
	/* Сума оплат (налаштовується 2) */
	SET @SaleSumCustom2DB=   JSON_VALUE(@ParamsOutDB, '$.SaleSumCustom2Fact')
	/* Сума оплат (налаштовується 3) */
	SET @SaleSumCustom3DB =  JSON_VALUE(@ParamsOutDB, '$.SaleSumCustom3Fact')
	/* Сума оплат (налаштовується 4) */
	SET @SaleSumCustom4DB =  JSON_VALUE(@ParamsOutDB, '$.SaleSumCustom4Fact')
	/* Сума оплат (налаштовується 5) */
	SET @SaleSumCustom5DB =  JSON_VALUE(@ParamsOutDB, '$.SaleSumCustom5Fact')

	/* Сума повернень (готівка) */
	SET @RetSumCashDB = JSON_VALUE(@ParamsOutDB, '$.SumRetCash')
	/* Сума повернень (платіжна картка) */
	SET @RetSumCardDB = JSON_VALUE(@ParamsOutDB, '$.SumRetCCard')
	/* Сума повернень (кредит) */
	SET @RetSumCreditDB = JSON_VALUE(@ParamsOutDB, '$.SumRetCredit')
	/* Сума повернень (чек) */
	SET @RetSumChequeDB = JSON_VALUE(@ParamsOutDB, '$.SumRetCheque')
	/* Сума повернень (інше) */
	SET @RetSumOtherDB = JSON_VALUE(@ParamsOutDB, '$.SumRetOther')
	/* Сума повернень (налаштовується 1) */
	SET @RetSumCustom1DB =  JSON_VALUE(@ParamsOutDB, '$.SumRetCustom1')
	/* Сума повернень (налаштовується 2) */
	SET @RetSumCustom2DB =  JSON_VALUE(@ParamsOutDB, '$.SumRetCustom2')
	/* Сума повернень (налаштовується 3) */
	SET @RetSumCustom3DB =  JSON_VALUE(@ParamsOutDB, '$.SumRetCustom3')
	/* Сума повернень (налаштовується 4) */
	SET @RetSumCustom4DB =  JSON_VALUE(@ParamsOutDB, '$.SumRetCustom4')
	/* Сума повернень (налаштовується 5) */
	SET @RetSumCustom5DB =  JSON_VALUE(@ParamsOutDB, '$.SumRetCustom5')


	/* Продажі: Заокруглення */
	SET @SaleRndSumDB = JSON_VALUE(@ParamsOutDB, '$.SaleRndSum')
	/* Продажі: Загальна сума без заокруглення */
	SET @SaleNoRndSumDB = JSON_VALUE(@ParamsOutDB, '$.SaleNoRndSum')
	/* Повернення: Заокруглення */
	SET @RetRndSumDB = JSON_VALUE(@ParamsOutDB, '$.RetRndSum')
	/* Повернення: Загальна сума без заокруглення */
	SET @RetNoRndSumDB = JSON_VALUE(@ParamsOutDB, '$.RetNoRndSum')
	  
	/* Сума готівки в касі */
	SET @SumRemDB = ROUND(ISNULL(@SaleSumCashDB,0) - ISNULL(@RetSumCashDB,0) + ISNULL(@SumMonRecDB,0) - ISNULL(@SumMonExpDB,0) - ISNULL(@SumCashBackDB,0),2)
	SET @InitialBalanceDB = 0

	IF @IsNoExpMode = 1
	  BEGIN
	    /* Баланс на момент відкриття зміни (впливає параметр NoExpMode (Довідник роомочих місць: Ролі)) */
        SET @InitialBalanceDB = JSON_VALUE(@ParamsOutDB, '$.InitialBalance')
	    SET @SumRemDB = @SumRemDB  + @InitialBalanceDB
	  END

  /* END: DB */

  SET @Cat1 = ' Загальний обіг'
  SET @Cat2 = ' Кількість'
  
  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Чеків продажу' AS [Name], @ChequesCountSaleDB AS ValueDB, @ChequesCountSaleCR AS ValueCR, 0 AS Diff
  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Чеків повернення' AS [Name], @ChequesCountRetDB AS ValueDB, @ChequesCountRetCR AS ValueCR, 0 AS Diff
  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Чеків відачі готівки' AS [Name], @ChequesCountCashBackDB AS ValueDB, @ChequesCountCashBackCR AS ValueCR, 0 AS Diff
  --INSERT INTO #Sale
  --SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Чеків переказу коштів' AS [Name], @ChequesCountTransferFundsDB AS ValueDB, @ChequesCountTransferFundsCR AS ValueCR, 0 AS Diff
  --INSERT INTO #Sale
  --SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Чеків службового внесення' AS [Name], @ChequesCountInMoneyDB AS ValueDB, @ChequesCountInMoneyCR AS ValueCR, 0 AS Diff
  --INSERT INTO #Sale
  --SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Чеків службового винесення' AS [Name], @ChequesCountOutMoneyDB AS ValueDB, @ChequesCountOutMoneyCR AS ValueCR, 0 AS Diff
  
  SET @Cat1 = ' Загальний обіг'
  SET @Cat2 = 'Загальні суми'

  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Залишок на початок зміни' AS [Name], @InitialBalanceDB AS ValueDB, @InitialBalanceCR AS ValueCR, 0 AS Diff
  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Сума службового внесення' AS [Name], @SumMonRecDB AS ValueDB, @SumMonRecCR AS ValueCR, 0 AS Diff
  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Сума службового винесення' AS [Name], @SumMonExpDB AS ValueDB, @SumMonExpCR AS ValueCR, 0 AS Diff   
  
  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Сума оплат (загальна)' AS [Name], @SaleSumType0DB + @SaleSumType1DB + @SaleSumType2DB AS ValueDB, @SaleSumType0CR + @SaleSumType1CR + @SaleSumType2CR AS ValueCR, 0 AS Diff
  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Сума оплат (0-готівка)' AS [Name], @SaleSumType0DB AS ValueDB, @SaleSumType0CR AS ValueCR, 0 AS Diff
  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Сума оплат (1-безготівкова)' AS [Name], @SaleSumType1DB AS ValueDB, @SaleSumType1CR AS ValueCR, 0 AS Diff
  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Сума оплат (2-інше)' AS [Name], @SaleSumType2DB AS ValueDB, @SaleSumType2CR AS ValueCR, 0 AS Diff
  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Сума повернень (загальна)' AS [Name], @RetSumType0DB + @RetSumType1DB + @RetSumType2DB AS ValueDB, @RetSumType0CR + @RetSumType1CR + @RetSumType2CR AS ValueCR, 0 AS Diff
  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Сума повернень (0-готівка)' AS [Name], @RetSumType0DB AS ValueDB, @RetSumType0CR AS ValueCR, 0 AS Diff
  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Сума повернень (1-безготівкова)' AS [Name], @RetSumType1DB AS ValueDB, @RetSumType1CR AS ValueCR, 0 AS Diff
  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Сума повернень (2-інше)' AS [Name], @RetSumType2DB AS ValueDB, @RetSumType2CR AS ValueCR, 0 AS Diff

 -- INSERT INTO #Sale
 -- SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Сума переказу коштів' AS [Name], @SumCashTransferFundsDB AS ValueDB, @SumCashTransferFundsCR AS ValueCR, 0 AS Diff
  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Видано готівки' AS [Name], @SumCashBackDB AS ValueDB, @SumCashBackCR AS ValueCR, 0 AS Diff
  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Сума готівки в касі' AS [Name], @SumRemDB AS ValueDB, @SumRemCR AS ValueCR, 0 AS Diff
  
  /* Заокруглення
  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Продажі: Сума заокруглення' AS [Name], @SaleRndSumDB AS ValueDB, @SaleRndSumCR AS ValueCR, 0 AS Diff
  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Продажі: Сума без заокруглення' AS [Name], @SaleNoRndSumDB AS ValueDB, @SaleNoRndSumCR AS ValueCR, 0 AS Diff
  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Повернення: Сума заокруглення' AS [Name], @RetRndSumDB AS ValueDB, @RetRndSumCR AS ValueCR, 0 AS Diff
  INSERT INTO #Sale
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, 'Повернення: Сума без заокруглення' AS [Name], @RetNoRndSumDB AS ValueDB, @RetNoRndSumCR AS ValueCR, 0 AS Diff
  */
 
  INSERT INTO #SalePays
  SELECT p.PayFormCode, p.PayFormName, pcr.CRPayFormCode, 0 AS SumDB, 0 AS SumCR, 0 AS Diff
  FROM r_PayFormCR pcr
  INNER JOIN r_PayForms p ON p.PayFormCode = pcr.PayFormCode
  WHERE pcr.CashType = @CashType

  UPDATE #SalePays SET SumDB = @SaleSumCashDB, SumCR = @SaleSumCashCR WHERE PayFormCode IN (SELECT PayFormCode FROM r_PayFormCR WITH(NOLOCK) WHERE CashType = @CashType AND CRPayFormCode = 0)
  UPDATE #SalePays SET SumDB = @SaleSumCardDB, SumCR = @SaleSumCardCR WHERE PayFormCode IN (SELECT PayFormCode FROM r_PayFormCR WITH(NOLOCK) WHERE CashType = @CashType AND CRPayFormCode = 1)
  UPDATE #SalePays SET SumDB = @SaleSumCreditDB, SumCR = @SaleSumCreditCR WHERE PayFormCode IN (SELECT PayFormCode FROM r_PayFormCR WITH(NOLOCK) WHERE CashType = @CashType AND CRPayFormCode = 2)
  UPDATE #SalePays SET SumDB = @SaleSumChequeDB, SumCR = @SaleSumChequeCR WHERE PayFormCode IN (SELECT PayFormCode FROM r_PayFormCR WITH(NOLOCK) WHERE CashType = @CashType AND CRPayFormCode = 3)
  UPDATE #SalePays SET SumDB = @SaleSumCustom1DB, SumCR = @SaleSumCustom1CR WHERE PayFormCode IN (SELECT PayFormCode FROM r_PayFormCR WITH(NOLOCK) WHERE CashType = @CashType AND CRPayFormCode = 4)
  UPDATE #SalePays SET SumDB = @SaleSumCustom2DB, SumCR = @SaleSumCustom2CR WHERE PayFormCode IN (SELECT PayFormCode FROM r_PayFormCR WITH(NOLOCK) WHERE CashType = @CashType AND CRPayFormCode = 5)
  UPDATE #SalePays SET SumDB = @SaleSumCustom3DB, SumCR = @SaleSumCustom3CR WHERE PayFormCode IN (SELECT PayFormCode FROM r_PayFormCR WITH(NOLOCK) WHERE CashType = @CashType AND CRPayFormCode = 6)
  UPDATE #SalePays SET SumDB = @SaleSumCustom4DB, SumCR = @SaleSumCustom4CR WHERE PayFormCode IN (SELECT PayFormCode FROM r_PayFormCR WITH(NOLOCK) WHERE CashType = @CashType AND CRPayFormCode = 7)
  UPDATE #SalePays SET SumDB = @SaleSumCustom5DB, SumCR = @SaleSumCustom5CR WHERE PayFormCode IN (SELECT PayFormCode FROM r_PayFormCR WITH(NOLOCK) WHERE CashType = @CashType AND CRPayFormCode = 8)
  UPDATE #SalePays SET SumDB = @SaleSumCCardCashBackDB, SumCR = @SaleSumCCardCashBackCR WHERE PayFormCode = 11
  
  INSERT INTO #RetPays
  SELECT p.PayFormCode, p.PayFormName, pcr.CRPayFormCode, 0 AS SumDB, 0 AS SumCR, 0 AS Diff
  FROM r_PayFormCR pcr
  INNER JOIN r_PayForms p ON p.PayFormCode = pcr.PayFormCode
  WHERE pcr.CashType = @CashType

  UPDATE #RetPays SET SumDB = @RetSumCashDB, SumCR = @RetSumCashCR WHERE PayFormCode IN (SELECT PayFormCode FROM r_PayFormCR WITH(NOLOCK) WHERE CashType = @CashType AND CRPayFormCode = 0)
  UPDATE #RetPays SET SumDB = @RetSumCardDB, SumCR = @RetSumCardCR WHERE PayFormCode IN (SELECT PayFormCode FROM r_PayFormCR WITH(NOLOCK) WHERE CashType = @CashType AND CRPayFormCode = 1 AND PayFormCode <> 11)
  UPDATE #RetPays SET SumDB = @RetSumCreditDB, SumCR = @RetSumCreditCR WHERE PayFormCode IN (SELECT PayFormCode FROM r_PayFormCR WITH(NOLOCK) WHERE CashType = @CashType AND CRPayFormCode = 2)
  UPDATE #RetPays SET SumDB = @RetSumChequeDB, SumCR = @RetSumChequeCR WHERE PayFormCode IN (SELECT PayFormCode FROM r_PayFormCR WITH(NOLOCK) WHERE CashType = @CashType AND CRPayFormCode = 3)
  UPDATE #RetPays SET SumDB = @RetSumCustom1DB, SumCR = @RetSumCustom1CR WHERE PayFormCode IN (SELECT PayFormCode FROM r_PayFormCR WITH(NOLOCK) WHERE CashType = @CashType AND CRPayFormCode = 4)
  UPDATE #RetPays SET SumDB = @RetSumCustom2DB, SumCR = @RetSumCustom2CR WHERE PayFormCode IN (SELECT PayFormCode FROM r_PayFormCR WITH(NOLOCK) WHERE CashType = @CashType AND CRPayFormCode = 5)
  UPDATE #RetPays SET SumDB = @RetSumCustom3DB, SumCR = @RetSumCustom3CR WHERE PayFormCode IN (SELECT PayFormCode FROM r_PayFormCR WITH(NOLOCK) WHERE CashType = @CashType AND CRPayFormCode = 6)
  UPDATE #RetPays SET SumDB = @RetSumCustom4DB, SumCR = @RetSumCustom4CR WHERE PayFormCode IN (SELECT PayFormCode FROM r_PayFormCR WITH(NOLOCK) WHERE CashType = @CashType AND CRPayFormCode = 7)
  UPDATE #RetPays SET SumDB = @RetSumCustom5DB, SumCR = @RetSumCustom5CR WHERE PayFormCode IN (SELECT PayFormCode FROM r_PayFormCR WITH(NOLOCK) WHERE CashType = @CashType AND CRPayFormCode = 8)


  /* Begin Taxes */

  DECLARE @TAX_GROUPS VARCHAR(200), @TaxIDNotVAT int, @TaxPayer bit       
  SET @TAX_GROUPS = 'АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЬЪЭЮЯ'
  
  /* Неплательщик НДС */ 
  SET @TaxIDNotVAT = ISNULL((SELECT ISNULL(TaxID,1) FROM r_Taxes WITH(NOLOCK) WHERE TaxTypeID = 1),1)

  SELECT @TaxPayer = o.TaxPayer 
  FROM r_CRs c WITH(NOLOCK), r_CRSrvs s WITH(NOLOCK), r_Ours o WITH(NOLOCK)               
  WHERE c.SrvID = s.SrvID AND s.OurID = o.OurID AND c.CRID = @CRID

  /* ПДВ */
  INSERT INTO #Taxes
  SELECT
    m.TaxTypeID,
	m.TaxID,
    SUBSTRING(@TAX_GROUPS, ISNULL(CASE WHEN @TaxPayer = 1 THEN m.TaxID ELSE @TaxIDNotVAT END,0) + 1, 1) AS Letter,      
    dbo.zf_GetTaxPercent(CASE WHEN @TaxPayer = 1 THEN m.TaxTypeID ELSE 1 END) AS TaxPercent,
	'ПДВ' AS TaxName,
	'' AS TaxPerName
  FROM r_Taxes m WITH(NOLOCK) 
  WHERE m.TaxID IS NOT NULL

  /* Акциз */ 
  INSERT INTO #Taxes
  SELECT
    m.TaxTypeID,  
    m.TaxID,
    SUBSTRING(@TAX_GROUPS, ISNULL(m.TaxID,0) + 1, 1) AS Letter,
    m.CRTaxPercent AS TaxPercent,
    'Акцизний податок' AS TaxName,
	'' AS TaxPerName
  FROM r_LevyCR m WITH(NOLOCK)   
  WHERE m.CashType = @CashType

  UPDATE #Taxes SET TaxPerName = TaxName + ' ' + Letter + ' ' + CAST(FORMAT(TaxPercent, 'N2','ru-UA') as VARCHAR(250)) + '%'

  SET @Cat1 = ' Продажі'
  SET @Cat2 = 'Податки'
  SET @Name = 'Сума продажу'

  INSERT INTO #SaleTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, @Name + ' (податок '+ Letter + ')' AS [Name], @SumByTax_0DB AS ValueDB, @SumByTax_0CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 0
  INSERT INTO #SaleTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, TaxPerName AS [Name], @TaxSum_0DB AS ValueDB, @TaxSum_0CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 0
  INSERT INTO #SaleTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, @Name + ' (податок '+ Letter + ')' AS [Name], @SumByTax_1DB AS ValueDB, @SumByTax_1CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 1
  INSERT INTO #SaleTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, TaxPerName AS [Name], @TaxSum_1DB AS ValueDB, @TaxSum_1CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 1
  INSERT INTO #SaleTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, @Name + ' (податок '+ Letter + ')' AS [Name], @SumByTax_2DB AS ValueDB, @SumByTax_2CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 2
  INSERT INTO #SaleTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, TaxPerName AS [Name], @TaxSum_2DB AS ValueDB, @TaxSum_2CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 2
  INSERT INTO #SaleTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, @Name + ' (податок '+ Letter + ')' AS [Name], @SumByTax_3DB AS ValueDB, @SumByTax_3CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 3
  INSERT INTO #SaleTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, TaxPerName AS [Name], @TaxSum_3DB AS ValueDB, @TaxSum_3CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 3
  INSERT INTO #SaleTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, @Name + ' (податок '+ Letter + ')' AS [Name], @SumByTax_4DB AS ValueDB, @SumByTax_4CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 4
  INSERT INTO #SaleTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, TaxPerName AS [Name], @TaxSum_4DB AS ValueDB, @TaxSum_4CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 4
  INSERT INTO #SaleTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, @Name + ' (податок '+ Letter + ')' AS [Name], @SumByTax_5DB AS ValueDB, @SumByTax_5CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 5
  INSERT INTO #SaleTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, TaxPerName AS [Name], @TaxSum_5DB AS ValueDB, @TaxSum_5CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 5
  INSERT INTO #SaleTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, @Name + ' (податок '+ Letter + ')' AS [Name], @SumByTax_6DB AS ValueDB, @SumByTax_6CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 6
  INSERT INTO #SaleTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, TaxPerName AS [Name], @TaxSum_6DB AS ValueDB, @TaxSum_6CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 6
  INSERT INTO #SaleTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, @Name + ' (податок '+ Letter + ')' AS [Name], @SumByTax_7DB AS ValueDB, @SumByTax_7CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 7
  INSERT INTO #SaleTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, TaxPerName AS [Name], @TaxSum_7DB AS ValueDB, @TaxSum_7CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 7
  
  SET @Cat1 = 'Повернення'
  SET @Cat2 = 'Податки'
  SET @Name = 'Сума повернення'

  INSERT INTO #RetTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, @Name + ' (податок '+ Letter + ')' AS [Name], @RetSumByTax_0DB AS ValueDB, @RetSumByTax_0CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 0
  INSERT INTO #RetTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, TaxPerName AS [Name], @RetTaxSum_0DB AS ValueDB, @RetTaxSum_0CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 0
  INSERT INTO #RetTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, @Name + ' (податок '+ Letter + ')' AS [Name], @RetSumByTax_1DB AS ValueDB, @RetSumByTax_1CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 1
  INSERT INTO #RetTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, TaxPerName AS [Name], @RetTaxSum_1DB AS ValueDB, @RetTaxSum_1CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 1
  INSERT INTO #RetTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, @Name + ' (податок '+ Letter + ')' AS [Name], @RetSumByTax_2DB AS ValueDB, @RetSumByTax_2CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 2
  INSERT INTO #RetTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, TaxPerName AS [Name], @RetTaxSum_2DB AS ValueDB, @RetTaxSum_2CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 2
  INSERT INTO #RetTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, @Name + ' (податок '+ Letter + ')' AS [Name], @RetSumByTax_3DB AS ValueDB, @RetSumByTax_3CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 3
  INSERT INTO #RetTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, TaxPerName AS [Name], @RetTaxSum_3DB AS ValueDB, @RetTaxSum_3CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 3
  INSERT INTO #RetTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, @Name + ' (податок '+ Letter + ')' AS [Name], @RetSumByTax_4DB AS ValueDB, @RetSumByTax_4CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 4
  INSERT INTO #RetTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, TaxPerName AS [Name], @RetTaxSum_4DB AS ValueDB, @RetTaxSum_4CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 4
  INSERT INTO #RetTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, @Name + ' (податок '+ Letter + ')' AS [Name], @RetSumByTax_5DB AS ValueDB, @RetSumByTax_5CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 5
  INSERT INTO #RetTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, TaxPerName AS [Name], @RetTaxSum_5DB AS ValueDB, @RetTaxSum_5CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 5
  INSERT INTO #RetTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, @Name + ' (податок '+ Letter + ')' AS [Name], @RetSumByTax_6DB AS ValueDB, @RetSumByTax_6CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 6
  INSERT INTO #RetTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, TaxPerName AS [Name], @RetTaxSum_6DB AS ValueDB, @RetTaxSum_6CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 6
  INSERT INTO #RetTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, @Name + ' (податок '+ Letter + ')' AS [Name], @RetSumByTax_7DB AS ValueDB, @RetSumByTax_7CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 7
  INSERT INTO #RetTaxes
  SELECT @Cat1 AS Cat1, @Cat2 AS Cat2, TaxPerName AS [Name], @RetTaxSum_7DB AS ValueDB, @RetTaxSum_7CR AS ValueCR, 0 AS Diff FROM #Taxes WHERE TaxID = 7
  
  /* End Taxes */


 /* Rezult */
  INSERT INTO #Rezult 
  SELECT Cat1, Cat2, [Name], ValueDB, ValueCR, ValueDB - ValueCR FROM #Sale
  INSERT INTO #Rezult 
  SELECT ' Продажі', 'Оплати', PayFormName, SumDB, SumCR, SumDB - SumCR FROM #SalePays WHERE Not (SumDB = 0 AND SumCR = 0)
  INSERT INTO #Rezult 
  SELECT 'Повернення', 'Оплати', PayFormName, SumDB, SumCR, SumDB - SumCR FROM #RetPays WHERE Not (SumDB = 0 AND SumCR = 0)
  INSERT INTO #Rezult 
  SELECT Cat1, Cat2, [Name], ValueDB, ValueCR, ValueDB - ValueCR FROM #SaleTaxes WHERE Not (ValueDB = 0 AND ValueCR = 0)
  INSERT INTO #Rezult
  SELECT Cat1, Cat2, [Name], ValueDB, ValueCR, ValueDB - ValueCR FROM #RetTaxes WHERE Not (ValueDB = 0 AND ValueCR = 0)


  SELECT m.Cat1 AS [:], m.Cat2 AS [::], m.Name AS 'Найменування', 
    CASE WHEN Cat2 = ' Кількість' THEN CAST(FORMAT(ValueDB, 'N0', 'ru-UA') as VARCHAR(250)) 
	  ELSE CASE WHEN ValueDB = 0 THEN '0' ELSE CAST(FORMAT(ValueDB, 'N2', 'ru-UA') as VARCHAR(250)) END END AS 'Обіг БД', 
    CASE WHEN Cat2 = ' Кількість' THEN CAST(FORMAT(ValueCR, 'N0', 'ru-UA') as VARCHAR(250)) 
	  ELSE CASE WHEN ValueCR = 0 THEN '0' ELSE CAST(FORMAT(ValueCR, 'N2', 'ru-UA') as VARCHAR(250)) END END AS 'Обіг РРО', 
	CASE WHEN Cat2 = ' Кількість' AND Diff <> 0 THEN CAST(FORMAT(Diff, 'N0', 'ru-UA') as VARCHAR(250)) 
	  ELSE CASE WHEN Diff = 0 THEN '' ELSE CAST(FORMAT(Diff, 'N2', 'ru-UA') as VARCHAR(250)) END END AS 'Різниця' 
  FROM #Rezult m
END
GO