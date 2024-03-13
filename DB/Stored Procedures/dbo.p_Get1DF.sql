SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_Get1DF](@OurID int, @Date datetime, @Period int, @ExclEmps varchar(10), @SubID varchar(10), @DepID varchar(10))
/* Возвращает совокупность данных для формирования отчета 1ДФ*/
AS
BEGIN
SET NOCOUNT ON
DECLARE @BDate datetime, @EDate datetime, @IncRecalc int, @DedRecalc int, @TAXBDATE  datetime, @TAXEDATE datetime, @TAXBEGINDATE datetime, @INCOMETAXPREV varchar(2)
DEClARE @Quart Int, @Year Int
  IF @Period = 0
    BEGIN
      SET @BDate = dbo.zf_GetMonthFirstDay(@Date)
      SET @EDate = dbo.zf_GetMonthLastDay(@Date)
    END
  ELSE
    BEGIN
      SET @BDate = dbo.zf_GetQuarterFirstDay(@Date)
      SET @EDate = dbo.zf_GetQuarterLastDay(@Date)
    END
  IF Month(@Date) >= 10 SET @Quart = 4 ELSE
  IF Month(@Date) >= 7  SET @Quart = 3 ELSE
  IF Month(@Date) >= 4  SET @Quart = 2 ELSE
  IF Month(@Date) >= 1  SET @Quart = 1
SET @Year = Year(@Date)
SET @TAXBDATE = DATEDIFF(MONTH, -1, @BDate)
SET @TAXEDATE = DATEDIFF(MONTH, -1, @EDate)
SET @TAXBEGINDATE = @TAXBDATE

SET @IncRecalc = (SELECT z_FRUDFs.EFormula FROM z_FRUDFs WHERE z_FRUDFs.OperName ='КЗ_ПерерасчетПодоходногоУдержание')
SET @DedRecalc = (SELECT z_FRUDFs.EFormula FROM z_FRUDFs WHERE z_FRUDFs.OperName ='КЗ_ПерерасчетПодоходногоДоплата')

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

DECLARE @LRec TABLE (EmpID int, TaxCode varchar (50), EmpName varchar (200), AcceptDate datetime, DismissDate datetime, IncomeTaxPrev int, IsJoint bit)
INSERT INTO @LRec(EmpID, TaxCode, EmpName, AcceptDate, DismissDate, IncomeTaxPrev, IsJoint)
SELECT DISTINCT
  d.EmpID,
  e.TaxCode,e.empname,
  (SELECT TOP 1 m1.WorkAppDate FROM p_EGivs m1 WITH (NOLOCK) WHERE m1.EmpID=d.EmpID AND m1.OurID= @OurID AND m1.DocDate<=@EDate ORDER BY m1.WorkAppDate DESC) AS AcceptDate,
  (SELECT TOP 1 m1.DisDate FROM p_EDiss m1 WITH (NOLOCK) WHERE m1.EmpID=d.EmpID AND m1.OurID=@OurID AND m1.DocDate<=@EDate ORDER BY m1.DisDate DESC) AS DismissDate,
  (SELECT TOP 1 p.PrevID FROM r_EmpMP mp WITH (NOLOCK), r_Prevs p WITH (NOLOCK) WHERE mp.EmpID=d.EmpID AND mp.OurID=@OurID AND p.PrevID=mp.PrevID AND p.PrevDocID='0'
   AND p.PrevDocItem='0' AND p.PrevDocPoint='0' AND p.PrevDocPart='0' AND p.PrevID<>0) AS IncomeTaxPrev,
  (SELECT mp1.Joint FROM r_EmpMPst mp1 WITH (NOLOCK) WHERE mp1.EmpID=d.EmpID AND mp1.OurID=@OurID AND mp1.BDate=(SELECT Max(BDate) FROM r_EmpMPst mp2 WITH (NOLOCK) WHERE mp2.EmpID=d.EmpID AND mp2.OurID=@OurID)) AS IsJoint
