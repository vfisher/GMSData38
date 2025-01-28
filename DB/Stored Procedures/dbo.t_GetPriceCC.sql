SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetPriceCC](@DocCode int, @ChID bigint, @ProdID int, @PPID int, @RateMC numeric(21,9), @Discount numeric(21,9), @PLID int, @Result numeric(21,9) OUTPUT)
/* Возвращает цену для указанного документа */
AS
BEGIN
  DECLARE @PriceMode smallint
  /* Режимы цены:
    0 - Нулевая
    1 - Цена прихода ЛВ
    2 - Себестоимость ЛВ
    3 - Цена продажи
    4 - Цена прихода ВС
    5 - Себестоимость ВС
    6 - Цена продажи из прайс-листа
    7 - Цена продажи из КЦП
    8 - Рекомендованая цена прихода
  */

  SELECT @PriceMode =
    CASE @DocCode
      WHEN 11001 THEN 3 /* Счет на оплату товара */
      WHEN 11002 THEN 1 /* Приход товара */
      WHEN 11003 THEN 0 /* Возврат товара от получателя */
      WHEN 11004 THEN 0 /* Возврат товара по чеку */
      WHEN 11011 THEN 1 /* Возврат товара поставщику */
      WHEN 11012 THEN 3 /* Расходная накладная */
      WHEN 11015 THEN 3 /* Расходный документ */
      WHEN 11016 THEN 1 /* Расходный документ в ценах прихода */
      WHEN 11018 THEN 0 /* Прием наличных денег на склад */
      WHEN 11021 THEN 1 /* Перемещение товара */
      WHEN 11022 THEN 1 /* Инвентаризация товара */
      WHEN 11031 THEN 1 /* Переоценка цен прихода */
      WHEN 11032 THEN 0 /* Переоценка цен продажи */
      WHEN 11035 THEN 3 /* Продажа товара оператором */
      WHEN 11037 THEN 3 /* Продажа товара через сервер */
      WHEN 11040 THEN 1 /* Формирование себестоимости */
      WHEN 11045 THEN 0 /* Приход товара по ГТД */
      WHEN 11051 THEN 0 /* Служебный приход денег */
      WHEN 11052 THEN 0 /* Служебный расход денег */
      WHEN 11101 THEN 3 /* Ресторан: Резервирование столиков */
      WHEN 11211 THEN 8 /* Заказ внешний: Формирование */
      WHEN 11212 THEN 0 /* Заказ внешний: Обработка */
      WHEN 11221 THEN 6 /* Заказ внутренний: Формирование */
      WHEN 11222 THEN 3 /* Заказ внутренний: Обработка */
      WHEN 11231 THEN 0 /* Распределение товара */
      WHEN 11311 THEN 1 /* Планирование Комплектации */
      WHEN 11312 THEN 1 /* Планирование Разукомплектации */
      WHEN 11321 THEN 1 /* Комплектация товара */
      WHEN 11322 THEN 1 /* Разукомплектация товара */
      WHEN 11901 THEN 1 /* Входящие остатки товара */
      ELSE 0
    END
  IF @PriceMode = -1 BEGIN
 DECLARE @Error_msg1 varchar(2000) = dbo.zf_Translate('Для документа не определен режим цены (t_GetPriceCC)')
 RAISERROR(@Error_msg1, 16, 1) END


  IF      @PriceMode = 0 SET @Result = 0
  ELSE IF @PriceMode = 1 EXEC t_GetPriceCCIn @ProdID, @PPID, @RateMC, @Result OUTPUT
  ELSE IF @PriceMode = 2 EXEC t_GetPriceCCCost @ProdID, @PPID, @RateMC, @Result OUTPUT
  ELSE IF @PriceMode = 3
    BEGIN
      IF dbo.zf_Var('t_SPCfg') = '0' SET @PriceMode = 6
      ELSE                           SET @PriceMode = 7
    END
  ELSE IF @PriceMode = 4 EXEC t_GetPriceCCInReal @ProdID, @PPID, @RateMC, @Result OUTPUT
  ELSE IF @PriceMode = 5 EXEC t_GetPriceCCCostReal @ProdID, @PPID, @RateMC, @Result OUTPUT

  IF      @PriceMode = 6
    BEGIN
      EXEC t_GetPriceCCPL @ProdID, @RateMC, @Discount, @PLID, @Result OUTPUT
      SELECT @Result = dbo.zf_CorrectPriceForTaxProd(@Result, @ProdID, dbo.zf_GetDocDate(@DocCode, @ChID))
    END
  ELSE IF @PriceMode = 7
    BEGIN
      EXEC t_GetPriceCCPP @ProdID, @PPID, @RateMC, @Discount, @Result OUTPUT
      SELECT @Result = dbo.zf_CorrectPriceForTaxProd(@Result, @ProdID, dbo.zf_GetDocDate(@DocCode, @ChID))
    END
  ELSE IF @PriceMode = 8 SELECT @Result = dbo.zf_GetStdRecPriceCC(@ProdID)
End

GO
