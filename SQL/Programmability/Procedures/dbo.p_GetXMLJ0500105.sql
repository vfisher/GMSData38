SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_GetXMLJ0500105]
/* Ф. №1ДФ Податковий розрахунок сум доходу, нарахованого (сплаченого) на користь платників податку, і сум утриманого з них податку */
(
  @OurID int, @Date datetime, @Period int, @ExclEmps varchar(250), @SubID varchar(250), @DepID varchar(250)
)
AS
SET NOCOUNT ON

DECLARE
  @Tab1 char(1), @Tab2 char(2),  
  @OurName varchar(250), @OurAdress varchar(250), @MonthChar char(2), @YearChar char(4),
  @Year varchar(4), @Month varchar(2),
  @FillDate char(8), @HFill char(8), @Code varchar(250), @TaxCode varchar(250),
  @TaxRegNo varchar(250), @Job1 varchar(250), @Job2 varchar(250)

SELECT
	 @Year = Year(@Date), @Month = Month(@Date)
SELECT
  @OurName = OurName, 
  @OurAdress = (PostIndex + ', ' + City + ', ' + Address),
  @Code = Code, @TaxCode = TaxCode,
  @TaxRegNo = TaxRegNo, @Job1 = Job1, @Job2 = Job2
FROM r_Ours 
WHERE OurID = @OurID

SELECT
  @HFill = replace(convert(varchar, getdate(), 104), '.', ''),
  @FillDate = replace(convert(varchar, @Date, 104), '.', ''),
  @Tab1 = char(9), @Tab2 = char(9) + char(9)

DECLARE 
  @Get1DF TABLE (
    EMPID         int,
    PERIOD        int,           /*Звітний період (квартал) (1,0)*/
    RIK           int,           /*Звітний рік (4,0)*/
    KOD           int,           /*Код ЄДРПОУ (10,0)*/
    TYP           int,           /*Ознака податкового агента, який подає податковий розрахунок (0 - юридична особа, 1 - фізична особа) (1,0)*/
    TIN           varchar(50),   /*Ідентифікаційний номер фізичної особи (10,0) */
    S_NAR         decimal(21,9), /*Сума нарахованого доходу (12,2)*/ 
    S_DOX         decimal(21,9), /*Сума виплаченого доходу (12,2)*/ 
    S_TAXN        decimal(21,9), /*Сума утриманого податку (нарахованого) (12,2)*/
    S_TAXP        decimal(21,9), /*Сума утриманого податку (перерахованого) (12,2)*/
    S_MILITARY    decimal(21,9), /*Военный сбор*/
    S_MILITARYSUM decimal(21,9), /* Сумма для удержания военного сбора*/ 
    OZN_DOX       int,           /*Ознака доходу (3,0)*/
    D_PRIYN       datetime,      /*Дата прийняття на роботу (10,0)*/
    D_ZVILN       datetime,      /*Дата звільнення з роботи (10,0)*/
    OZN_PILG      int,           /*Ознака податкової соціальної пільги (2,0)*/
    OZNAKA        int            /*Ознака: 0 - введення запису, 1 - вилучення запису (1,0)*/ 
                 )

INSERT INTO @Get1DF (EMPID, PERIOD, RIK, KOD, TYP, TIN, S_NAR, S_DOX, S_TAXN, S_TAXP, S_MILITARY, S_MILITARYSUM, OZN_DOX, D_PRIYN, D_ZVILN, OZN_PILG, OZNAKA)
EXEC p_Get1DF @OurID, @Date, @Period, @ExclEmps, @SubID, @DepID 

DECLARE @PERIOD_TYPE varchar(1)
SET @PERIOD_TYPE = @Period + 1

/* Идентификационный номер руководителя предприятия, служебный телефон */
DECLARE @DirectorCode TABLE (EmpID int, EmpName varchar(200), TaxCode varchar (50), Phone varchar (20))
INSERT INTO @DirectorCode (EmpID, EmpName, TaxCode, Phone)
SELECT TOP 1
e.EmpID,
e.EmpName,
e.TaxCode,
CASE Replace(Replace(Replace(Replace(e.Phone,'-',''),' ',''),'(',''),')','')
  WHEN '' THEN NULL
  ELSE Replace(Replace(Replace(Replace(e.Phone,'-',''),' ',''),'(',''),')','')
