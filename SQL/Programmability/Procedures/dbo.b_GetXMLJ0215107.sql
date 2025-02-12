SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[b_GetXMLJ0215107]
/* Налоговая декларация по НДС. Приложение 5. Расшифровки налоговых обязательств и налогового кредита в разрезе контрагентов (Д5) */
/* */
(
  @OurID int, @DocDate smalldatetime
)
as
set nocount on
DECLARE
  @OurName varchar(250), @MonthChar char(2), @YearChar char(4),
	 @Year int, @Month int,
  @FillDate char(8), @Code varchar(250), @TaxCode varchar(250),
	 @TaxRegNo varchar(250), @Job1 varchar(250), @Job2 varchar(250),
	 @Tab1 char(1), @Tab2 char(2)
SELECT
	 @Year = YEAR(@DocDate), @Month = MONTH(@DocDate)
SELECT
	 @OurName = OurName, @Code = Code, @TaxCode = TaxCode,
	 @TaxRegNo = TaxRegNo, @Job1 = Job1, @Job2 = Job2
FROM r_Ours where OurID = @OurID

SELECT
  @FillDate = replace(convert(varchar, getdate(), 104), '.', ''),
  @MonthChar = right(cast(100 + @Month as varchar), 2),
	 @YearChar = cast(@Year as varchar),
  @Tab1 = char(9), @Tab2 = char(9) + char(9)

DECLARE @t TABLE (DocDate datetime, CompID int, DocID int, CompName varchar(200), TaxCode varchar(200),
                  TSumCC_wt decimal(21,9), TSumCC_nt decimal(21,9), TSumCC_nt_20 decimal(21,9), TSumCC_nt_7 decimal(21,9),
                  TSumCC_nt_0 decimal(21,9), TSumCC_nt_Free decimal(21,9), TSumCC_nt_No decimal(21,9), TTaxSum decimal(21,9),
                  TTaxSum_20 decimal(21,9), TTaxSum_7 decimal(21,9), TTaxSum_Free decimal(21,9), TTaxSum_No decimal(21,9))
INSERT INTO @t
/*-----------------ТМЦ: Суммовой учет-----------------*/
SELECT DISTINCT
  m.DocDate, m.CompID, IntDocID AS DocID, c.CompName, c.TaxCode,
  SUM(m.SumCC_wt + m.SumCC2_wt + SumCC3_wt + SumCC4_wt) AS TSumCC_wt,
  SUM(m.SumCC_nt + m.SumCC2_nt + SumCC3_nt + SumCC4_nt) AS TSumCC_nt,
  SUM(m.SumCC_nt + m.SumCC2_nt + SumCC3_nt + SumCC4_nt) AS TSumCC_nt_20,
  0                                                     AS TSumCC_nt_7,
  0                                                     AS TSumCC_nt_0,
  0                                                     AS TSumCC_nt_Free,
  0                                                     AS TSumCC_nt_No,
  SUM(m.TaxSum + m.TaxSum2 + m.TaxSum3 + m.TaxSum4)     AS TTaxSum,
  SUM(m.TaxSum + m.TaxSum2 + m.TaxSum3 + m.TaxSum4)     AS TTaxSum_20,
  0                                                     AS TTaxSum_7,
  0                                                     AS TTaxSum_Free,
  0                                                     AS TTaxSum_No

FROM dbo.b_DStack AS m INNER JOIN
     dbo.r_Comps AS c ON m.CompID = c.CompID
WHERE (m.DocDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate)) AND m.OurID = @OurID
GROUP BY m.DocDate, m.CompID, IntDocID, c.CompName, c.TaxCode
/*-----------------ТМЦ: Суммовой учет-----------------*/

UNION ALL

/*-----------------Основные средства: Продажа---------*/
SELECT DISTINCT
  m.DocDate, m.CompID, m.DocID, c.CompName, c.TaxCode,
  SUM(d.SumCC_wt)      AS TSumCC_wt,
  SUM(d.SumCC_nt)      AS TSumCC_nt,
  SUM(d.SumCC_nt)      AS TSumCC_nt_20,
  0                    AS TSumCC_nt_7,
  0                    AS TSumCC_nt_0,
  0                    AS TSumCC_nt_Free,
  0                    AS TSumCC_nt_No,
  SUM(d.TaxSum)        AS TTaxSum,
  0                    AS TTaxSum_20,
  0                    AS TTaxSum_7,
  0                    AS TTaxSum_Free,
  0                    AS TTaxSum_No

