SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[b_GetXMLJ0200514]
/* Налоговая декларация по НДС. Приложение 1. Расчет корректировки сумм НДС (Д1) */
/* J0200519	Дод.1 Розрахунок коригування сум ПДВ (Д1) 05.04.2017 */
(
  @OurID int, @DocDate smalldatetime
)
AS
SET NOCOUNT ON

DECLARE
	 @OurName varchar(250), @MonthChar char(2), @YearChar char(4),
	 @Year int, @Month int,
	 @FillDate char(8), @Code varchar(250), @TaxCode varchar(250),
	 @TaxRegNo varchar(250), @Job1 varchar(250), @Job2 varchar(250),
	 @Tab1 char(1), @Tab2 char(2)
DECLARE
  @t1 TABLE (ChID bigint, ChIDInv bigint, OurID int, CompID int, DocID bigint)
SELECT
	 @Year = Year(@DocDate), @Month = Month(@DocDate)
SELECT
	 @OurName = OurName, @Code = Code, @TaxCode = TaxCode,
	 @TaxRegNo = TaxRegNo, @Job1 = Job1, @Job2 = Job2
FROM r_Ours where OurID = @OurID

SELECT
	 @FillDate = replace(convert(varchar, getdate(), 104), '.', ''),
	 @MonthChar = right(cast(100 + @Month as varchar), 2),
	 @YearChar = cast(@Year as varchar),
	 @Tab1 = char(9), @Tab2 = char(9) + char(9)


INSERT INTO @t1
/* ChID    - Код регистрации налоговой накладной (корректировки),
   ChIDInv - Код регистрации расходной накладной,
   OurID   - Код фирмы (налоговая накладная (корректировка)),
   CompID  - Код предприятия (налоговая накладная (корректировка)),
   DocID   - Номер документа (налоговая накладная (корректировка)),
*/
SELECT l.ChildChID AS ChID, MAX(tt.ChID) AS ChIDInv,
  e.OurID, e.CompID, e.DocID
FROM b_Ret m
INNER JOIN b_RetD d ON m.ChID = d.ChID AND m.OurID = @OurID
INNER JOIN dbo.z_DocLinks l ON m.ChID = l.ParentChID and l.ChildDocCode= 14342
INNER JOIN b_TExp e ON l.ChildChID = e.ChID AND e.DocDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate)

INNER JOIN (
            SELECT DISTINCT
              e.ChID AS ChID1, m.OurID, dd.ChID
            FROM b_Ret m
            INNER JOIN b_RetD d ON m.ChID = d.ChID
            INNER JOIN dbo.z_DocLinks l ON m.ChID = l.ParentChID and l.ChildDocCode= 14342
            INNER JOIN b_TExp e ON l.ChildChID = e.ChID
            INNER JOIN
              (SELECT u.RefID, u.RefName
               FROM r_UniTypes ut
               INNER JOIN dbo.r_Uni u ON ut.RefTypeID = u.RefTypeID
               AND ut.RefTypeName = dbo.zf_Translate('Справочник причин корректировки налоговых накладных')) u
               ON e.TaxCorrType = u.RefID
               INNER JOIN dbo.r_Prods p ON d.ProdID = p.ProdID
               INNER JOIN b_InvD dd ON dd.ChID = dbo.bf_GetInvChID(m.ChID, d.ProdID, d.PPID, d.PriceCC_wt) AND dd.ProdID = d.ProdID AND dd.PPID = d.PPID AND dd.PriceCC_wt = d.PriceCC_wt AND e.OurID = m.OurID AND m.OurID = @OurID
            ) tt ON l.ChildChID = tt.ChID1
GROUP BY l.ChildChID, e.OurID, e.CompID, e.DocID
/* ----------------------------- */

DECLARE @UT TABLE
(
	 RowID int identity, XMLText varchar(8000)
)

INSERT INTO @UT(XMLText)
SELECT
	'<?xml version="1.0" encoding="windows-1251"?>'
UNION ALL SELECT
	'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J0200519.xsd">'
UNION ALL SELECT
  @Tab1 + '<DECLARHEAD>'
