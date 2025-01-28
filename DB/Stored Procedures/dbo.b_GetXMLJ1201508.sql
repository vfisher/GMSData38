SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[b_GetXMLJ1201508]
/*Реестр выданных и полученных налоговых накладных (01.12.2014)*/
(
	@OurID int, @BeginDate smalldatetime, @EndDate smalldatetime, @Notes varchar(250)
)
as
set nocount on
DECLARE
	 @OurName varchar(250), @MonthChar char(2), @YearChar char(4),
	 @Year int, @Month int, @BDate varchar(50), @EDate varchar(50),
	 @FillDate char(8), @Code varchar(250), @TaxCode varchar(250),
	 @TaxRegNo varchar(250), @Address varchar(250),
	 @Tab1 char(1), @Tab2 char(2)
SELECT
	 @Year = Year(@BeginDate), @Month = Month(@BeginDate)
SELECT
	 @OurName = OurName, @Code = Code, @TaxCode = TaxCode,
	 @TaxRegNo = TaxRegNo, @Address = Address
FROM r_Ours where OurID = @OurID

SELECT
	 @FillDate = replace(convert(varchar, getdate(), 104), '.', ''),
	 @BDate = replace(convert(varchar, @BeginDate, 104), '.', ''),
	 @EDate = replace(convert(varchar, @EndDate, 104), '.', ''),
	 @MonthChar = right(cast(100 + @Month as varchar), 2),
	 @YearChar = cast(@Year as varchar),
	 @Tab1 = char(9), @Tab2 = char(9) + char(9)
DECLARE @UT table
(
	RowID int identity, XMLText varchar(8000)
)

INSERT INTO @UT(XMLText)
SELECT
	 '<?xml version="1.0" encoding="windows-1251"?>'
UNION ALL SELECT
	 '<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201508.xsd">'
UNION ALL SELECT
	 @Tab1 + '<DECLARHEAD>'
UNION ALL SELECT
	 @Tab2 + '<TIN>' + @Code + '</TIN>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC>J12</C_DOC>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC_SUB>015</C_DOC_SUB>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC_VER>8</C_DOC_VER>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC_TYPE>0</C_DOC_TYPE>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC_CNT>1</C_DOC_CNT>'
UNION ALL SELECT
  @Tab2 + '<C_REG></C_REG>'
UNION ALL SELECT
  @Tab2 + '<C_RAJ></C_RAJ>'
UNION ALL SELECT
	 @Tab2 + '<PERIOD_MONTH>' + @MonthChar + '</PERIOD_MONTH>'
UNION ALL SELECT
	 @Tab2 + '<PERIOD_TYPE>1</PERIOD_TYPE>'
UNION ALL SELECT
	 @Tab2 + '<PERIOD_YEAR>' + @YearChar + '</PERIOD_YEAR>'
UNION ALL SELECT
  @Tab2 + '<C_STI_ORIG></C_STI_ORIG>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC_STAN>1</C_DOC_STAN>'
UNION ALL SELECT
  @Tab2 + '<LINKED_DOCS xsi:nil="true"></LINKED_DOCS>'
UNION ALL SELECT
	 @Tab2 + '<D_FILL>' + @FillDate + '</D_FILL>'
UNION ALL SELECT
	 @Tab1 + '</DECLARHEAD>'
UNION ALL SELECT
	 @Tab1 + '<DECLARBODY>'
UNION ALL SELECT
	 @Tab2 + '<HZ>1</HZ>'
UNION ALL SELECT
	 @Tab2 + '<HNP></HNP>'
UNION ALL SELECT
	 @Tab2 + '<HZY>' + @YearChar + '</HZY>'
UNION ALL SELECT
	 @Tab2 + '<HZM>' + @MonthChar + '</HZM>'
UNION ALL SELECT
  @Tab2 + '<HKV xsi:nil="true" />'
UNION ALL SELECT
	 @Tab2 + '<HNAME>' + @OurName + '</HNAME>'

DECLARE
		@SrcDocID varchar(200), @SrcDocDate char(8),
		@IntDocID varchar(200), @DocDate char(8),       @Type varchar(10),       @Type2 varchar(10),    @Type3 varchar(10),
		@CompName varchar(200), @CTaxCode varchar(200), @RowNumChar varchar(12), @RowNum int,
		@T1G7 decimal(18,2),    @T1G8 decimal(18,2),    @T1G9 decimal(18,2),     @T1G110 decimal(18,2), @T1G111 decimal(18,2),
		@T1G10 decimal(18,2),   @T1G113 decimal(18,2),  @T1G114 decimal(18,2),   @T1G12 decimal(18,2),  @T1G13 decimal(18,2)

