SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetCostCC] (@DocCode int, @Vals varchar(3600))
/* Расcчитывает себестоимость для документа */
AS
  DECLARE @CostCCExp varchar(400)
  SET @CostCCExp =
  CASE @DocCode
  /* Приход товара */
  WHEN 11002 THEN 'CASE Qty WHEN 0 THEN 0 ELSE PriceCC_wt + CostSum / Qty END'
  /* Переоценка цен прихода */
  WHEN 11031 THEN 'NewPriceCC_wt'
  /* Приход товара по ГТД */
  WHEN 11045 THEN 'PriceCC_In'
  /* Приход товара по ГТД (новый) */
  WHEN 11046 THEN 'PriceCC_In'
  /* Комплектация товара */
  WHEN 11321 THEN 'NewPriceCC_wt'
  /* Разукомплектация товара */
  WHEN 11322 THEN 'SubNewPriceCC_wt'
  /* ТМЦ: Приход по накладной */
  WHEN 14102 THEN 'CASE Qty WHEN 0 THEN 0 ELSE PriceCC_nt + CostSum / Qty END'
  /* ТМЦ: Формирование себестоимости */
  WHEN 14125 THEN 'NewPriceCC_nt'
  /* ТМЦ: Приход по ГТД */
  WHEN 14131 THEN 'PriceCC_In'
  /* Входящие остатки ТМЦ */
  WHEN 14904 THEN 'PriceCC_nt'
  /* Входящие остатки товара */
  WHEN 11901 THEN 'PriceCC_wt'
  /* Остальные документы */
  ELSE 'PriceCC_nt'
 END

DECLARE @SQL nvarchar(4000)
SET @SQL = N'SELECT ' + @CostCCExp + ' AS Col1 FROM ' + @Vals
EXEC sp_executesql @SQL
GO