UNION ALL SELECT
	 @Tab2 + '<TIN>' + @Code + '</TIN>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC>J02</C_DOC>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC_SUB>005</C_DOC_SUB>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC_VER>19</C_DOC_VER>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC_TYPE>0</C_DOC_TYPE>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC_CNT>1</C_DOC_CNT>'
UNION ALL SELECT
/*@Tab2 + '<C_REG></C_REG>'*/
/*UNION ALL SELECT*/
/*@Tab2 + '<C_RAJ></C_RAJ>'*/
/*UNION ALL SELECT*/
	 @Tab2 + '<PERIOD_MONTH>' + @MonthChar + '</PERIOD_MONTH>'
UNION ALL SELECT
	 @Tab2 + '<PERIOD_TYPE>1</PERIOD_TYPE>'
UNION ALL SELECT
	 @Tab2 + '<PERIOD_YEAR>' + @YearChar + '</PERIOD_YEAR>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC_STAN>1</C_DOC_STAN>'
UNION ALL SELECT
	 @Tab2 + '<D_FILL>' + @FillDate + '</D_FILL>'
UNION ALL SELECT
	 @Tab1 + '</DECLARHEAD>'
UNION ALL SELECT
	 @Tab1 + '<DECLARBODY>'
UNION ALL SELECT
  @Tab2 + '<HZ>1</HZ>'
UNION ALL SELECT
	 @Tab2 + '<HZY>' + @YearChar + '</HZY>'
UNION ALL SELECT
	 @Tab2 + '<HZM>' + @MonthChar + '</HZM>'
UNION ALL SELECT
	 @Tab2 + '<HNAME>' + @OurName + '</HNAME>'
UNION ALL SELECT
  @Tab2 + '<HTIN>' + @Code + '</HTIN>'
UNION ALL SELECT
	 @Tab2 + '<HNPDV>' + @TaxCode + '</HNPDV>'
UNION ALL SELECT
	 @Tab2 + '<HFILL>' + @FillDate + '</HFILL>'
UNION ALL SELECT
	 @Tab2 + '<HBOS>' + @Job1 + '</HBOS>'
UNION ALL SELECT
	 @Tab2 + '<HBUH>' + @Job2 + '</HBUH>'


DECLARE @T11RXXXXG2S varchar(200), @T11RXXXXG3 varchar(15), @T11RXXXXG4D char(8), @T11RXXXXG5S varchar(20), @T11RXXXXG6S varchar(30),
        @T11RXXXXG7D char(8), @T11RXXXXG8S varchar(250), @T11RXXXXG9 decimal(18,2), @T11RXXXXG10 decimal(18,2), @T11RXXXXG11 decimal(18,2),
        @T11RXXXXG12 decimal(18,2), @T11RXXXXG13 decimal(18,2),
		     @RowNum int, @RowNumChar varchar(12),
		     @R011G9 decimal(18,2), @R011G10 decimal(18,2), @R011G11 decimal(18,2), @R011G12 decimal(18,2), @R011G13 decimal(18,2),
		     @RowNum2 int, @RowNumChar2 varchar(12),
		     @R012G9 decimal(18,2), @R012G10 decimal(18,2), @R012G11 decimal(18,2), @R012G12 decimal(18,2), @R012G13 decimal(18,2),
		     @R010G9 decimal(18,2), @R010G10 decimal(18,2), @R010G11 decimal(18,2), @R010G12 decimal(18,2), @R010G13 decimal(18,2)