DECLARE Rows2 cursor fast_forward for
SELECT
  REPLACE(CONVERT(varchar, a.DocDate, 104), '.', '') AS T1G2D,
  a.IntDocID AS T1G3S,
  REPLACE(c.Notes, SUBSTRING(c.Notes, PATINDEX('%[0-9]%', c.Notes), 2),'') AS T1G41S,
  CASE WHEN PATINDEX('%[0-9]%', c.Notes) <> 0 THEN
  SUBSTRING(c.Notes, PATINDEX('%[0-9]%', c.Notes), 2) ELSE c.Notes END AS T1G42S,
  (CASE WHEN a.IsCorrection = 1 THEN 'У' ELSE '' END) AS T1G43S,
  CASE
    WHEN (SUBSTRING(c.Notes, PATINDEX('%[0-9]%', c.Notes), 2) IN ('02','11')) OR (b.TaxPayer = 0) THEN dbo.zf_Translate('Неплатник')
    WHEN SUBSTRING(c.Notes, PATINDEX('%[0-9]%', c.Notes), 2) IN ('07') THEN '' ELSE b.CompName
  END AS T1G5S,
  CASE
    WHEN SUBSTRING(c.Notes, PATINDEX('%[0-9]%', c.Notes), 2) IN ('02','11') THEN '100000000000'
    WHEN SUBSTRING(c.Notes, PATINDEX('%[0-9]%', c.Notes), 2) IN ('07') THEN '300000000000'
    WHEN (SUBSTRING(c.Notes, PATINDEX('%[0-9]%', c.Notes), 2) <> '') OR (b.TaxPayer = 0) THEN '400000000000' ELSE b.TaxCode
  END AS T1G6,
  a.SumCC_wt AS T1G7,
  CASE WHEN a.SumCC_nt_20 <> 0 AND a.PosType <> 4 THEN a.SumCC_nt_20 ELSE 0 END AS T1G8,
  CASE WHEN a.TaxSum_20 <> 0 AND a.PosType <> 4 THEN a.TaxSum_20 ELSE 0 END AS T1G9,
  CASE WHEN a.SumCC_nt_7 <> 0 AND a.PosType <> 4 THEN a.SumCC_nt_7 ELSE 0 END AS T1G110,
  CASE WHEN a.TaxSum_7 <> 0 AND a.PosType <> 4 THEN a.TaxSum_7 ELSE 0 END AS T1G111,
  CASE WHEN a.SumCC_nt_0 <> 0 AND a.PosType <> 4 THEN a.SumCC_nt_0 ELSE 0 END AS T1G10,
  CASE WHEN a.SumCC_nt_Free <> 0 AND a.PosType <> 4 THEN a.SumCC_nt_Free ELSE 0 END AS T1G113,
  CASE WHEN a.SumCC_nt_No <> 0 AND a.PosType <> 4 THEN a.SumCC_nt_No ELSE 0 END AS T1G114,
  0 AS T1G12,
  0 AS T1G13
FROM
  b_TExp a INNER JOIN r_Comps b ON a.CompID = b.CompID
  INNER JOIN r_Uni c ON a.PosType = c.RefID AND c.RefTypeID = 10041
WHERE
  (a.OurID IN (@OurID)) AND (a.DocDate >= @BeginDate) AND (a.DocDate <= @EndDate) AND a.DocID <> 0
ORDER BY
  DocDate, DocID

open Rows2
	fetch next FROM Rows2
	into @DocDate, @IntDocID, @Type, @Type2, @Type3, @CompName, @CTaxCode,
	@T1G7, @T1G8, @T1G9, @T1G110, @T1G111, @T1G10, @T1G113, @T1G114, @T1G12, @T1G13

