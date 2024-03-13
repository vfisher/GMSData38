SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetDocDate](@DocCode int, @ChID bigint)
/* Возвращает дату документа */
RETURNS SMALLDATETIME AS
BEGIN
  DECLARE @DocDate SMALLDATETIME

  /* CASE соответствует таковому из t_GetPriceCC*/
  SELECT @DocDate =
    CASE @DocCode
      WHEN 11001 THEN (SELECT TOP 1 DocDate FROM t_Acc     WHERE ChID = @ChID) /* Счет на оплату товара */
      WHEN 11002 THEN (SELECT TOP 1 DocDate FROM t_Rec     WHERE ChID = @ChID) /* Приход товара */
      WHEN 11003 THEN (SELECT TOP 1 DocDate FROM t_Ret     WHERE ChID = @ChID) /* Возврат товара от получателя */
      WHEN 11004 THEN (SELECT TOP 1 DocDate FROM t_CRRet   WHERE ChID = @ChID) /* Возврат товара по чеку */
      WHEN 11011 THEN (SELECT TOP 1 DocDate FROM t_CRet    WHERE ChID = @ChID) /* Возврат товара поставщику */
      WHEN 11012 THEN (SELECT TOP 1 DocDate FROM t_Inv     WHERE ChID = @ChID) /* Расходная накладная */
      WHEN 11015 THEN (SELECT TOP 1 DocDate FROM t_Exp     WHERE ChID = @ChID) /* Расходный документ */
      WHEN 11016 THEN (SELECT TOP 1 DocDate FROM t_Epp     WHERE ChID = @ChID) /* Расходный документ в ценах прихода */
      WHEN 11018 THEN (SELECT TOP 1 DocDate FROM t_MonRec  WHERE ChID = @ChID) /* Прием наличных денег на склад */
      WHEN 11021 THEN (SELECT TOP 1 DocDate FROM t_Exc     WHERE ChID = @ChID) /* Перемещение товара */
      WHEN 11022 THEN (SELECT TOP 1 DocDate FROM t_Ven     WHERE ChID = @ChID) /* Инвентаризация товара */
      WHEN 11031 THEN (SELECT TOP 1 DocDate FROM t_Est     WHERE ChID = @ChID) /* Переоценка цен прихода */
      WHEN 11032 THEN (SELECT TOP 1 DocDate FROM t_SEst    WHERE ChID = @ChID) /* Переоценка цен продажи */
      WHEN 11035 THEN (SELECT TOP 1 DocDate FROM t_Sale    WHERE ChID = @ChID) /* Продажа товара оператором */
      /* WHEN 11037 THEN (SELECT TOP 1 DocDate FROM ? WHERE ChID = @ChID)  Продажа товара через сервер */
      WHEN 11040 THEN (SELECT TOP 1 DocDate FROM t_Cos     WHERE ChID = @ChID) /* Формирование себестоимости */
      WHEN 11045 THEN (SELECT TOP 1 DocDate FROM t_Cst     WHERE ChID = @ChID) /* Приход товара по ГТД */
      WHEN 11101 THEN (SELECT TOP 1 DocDate FROM t_DeskRes WHERE ChID = @ChID) /* Ресторан: Резервирование столиков */
      WHEN 11211 THEN (SELECT TOP 1 DocDate FROM t_EOExp   WHERE ChID = @ChID) /* Заказ внешний: Формирование */
      WHEN 11212 THEN (SELECT TOP 1 DocDate FROM t_EORec   WHERE ChID = @ChID) /* Заказ внешний: Обработка */
      WHEN 11221 THEN (SELECT TOP 1 DocDate FROM t_IORec   WHERE ChID = @ChID) /* Заказ внутренний: Формирование */
      WHEN 11222 THEN (SELECT TOP 1 DocDate FROM t_IOExp   WHERE ChID = @ChID) /* Заказ внутренний: Обработка */
      WHEN 11231 THEN (SELECT TOP 1 DocDate FROM t_Dis     WHERE ChID = @ChID) /* Распределение товара */
      WHEN 11311 THEN (SELECT TOP 1 DocDate FROM t_SPRec   WHERE ChID = @ChID) /* Планирование Комплектации */
      WHEN 11312 THEN (SELECT TOP 1 DocDate FROM t_SPExp   WHERE ChID = @ChID) /* Планирование Разукомплектации */
      WHEN 11321 THEN (SELECT TOP 1 DocDate FROM t_SRec    WHERE ChID = @ChID) /* Комплектация товара */
      WHEN 11322 THEN (SELECT TOP 1 DocDate FROM t_SExp    WHERE ChID = @ChID) /* Разукомплектация товара */
      ELSE (SELECT Now FROM vz_Now) /* По умолчанию берем сегодняшнюю дату */
    END
  RETURN @DocDate
End
GO