FROM dbo.b_SInv AS m INNER JOIN
     dbo.b_SInvD AS d ON m.ChID = d.ChID INNER JOIN
     dbo.r_Comps AS c ON m.CompID = c.CompID
WHERE (m.DocDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate)) AND m.OurID = @OurID
GROUP BY m.DocDate, m.CompID, m.DocID, c.CompName, c.TaxCode
/*-----------------Основные средства: Продажа---------*/

UNION ALL

/*-----------------ТМЦ: Возврат от получателя---------*/
SELECT
  SrcDocDate, CompID, SrcDocID, CompName, TaxCode,
  SUM(ISNULL(TSumCC_wt,0))      AS TSumCC_wt,
  SUM(ISNULL(TSumCC_nt,0))      AS TSumCC_nt,
  SUM(ISNULL(TSumCC_nt_20,0))   AS TSumCC_nt_20,
  SUM(ISNULL(TSumCC_nt_7,0))    AS TSumCC_nt_7,
  SUM(ISNULL(TSumCC_nt_0,0))    AS TSumCC_nt_0,
  SUM(ISNULL(TSumCC_nt_Free,0)) AS TSumCC_nt_Free,
  SUM(ISNULL(TSumCC_nt_No,0))   AS TSumCC_nt_No,
  SUM(ISNULL(TTaxSum,0))        AS TTaxSum,
  SUM(ISNULL(TTaxSum_20,0))     AS TTaxSum_20,
  SUM(ISNULL(TTaxSum_7,0))      AS TTaxSum_7,
  SUM(ISNULL(TTaxSum_Free,0))   AS TTaxSum_Free,
  SUM(ISNULL(TTaxSum_No,0))     AS TTaxSum_No
FROM (
  SELECT DISTINCT
    m.SrcDocDate, m.CompID, m.SrcDocID, c.CompName, c.TaxCode,
    -d.SumCC_wt AS TSumCC_wt,
    -d.SumCC_nt AS TSumCC_nt,
    CASE WHEN (SELECT dbo.zf_GetTaxPercentByDate(p.TaxTypeID,m.DocDate)) = 20 THEN -d.SumCC_nt END AS TSumCC_nt_20,
    CASE WHEN (SELECT dbo.zf_GetTaxPercentByDate(p.TaxTypeID,m.DocDate)) = 7 THEN -d.SumCC_nt END AS TSumCC_nt_7,
    CASE WHEN (SELECT dbo.zf_GetTaxPercentByDate(p.TaxTypeID,m.DocDate)) = 0 AND p.TaxTypeID = 1 THEN -d.SumCC_nt END AS TSumCC_nt_0,
    CASE WHEN (SELECT dbo.zf_GetTaxPercentByDate(p.TaxTypeID,m.DocDate)) = 0 AND p.TaxTypeID = 2 THEN -d.SumCC_nt END AS TSumCC_nt_Free,
    CASE WHEN (SELECT dbo.zf_GetTaxPercentByDate(p.TaxTypeID,m.DocDate)) = 0 AND p.TaxTypeID = 3 THEN -d.SumCC_nt END AS TSumCC_nt_No,
    -d.TaxSum   AS TTaxSum,
    CASE WHEN (SELECT dbo.zf_GetTaxPercentByDate(p.TaxTypeID,m.DocDate)) = 20 THEN -d.TaxSum END AS TTaxSum_20,
    CASE WHEN (SELECT dbo.zf_GetTaxPercentByDate(p.TaxTypeID,m.DocDate)) = 7 THEN -d.TaxSum END AS TTaxSum_7,
    CASE WHEN (SELECT dbo.zf_GetTaxPercentByDate(p.TaxTypeID,m.DocDate)) = 0 AND p.TaxTypeID = 1 THEN -d.TaxSum END AS TTaxSum_Free,
    CASE WHEN (SELECT dbo.zf_GetTaxPercentByDate(p.TaxTypeID,m.DocDate)) = 0 AND p.TaxTypeID = 2 THEN -d.TaxSum END AS TTaxSum_No
  FROM
    dbo.b_ret AS m
  INNER JOIN dbo.b_retD AS d ON m.ChID = d.ChID AND (m.DocDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate)) AND m.OurID = @OurID
  INNER JOIN dbo.r_Prods p ON d.ProdID = p.ProdID
  INNER JOIN dbo.r_Comps AS c ON m.CompID = c.CompID) s
  GROUP BY SrcDocDate, CompID, SrcDocID, CompName, TaxCode