SELECT @RowNum = 1
  while @@fetch_status = 0
  begin
    SELECT @RowNumChar = cast(@RowNum as varchar)

  INSERT INTO @UT(XMLText) SELECT
		 @Tab2 + '<T1RXXXXG1 ROWNUM="' + @RowNumChar + '">' + @RowNumChar + '</T1RXXXXG1>' /*№ з/п*/
  UNION ALL SELECT
		 @Tab2 + '<T1RXXXXG2D ROWNUM="' + @RowNumChar + '">' + @DocDate + '</T1RXXXXG2D>'  /*дата складання*/
  UNION ALL SELECT
		 @Tab2 + '<T1RXXXXG3S ROWNUM="' + @RowNumChar + '">' + @IntDocID + '</T1RXXXXG3S>' /*порядковий номер*/
  UNION ALL SELECT
		 @Tab2 + '<T1RXXXXG41S ROWNUM="' + @RowNumChar + '">' + @Type + '</T1RXXXXG41S>'   /*вид документа - 1*/
	 UNION ALL SELECT
	   @Tab2 + '<T1RXXXXG42S ROWNUM="' + @RowNumChar + '">' + @Type2 + '</T1RXXXXG42S>'  /*вид документа - 2*/
	 UNION ALL SELECT
		 @Tab2 + '<T1RXXXXG43S ROWNUM="' + @RowNumChar + '">' + @Type3 + '</T1RXXXXG43S>'  /*вид документа - 3*/
	 UNION ALL SELECT
		 @Tab2 + '<T1RXXXXG5S ROWNUM="' + @RowNumChar + '">' + @CompName + '</T1RXXXXG5S>' /*платник податку - покупець: найменування*/
	 UNION ALL SELECT
		 @Tab2 + '<T1RXXXXG6 ROWNUM="' + @RowNumChar + '">' + @CTaxCode + '</T1RXXXXG6>'   /*платник податку - покупець: індивідуальний податковий номер*/
	 UNION ALL SELECT
		 @Tab2 + '<T1RXXXXG7 ROWNUM="' + @RowNumChar + '">' + CAST(@T1G7 as varchar) + '</T1RXXXXG7>'
	 UNION ALL SELECT
		 @Tab2 + '<T1RXXXXG8 ROWNUM="' + @RowNumChar + '">' + CAST(@T1G8 as varchar) + '</T1RXXXXG8>'
	 UNION ALL SELECT
		 @Tab2 + '<T1RXXXXG9 ROWNUM="' + @RowNumChar + '">' + CAST(@T1G9 as varchar) + '</T1RXXXXG9>'
	 UNION ALL SELECT
	   @Tab2 + '<T1RXXXXG110 ROWNUM="' + @RowNumChar + '">' + CAST(@T1G110 as varchar) + '</T1RXXXXG110>'
	 UNION ALL SELECT
	   @Tab2 + '<T1RXXXXG111 ROWNUM="' + @RowNumChar + '">' + CAST(@T1G111 as varchar) + '</T1RXXXXG111>'
	 UNION ALL SELECT
	   @Tab2 + '<T1RXXXXG10 ROWNUM="' + @RowNumChar + '">' + CAST(@T1G10 as varchar) + '</T1RXXXXG10>'
	 UNION ALL SELECT
	   @Tab2 + '<T1RXXXXG113 ROWNUM="' + @RowNumChar + '">' + CAST(@T1G113 as varchar) + '</T1RXXXXG113>'
	 UNION ALL SELECT
	   @Tab2 + '<T1RXXXXG114 ROWNUM="' + @RowNumChar + '">' + CAST(@T1G114 as varchar) + '</T1RXXXXG114>'
	 UNION ALL SELECT
	   @Tab2 + '<T1RXXXXG12 ROWNUM="' + @RowNumChar + '"></T1RXXXXG12>'
	 UNION ALL SELECT
	   @Tab2 + '<T1RXXXXG13 ROWNUM="' + @RowNumChar + '"></T1RXXXXG13>'
	 fetch next FROM Rows2
	 into  @DocDate, @IntDocID, @Type, @Type2, @Type3, @CompName, @CTaxCode,
	 @T1G7, @T1G8, @T1G9, @T1G110, @T1G111, @T1G10, @T1G113, @T1G114, @T1G12, @T1G13

SELECT @RowNum = @RowNum + 1
end
close Rows2
deallocate Rows2

DECLARE
  @T2G8 decimal(18,2), @T2G110 decimal(18,2), @T2G111 decimal(18,2), @T2G112 decimal(18,2), @T2G113 decimal(18,2),
  @T2G9 decimal(18,2), @T2G10 decimal(18,2),  @T2G11  decimal(18,2), @T2G12  decimal(18,2)