FROM p_LRec m WITH (NOLOCK), p_LRecD d WITH (NOLOCK), p_LRecDD dd WITH (NOLOCK), r_PayTypes pt WITH (NOLOCK), r_Emps e WITH (NOLOCK)
WHERE d.ChID=m.ChID AND m.LRecType=0 AND dd.AChID=d.AChID AND pt.PayTypeID=dd.PayTypeID AND e.EmpID=d.EmpID AND m.OurID=@OurID AND pt.IsDeduction=0 AND m.DocDate>=@BDate AND m.DocDate<=@EDate
  AND dd.PayTypeID NOT IN (@IncRecalc, @DedRecalc) AND d.EmpID NOT IN (SELECT * FROM [zf_FilterToTable] (@ExclEmps))
  /* AND d.DetSubID = CASE WHEN @SubID = '' THEN d.DetSubID ELSE @SubID END */
  AND d.DetSubID IN (SELECT SubID FROM @SubIDTbl) AND d.DetDepID IN (SELECT DepID FROM @DepIDTbl)

UNION
SELECT DISTINCT
  d.EmpID,
  e.TaxCode,e.empname,
  (SELECT TOP 1 m1.WorkAppDate FROM p_EGivs m1 WITH (NOLOCK) WHERE m1.EmpID=d.EmpID AND m1.OurID=@OurID AND m1.DocDate<=@EDate ORDER BY m1.WorkAppDate DESC) AS AcceptDate,
  (SELECT TOP 1 m1.DisDate FROM p_EDiss m1 WITH (NOLOCK) WHERE m1.EmpID=d.EmpID AND m1.OurID=@OurID AND m1.DocDate<=@EDate ORDER BY m1.DisDate DESC) AS DismissDate,
  (SELECT TOP 1 p.PrevID FROM r_EmpMP mp WITH (NOLOCK), r_Prevs p WITH (NOLOCK) WHERE mp.EmpID=d.EmpID AND mp.OurID= @OurID AND
     p.PrevID=mp.PrevID AND p.PrevDocID='0' AND p.PrevDocItem='0' AND p.PrevDocPoint='0' AND p.PrevDocPart='0' AND p.PrevID<>0) AS IncomeTaxPrev,
  (SELECT mp1.Joint FROM r_EmpMPst mp1 WITH (NOLOCK) WHERE mp1.EmpID=d.EmpID AND mp1.OurID=@OurID AND mp1.BDate=(SELECT Max(BDate) FROM r_EmpMPst mp2 WITH (NOLOCK) WHERE mp2.EmpID=d.EmpID AND mp2.OurID=@OurID)) AS IsJoint
FROM p_LExp m WITH (NOLOCK), p_LExpD d WITH (NOLOCK), p_LRec m1 WITH (NOLOCK), p_LRecD d1 WITH (NOLOCK), p_LRecDD dd1 WITH (NOLOCK), r_PayTypes pt WITH (NOLOCK), r_Emps e WITH (NOLOCK)
WHERE d.ChID=m.ChID AND d1.ChID=m1.ChID AND m.LExpType=0 AND m1.LRecType=0 AND dd1.AChID=d1.AChID AND pt.PayTypeID=dd1.PayTypeID AND m1.OurID=m.OurID AND m.OurID=@OurID AND YEAR(m1.DocDate)=YEAR(m.AccDate) AND MONTH(m1.DocDate)=MONTH(m.AccDate)
  AND e.EmpID=d.EmpID AND pt.IsDeduction=0 AND m.DocDate>=@BDate AND m.DocDate<=@EDate AND dd1.PayTypeID NOT IN (@IncRecalc,@DedRecalc) AND d.EmpID NOT IN (SELECT * FROM [zf_FilterToTable] (@ExclEmps))
  AND d.EmpID NOT IN (SELECT DISTINCT d2.EmpID FROM p_LRec m2, p_LRecD d2 WHERE m2.ChID=d2.ChID AND m2.OurID=@OurID AND m2.LRecType=0 AND m.DocDate>=@BDate AND m.DocDate<=@EDate)
  /* AND d.SubID = CASE WHEN @SubID = '' THEN d.SubID ELSE @SubID END */
  AND d.SubID IN (SELECT SubID FROM @SubIDTbl) AND d.DepID IN (SELECT DepID FROM @DepIDTbl)