/*-----------------ТМЦ: Возврат от получателя---------*/

UNION ALL

/*-----------------ТМЦ: Расходная накладная---------*/
SELECT
  DocDate, CompID, DocID, CompName, TaxCode,
  SUM(ISNULL(TSumCC_wt,0))      AS TSumCC_wt,
  SUM(ISNULL(TSumCC_nt,0))      AS TSumCC_nt,
  SUM(ISNULL(TSumCC_nt_20,0))   AS TSumCC_nt_20,
  SUM(ISNULL(TSumCC_nt_7,0))    AS TSumCC_nt_7,
  SUM(ISNULL(TSumCC_nt_0,0))    AS TSumCC_nt_0,
  SUM(ISNULL(TSumCC_nt_Free,0)) AS TSumCC_nt_Free,
  SUM(ISNULL(TSumCC_nt_No,0))   AS TSumCC_nt_No,
  SUM(ISNULL(TTaxSum,0))        AS TTaxSum,
  SUM(ISNULL(TTaxSum_20,0))     AS TTaxSum_20,
  SUM(ISNULL(TTaxSum_7,0))      AS TTaxSum_7,
  SUM(ISNULL(TTaxSum_Free,0))   AS TTaxSum_Free,
  SUM(ISNULL(TTaxSum_No,0))     AS TTaxSum_No
FROM (
SELECT DISTINCT
  m.DocDate, m.CompID, m.DocID, c.CompName, c.TaxCode,
  -d.SumCC_wt AS TSumCC_wt,
  -d.SumCC_nt AS TSumCC_nt,
  CASE WHEN (SELECT dbo.zf_GetTaxPercentByDate(p.TaxTypeID,m.DocDate)) = 20 THEN -d.SumCC_nt END AS TSumCC_nt_20,
  CASE WHEN (SELECT dbo.zf_GetTaxPercentByDate(p.TaxTypeID,m.DocDate)) = 7 THEN -d.SumCC_nt END AS TSumCC_nt_7,
  CASE WHEN (SELECT dbo.zf_GetTaxPercentByDate(p.TaxTypeID,m.DocDate)) = 0 AND p.TaxTypeID = 1 THEN -d.SumCC_nt END AS TSumCC_nt_0,
  CASE WHEN (SELECT dbo.zf_GetTaxPercentByDate(p.TaxTypeID,m.DocDate)) = 0 AND p.TaxTypeID = 2 THEN -d.SumCC_nt END AS TSumCC_nt_Free,
  CASE WHEN (SELECT dbo.zf_GetTaxPercentByDate(p.TaxTypeID,m.DocDate)) = 0 AND p.TaxTypeID = 3 THEN -d.SumCC_nt END AS TSumCC_nt_No,
  -d.TaxSum   AS TTaxSum,
  CASE WHEN (SELECT dbo.zf_GetTaxPercentByDate(p.TaxTypeID,m.DocDate)) = 20 THEN -d.TaxSum END AS TTaxSum_20,
  CASE WHEN (SELECT dbo.zf_GetTaxPercentByDate(p.TaxTypeID,m.DocDate)) = 7 THEN -d.TaxSum END AS TTaxSum_7,
  CASE WHEN (SELECT dbo.zf_GetTaxPercentByDate(p.TaxTypeID,m.DocDate)) = 0 AND p.TaxTypeID = 1 THEN -d.TaxSum END AS TTaxSum_Free,
  CASE WHEN (SELECT dbo.zf_GetTaxPercentByDate(p.TaxTypeID,m.DocDate)) = 0 AND p.TaxTypeID = 2 THEN -d.TaxSum END AS TTaxSum_No

FROM
  dbo.b_Inv AS m
INNER JOIN dbo.b_InvD AS d ON m.ChID = d.ChID AND (m.DocDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate)) AND m.OurID = @OurID        INNER JOIN dbo.r_Prods p ON d.ProdID = p.ProdID
INNER JOIN dbo.r_Comps AS c ON m.CompID = c.CompID ) s
GROUP BY DocDate, CompID, DocID, CompName, TaxCode
/*-----------------ТМЦ: Расходная накладная---------*/