END AS Phone
FROM r_EmpMO m, r_Emps e
WHERE e.EmpID=m.EmpID AND m.OurID=@OurID AND m.EmpState=1

/* Идентификационный номер главного бухгалтера предприятия, служебный телефон */
DECLARE @AccountantCode TABLE (EmpID int, EmpName varchar(200), TaxCode varchar (50), Phone varchar (20))
INSERT INTO @AccountantCode (EmpID, EmpName, TaxCode, Phone)
SELECT TOP 1
e.EmpID,
e.EmpName,
e.TaxCode,
CASE Replace(Replace(Replace(Replace(e.Phone,'-',''),' ',''),'(',''),')','')
  WHEN '' THEN NULL
  ELSE Replace(Replace(Replace(Replace(e.Phone,'-',''),' ',''),'(',''),')','')
END AS Phone
FROM r_EmpMO m, r_Emps e
WHERE e.EmpID=m.EmpID AND m.OurID=@OurID AND m.EmpState=2

DECLARE @HKBOS varchar(10), @HBOS varchar(200), @HTELBOS varchar(20), @HKBUH varchar(10), @HBUH varchar(200), @HTELBUH varchar(20)
SET @HKBOS = (SELECT TaxCode FROM @DirectorCode)
SET @HBOS = (SELECT EmpName FROM @DirectorCode)
SET @HTELBOS = (SELECT Phone FROM @DirectorCode)
SET @HKBUH = (SELECT TaxCode FROM @AccountantCode)
SET @HBUH = (SELECT EmpName FROM @AccountantCode)
SET @HTELBUH = (SELECT Phone FROM @AccountantCode)

DECLARE @UT TABLE
(
	 RowID int identity, XMLText varchar(8000)
)

INSERT INTO @UT(XMLText)
SELECT
	'<?xml version="1.0" encoding="windows-1251"?>'
UNION ALL SELECT
	'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J0500105.XSD">'
UNION ALL SELECT
     @Tab1 + '<DECLARHEAD>'
UNION ALL SELECT
	 @Tab2 + '<TIN>' + @Code + '</TIN>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC>J05</C_DOC>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC_SUB>001</C_DOC_SUB>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC_VER>5</C_DOC_VER>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC_TYPE>0</C_DOC_TYPE>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC_CNT>1</C_DOC_CNT>'
UNION ALL SELECT
/*@Tab2 + '<C_REG></C_REG>'*/
/*UNION ALL SELECT*/
/*@Tab2 + '<C_RAJ></C_RAJ>'*/
/*UNION ALL SELECT*/
	 @Tab2 + '<PERIOD_MONTH>' + @Month + '</PERIOD_MONTH>' 
UNION ALL SELECT
	 @Tab2 + '<PERIOD_TYPE>' + @PERIOD_TYPE + '</PERIOD_TYPE>'
UNION ALL SELECT
	 @Tab2 + '<PERIOD_YEAR>' + @Year + '</PERIOD_YEAR>'
UNION ALL SELECT
	 @Tab2 + '<C_DOC_STAN>1</C_DOC_STAN>'
UNION ALL SELECT
	 @Tab2 + '<D_FILL>' + cast(@FillDate as varchar) + '</D_FILL>'
UNION ALL SELECT
	 @Tab1 + '</DECLARHEAD>'
UNION ALL SELECT
	 @Tab1 + '<DECLARBODY>'
UNION ALL SELECT
     @Tab2 + '<HTIN>' + @Code + '</HTIN>'
UNION ALL SELECT
     @Tab2 + '<HZ>1</HZ>'
UNION ALL SELECT
     @Tab2 + '<HZY>' + @Year + '</HZY>'	 
UNION ALL SELECT
     @Tab2 + '<HNAME>' + @OurName + '</HNAME>'