DECLARE Rows cursor fast_forward for

  SELECT
    c.CompName AS T11RXXXXG2S,
    c.TaxCode AS T11RXXXXG3,
    REPLACE(CONVERT(varchar, t1.DocDate, 104), '.', '') AS T11RXXXXG4D,
    t1.IntDocID AS T11RXXXXG5S,
    e.IntDocID AS T11RXXXXG6S,
    REPLACE(CONVERT(varchar, e.DocDate, 104), '.', '') AS T11RXXXXG7D,
    '' AS T11RXXXXG8S,
    e.SumCC_nt_20 AS T11RXXXXG9,
    e.SumCC_nt_7 AS T11RXXXXG10,
    e.TaxSum_20 AS T11RXXXXG11,
    e.TaxSum_7 AS T11RXXXXG12,
    e.SumCC_nt_Free + e.SumCC_nt_No  AS T11RXXXXG13
  FROM b_TExp e
  INNER JOIN
    (SELECT u.RefID, u.RefName
     FROM r_UniTypes ut
     INNER JOIN dbo.r_Uni u ON ut.RefTypeID = u.RefTypeID
     AND ut.RefTypeName = dbo.zf_Translate('Справочник причин корректировки налоговых накладных')) u
  ON e.TaxCorrType = u.RefID
  INNER JOIN r_Comps c on e.CompID = c.CompID
  LEFT JOIN (SELECT t.*, m.IntDocID, m.DocDate FROM @t1 t
  INNER JOIN b_Inv m ON t.ChIDInv = m.ChID) t1 ON e.ChID = t1.ChID
  WHERE e.PosType <> 1 AND e.OurID = @OurID AND e.DocDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate)

open Rows
	 fetch next FROM Rows
	 into @T11RXXXXG2S, @T11RXXXXG3, @T11RXXXXG4D, @T11RXXXXG5S, @T11RXXXXG6S, @T11RXXXXG7D,
	      @T11RXXXXG8S, @T11RXXXXG9, @T11RXXXXG10, @T11RXXXXG11, @T11RXXXXG12, @T11RXXXXG13

SELECT @RowNum = 1
SELECT @RowNum2 = 1
SELECT @R011G9 = 0
SELECT @R011G10 = 0
SELECT @R011G11 = 0
SELECT @R011G12 = 0
SELECT @R011G13 = 0

SELECT @R012G9 = 0
SELECT @R012G10 = 0
SELECT @R012G11 = 0
SELECT @R012G12 = 0
SELECT @R012G13 = 0

SELECT @R010G9 = 0
SELECT @R010G10 = 0
SELECT @R010G11 = 0
SELECT @R010G12 = 0
SELECT @R010G13 = 0

WHILE @@fetch_status = 0
BEGIN

IF CONVERT(datetime,RIGHT(@T11RXXXXG4D,4)+SUBSTRING(@T11RXXXXG4D,3,2)+LEFT(@T11RXXXXG4D,2)) < '20150201'
BEGIN
  SELECT @RowNumChar = cast(@RowNum as varchar)
  INSERT INTO @UT(XMLText) SELECT
		 @Tab2 + '<T11RXXXXG2S ROWNUM="' + @RowNumChar + '">' + @T11RXXXXG2S + '</T11RXXXXG2S>'
	 UNION ALL SELECT
	  	@Tab2 + '<T11RXXXXG3 ROWNUM="' + @RowNumChar + '">' + @T11RXXXXG3 + '</T11RXXXXG3>'
	 UNION ALL SELECT
	  	@Tab2 + '<T11RXXXXG4D ROWNUM="' + @RowNumChar + '">' + @T11RXXXXG4D + '</T11RXXXXG4D>'
	 UNION ALL SELECT
	  	@Tab2 + '<T11RXXXXG5S ROWNUM="' + @RowNumChar + '">' + @T11RXXXXG5S + '</T11RXXXXG5S>'
	 UNION ALL SELECT
	  	@Tab2 + '<T11RXXXXG6S ROWNUM="' + @RowNumChar + '">' + @T11RXXXXG6S + '</T11RXXXXG6S>'
	 UNION ALL SELECT
	  	@Tab2 + '<T11RXXXXG7D ROWNUM="' + @RowNumChar + '">' + @T11RXXXXG7D + '</T11RXXXXG7D>'
	 UNION ALL SELECT
	  	@Tab2 + '<T11RXXXXG8S ROWNUM="' + @RowNumChar + '">' + @T11RXXXXG8S + '</T11RXXXXG8S>'
	 UNION ALL SELECT
	  	@Tab2 + '<T11RXXXXG9 ROWNUM="' + @RowNumChar + '">' + cast(@T11RXXXXG9 as varchar) + '</T11RXXXXG9>'
	 UNION ALL SELECT
		 @Tab2 + '<T11RXXXXG10 ROWNUM="' + @RowNumChar + '">' + cast(@T11RXXXXG10 as varchar) + '</T11RXXXXG10>'
	 UNION ALL SELECT
	  	@Tab2 + '<T11RXXXXG11 ROWNUM="' + @RowNumChar + '">' + cast(@T11RXXXXG11 as varchar) + '</T11RXXXXG11>'
	 UNION ALL SELECT
	  	@Tab2 + '<T11RXXXXG12 ROWNUM="' + @RowNumChar + '">' + cast(@T11RXXXXG12 as varchar) + '</T11RXXXXG12>'
	 UNION ALL SELECT
		 @Tab2 + '<T11RXXXXG13 ROWNUM="' + @RowNumChar + '">' + cast(@T11RXXXXG13 as varchar) + '</T11RXXXXG13>'

	 SELECT @R011G9 = @R011G9 + @T11RXXXXG9
	 SELECT @R011G10 = @R011G10 + @T11RXXXXG10
	 SELECT @R011G11 = @R011G11 + @T11RXXXXG11
	 SELECT @R011G12 = @R011G12 + @T11RXXXXG12
	 SELECT @R011G13 = @R011G13 + @T11RXXXXG13
	 SELECT @RowNum = @RowNum + 1