UNION ALL

/*-----------------НН: Исходящие--------------------*/
SELECT DISTINCT
  m.DocDate, m.CompID, m.IntDocID as DocID, c.CompName, c.TaxCode,
  SUM(m.SumCC_wt)      AS TSumCC_wt,
  SUM(m.SumCC_nt)      AS TSumCC_nt,
  SUM(m.SumCC_nt_20)   AS TSumCC_nt_20,
  SUM(m.SumCC_nt_7)    AS TSumCC_nt_7,
  SUM(m.SumCC_nt_0)    AS TSumCC_nt_0,
  SUM(m.SumCC_nt_Free) AS TSumCC_nt_Free,
  SUM(m.SumCC_nt_No)   AS TSumCC_nt_No,
  SUM(m.TaxSum)        AS TTaxSum,
  SUM(m.TaxSum_20)     AS TTaxSum_20,
  SUM(m.TaxSum_7)      AS TTaxSum_7,
  SUM(m.TaxSum_Free)   AS TTaxSum_Free,
  SUM(m.TaxSum_No)     AS TTaxSum_No

FROM
  dbo.b_TExp AS m
INNER JOIN dbo.r_Comps AS c ON m.CompID = c.CompID
WHERE  (m.DocDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate)) AND m.OurID = @OurID
GROUP BY  m.DocDate, m.IntDocID, m.CompID, c.CompName, c.TaxCode
/*-----------------НН: Исходящие--------------------*/

DECLARE @UT table
(
	  RowID int identity, XMLText varchar(8000)
)

INSERT INTO @UT(XMLText)
  SELECT
    '<?xml version="1.0" encoding="windows-1251" ?>'
  UNION ALL SELECT
	   '<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J0215119.XSD">'
  UNION ALL SELECT
	   @Tab1 + '<DECLARHEAD>'
  UNION ALL SELECT
	   @Tab2 + '<TIN>' + @Code + '</TIN>'
  UNION ALL SELECT
	   @Tab2 + '<C_DOC>J02</C_DOC>'
  UNION ALL SELECT
	   @Tab2 + '<C_DOC_SUB>151</C_DOC_SUB>'
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
    @Tab2 + '<PERIOD_MONTH>' + CAST(@Month as varchar) + '</PERIOD_MONTH>'
  UNION ALL SELECT
	   @Tab2 + '<PERIOD_TYPE>1</PERIOD_TYPE>'
  UNION ALL SELECT
	   @Tab2 + '<PERIOD_YEAR>' + @YearChar + '</PERIOD_YEAR>'
  UNION ALL SELECT
/*<C_STI_ORIG></C_STI_ORIG>*/
	   @Tab2 + '<C_DOC_STAN>1</C_DOC_STAN>'
  UNION ALL SELECT
	   @Tab2 + '<D_FILL>' + @FillDate + '</D_FILL>'
  UNION ALL SELECT
    @Tab1 + '</DECLARHEAD>'
  UNION ALL SELECT
    @Tab1 + '<DECLARBODY>'
  UNION ALL SELECT
/*<HZ>1</HZ>*/
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

/*-----------------Раздел I. Налоговые обязательства--------------------*/

DECLARE Rows cursor fast_forward for
SELECT
  t.TaxCode AS T1RXXXXG2,
  MONTH(@DocDate) AS T1RXXXXG3A,
  YEAR(@DocDate) AS T1RXXXXG3B,
  ROUND(SUM(t.TSumCC_nt_20),2) + ROUND(SUM(t.TSumCC_nt_7),2) AS T1RXXXXG4,
  ROUND(SUM(t.TTaxSum_20),2) AS T1RXXXXG5,
  ROUND(SUM(t.TTaxSum_7),2) AS T1RXXXXG6
FROM @t t
WHERE t.TSumCC_wt >= 0 AND t.TaxCode <> '0'
GROUP BY t.TaxCode
ORDER BY t.TaxCode