ORDER BY d.EmpID

DECLARE @OursCode varchar(20)
SET @OursCode = (SELECT m.Code FROM r_Ours m WHERE m.OurID = @OurID)

/* Суми нарахованого доходу по місяцях */
DECLARE @PeriodSum TABLE (EmpID int, DocDate datetime, SumCC  numeric(21,9), MilitaryRecSum numeric(21,9))
INSERT INTO @PeriodSum (EmpID, DocDate, SumCC, MilitaryRecSum)
SELECT
  s.EmpID,
  s.DocDate,
  SUM(s.RecSum) AS RecSum,
  SUM(s.MilitaryRecSum) AS MilitaryRecSum 
FROM  
(SELECT
  d.EmpID,
  m.DocDate,
  dd.SumCC AS RecSum,
  CASE WHEN (SELECT p.UseMilitaryTax FROM dbo.r_PayTypes p WHERE p.PayTypeID = dd.PayTypeID) = 1 THEN 
           dd.SumCC
       ELSE 0 
  END AS MilitaryRecSum
FROM p_LRec m, p_LRecD d, p_LREcDD dd
WHERE d.ChID=m.ChID AND d.AChID = dd.AChID AND m.LRecType=0 AND dd.IsDeduction <> 1 AND m.OurID = @OurID AND m.DocDate >= @BDate AND m.DocDate <= @EDate) s
GROUP BY s.EmpID, s.DocDate
ORDER BY s.EmpID

/* Суми утримань податкового податку по місяцях */
DECLARE @PeriodIncomeTax TABLE (EmpID int, MonthDocDate int, IncomeTaxCC  numeric(21,9), MilitaryTaxCC numeric(21,9))
INSERT INTO @PeriodIncomeTax (EmpID, MonthDocDate, IncomeTaxCC, MilitaryTaxCC)
SELECT
d.EmpID,
MONTH(m.DocDate),
SUM(d.IncomeTaxCC),
SUM(d.MilitaryTaxCC)
FROM p_LRec m, p_LRecD d
WHERE d.ChID = m.ChID AND m.OurID = @OurID AND m.DocDate >= @BDate AND m.DocDate <= @EDate
GROUP BY d.EmpID, MONTH(m.DocDate)

/* Cума нарахованого доходу */
DECLARE @RecSum TABLE (EmpID int, RecSum  numeric(21,9), RecIncomeTax numeric(21,9), MilitaryTaxCC numeric(21,9), MilitaryRecSum numeric(21,9), OZN_DOX int, OZN_PILG int)
INSERT INTO @RecSum (EmpID, RecSum, RecIncomeTax, MilitaryTaxCC, MilitaryRecSum, OZN_DOX, OZN_PILG)
SELECT
S1.EmpID,
SUM(S1.RecSum) AS RecSum,
SUM(S1.IncomeTax) AS IncomeTax,
SUM(S1.MilitaryTaxCC) AS MilitaryTaxCC,
SUM(S1.MilitaryRecSum) AS MilitaryRecSum, 
S1.OZN_DOX,
S1.OZN_PILG