DECLARE Rows cursor fast_forward for
SELECT
  REPLACE(CONVERT(varchar, a.DocDate, 104), '.', '') AS DocDate,
  REPLACE(CONVERT(varchar, a.SrcDocDate, 104), '.', '') AS SrcDocDate,
  ISNULL(a.SrcDocID,'') AS SrcDocID,
  CASE WHEN PATINDEX('%[0-9]%', c.Notes) <> 0 THEN
  REPLACE(c.Notes, SUBSTRING(c.Notes, PATINDEX('%[0-9]%', c.Notes), 2),'') ELSE c.Notes END AS T2G51S,
  (CASE WHEN a.PosType = 16 THEN 'Р' ELSE '' END) AS T2G52S,
  (CASE WHEN a.IsCorrection = 1 THEN 'У' ELSE '' END) AS T2G53S,
  b.CompName AS T2G6S,
  CASE
    WHEN b.TaxPayer = 0 THEN '400000000000' ELSE b.TaxCode
  END AS T2G7,
  CASE WHEN a.PosType != 16 THEN a.SumCC_wt ELSE 0 END AS T2G8,
  a.SumCC_nt_20 AS T2G110,
  a.TaxSum_20 AS T2G111,
  a.SumCC_nt_7 AS T2G112,
  a.TaxSum_7 AS T2G113,
  a.SumCC_nt_0 AS T2G9,
  a.TaxSum_0 AS T2G10,
  CASE WHEN a.SumCC_nt_Free <> 0 THEN a.SumCC_nt_Free
       WHEN a.PosType = 16 THEN (-1)*a.SumCC_nt
  ELSE
  (CASE WHEN a.SumCC_nt_No <> 0 THEN a.SumCC_nt_No
        WHEN a.PosType = 16 THEN (-1)*a.SumCC_nt
   ELSE 0 END)
  END AS T2G11,
  CASE WHEN a.TaxSum_Free <> 0 THEN a.TaxSum_Free
    WHEN a.PosType = 16 THEN (-1)*a.TaxSum
    ELSE
    (CASE WHEN a.TaxSum_No <> 0 THEN a.TaxSum_No
          WHEN a.PosType = 16 THEN (-1)*a.TaxSum
    ELSE 0 END)
  END AS T2G12

FROM
  b_TRec a INNER JOIN r_Comps b ON a.CompID = b.CompID
	INNER JOIN r_Uni c ON a.PosType = c.RefID AND c.RefTypeID = 10041
WHERE
  (a.OurID IN (@OurID)) AND (a.DocDate >= @BeginDate) AND (a.DocDate <= @EndDate) AND a.DocID <> 0
ORDER BY
  a.DocDate, a.IntDocID

open Rows
	 fetch next FROM Rows
	 into @DocDate, @SrcDocDate, @IntDocID, @Type, @Type2, @Type3, @CompName, @CTaxCode,
	 @T2G8, @T2G110, @T2G111, @T2G112, @T2G113, @T2G9, @T2G10, @T2G11, @T2G12