DECLARE 
        @T1RXXXXG2 varchar(12), @T1RXXXXG3A varchar(2), @T1RXXXXG3B varchar(4),
        @T1RXXXXG4 decimal(18,2), @T1RXXXXG5 decimal(18,2), @T1RXXXXG6 decimal(18,2),
        @RowNum int, @RowNumChar varchar(12),
        @R010G4 decimal(18,2), @R010G5 decimal(18,2), @R010G6 decimal(18,2),
        @R001G4 decimal(18,2), @R001G5 decimal(18,2), @R001G6 decimal(18,2),
        @R0011G4 decimal(18,2), @R0011G5 decimal(18,2), @R0011G6 decimal(18,2),
        @R0012G4 decimal(18,2), @R0012G5 decimal(18,2), @R0012G6 decimal(18,2),
        @R0013G4 decimal(18,2), @R0013G5 decimal(18,2), @R0013G6 decimal(18,2),
        @R0014G4 decimal(18,2), @R0014G5 decimal(18,2), @R0014G6 decimal(18,2)

open Rows
fetch next FROM Rows
into @T1RXXXXG2, @T1RXXXXG3A, @T1RXXXXG3B, @T1RXXXXG4, @T1RXXXXG5, @T1RXXXXG6
SELECT @RowNum = 1
SELECT @R010G4 = 0
SELECT @R010G5 = 0
SELECT @R010G6 = 0

SELECT @R0011G4 = 0
SELECT @R0011G5 = 0
SELECT @R0011G6 = 0

SELECT @R0012G4 = 0
SELECT @R0012G5 = 0
SELECT @R0012G6 = 0

SELECT @R0013G4 = 0
SELECT @R0013G5 = 0
SELECT @R0013G6 = 0

SELECT @R0014G4 = 0
SELECT @R0014G5 = 0
SELECT @R0014G6 = 0

while @@fetch_status = 0
begin
	 SELECT @RowNumChar = cast(@RowNum as varchar)

	 INSERT INTO @UT(XMLText) SELECT
		 @Tab2 + '<T1RXXXXG2 ROWNUM="' + @RowNumChar + '">' + @T1RXXXXG2 + '</T1RXXXXG2>'
	 UNION ALL SELECT
		 @Tab2 +  '<T1RXXXXG3A ROWNUM="' + @RowNumChar + '">' + @T1RXXXXG3A + '</T1RXXXXG3A>'
	 UNION ALL SELECT
         @Tab2 +  '<T1RXXXXG3B ROWNUM="' + @RowNumChar + '">' + @T1RXXXXG3B + '</T1RXXXXG3B>'
     UNION ALL SELECT
		 @Tab2 + '<T1RXXXXG4 ROWNUM="' + @RowNumChar + '">' + cast(@T1RXXXXG4 as varchar) + '</T1RXXXXG4>'
	 UNION ALL SELECT
		 @Tab2 + '<T1RXXXXG5 ROWNUM="' + @RowNumChar + '">' + cast(@T1RXXXXG5 as varchar) + '</T1RXXXXG5>'
	 UNION ALL SELECT
		 @Tab2 + '<T1RXXXXG6 ROWNUM="' + @RowNumChar + '">' + cast(@T1RXXXXG6 as varchar) + '</T1RXXXXG6>'

  SELECT @R010G4 = @R010G4 + @T1RXXXXG4
  SELECT @R010G5 = @R010G5 + @T1RXXXXG5
  SELECT @R010G6 = @R010G6 + @T1RXXXXG6

  IF @T1RXXXXG2 = '100000000000'
   BEGIN
     SELECT @R0011G4 = @R0011G4 + @T1RXXXXG4
     SELECT @R0011G5 = @R0011G5 + @T1RXXXXG5
     SELECT @R0011G6 = @R0011G6 + @T1RXXXXG6
   END
   IF @T1RXXXXG2 = '200000000000'
   BEGIN 
     SELECT @R0012G4 = @R0012G4 + @T1RXXXXG4
     SELECT @R0012G5 = @R0012G5 + @T1RXXXXG5
     SELECT @R0012G6 = @R0012G6 + @T1RXXXXG6
   END
   IF @T1RXXXXG2 = '300000000000'
   BEGIN 
     SELECT @R0013G4 = @R0013G4 + @T1RXXXXG4 
     SELECT @R0013G5 = @R0013G5 + @T1RXXXXG5
     SELECT @R0013G6 = @R0013G6 + @T1RXXXXG6
   END 
   IF @T1RXXXXG2 = '400000000000' 
   BEGIN
     SELECT @R0014G4 = @R0014G4 + @T1RXXXXG4 
     SELECT @R0014G5 = @R0014G5 + @T1RXXXXG5
     SELECT @R0014G6 = @R0014G6 + @T1RXXXXG6
   END

	 fetch next FROM Rows
	 into @T1RXXXXG2, @T1RXXXXG3A, @T1RXXXXG3B, @T1RXXXXG4, @T1RXXXXG5, @T1RXXXXG6
	 SELECT @RowNum = @RowNum + 1

