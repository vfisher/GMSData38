SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_GetXMLJ3001001]
/* Повідомлення про прийняття працівника на роботу (01.06.2015 р.)*/
(
  @OurID int, @DocDate smalldatetime, @SubID varchar(200), @DepID varchar(200), @Type int
)
AS
SET NOCOUNT ON

DECLARE
	 @OurName varchar(250), @MonthChar char(2), @YearChar char(4),
	 @Year int, @Month int,
	 @FillDate char(8), @Code varchar(250), @TaxCode varchar(250),
	 @TaxRegNo varchar(250), @FIRM_RUK varchar(250), @FIRM_BUH varchar(250),
     @FIRM_RUKINN VARCHAR(10), @FIRM_BUHINN VARCHAR(10),
	 @Tab1 char(1), @Tab2 char(2),
     @TypeIn INT, @TypeOut int

SELECT
	 @Year = Year(@DocDate), @Month = Month(@DocDate)
SELECT
	 @OurName = OurName, @Code = Code, @TaxCode = TaxCode,
	 @TaxRegNo = TaxRegNo, @FIRM_RUK = Job1, @FIRM_BUH = Job2,
     @FIRM_RUKINN = (SELECT TOP 1 e.TaxCode FROM r_Emps e WHERE e.EmpName = Job1),
     @FIRM_BUHINN = (SELECT TOP 1 e.TaxCode FROM r_Emps e WHERE e.EmpName = Job2)
FROM r_Ours where OurID = @OurID

SELECT
	 @FillDate = replace(convert(varchar, getdate(), 104), '.', ''),
	 @MonthChar = right(cast(100 + @Month as varchar), 2),
	 @YearChar = cast(@Year as varchar),
	 @Tab1 = char(9), @Tab2 = char(9) + char(9)

SET @TypeIn = 0
SET @TypeOut = 0

IF @Type = 1 
  SET @TypeIn = 1
ELSE
  SET @TypeOut = 1

/* Преобразование отбора подразделений */
DECLARE @SubIDTbl TABLE(SubID INT)
IF @SubID = ''
  INSERT INTO @SubIDTbl(SubID)
  SELECT SubID FROM r_Subs
ELSE
  INSERT INTO @SubIDTbl(SubID)
  SELECT * FROM [zf_FilterToTable] (@SubID)

/* Преобразование отбора отделов */
DECLARE @DepIDTbl TABLE(DepID INT)
IF @DepID = ''
  INSERT INTO @DepIDTbl(DepID)
  SELECT DepID FROM r_Deps
ELSE
  INSERT INTO @DepIDTbl(DepID)
  SELECT * FROM [zf_FilterToTable] (@DepID)

DECLARE @UT TABLE (RowID int identity, XMLText varchar(8000))

INSERT INTO @UT(XMLText)
SELECT
	'<?xml version="1.0" encoding="windows-1251" ?>'
UNION ALL SELECT
	'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J3001001.xsd">'
UNION ALL SELECT
  @Tab1 + '<DECLARHEAD>'
UNION ALL SELECT
	 @Tab2 + '<TIN>' + @Code + '</TIN>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC>J30</C_DOC>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC_SUB>010</C_DOC_SUB>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC_VER>01</C_DOC_VER>'
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
	 @Tab2 + '<HBOS>' + @FIRM_RUK + '</HBOS>'
UNION ALL SELECT
     @Tab2 + '<HKBOS>' + @FIRM_RUKINN + '</HKBOS>'
UNION ALL SELECT
	 @Tab2 + '<HBUH>' + @FIRM_BUH + '</HBUH>'
UNION ALL SELECT
     @Tab2 + '<HKBUH>' + @FIRM_BUHINN + '</HKBUH>'
UNION ALL SELECT
	 @Tab2 + '<H01>' + CAST(@TypeIn as varchar) + '</H01>'
UNION ALL SELECT
	 @Tab2 + '<H02>' + CAST(@TypeOut as varchar) + '</H02>'

DECLARE  @T1RXXXXG4 INT, @T1RXXXXG5S VARCHAR(10), @T1RXXXXG61S VARCHAR(100), @T1RXXXXXG62S VARCHAR(100), 
         @T1RXXXXG63S VARCHAR(100), @T1RXXXXG7S VARCHAR(20), @T1RXXXXG8D CHAR(8), @T1RXXXXG9D CHAR(8),   
		 @RowNum int, @RowNumChar varchar(12)