END
ELSE
BEGIN
SELECT @RowNumChar2 = cast(@RowNum2 as varchar)
	 INSERT INTO @UT(XMLText) SELECT
	   @Tab2 + '<T12RXXXXG2S ROWNUM="' + @RowNumChar2 + '">' + @T11RXXXXG2S + '</T12RXXXXG2S>'
	 UNION ALL SELECT
	   @Tab2 + '<T12RXXXXG3 ROWNUM="' + @RowNumChar2 + '">' + @T11RXXXXG3 + '</T12RXXXXG3>'
	 UNION ALL SELECT
	   @Tab2 + '<T12RXXXXG4D ROWNUM="' + @RowNumChar2 + '">' + @T11RXXXXG4D + '</T12RXXXXG4D>'
	 UNION ALL SELECT
	   @Tab2 + '<T12RXXXXG5S ROWNUM="' + @RowNumChar2 + '">' + @T11RXXXXG5S + '</T12RXXXXG5S>'
	 UNION ALL SELECT
		 @Tab2 + '<T12RXXXXG6S ROWNUM="' + @RowNumChar2 + '">' + @T11RXXXXG6S + '</T12RXXXXG6S>'
	 UNION ALL SELECT
	   @Tab2 + '<T12RXXXXG7D ROWNUM="' + @RowNumChar2 + '">' + @T11RXXXXG7D + '</T12RXXXXG7D>'
	 UNION ALL SELECT
	   @Tab2 + '<T12RXXXXG8S ROWNUM="' + @RowNumChar2 + '">' + @T11RXXXXG8S + '</T12RXXXXG8S>'
	 UNION ALL SELECT
	   @Tab2 + '<T12RXXXXG9 ROWNUM="' + @RowNumChar2 + '">' + cast(@T11RXXXXG9 as varchar) + '</T12RXXXXG9>'
	 UNION ALL SELECT
		 @Tab2 + '<T12RXXXXG10 ROWNUM="' + @RowNumChar2 + '">' + cast(@T11RXXXXG10 as varchar) + '</T12RXXXXG10>'
	 UNION ALL SELECT
	  	@Tab2 + '<T12RXXXXG11 ROWNUM="' + @RowNumChar2 + '">' + cast(@T11RXXXXG11 as varchar) + '</T12RXXXXG11>'
	 UNION ALL SELECT
	 	@Tab2 + '<T12RXXXXG12 ROWNUM="' + @RowNumChar2 + '">' + cast(@T11RXXXXG12 as varchar) + '</T12RXXXXG12>'
	 UNION ALL SELECT
	 	@Tab2 + '<T12RXXXXG13 ROWNUM="' + @RowNumChar2 + '">' + cast(@T11RXXXXG13 as varchar) + '</T12RXXXXG13>'

	 SELECT @R012G9 = @R012G9 + @T11RXXXXG9
	 SELECT @R012G10 = @R012G10 + @T11RXXXXG10
 	SELECT @R012G11 = @R012G11 + @T11RXXXXG11
	 SELECT @R012G12 = @R012G12 + @T11RXXXXG12
	 SELECT @R012G13 = @R012G13 + @T11RXXXXG13
	 SELECT @RowNum2 = @RowNum2 + 1