SELECT @RowNum = 1
while @@fetch_status = 0
begin
	 SELECT @RowNumChar = cast(@RowNum as varchar)

	 INSERT INTO @UT(XMLText) SELECT
		 @Tab2 + '<T2RXXXXG1 ROWNUM="' + @RowNumChar + '">' + @RowNumChar + '</T2RXXXXG1>'
	 UNION ALL SELECT
		 @Tab2 + '<T2RXXXXG2D ROWNUM="' + @RowNumChar + '">' + @DocDate + '</T2RXXXXG2D>'
	 UNION ALL SELECT
		 @Tab2 + '<T2RXXXXG3D ROWNUM="' + @RowNumChar + '">' + @SrcDocDate + '</T2RXXXXG3D>'
	 UNION ALL SELECT
		 @Tab2 + '<T2RXXXXG4S ROWNUM="' + @RowNumChar + '">' + @SrcDocID + '</T2RXXXXG4S>'
	 UNION ALL SELECT
		 @Tab2 + '<T2RXXXXG51S ROWNUM="' + @RowNumChar + '">' + @Type + '</T2RXXXXG51S>'
	 UNION ALL SELECT
		 @Tab2 + '<T2RXXXXG52S ROWNUM="' + @RowNumChar + '">' + @Type2 + '</T2RXXXXG52S>'
	 UNION ALL SELECT
		 @Tab2 + '<T2RXXXXG53S ROWNUM="' + @RowNumChar + '">' + @Type3 + '</T2RXXXXG53S>'
	 UNION ALL SELECT
		 @Tab2 + '<T2RXXXXG6S ROWNUM="' + @RowNumChar + '">' + @CompName + '</T2RXXXXG6S>'
	 UNION ALL SELECT
		 @Tab2 + '<T2RXXXXG7 ROWNUM="' + @RowNumChar + '">' + @CTaxCode + '</T2RXXXXG7>'
	 UNION ALL SELECT
		 @Tab2 + '<T2RXXXXG8 ROWNUM="' + @RowNumChar + '">' + CAST(@T2G8 as varchar) + '</T2RXXXXG8>'
  UNION ALL SELECT
    @Tab2 + '<T2RXXXXG109 ROWNUM="' + @RowNumChar + '">' + CAST(ROUND(((@T2G110+@T2G111+@T2G112+@T2G113+@T2G9+@T2G10)*100/
    (CASE WHEN @T2G8 = 0 THEN 1 ELSE @T2G8 END)),2) as varchar) + '</T2RXXXXG109>'
  UNION ALL SELECT
		 @Tab2 + '<T2RXXXXG110 ROWNUM="' + @RowNumChar + '">' + CAST(@T2G110 as varchar) + '</T2RXXXXG110>'
	 UNION ALL SELECT
		 @Tab2 + '<T2RXXXXG111 ROWNUM="' + @RowNumChar + '">' + CAST(@T2G111 as varchar) + '</T2RXXXXG111>'
	 UNION ALL SELECT
	   @Tab2 + '<T2RXXXXG112 ROWNUM="' + @RowNumChar + '">' + CAST(@T2G112 as varchar) + '</T2RXXXXG112>'
	 UNION ALL SELECT
		 @Tab2 + '<T2RXXXXG113 ROWNUM="' + @RowNumChar + '">' + CAST(@T2G113 as varchar) + '</T2RXXXXG113>'
  UNION ALL SELECT
	   @Tab2 + '<T2RXXXXG9 ROWNUM="' + @RowNumChar + '">' + CAST(@T2G9 as varchar) + '</T2RXXXXG9>'
	 UNION ALL SELECT
	   @Tab2 + '<T2RXXXXG10 ROWNUM="' + @RowNumChar + '">' + CAST(@T2G10 as varchar) + '</T2RXXXXG10>'
	 UNION ALL SELECT
	   @Tab2 + '<T2RXXXXG11 ROWNUM="' + @RowNumChar + '">' + CAST(@T2G11 as varchar) + '</T2RXXXXG11>'
	 UNION ALL SELECT
		 @Tab2 + '<T2RXXXXG12 ROWNUM="' + @RowNumChar + '">' + CAST(@T2G12 as varchar) + '</T2RXXXXG12>'
	 UNION ALL SELECT
		 @Tab2 + '<T2RXXXXG13 ROWNUM="' + @RowNumChar + '"></T2RXXXXG13>'
	 UNION ALL SELECT
		 @Tab2 + '<T2RXXXXG14 ROWNUM="' + @RowNumChar + '"></T2RXXXXG14>'
	 UNION ALL SELECT
		 @Tab2 + '<T2RXXXXG15 ROWNUM="' + @RowNumChar + '"></T2RXXXXG15>'
	 UNION ALL SELECT
	   @Tab2 + '<T2RXXXXG16 ROWNUM="' + @RowNumChar + '"></T2RXXXXG16>'

	 fetch next FROM Rows
	 into @DocDate, @SrcDocDate, @IntDocID, @Type, @Type2, @Type3, @CompName, @CTaxCode,
	 @T2G8, @T2G110, @T2G111, @T2G112, @T2G113, @T2G9, @T2G10, @T2G11, @T2G12
	 SELECT @RowNum = @RowNum + 1
end
close Rows
deallocate Rows

INSERT INTO @UT(XMLText) SELECT
	 @Tab1 + '</DECLARBODY>'
UNION ALL SELECT
	'</DECLAR>'

SELECT XMLText FROM @UT order by RowID

GO