FROM (
SELECT
S.EmpID,
S.DocDate,
SUM(S.MilitaryTaxCC) AS MilitaryTaxCC,
SUM(S.MilitaryRecSum) AS MilitaryRecSum,
SUM(S.RecSum) AS RecSum ,
SUM(S.IncomeTax) AS IncomeTax,
S.OZN_DOX,
CASE
  WHEN S.OZN_DOX <> 101 THEN 0 ELSE
    CASE 
    WHEN SUM(S.RecSum) <= (SELECT d.EExp FROM z_FRUDFR m, z_FRUDFRD d
                           WHERE m.UDFID = d.UDFID AND m.UDFName = 'НЗ_ЗК_ГраничныйДоходЛьготыПН' AND s.DocDate BETWEEN d.BDate AND d.EDate) AND
         (SUM(S.RecSum) >= (SELECT d.EExp FROM z_FRUDFR m, z_FRUDFRD d
                           WHERE m.UDFID = d.UDFID AND m.UDFName = 'НЗ_ЗК_СуммаЛьготыПН' AND s.DocDate BETWEEN d.BDate AND d.EDate) 
                           OR SUM(S.IncomeTax) = 0)                  
    THEN (SELECT TOP 1 d2.PrevFiscID FROM r_EmpMP d1, r_Prevs d2
          WHERE d1.PrevID = d2.PrevID AND d1.Ourid = @OurID AND d1.EmpID = S.EmpID AND S.DocDate BETWEEN d1.BDate AND d1.EDate)
    ELSE 0
    END
END AS OZN_PILG
FROM (
Select
d.EmpID,
CASE WHEN (SELECT p.UseMilitaryTax FROM dbo.r_PayTypes p WHERE p.PayTypeID = dd.PayTypeID) = 1 THEN 
           dd.SumCC
     ELSE 0 
     END AS MilitaryRecSum,
m.DocDate AS DocDate,
dd.SumCC AS RecSum,
dd.SumCC/(SELECT SumCC FROM @PeriodSum WHERE Docdate = m.DocDate AND EmpID = d.EmpID)*(SELECT IncomeTaxCC FROM @PeriodIncomeTax WHERE MonthDocDate = MONTH(m.DocDate) AND EmpID = d.EmpID) AS IncomeTax, 
CASE WHEN (SELECT MilitaryRecSum FROM @PeriodSum WHERE Docdate = m.DocDate AND EmpID = d.EmpID) = 0 THEN 0 else
CASE WHEN (SELECT p.UseMilitaryTax FROM dbo.r_PayTypes p WHERE p.PayTypeID = dd.PayTypeID) = 1 THEN 
           dd.SumCC
     ELSE 0 
END/ 
(SELECT MilitaryRecSum FROM @PeriodSum WHERE Docdate = m.DocDate AND EmpID = d.EmpID)*(SELECT MilitaryTaxCC FROM @PeriodIncomeTax WHERE MonthDocDate = MONTH(m.DocDate) AND EmpID = d.EmpID) end AS MilitaryTaxCC,
CASE
  WHEN dd.PayTypeID in (408,410,425) THEN 128
  WHEN (SELECT DISTINCT TOP 1 d1.Joint FROM r_EmpMPst d1 WHERE d1.EmpID = d.EmpID AND m.DocDate >= d1.BDate AND m.DocDate <= d1.EDate) = 1 THEN 102
  ELSE 101
END AS OZN_DOX
FROM p_LRec m, p_LRecD d, p_LREcDD dd
WHERE d.ChID=m.ChID AND d.AChID = dd.AChID
AND m.LRecType=0 AND dd.IsDeduction <> 1 AND m.OurID = @OurID AND m.DocDate >= @BDate AND m.DocDate <= @EDate) S
GROUP BY S.EmpID, s.DocDate, S.OZN_DOX) S1
GROUP BY S1.EmpID, S1.OZN_DOX, S1.OZN_PILG
ORDER BY S1.EmpID

/* Идентификационный номер руководителя предприятия, служебный телефон */
DECLARE @DirectorCode TABLE (EmpID int, TaxCode varchar (50), Phone varchar (20))
INSERT INTO @DirectorCode (EmpID, TaxCode, Phone)
SELECT DISTINCT
e.EmpID,
e.TaxCode,
CASE Replace(Replace(Replace(Replace(e.Phone,'-',''),' ',''),'(',''),')','')
  WHEN '' THEN NULL
  ELSE Replace(Replace(Replace(Replace(e.Phone,'-',''),' ',''),'(',''),')','')