end
close Rows
deallocate Rows

SELECT @R001G4 = @R0011G4 + @R0012G4 + @R0013G4 + @R0014G4
SELECT @R001G5 = @R0011G5 + @R0012G5 + @R0013G5 + @R0014G5
SELECT @R001G6 = @R0011G6 + @R0012G6 + @R0013G6 + @R0014G6

/*SELECT
@R001G4 = ROUND(SUM(t.TSumCC_nt_20),2) + ROUND(SUM(t.TSumCC_nt_7),2),
@R001G5 = ROUND(SUM(t.TTaxSum_20),2),
@R001G6 = ROUND(SUM(t.TTaxSum_7),2)
FROM @t t
WHERE t.TTaxSum <> 0 AND t.TaxCode = '0' AND t.TSumCC_wt >= 0
GROUP BY t.TaxCode
ORDER BY t.TaxCode
*/
SELECT @R010G4 = @R010G4 + ISNULL(@R001G4,0)
SELECT @R010G5 = @R010G5 + ISNULL(@R001G5,0)
SELECT @R010G6 = @R010G6 + ISNULL(@R001G6,0)

INSERT INTO @UT(XMLText) SELECT
  @Tab2 + '<R001G4>' + cast(ISNULL(@R001G4,0) as varchar) + '</R001G4>'
UNION ALL SELECT
  @Tab2 + '<R001G5>' + cast(ISNULL(@R001G5,0) as varchar) + '</R001G5>'
UNION ALL SELECT
  @Tab2 + '<R001G6>' + cast(ISNULL(@R001G6,0) as varchar) + '</R001G6>'
UNION ALL SELECT
  @Tab2 + '<R0011G4>' + cast(@R0011G4 as varchar) + '</R0011G4>'
UNION ALL SELECT
  @Tab2 + '<R0011G5>' + cast(@R0011G5 as varchar) + '</R0011G5>'
UNION ALL SELECT 
  @Tab2 + '<R0011G6>' + cast(@R0011G6 as varchar) + '</R0011G6>'
UNION ALL SELECT   
  @Tab2 + '<R0012G4>' + cast(@R0012G4 as varchar) + '</R0012G4>'
UNION ALL SELECT  
  @Tab2 + '<R0012G5>' + cast(@R0012G5 as varchar) + '</R0012G5>'
UNION ALL SELECT  
  @Tab2 + '<R0012G6>' + cast(@R0012G6 as varchar) + '</R0012G6>'
UNION ALL SELECT
  @Tab2 + '<R0013G4>' + cast(@R0013G4 as varchar) + '</R0013G4>'
UNION ALL SELECT  
  @Tab2 + '<R0013G5>' + cast(@R0013G5 as varchar) + '</R0013G5>'
UNION ALL SELECT  
  @Tab2 + '<R0013G6>' + cast(@R0013G6 as varchar) + '</R0013G6>'
UNION ALL SELECT
  @Tab2 + '<R0014G4>' + cast(@R0014G4 as varchar) + '</R0014G4>'
UNION ALL SELECT  
  @Tab2 + '<R0014G5>' + cast(@R0014G5 as varchar) + '</R0014G5>'
UNION ALL SELECT  
  @Tab2 + '<R0014G6>' + cast(@R0014G6 as varchar) + '</R0014G6>'
UNION ALL SELECT
  @Tab2 + '<R010G4>' + cast(@R010G4 as varchar) + '</R010G4>'
UNION ALL SELECT
  @Tab2 + '<R010G5>' + cast(@R010G5 as varchar) + '</R010G5>'
UNION ALL SELECT
  @Tab2 + '<R010G6>' + cast(@R010G6 as varchar) + '</R010G6>'

/*-----------------Раздел I. Налоговые обязательства--------------------*/

/*-----------------Раздел II. Налоговый кредит--------------------*/