DECLARE Rows cursor fast_forward for

SELECT
  CASE WHEN (e.WorkBookNo IS NOT NULL) AND (e.WorkBookSer IS NOT NULL) THEN 1 ELSE 2 END AS T1RXXXXG4, /*Категорія особи*/
  e.TaxCode AS T1RXXXXG5S, /*Реєстраційний номер облікової картки платника податків або серія та номер паспорта*/
  e.UAEmpLastName AS T1RXXXXG61S, /*Прізвище*/
  e.UAEmpFirstName AS T1RXXXXXG62S, /*Ім'я*/
  e.UAEmpParName AS T1RXXXXG63S, /*По батькові*/
  m.WOrderID AS T1RXXXXG7S, /*Номер наказу або розпорядження про прийняття на роботу*/
  REPLACE(CONVERT(varchar, m.DocDate, 104), '.', '') AS T1RXXXXG8D, /*Дата видання наказу або розпорядження про прийняття на роботу*/
  REPLACE(CONVERT(varchar, m.WorkAppDate, 104), '.', '') AS T1RXXXXG9D /*Дата початку роботи*/
FROM p_EGiv m
LEFT JOIN r_Emps e ON m.EmpID = e.EmpID 
WHERE m.WorkAppDate = @DocDate AND m.DepID IN (SELECT DepID FROM @DepIDTbl) AND m.SubID IN (SELECT SubID FROM @SubIDTbl) 

open Rows
	 fetch next FROM Rows
	 into @T1RXXXXG4, @T1RXXXXG5S, @T1RXXXXG61S, @T1RXXXXXG62S, 
          @T1RXXXXG63S, @T1RXXXXG7S, @T1RXXXXG8D, @T1RXXXXG9D

SELECT @RowNum = 1

WHILE @@fetch_status = 0
BEGIN
  SELECT @RowNumChar = cast(@RowNum as varchar)
    INSERT INTO @UT(XMLText) SELECT
      @Tab2 + '<T1RXXXXG4 ROWNUM="' + @RowNumChar + '">' + CAST(@T1RXXXXG4 as varchar) + '</T1RXXXXG4>'
	UNION ALL SELECT
	  @Tab2 + '<T1RXXXXG5S ROWNUM="' + @RowNumChar + '">' + @T1RXXXXG5S + '</T1RXXXXG5S>'
	UNION ALL SELECT
	  @Tab2 + '<T1RXXXXG61S ROWNUM="' + @RowNumChar + '">' + @T1RXXXXG61S + '</T1RXXXXG61S>'
	UNION ALL SELECT
	  @Tab2 + '<T1RXXXXG62S ROWNUM="' + @RowNumChar + '">' + @T1RXXXXXG62S + '</T1RXXXXG62S>'
	UNION ALL SELECT
	  @Tab2 + '<T1RXXXXG63S ROWNUM="' + @RowNumChar + '">' + @T1RXXXXG63S + '</T1RXXXXG63S>'
	UNION ALL SELECT
	  @Tab2 + '<T1RXXXXG7S ROWNUM="' + @RowNumChar + '">' + @T1RXXXXG7S + '</T1RXXXXG7S>'
	UNION ALL SELECT
	  @Tab2 + '<T1RXXXXG8D ROWNUM="' + @RowNumChar + '">' + @T1RXXXXG8D + '</T1RXXXXG8D>'
	UNION ALL SELECT
	  @Tab2 + '<T1RXXXXG9D ROWNUM="' + @RowNumChar + '">' + @T1RXXXXG9D + '</T1RXXXXG9D>'

fetch next FROM Rows
	 into @T1RXXXXG4, @T1RXXXXG5S, @T1RXXXXG61S, @T1RXXXXXG62S, 
          @T1RXXXXG63S, @T1RXXXXG7S, @T1RXXXXG8D, @T1RXXXXG9D 

SELECT @RowNum = @RowNum + 1

END
close Rows
deallocate ROWS

INSERT INTO @UT(XMLText) SELECT
  @Tab2 + '<R011G1>' + CAST((@RowNum - 1) as varchar) + '</R011G1>'
UNION ALL SELECT
  @Tab1 + '</DECLARBODY>'
UNION ALL SELECT
  '</DECLAR>'

SELECT XMLText FROM @UT order by RowID
GO