END AS Phone
FROM r_EmpMO m, r_Emps e
WHERE e.EmpID=m.EmpID AND m.OurID=@OurID AND m.EmpState=1

/* Идентификационный номер главного бухгалтера предприятия, служебный телефон */
DECLARE @AccountantCode TABLE (EmpID int, TaxCode varchar (50), Phone varchar (20))
INSERT INTO @AccountantCode (EmpID, TaxCode, Phone)
SELECT DISTINCT
e.EmpID,
e.TaxCode,
CASE Replace(Replace(Replace(Replace(e.Phone,'-',''),' ',''),'(',''),')','')
  WHEN '' THEN NULL
  ELSE Replace(Replace(Replace(Replace(e.Phone,'-',''),' ',''),'(',''),')','')
END AS Phone
FROM r_EmpMO m, r_Emps e
WHERE e.EmpID=m.EmpID AND m.OurID=@OurID AND m.EmpState=2


DECLARE @S1 TABLE (EMPID int, PERIOD int, RIK int, KOD int, TYP int, TIN varchar (50), S_NAR numeric(21,9), S_DOX numeric(21,9), S_TAXN numeric(21,9), S_TAXP numeric(21,9), S_MILITARY numeric(21,9), S_MILITARYSUM numeric(21,9), OZN_DOX int, D_PRIYN datetime, D_ZVILN datetime, OZN_PILG int, OZNAKA int)
INSERT INTO @S1(EMPID, PERIOD, RIK, KOD, TYP, TIN, S_NAR, S_DOX, S_TAXN, S_TAXP, S_MILITARY, S_MILITARYSUM, OZN_DOX, D_PRIYN, D_ZVILN, OZN_PILG, OZNAKA)
SELECT
r.EmpID             AS EmpID,    /* Код служащего */
@Quart              AS PERIOD,   /* Порядковий номер звітного кварталу*/
@YEAR               AS RIK,      /* Звітний рік*/
@OursCode           AS KOD,      /* Ідентифікаційний код за ЄДРПОУ */
0                   AS TYP,      /* Ознака податкового агента, який подає податковий розрахунок (0 - юридична особа, 1 - фізична особа)*/
l.TaxCode           AS TIN,      /* Ідентифікаційний номер фізичної особи */
r.RecSum            AS S_NAR,    /* Сума нарахованого доходу */
r.RecSum            AS S_DOX,    /* Сума виплаченого доходу */
r.RecIncomeTax      AS S_TAXN,   /* Сума нарахованого прибуткового податку */
r.RecIncomeTax      AS S_TAXP,   /* Сума утриманного прибуткового податку*/
r.MilitaryTaxCC     AS S_MILITARY, /* Сумма военного сбора*/
r.MilitaryRecSum    AS S_MILITARYSUM, /* Сумма для удержания военного сбора*/
r.OZN_DOX           AS OZN_DOX,  /* Ознака доходу згідно з довідником ознак доходів */
CASE WHEN l.AcceptDate >= @BDate THEN l.AcceptDate END
                    AS D_PRIYN,  /* Дата прийняття на роботу фізичної особи */
CASE WHEN (l.DismissDate >= @BDate AND l.DismissDate <= @EDate) THEN l.DismissDate END
                    AS D_ZVILN,  /* Дата звільнення з роботи фізичної особи */
r.OZN_PILG          AS OZN_PILG, /* Ознака пільги згідно з довідником ознак податкових соціальних пільг */
0                   AS OZNAKA    /* Ознака: 0 - введення запису, 1 - вилучення запису */
FROM
@RecSum r, @LRec l
WHERE r.EmpID = l.EmpID

/* Результирующий набор */
SELECT * FROM @S1
END
GO