END

fetch next FROM Rows
	 into @T11RXXXXG2S, @T11RXXXXG3, @T11RXXXXG4D, @T11RXXXXG5S, @T11RXXXXG6S, @T11RXXXXG7D,
	      @T11RXXXXG8S, @T11RXXXXG9, @T11RXXXXG10, @T11RXXXXG11, @T11RXXXXG12, @T11RXXXXG13
END
close Rows
deallocate ROWS

  INSERT INTO @UT(XMLText) SELECT
		 @Tab2 + '<R011G9>' + cast(@R011G9 as varchar) + '</R011G9>'
  UNION ALL SELECT
	   @Tab2 + '<R011G11>' + cast(@R011G11 as varchar) + '</R011G11>'
	 UNION ALL SELECT
	   @Tab2 + '<R011G13>' + cast(@R011G13 as varchar) + '</R011G13>'
	 UNION ALL SELECT
	   @Tab2 + '<R011G10>' + cast(@R011G10 as varchar) + '</R011G10>'
	 UNION ALL SELECT
	   @Tab2 + '<R011G12>' + cast(@R011G12 as varchar) + '</R011G12>'

  INSERT INTO @UT(XMLText) SELECT
		 @Tab2 + '<R012G9>' + cast(@R012G9 as varchar) + '</R012G9>'
  UNION ALL SELECT
	   @Tab2 + '<R012G11>' + cast(@R012G11 as varchar) + '</R012G11>'
  UNION ALL SELECT
	   @Tab2 + '<R012G13>' + cast(@R012G13 as varchar) + '</R012G13>'
	 UNION ALL SELECT
	   @Tab2 + '<R012G10>' + cast(@R012G10 as varchar) + '</R012G10>'
	 UNION ALL SELECT
	   @Tab2 + '<R012G12>' + cast(@R012G12 as varchar) + '</R012G12>'

  SELECT @R010G9 = ROUND(@R011G9,0) + ROUND(@R012G9,0)
  SELECT @R010G10 = ROUND(@R011G10,0) + ROUND(@R012G10,0)
  SELECT @R010G11 = ROUND(@R011G11,0) + ROUND(@R012G11,0)
  SELECT @R010G12 = ROUND(@R011G12,0) + ROUND(@R012G12,0)
  SELECT @R010G13 = ROUND(@R011G13,0) + ROUND(@R012G13,0)

  INSERT INTO @UT(XMLText) SELECT
		 @Tab2 + '<R010G9>' + cast(@R010G9 as varchar) + '</R010G9>'
	 UNION ALL SELECT
	   @Tab2 + '<R010G11>' + cast(@R010G11 as varchar) + '</R010G11>'
	 UNION ALL SELECT
	   @Tab2 + '<R010G13>' + cast(@R010G13 as varchar) + '</R010G13>'
	 UNION ALL SELECT
	   @Tab2 + '<R010G10>' + cast(@R010G10 as varchar) + '</R010G10>'
	 UNION ALL SELECT
	   @Tab2 + '<R010G12>' + cast(@R010G12 as varchar) + '</R010G12>'

  DECLARE @T21RXXXXG2S varchar(200), @T21RXXXXG3 varchar(15), @T21RXXXXG4D char(8), @T21RXXXXG5S varchar(20), @T21RXXXXG6S varchar(30),
          @T21RXXXXG7D char(8), @T21RXXXXG8S varchar(250), @T21RXXXXG9 decimal(18,2), @T21RXXXXG10 decimal(18,2), @T21RXXXXG11 decimal(18,2),
          @T21RXXXXG12 decimal(18,2), @T21RXXXXG13 decimal(18,2), @T21RXXXXG14 decimal(18,2), @T21RXXXXG15 decimal(18,2),
		       @R021G9 decimal(18,2), @R021G10 decimal(18,2), @R021G11 decimal(18,2), @R021G12 decimal(18,2),
		       @R021G13 decimal(18,2), @R021G14 decimal(18,2), @R021G15 decimal(18,2)