UNION ALL SELECT 
     @Tab2 + '<HLOC>' + @OurAdress + '</HLOC>'
UNION ALL SELECT  
     @Tab2 + '<HSTI></HSTI>' 
UNION ALL SELECT   
     @Tab2 + '<HZKV>' + @PERIOD_TYPE + '</HZKV>'

DECLARE 
  @RowNum int, @RowNumChar varchar(12),
  @TAB1_A2 varchar(10), @TAB1_A21 varchar(250), 
  @TAB1_A3 decimal(12,2), @TAB1_A31 decimal(12,2), @TAB1_A4 decimal(12,2), @TAB1_A41 decimal(12,2), 
  @S_MILITARY decimal(21,9), @S_MILITARYSUM decimal(21,9),  
  @TAB1_A5 varchar(3), @TAB1_A6 char(8), @TAB1_A7 char(8), @TAB1_A8 varchar(2), @TAB1_OZNAKA varchar(1),
  @A3 decimal(12,2), @A31 decimal(12,2), @A4 decimal(12,2), @A41 decimal(12,2), @TA31_3 decimal(12,2), @TA41_3 decimal(21,9) 

DECLARE Rows cursor fast_forward FOR
SELECT
  df.TIN AS TAB1_A2,
  e.EmpName AS TAB1_A21,
  df.S_DOX AS TAB1_A3,
  df.S_NAR AS TAB1_A31,
  df.S_TAXP AS TAB1_A4,
  df.S_TAXN AS TAB1_A41,
  df.S_MILITARY AS S_MILITARY, 
  df.S_MILITARYSUM AS S_MILITARYSUM,  
  df.OZN_DOX AS TAB1_A5,
  replace(convert(varchar, df.D_PRIYN, 104), '.', '') AS TAB1_A6,
  replace(convert(varchar, df.D_ZVILN, 104), '.', '') AS TAB1_A7,
  df.OZN_PILG AS TAB1_A8,
  df.OZNAKA AS TAB1_OZNAKA
FROM @Get1DF df
INNER JOIN r_Emps e ON df.EMPID = e.EmpID

open Rows
	 fetch next FROM Rows
	 into @TAB1_A2, @TAB1_A21, @TAB1_A3, @TAB1_A31, @TAB1_A4, @TAB1_A41, @S_MILITARY, @S_MILITARYSUM,  
          @TAB1_A5, @TAB1_A6, @TAB1_A7, @TAB1_A8, @TAB1_OZNAKA

SELECT @RowNum = 1
SELECT @A3  = 0
SELECT @A31 = 0
SELECT @A4  = 0
SELECT @A41 = 0
SELECT @TA41_3 = 0
SELECT @TA31_3 = 0

WHILE @@fetch_status = 0
BEGIN
SELECT @RowNumChar = cast(@RowNum as varchar)
  INSERT INTO @UT(XMLText) SELECT 
		@Tab2 + '<T1RXXXXG02 ROWNUM="' + @RowNumChar + '">' + @TAB1_A2 + '</T1RXXXXG02>'
	 UNION ALL SELECT
	  	@Tab2 + '<T1RXXXXG03 ROWNUM="' + @RowNumChar + '">' + cast(@TAB1_A3 as varchar) + '</T1RXXXXG03>' 
	 UNION ALL SELECT
	  	@Tab2 + '<T1RXXXXG03A ROWNUM="' + @RowNumChar + '">' + cast(@TAB1_A31 as varchar) + '</T1RXXXXG03A>' 
	 UNION ALL SELECT
	  	@Tab2 + '<T1RXXXXG04 ROWNUM="' + @RowNumChar + '">' + cast(@TAB1_A4 as varchar) + '</T1RXXXXG04>' 
	 UNION ALL SELECT
	  	@Tab2 + '<T1RXXXXG04A ROWNUM="' + @RowNumChar + '">' + cast(@TAB1_A41 as varchar) + '</T1RXXXXG04A>'
	 UNION ALL SELECT
	  	@Tab2 + '<T1RXXXXG05 ROWNUM="' + @RowNumChar + '">' + cast(@TAB1_A5 as varchar) + '</T1RXXXXG05>' 
	 UNION ALL SELECT
	  	@Tab2 + '<T1RXXXXG06D ROWNUM="' + @RowNumChar + '">' + cast(@TAB1_A6 as varchar) + '</T1RXXXXG06D>'
	 UNION ALL SELECT
		@Tab2 + '<T1RXXXXG07D ROWNUM="' + @RowNumChar + '">' + cast(@TAB1_A7 as varchar) + '</T1RXXXXG07D>'
	 UNION ALL SELECT
	  	@Tab2 + '<T1RXXXXG08 ROWNUM="' + @RowNumChar + '">0' + @TAB1_A8 + '</T1RXXXXG08>' 
	 UNION ALL SELECT
		@Tab2 + '<T1RXXXXG09 ROWNUM="' + @RowNumChar + '">' + @TAB1_OZNAKA + '</T1RXXXXG09>' 

     SELECT @A3 =  @A3 +  @TAB1_A3
     SELECT @A31 = @A31 + @TAB1_A31
     SELECT @A4 =  @A4 +  @TAB1_A4
     SELECT @A41 = @A41 + @TAB1_A41
     SELECT @TA31_3 = @TA31_3 + @S_MILITARYSUM
     SELECT @TA41_3 = @TA41_3 + @S_MILITARY 

	 SELECT @RowNum = @RowNum + 1 

