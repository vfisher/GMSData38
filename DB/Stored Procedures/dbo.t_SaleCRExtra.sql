SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleCRExtra](@CRID int, @DocCode int, @ChID bigint, @Action int, @AParam1 VARCHAR(2000))
AS
/* Возвращает информацию для печати текстовых чеков */
BEGIN
  /*
    1 - Закрытие чека
    2 - Сведения о подарочном сертификате
    11 - X-отчет
    12 - Z-отчет
    13 - Копия последнего чека
    14 - Отчёт об инвентаризации товаров в торговых модулях
  */
  DECLARE @out TABLE(SrcPosID int identity(1, 1), Col1 varchar(250), Col2 varchar(250), Col3 varchar(250), Barcode varchar(250))

  DECLARE @CRName varchar(250)
  DECLARE @EmpName varchar(250)
  DECLARE @EmpID int

  SELECT @CRName = CRName FROM r_CRs WITH(NOLOCK) WHERE CRID = @CRID

  SELECT TOP 1 @EmpName = EmpName, @EmpID = o.EmpID
  FROM r_Emps e WITH(NOLOCK), r_Opers o WITH(NOLOCK)
  WHERE e.EmpID = o.EmpID AND o.OperID = dbo.tf_GetOperID()

  DECLARE @s1 varchar(250)
  DECLARE @s2 varchar(250)

  SELECT
    @s1 = CONVERT(varchar(20), GETDATE(), 104) + ' ' + CONVERT(varchar(20), GETDATE(), 108) + '  ' + @CRName,
    @s2 = @EmpName + ' (' + CAST(@EmpID AS varchar(20)) + ')'

  INSERT INTO @Out(Col1, Col2, Col3, Barcode)
  VALUES (@s1, @s2, '--------------------------', '')

  IF @Action = 1 AND @DocCode = 1011
    BEGIN
      IF (EXISTS (SELECT * FROM t_SaleTempD WHERE ChID = @ChID AND Qty < 0)) AND ((SELECT SUM(Qty) FROM t_SaleTempD WHERE ChID = @ChID) = 0)
        BEGIN
          /* Печать полностью отмененных чеков */
          DECLARE @SaleDocID bigint
          DECLARE @UseProdNotes bit

          SELECT @SaleDocID = m.SaleDocID, @UseProdNotes = c.UseProdNotes
          FROM t_SaleTemp m WITH(NOLOCK), r_CRs c WITH(NOLOCK)
          WHERE m.CRID = c.CRID AND m.ChID = @ChID

          INSERT INTO @Out(Col1, Col2, Col3, Barcode)
          SELECT
            '' Col1,
            'Отмены (чек#' + CAST(@SaleDocID AS varchar(20)) + ')' Col2,
            '--------------------------' Col3,
            '' Barcode
          UNION ALL
          SELECT
            /* 1 */ (
              LTRIM(STR(d.Qty, 10, 3)) + ' X ' +
              LTRIM(STR(dbo.zf_RoundPriceSale(d.PriceCC_wt), 50, 2) + '=' +
              LTRIM(STR(dbo.zf_RoundPriceSale(d.PriceCC_wt * d.Qty), 50, 2)))) Col1,
            /* 2 */ CASE @UseProdNotes WHEN 0 THEN p.ProdName ELSE p.Notes END Col2,
            /* 3 */ '' Col3,
            '' Barcode
          FROM t_SaleTempD d WITH(NOLOCK), r_Prods p WITH(NOLOCK)
          WHERE d.ProdID = p.ProdID AND d.ChID = @ChID AND d.Qty < 0
          UNION ALL
          SELECT
            '--------------------' Col1,
            '' Col2,
            '' Col3,
            '' Barcode
        END
    END

  IF @Action IN (11, 12)
    BEGIN
      DECLARE @LastZRep datetime, @Time datetime
      SET @Time = GETDATE()
      SELECT @LastZRep = ISNULL((SELECT TOP 1 DocTime FROM t_zRep WHERE CRID = @CRID ORDER BY DocTime DESC), '1900-01-01 00:00:00')

      /* Для Z-отчета смещаем диапазон: от позапрошлого Z-отчета до прошлого */
      IF @Action = 12
        SELECT
          @Time = @LastZRep,
          @LastZRep = ISNULL((SELECT TOP 1 DocTime FROM t_zRep WHERE CRID = @CRID AND DocTime < @LastZRep ORDER BY DocTime DESC), '1900-01-01 00:00:00')

      IF @Action = 11 SELECT @s1 = 'X-отчет'
      IF @Action = 12 SELECT @s1 = 'Z-отчет'

      INSERT INTO @Out(Col1, Col2, Col3, Barcode)
      SELECT
        '' Col1,
        @s1 Col2,
        '--------------------------' Col3,
        '' Barcode
      UNION ALL
      SELECT
        /* 1 */ 'ВСЕГО ОТМЕН:@WidthJustify@' + CAST(COUNT(*) AS varchar(20)) Col1,
        /* 2 */ 'СУММА ОТМЕН:@WidthJustify@' + CAST(LTRIM(STR(-SUM(c.SumCC_wt), 50, 2)) AS varchar(20)) Col2,
        /* 3 */ '' Col3,
        '' Barcode
      FROM t_Sale m WITH(NOLOCK), t_SaleC c WITH(NOLOCK)
      WHERE m.ChID = c.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID
    END

  /* Информация о подарочном сертификате c DCardID = @AParam1 */ 
  IF @Action = 2
    BEGIN
      DECLARE @EDate smalldatetime
      DECLARE @BDate smalldatetime
      DECLARE @Now smalldatetime
      DECLARE @DCardID varchar(250)
      DECLARE @Value numeric(21, 2)
      DECLARE @AutoCalcSum int
      DECLARE @InUse bit

      /* Определяем, какое поле отвечает за сумму бонусов на подарочном сертификате */
      SELECT @AutoCalcSum = AutoCalcSum FROM r_PayForms WHERE PayFormCode = 5

      SELECT @Now = dbo.zf_GetDate(Now) FROM vz_Now

      SELECT @EDate = r.EDate, @DCardID = @AParam1, @BDate = r.BDate, @InUse = r.InUse,
             @Value = ISNULL(dbo.tf_GetDCardPaySum(-1, -1, r.DCardID, 5), 0)
      FROM r_DCards r
      INNER JOIN r_DCTypes t ON t.DCTypeCode = r.DCTypeCode
      WHERE r.DCardID = @AParam1

      INSERT INTO @Out(Col1, Col2, Col3, Barcode)
      SELECT
        'ІНФОРМАЦІЯ' Col1,
        'ПРО ПОДАРУНКОВИЙ СЕРТИФІКАТ' Col2,
        ' ' Col3,
        '' Barcode

      IF @InUse = 0
        INSERT INTO @Out(Col1, Col2, Col3, Barcode)
        SELECT
        '-----------------------------' Col1,
        '         НЕДІЙСНИЙ   ' Col2,
        '-----------------------------' Col3,
        '' Barcode

      IF @InUse = 1 AND (@Now > @EDate)
        INSERT INTO @Out(Col1, Col2, Col3, Barcode)
        SELECT
        '-----------------------------' Col1,
        '        ПРОСТРОЧЕНИЙ   ' Col2,
        '-----------------------------' Col3,
        '' Barcode

      INSERT INTO @Out(Col1, Col2, Col3, Barcode)
      SELECT
        'НОМЕР:@WidthJustify@' + @DCardID Col1,
        ' ' Col2,
        'НОМІНАЛ:@WidthJustify@' + CAST(@Value AS VARCHAR(20)) Col3,
        '' Barcode
      UNION ALL
      SELECT
        ' ' Col1,
        'АКТИВОВАНИЙ:@WidthJustify@' + CONVERT(varchar(20), @BDate, 104) Col2,
        '' Col3,
        '' Barcode
      UNION ALL
      SELECT
        ' ' Col1,
        'ДІЄ ДО:@WidthJustify@' + ISNULL(CONVERT(varchar(20), @EDate, 104), 'не визначено') Col2,
        ' ' Col3,
        '' Barcode
      UNION ALL
      SELECT
        'У разі виникнення питань' Col1,
        'звертайтесь до Гарячої линії' Col2,
        '-----------------------------' Col3,
        '' Barcode
    END

  IF (SELECT COUNT(*) FROM @Out) < 2 DELETE FROM @Out

  SELECT Col1, Col2, Col3, Barcode FROM @Out ORDER BY SrcPosID
END
GO
