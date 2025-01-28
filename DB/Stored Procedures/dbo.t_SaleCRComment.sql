SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleCRComment](@ChID bigint)
/* Возвращает комментарии к чеку */
AS
BEGIN
  DECLARE @out table(SrcPosID int identity(1, 1), Col1 varchar(250), Col2 varchar(250), Col3 varchar(250), BarCode VARCHAR(250))

  DECLARE @String varchar(8000), @ExtraInfo varchar(MAX)
  DECLARE @idx int     
  DECLARE @slice varchar(8000)     
  DECLARE @delimiter char(1)
  SELECT @String = ''
  EXEC t_DiscOnPrint 1011, @ChID, 0, @String OUTPUT
  SELECT @idx = 1, @delimiter = CHAR(13)
  IF LEN(@String)>1 AND @String IS NOT NULL 
    WHILE @idx!= 0     
    BEGIN     
      SET @idx = CHARINDEX(@Delimiter, @String)     
        IF @idx!=0     
          SET @slice = REPLACE(REPLACE(RTRIM(LTRIM(LEFT(@String, @idx-1))), CHAR(13), ''), CHAR(10), '')  
        ELSE
          SET @slice = @String     

        IF(LEN(@slice)>0)
            INSERT INTO @Out(Col1, Col2, Col3, BarCode)
            VALUES(@slice, '', '', '')     

        SET @String = RTRIM(LTRIM(RIGHT(@String, LEN(@String) - @idx + 1)))
        SET @idx = CHARINDEX(@Delimiter, @String)
        IF @idx = 1
          SET @String = RIGHT(@String, LEN(@String)-1)
        SET @String = RTRIM(LTRIM(@String))
        IF LEN(@String) = 0 BREAK
    END 

  IF EXISTS(SELECT * FROM t_SaleTempD WHERE ChID = @ChID AND Qty < 0)
    BEGIN
      DECLARE @UseProdNotes bit
      SELECT @UseProdNotes = c.UseProdNotes
      FROM t_SaleTemp m WITH(NOLOCK), r_CRs c WITH(NOLOCK)
      WHERE m.CRID = c.CRID AND m.ChID = @ChID

      INSERT INTO @Out(Col1, Col2, Col3, BarCode)
      SELECT 
        '--------------------' Col1,
        dbo.zf_Translate('Список отмен по чеку') Col2,
        '--------------------' Col3,
        '' Barcode
      UNION ALL
      SELECT
        /* 1 */ (
          LTRIM(STR(d.Qty, 10, 3)) + ' X ' +
          LTRIM(STR(dbo.zf_RoundPriceSale(d.PriceCC_wt), 50, 2) + '=' +
          LTRIM(STR(dbo.zf_RoundPriceSale(d.PriceCC_wt * d.Qty), 50, 2)))) Col1,
        /* 2 */ CASE @UseProdNotes WHEN 0 THEN p.ProdName ELSE p.Notes END Col2,
        /* 3 */ '' Col3, 
        '' BarCode
      FROM t_SaleTempD d WITH(NOLOCK), r_Prods p WITH(NOLOCK)
      WHERE d.ProdID = p.ProdID AND d.ChID = @ChID AND d.Qty < 0
    END

  IF EXISTS(SELECT * FROM t_LogDiscExp l WITH(NOLOCK), r_Discs d WITH(NOLOCK) WHERE l.DocCode = 1011 AND l.ChID = @ChID AND l.SrcPosID IS NULL AND l.DiscCode <> 0 AND l.DiscCode = d.DiscCode AND d.PrintInCheque = 1) 
    BEGIN
      INSERT INTO @Out(Col1, Col2, Col3, Barcode)
      SELECT
        '--------------------' Col1,
        dbo.zf_Translate('Скидки по чеку') Col2,
        '--------------------' Col3,
        '' Barcode
      UNION ALL
      SELECT 
        /* 1 */ d.DiscName + ' ' + CASE WHEN l.Discount <> 0 THEN (CAST(CAST(l.Discount AS int) AS varchar(20))) + '%' ELSE (CAST(CAST(l.SumBonus AS numeric(21, 2)) AS varchar(20))) + dbo.zf_Translate(' грн.') END Col1,
        /* 2 */ '' Col2,
        /* 3 */ '' Col3,
        '' BarCode
      FROM t_LogDiscExp l WITH(NOLOCK), r_Discs d WITH(NOLOCK)
      WHERE l.DiscCode = d.DiscCode AND l.DiscCode <> 0 AND l.DocCode = 1011 AND l.ChID = @ChID AND l.SrcPosID IS NULL AND d.PrintInCheque = 1
    END

  /* Печать купонов процессинга BPM */ 
  SELECT @ExtraInfo = ExtraInfo FROM t_SaleTemp WHERE ChID = @ChID
  IF ISNULL(@ExtraInfo, '') <> ''
    BEGIN
      DECLARE @xml xml
      SET @xml = @ExtraInfo
      INSERT INTO @Out(Col1, Col2, Col3, Barcode)
      SELECT '', '', '',
        c.value('(./text())[1]','Varchar(200)') as [Barcode]
        FROM @xml.nodes('//BPM/ResponseCoupons/child::node()') as a(c) 
    END

  IF EXISTS(SELECT TOP 1 1 FROM @Out) INSERT INTO @Out(Col1, Col2, Col3, Barcode) VALUES ('--------------------', '', '', '')

  SELECT Col1, Col2, Col3, Barcode FROM @Out ORDER BY SrcPosID
END

GO