fetch next FROM Rows
	 into @TAB1_A2, @TAB1_A21, @TAB1_A3, @TAB1_A31, @TAB1_A4, @TAB1_A41, @S_MILITARY, @S_MILITARYSUM, 
          @TAB1_A5, @TAB1_A6, @TAB1_A7, @TAB1_A8, @TAB1_OZNAKA	

END
close Rows
deallocate ROWS

  INSERT INTO @UT(XMLText) SELECT
    @Tab2 + '<R01G03>' + cast(@A3 as varchar) + '</R01G03>'
  UNION ALL SELECT
	@Tab2 + '<R01G03A>' + cast(@A31 as varchar) + '</R01G03A>'
  UNION ALL SELECT
	@Tab2 + '<R01G04>' + cast(@A4 as varchar) + '</R01G04>'
  UNION ALL SELECT
	@Tab2 + '<R01G04A>' + cast(@A41 as varchar) + '</R01G04A>'
  UNION ALL SELECT
    @Tab2 + '<R0205G03A>' + cast(@TA31_3 as varchar) + '</R0205G03A>'
  UNION ALL SELECT
    @Tab2 + '<R0205G03>' + cast(@TA31_3 as varchar) + '</R0205G03>'
  UNION ALL SELECT
    @Tab2 + '<R0205G04A>' + cast(CAST(ROUND(@TA41_3, 2) AS DECIMAL(12,2)) as varchar) + '</R0205G04A>'
  UNION ALL SELECT
    @Tab2 + '<R0205G04>' + cast(CAST(ROUND(@TA41_3, 2) AS DECIMAL(12,2)) as varchar) + '</R0205G04>'
  UNION ALL SELECT 
    @Tab2 + '<HFILL>' + @HFill + '</HFILL>'
  UNION ALL SELECT 
    @Tab2 + '<HKBOS>' + @HKBOS + '</HKBOS>'
  UNION ALL SELECT
    @Tab2 + '<HBOS>' + @HBOS + '</HBOS>'
  UNION ALL SELECT
    @Tab2 + '<HTELBOS>' + @HTELBOS + '</HTELBOS>'
  UNION ALL SELECT
    @Tab2 + '<HKBUH>' + @HKBUH + '</HKBUH>'
  UNION ALL SELECT
    @Tab2 + '<HBUH>' + @HBUH + '</HBUH>'
  UNION ALL SELECT
    @Tab2 + '<HTELBUH>' + @HTELBUH + '</HTELBUH>'
  UNION ALL SELECT
	@Tab1 + '</DECLARBODY>'
  UNION ALL SELECT
	    '</DECLAR>'

SELECT XMLText FROM @UT order by RowID
GO