DECLARE Rows cursor fast_forward for

SELECT
  c.CompName AS T21RXXXXG2S,
  c.TaxCode AS T21RXXXXG3,
  REPLACE(CONVERT(varchar, e.DocDate, 104), '.', '') AS T21RXXXXG4D,
  e.IntDocID AS T21RXXXXG5S,
  null AS T21RXXXXG6S,
  null AS T21RXXXXG7D,
  '' AS T21RXXXXG8S,
  e.SumCC_nt_20 AS T21RXXXXG9,
  e.SumCC_nt_7 AS T21RXXXXG10,
  e.TaxSum_20 AS T21RXXXXG11,
  e.TaxSum_7 AS T21RXXXXG12,
  e.SumCC_nt_Free + e.SumCC_nt_No  AS T21RXXXXG13,
  0 AS T21RXXXXG14,
  0 AS T21RXXXXG15
FROM b_TRec e
INNER JOIN
  (SELECT u.RefID, u.RefName
   FROM r_UniTypes ut
   INNER JOIN dbo.r_Uni u ON ut.RefTypeID = u.RefTypeID
   AND ut.RefTypeName = dbo.zf_Translate('Справочник причин корректировки налоговых накладных')) u
ON e.TaxCorrType = u.RefID
INNER JOIN r_Comps c on e.CompID = c.CompID
WHERE e.PosType <> 1 AND e.OurID = @OurID AND e.DocDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate)

open Rows
fetch next FROM Rows
into @T21RXXXXG2S, @T21RXXXXG3, @T21RXXXXG4D, @T21RXXXXG5S, @T21RXXXXG6S, @T21RXXXXG7D,
	    @T21RXXXXG8S, @T21RXXXXG9, @T21RXXXXG10, @T21RXXXXG11, @T21RXXXXG12, @T21RXXXXG13, @T21RXXXXG14, @T21RXXXXG15