DECLARE Rows cursor fast_forward for
SELECT
  TaxCode AS T2RXXXXG2, MonthID AS T2RXXXXG3A, YearID AS T2RXXXXG3B,
  SUM(m.SumCC_nt) AS T2RXXXXG4, SUM(m.TaxSum_20) AS T2RXXXXG5, SUM(m.TaxSum_7) AS T2RXXXXG6
FROM
(SELECT c.TaxCode, MONTH(m.SrcDocDate) MonthID,  YEAR(m.SrcDocDate) YearID, m.SumCC_nt,
        m.TaxSum_20, m.TaxSum_7
FROM b_TRec m
INNER JOIN r_Comps c ON m.CompID = c.CompID
WHERE m.SrcDocDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate) AND m.OurID = @OurID
      and m.TaxSum <> 0 AND m.PosType=1) m
GROUP BY TaxCode, MonthID,  YearID

DECLARE @T2RXXXXG2 varchar(12), @T2RXXXXG3A varchar(2), @T2RXXXXG3B varchar(4),
        @T2RXXXXG4 decimal(18,2), @T2RXXXXG5 decimal(18,2), @T2RXXXXG6 decimal(18,2),
        @R020G4 decimal(18,2), @R020G5 decimal(18,2), @R020G6 decimal(18,2),
        @R021G4 decimal(18,2), @R021G5 decimal(18,2), @R021G6 decimal(18,2)

open Rows
	 fetch next FROM Rows
  into @T2RXXXXG2, @T2RXXXXG3A, @T2RXXXXG3B, @T2RXXXXG4, @T2RXXXXG5, @T2RXXXXG6
  SELECT @RowNum = 1
  SELECT @R020G4 = 0
  SELECT @R020G5 = 0
  SELECT @R020G6 = 0

while @@fetch_status = 0
begin
	 SELECT @RowNumChar = cast(@RowNum as varchar)

	 INSERT INTO @UT(XMLText) SELECT
		 @Tab2 + '<T2RXXXXG2 ROWNUM="' + @RowNumChar + '">' + @T2RXXXXG2 + '</T2RXXXXG2>'
	 UNION ALL SELECT
		 @Tab2 +  '<T2RXXXXG3A ROWNUM="' + @RowNumChar + '">' + @T2RXXXXG3A + '</T2RXXXXG3A>'
	 UNION ALL SELECT
         @Tab2 +  '<T2RXXXXG3B ROWNUM="' + @RowNumChar + '">' + @T2RXXXXG3B + '</T2RXXXXG3B>'
	 UNION ALL SELECT
		 @Tab2 + '<T2RXXXXG4 ROWNUM="' + @RowNumChar + '">' + cast(@T2RXXXXG4 as varchar) + '</T2RXXXXG4>'
	 UNION ALL SELECT
	     @Tab2 + '<T2RXXXXG5 ROWNUM="' + @RowNumChar + '">' + cast(@T2RXXXXG5 as varchar) + '</T2RXXXXG5>'
	 UNION ALL SELECT
	     @Tab2 + '<T2RXXXXG6 ROWNUM="' + @RowNumChar + '">' + cast(@T2RXXXXG6 as varchar) + '</T2RXXXXG6>'

  SELECT @R020G4 = @R020G4 + @T2RXXXXG4
  SELECT @R020G5 = @R020G5 + @T2RXXXXG5
  SELECT @R020G6 = @R020G6 + @T2RXXXXG6

	 fetch next FROM Rows
	 into @T2RXXXXG2, @T2RXXXXG3A, @T2RXXXXG3B, @T2RXXXXG4, @T2RXXXXG5, @T2RXXXXG6
	 SELECT @RowNum = @RowNum + 1

end
close Rows
deallocate Rows

INSERT INTO @UT(XMLText) SELECT
  @Tab2 + '<R020G4>' + cast(@R020G4 as varchar) + '</R020G4>'
UNION ALL SELECT
  @Tab2 + '<R020G5>' + cast(@R020G5 as varchar) + '</R020G5>'
UNION ALL SELECT
  @Tab2 + '<R020G6>' + cast(@R020G6 as varchar) + '</R020G6>'
/*--------------------------------------*/

/*--------------------------------------*/
/*-----------------Раздел II. Налоговый кредит--------------------*/

INSERT INTO @UT(XMLText) SELECT
	 @Tab1 + '</DECLARBODY>'
UNION ALL SELECT
	 '</DECLAR>'

SELECT XMLText FROM @UT order by RowID
GO