SELECT @RowNum = 1
SELECT @R021G9 = 0
SELECT @R021G10 = 0
SELECT @R021G11 = 0
SELECT @R021G12 = 0
SELECT @R021G13 = 0
SELECT @R021G14 = 0
SELECT @R021G15 = 0
WHILE @@fetch_status = 0
BEGIN
  SELECT @RowNumChar = cast(@RowNum as varchar)

	 INSERT INTO @UT(XMLText) SELECT
	   @Tab2 + '<T21RXXXXG2S ROWNUM="' + @RowNumChar + '">' + @T21RXXXXG2S + '</T21RXXXXG2S>'
	 UNION ALL SELECT
		 @Tab2 + '<T21RXXXXG3 ROWNUM="' + @RowNumChar + '">' + @T21RXXXXG3 + '</T21RXXXXG3>'
	 UNION ALL SELECT
		 @Tab2 + '<T21RXXXXG4D ROWNUM="' + @RowNumChar + '">' + @T21RXXXXG4D + '</T21RXXXXG4D>'
	 UNION ALL SELECT
		 @Tab2 + '<T21RXXXXG5S ROWNUM="' + @RowNumChar + '">' + @T21RXXXXG5S + '</T21RXXXXG5S>'
	 UNION ALL SELECT
	   @Tab2 + '<T21RXXXXG6S ROWNUM="' + @RowNumChar + '">' + @T21RXXXXG6S + '</T21RXXXXG6S>'
	 UNION ALL SELECT
	   @Tab2 + '<T21RXXXXG7D ROWNUM="' + @RowNumChar + '">' + @T21RXXXXG7D + '</T21RXXXXG7D>'
	 UNION ALL SELECT
	   @Tab2 + '<T21RXXXXG8S ROWNUM="' + @RowNumChar + '">' + @T21RXXXXG8S + '</T21RXXXXG8S>'
	 UNION ALL SELECT
	   @Tab2 + '<T21RXXXXG9 ROWNUM="' + @RowNumChar + '">' + cast(@T21RXXXXG9 as varchar) + '</T21RXXXXG9>'
	 UNION ALL SELECT
	   @Tab2 + '<T21RXXXXG10 ROWNUM="' + @RowNumChar + '">' + cast(@T21RXXXXG10 as varchar) + '</T21RXXXXG10>'
	 UNION ALL SELECT
		 @Tab2 + '<T21RXXXXG11 ROWNUM="' + @RowNumChar + '">' + cast(@T21RXXXXG11 as varchar) + '</T21RXXXXG11>'
	 UNION ALL SELECT
	  	@Tab2 + '<T21RXXXXG12 ROWNUM="' + @RowNumChar + '">' + cast(@T21RXXXXG12 as varchar) + '</T21RXXXXG12>'
	 UNION ALL SELECT
		 @Tab2 + '<T21RXXXXG13 ROWNUM="' + @RowNumChar + '">' + cast(@T21RXXXXG13 as varchar) + '</T21RXXXXG13>'
	 UNION ALL SELECT
		 @Tab2 + '<T21RXXXXG14 ROWNUM="' + @RowNumChar + '">' + cast(@T21RXXXXG14 as varchar) + '</T21RXXXXG14>'
	 UNION ALL SELECT
		 @Tab2 + '<T21RXXXXG15 ROWNUM="' + @RowNumChar + '">' + cast(@T21RXXXXG15 as varchar) + '</T21RXXXXG15>'

	 fetch next FROM Rows
	 into @T21RXXXXG2S, @T21RXXXXG3, @T21RXXXXG4D, @T21RXXXXG5S, @T21RXXXXG6S, @T21RXXXXG7D,
	      @T21RXXXXG8S, @T21RXXXXG9, @T21RXXXXG10, @T21RXXXXG11, @T21RXXXXG12, @T21RXXXXG13, @T21RXXXXG14, @T21RXXXXG15
	 SELECT @RowNum = @RowNum + 1
	 SELECT @R021G9 = @R021G9 + @T21RXXXXG9
	 SELECT @R021G10 = @R021G10 + @T21RXXXXG10
	 SELECT @R021G11 = @R021G11 + @T21RXXXXG11
	 SELECT @R021G12 = @R021G12 + @T21RXXXXG12
	 SELECT @R021G13 = @R021G13 + @T21RXXXXG13
  SELECT @R021G14 = @R021G14 + @T21RXXXXG14
	 SELECT @R021G15 = @R021G15 + @T21RXXXXG15
END
close Rows
deallocate ROWS

  INSERT INTO @UT(XMLText) SELECT
		  @Tab2 + '<R021G9>' + cast(@R021G9 as varchar) + '</R021G9>'
	 UNION ALL SELECT
	    @Tab2 + '<R021G10>' + cast(@R021G10 as varchar) + '</R021G10>'
	 UNION ALL SELECT
	    @Tab2 + '<R021G11>' + cast(@R021G11 as varchar) + '</R021G11>'
	 UNION ALL SELECT
	    @Tab2 + '<R021G12>' + cast(@R021G12 as varchar) + '</R021G12>'
	 UNION ALL SELECT
	    @Tab2 + '<R021G13>' + cast(@R021G13 as varchar) + '</R021G13>'
	 UNION ALL SELECT
	    @Tab2 + '<R021G14>' + cast(@R021G14 as varchar) + '</R021G14>'
	 UNION ALL SELECT
	    @Tab2 + '<R021G15>' + cast(@R021G15 as varchar) + '</R021G15>'
	 UNION ALL SELECT
	    @Tab1 + '</DECLARBODY>'
  UNION ALL SELECT
	    '</DECLAR>'

SELECT XMLText FROM @UT order by RowID
GO