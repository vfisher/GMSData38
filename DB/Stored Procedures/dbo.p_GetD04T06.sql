SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_GetD04T06] (@OurID int, @BDate smalldatetime)
/* Возвращает данные таблицы E04T06 (экспорт в "M.E.DOC Додаток 4. Таблиця 6.Відомості про нарахування зароботної плати (доходу) застрахованим особам") */
AS
BEGIN
SET NOCOUNT ON
DECLARE @PeriodBegin smalldatetime, @PeriodEnd smalldatetime, @PeriodM int, @PeriodY int, @MinSalary numeric(21,9), @MaxSalaryESV numeric(21,9)  
SET @PeriodBegin = dbo.zf_GetDate(dbo.zf_GetMonthFirstDay(@BDate))
SET @PeriodEnd = dbo.zf_GetDate(dbo.zf_GetMonthLastDay(@BDate))
SET @PeriodY = DATEPART(yyyy, @BDate)
SET @PeriodM = DATEPART(mm, @BDate)
SET @MinSalary =
ISNULL((SELECT TOP 1 EExp FROM z_FRUDFR m
INNER JOIN z_FRUDFRD d ON m.UDFID = d.UDFID AND m.UDFName = 'НЗ_ЗК_МинимальнаяЗП' AND @BDate BETWEEN d.BDate AND d.EDate),0)

SET @MaxSalaryESV =
ISNULL((SELECT TOP 1 EExp * 25 FROM z_FRUDFR m
INNER JOIN z_FRUDFRD d ON m.UDFID = d.UDFID AND m.UDFName = 'НЗ_БУ_ПрожиточныйМинимум' AND @BDate BETWEEN d.BDate AND d.EDate),0)

/* выборка актуального кадрового состояния за отчетный период */
DECLARE @EmpMPst TABLE (OurID int, EmpID int, BDate smalldatetime, PensCatID INT, SalaryQty numeric(21,9), Joint bit, 
                        IsDisDoc bit, IsGivDoc BIT)

INSERT INTO @EmpMPst(OurID, EmpID, BDate, PensCatID, SalaryQty, Joint, IsDisDoc, IsGivDoc)
SELECT OurID, EmpID, BDate, PensCatID, SalaryQty, Joint, 
       CASE WHEN IsDisDoc = 1 AND Edate < @PeriodEnd THEN 1 ELSE 0 END IsDisDoc, 
       CASE WHEN IsGivDoc = 1 AND Bdate > @PeriodBegin THEN 1 ELSE 0 END IsGivDoc
FROM   r_EmpMPst s
WHERE  s.OurID = @OurID AND s.BDate = (SELECT Max(ss.BDate) FROM r_EmpMPst ss WHERE s.OurID = ss.OurID AND s.EmpID = ss.EmpID
                                       AND ((BDate BETWEEN @PeriodBegin AND @PeriodEnd) OR (EDate BETWEEN @PeriodBegin AND @PeriodEnd) OR (BDate <= @PeriodBegin AND EDate >= @PeriodEnd)))

DECLARE  @PayTypes TABLE (PayTypeID int, IsSicLeav tinyint) /*1-признак больничного, 2- признак отпуска*/

/* типы выплат по больничным */
INSERT INTO @PayTypes (PayTypeID, IsSicLeav)
SELECT PayTypeID, 1 FROM r_PayTypes WHERE SrcDocTypeE LIKE '%p_ESic%' AND PayTypeName NOT LIKE dbo.zf_Translate('%беремен%')

/*типы выплат по отпускам*/
INSERT INTO @PayTypes (PayTypeID, IsSicLeav)
SELECT PayTypeID, 2 FROM r_PayTypes WHERE SrcDocTypeE LIKE '%p_ELeav%' AND PayTypeName NOT LIKE dbo.zf_Translate('%компенс%')

/*типы выплат по беременности и родам*/
INSERT INTO @PayTypes (PayTypeID, IsSicLeav)
SELECT PayTypeID, 3 FROM r_PayTypes WHERE SrcDocTypeE LIKE '%p_ESic%' AND PayTypeName LIKE dbo.zf_Translate('%беремен%')

/* получить данные о начислениях за указанный период */
DECLARE  @Pays TABLE (StepID int DEFAULT 1, OurID int, EmpID int, SumCC numeric(21,9),
                      UniSocDedRate numeric(21,9), UniSocChargeRate numeric(21,9), UniSocDedСС numeric(21,9), UniSocChargeСС numeric(21,9), 
                      SumCCByUniSocDed numeric(21,9) DEFAULT 0, IsSicLeav tinyint DEFAULT 0)

INSERT INTO  @Pays (OurID, EmpID, SumCC, UniSocDedRate, UniSocChargeRate, UniSocDedСС, UniSocChargeСС, IsSicLeav)
SELECT OurID, EmpID, SumCC,
       dd.UniSocDedRate,
       dd.UniSocChargeRate,
       dd.UniSocDedСС,
       dd.UniSocChargeСС,
       ISNULL(p2.IsSicLeav, 0)
FROM   p_LRec m
       JOIN p_LRecD d ON d.ChID = m.ChID
       JOIN p_LRecDD dd ON d.AChID = dd.AChID
       JOIN r_PayTypes p ON dd.PayTypeID = p.PayTypeID
       LEFT JOIN @PayTypes p2 ON p2.PayTypeID = dd.PayTypeID
WHERE m.LRecType IN (0)
       AND SrcDate BETWEEN @PeriodBegin AND @PeriodEnd
       AND p.IsDeduction = 0
       AND p.FundType BETWEEN 0 AND 3

/* вычислить базис облагаемой суммы по каждому коду выплаты; суммы  SumCCByUniSocDed и SumCC
   могут отличаться когда начисления по сотруднику превышают максимальную облагаемую сумму */
UPDATE @Pays SET SumCCByUniSocDed = 100 * UniSocDedСС / UniSocDedRate WHERE UniSocDedRate > 0


/* консолидация сумм по сотруднику */
INSERT INTO  @Pays (StepID, OurID, EmpID, SumCC, UniSocDedRate, UniSocChargeRate, UniSocDedСС, UniSocChargeСС, SumCCByUniSocDed, IsSicLeav)
SELECT 2, OurID, EmpID,  SUM(SumCC), UniSocDedRate, UniSocChargeRate, SUM(UniSocDedСС), SUM(UniSocChargeСС), SUM(SumCCByUniSocDed), IsSicLeav
FROM @Pays
GROUP BY  OurID, EmpID, UniSocDedRate, UniSocChargeRate, IsSicLeav

/* очистка промежуточных значений */
DELETE FROM @Pays WHERE StepID <> 2

DECLARE  @t1 TABLE (StepID int, EmpID int, LN VARCHAR(200), NM VARCHAR(200), FTN VARCHAR(200), ZO INT, UKR_GROMAD INT, PERIOD_Y INT,
                   PERIOD_M INT, PAY_TP INT, EXP VARCHAR(255), PAY_YEAR INT, PAY_MNTH INT, ST INT, OTK INT, NRM INT, NUMIDENT VARCHAR(50),
                   SUM_TOTAL numeric(21,9), SUM_INS numeric(21,9), SUM_MAX numeric(21,9), KD_NP INT, KD_NZP INT, KD_PTV INT,
                   KD_VP INT, IsSicLeav INT, SUM_DIFF numeric(21,9), SUM_NARAH numeric(21,9), NRC INT, UniSocDedRate numeric(21,9), 
                   UniSocChargeRate numeric(21,9), Joint bit, IsDisDoc bit, IsGivDoc bit)
INSERT INTO @t1 (StepID, EmpID, LN, NM, FTN, ZO, UKR_GROMAD, PERIOD_Y, PERIOD_M, PAY_TP, EXP, PAY_YEAR, PAY_MNTH, ST, OTK, NRM, NUMIDENT,
                 SUM_TOTAL, SUM_INS, SUM_MAX, KD_NP, KD_NZP, KD_PTV, KD_VP, IsSicLeav, SUM_DIFF, SUM_NARAH, NRC, UniSocDedRate, UniSocChargeRate,                       Joint, IsDisDoc, IsGivDoc)

SELECT StepID, s.EmpID,
       ISNULL(n.UAEmpLastName, e.UAEmpLastName)    AS LN,
       ISNULL(n.UAEmpFirstName, e.UAEmpFirstName)  AS NM,
       ISNULL(n.UAEmpParName, e.UAEmpParName)      AS FTN,
       CASE
         WHEN IsSicLeav = 1 THEN 29
         WHEN (SELECT TOP 1 r.IsInvalid FROM r_EmpMP r WHERE r.OurID = @OurID AND r.EmpID = s.EmpID AND r.BDate <= @PeriodBegin AND r.EDate >= @PeriodEnd) = 1 THEN 2
         WHEN IsSicLeav = 3 THEN 42
         ELSE 1
       END ZO,
       CAST(IsCitizen AS int) AS UKR_GROMAD,
       @PeriodY  AS PERIOD_Y,
       @PeriodM  AS PERIOD_M,
       CASE WHEN IsSicLeav = 2 THEN 10 ELSE NULL END AS  PAY_TP,
       NULL  AS EXP,
       /*CASE WHEN IsSicLeav = 1 THEN */@PeriodY /*ELSE NULL END*/   PAY_YEAR,
       /*CASE WHEN IsSicLeav = 1 THEN */@PeriodM /*ELSE NULL END*/   PAY_MNTH,
       CASE WHEN EmpSex = 2 THEN 0 WHEN EmpSex > 2 THEN NULL ELSE 1 END AS ST,
       CASE WHEN (e.WorkBookNo IS NOT NULL) AND (e.WorkBookSer IS NOT NULL) THEN 1 ELSE 0 END  AS OTK,
       0 AS NRM,
       CASE WHEN e.TaxCode = '' THEN CASE WHEN IsCitizen = 1 THEN  'БК' + n.PassSer + n.PassNo ELSE 'F' + n.PassSer + n.PassNo END ELSE e.TaxCode END AS NUMIDENT,
       ISNULL(p.SumCC, 0) AS SUM_TOTAL,
       ISNULL(p.UniSocDedСС, 0) AS SUM_INS,
       CASE WHEN ISNULL(p.SumCC, 0) <= @MaxSalaryESV THEN ISNULL(p.SumCC, 0) ELSE @MaxSalaryESV END AS SUM_MAX,
       /*ISNULL(p.SumCCByUniSocDed, 0) AS SUM_MAX,*/
       CASE WHEN IsSicLeav = 1 THEN ISNULL((
         SELECT TOP 1 SickDaysCount 
         FROM p_CWTime JOIN p_CWTimeD ON p_CWTime.ChID = p_CWTimeD.ChID 
         WHERE CWTimeType = 0  AND OurID = s.OurID AND EmpID = s.EmpID AND @BDate BETWEEN BDate AND EDate ORDER BY  DocDate DESC) , 0) 
       ELSE NULL END KD_NP,
       (SELECT DATEDIFF(DAY, 
          CASE WHEN BDate BETWEEN @PeriodBegin AND @PeriodEnd THEN BDate ELSE @PeriodBegin END,
       	  CASE WHEN EDate BETWEEN @PeriodBegin AND @PeriodEnd THEN EDate ELSE @PeriodEnd END) + 1 AS LeavDays
        FROM p_ELeav m JOIN p_ELeavD d ON d.ChID = m.ChID LEFT JOIN p_ELeavDP dd ON dd.AChID = d.AChID WHERE OurID = @OurID AND LeavType BETWEEN 51 AND 59 AND EmpID = s.EmpID AND BDate <= @PeriodEnd AND EDate >= @PeriodBegin) KD_NZP,

       CASE WHEN IsSicLeav IN (1,2) AND EXISTS (SELECT EmpID, COUNT(EmpID) FROM @Pays WHERE OurID = @OurID AND UniSocChargeСС <> 0 AND EmpID = s.EmpID GROUP BY EmpID HAVING COUNT (EmpID) > 1) THEN NULL
            ELSE
       (CASE WHEN EXISTS (SELECT TOP 1 1 FROM r_EmpMPst WHERE OurID = s.OurID AND EmpID = s.EmpID AND EDate BETWEEN @PeriodBegin AND @PeriodEnd AND IsDisDoc = 1)
            THEN (SELECT DATEDIFF(dd, @PeriodBegin, MAX(EDate) + 1) FROM r_EmpMPst WHERE OurID = s.OurID AND EmpID = s.EmpID AND EDate BETWEEN @PeriodBegin AND @PeriodEnd AND IsDisDoc = 1)
            WHEN EXISTS (SELECT TOP 1 1 FROM r_EmpMPst WHERE OurID = s.OurID AND EmpID = s.EmpID AND BDate BETWEEN @PeriodBegin AND @PeriodEnd AND IsGivDoc = 1)
            THEN (SELECT DATEDIFF(dd, MIN(BDate), @PeriodEnd + 1) FROM r_EmpMPst WHERE OurID = s.OurID AND EmpID = s.EmpID AND BDate BETWEEN @PeriodBegin AND @PeriodEnd AND IsGivDoc = 1)
            ELSE  DATEDIFF (dd, @PeriodBegin, @PeriodEnd + 1) END) END AS KD_PTV,
       CASE
         WHEN IsSicLeav = 3 THEN ISNULL((
           SELECT SUM(ROUND((d.DetTillFiveSumCC + d.DetAfterFiveSumCC) / m.AvrSalary / m.SickPayPrc * 100, 0))
           FROM p_ESic m, p_ESicA d
           WHERE m.ChID = d.ChID AND m.OurID = @OurID AND m.EmpID = s.EmpID AND m.SickType = 8 AND d.DetSrcDate BETWEEN @PeriodBegin AND @PeriodEnd AND m.OurID = @OurID), 0)
         ELSE NULL
       END KD_VP,
       IsSicLeav,
       /*CASE WHEN ISNULL(p.SumCC, 0) < @MinSalary THEN NULL ELSE @MinSalary - ISNULL(p.SumCC, 0) END */
        NULL AS SUM_DIFF,
       ISNULL(p.UniSocChargeСС,0) AS SUM_NARAH,
       CASE WHEN s.SalaryQty < 1 THEN 1 ELSE 0 END AS NRC,
       p.UniSocDedRate AS UniSocDedRate,
       p.UniSocChargeRate AS UniSocChargeRate,
       s.Joint,
       s.IsDisDoc, 
       s.IsGivDoc

FROM   @Pays p
       JOIN @EmpMPst s  ON p.OurID = s.OurID AND p.EmpID = s.EmpID
       JOIN r_Emps e ON e.EmpID = s.EmpID
       LEFT JOIN r_EmpNamesDates n ON n.OurID = s.OurID AND n.EmpID = s.EmpID AND @PeriodEnd BETWEEN n.BDate AND n.EDate
WHERE ISNULL(p.UniSocChargeСС,0) <> 0

/* результирующий набор данных */

SELECT * FROM @t1 tt 
UNION ALL

SELECT t.StepID, t.EmpID, t.LN, t.NM, t.FTN, 1 AS ZO, t.UKR_GROMAD, t.PERIOD_Y, t.PERIOD_M, 13 AS PAY_TP, t.EXP, t.PAY_YEAR, t.PAY_MNTH, t.ST,
       t.OTK, t.NRM, t.NUMIDENT, 
       NULL AS SUM_TOTAL, 
       ROUND((@MinSalary - SUM(t.SUM_TOTAL)) * t.UniSocDedRate / 100, 2) AS  SUM_INS,
       NULL AS SUM_MAX,
       NULL, t.KD_NZP, null, t.KD_VP, null, @MinSalary - SUM(t.SUM_TOTAL) AS SUM_DIFF,
       /*ROUND((@MinSalary - SUM(t.SUM_TOTAL)) * t.UniSocChargeRate / 100, 2) AS  SUM_NARAH, */
       ROUND(t1.UniSocChargeСС,2) AS SUM_NARAH,
       t.NRC AS NRC, t.UniSocDedRate, t.UniSocChargeRate, NULL, NULL, NULL 
FROM @t1 t
LEFT JOIN (SELECT d.EmpID, d.UniSocChargeСС FROM p_LRec m, p_LrecD d WHERE m.ChID = d.ChID AND m.OurID = @OurID AND m.DocDate BETWEEN @PeriodBegin AND @PeriodEnd AND m.LRecType = 3) t1 ON t.EmpID = t1.EmpID
WHERE 
t.ZO = 1 AND t.Joint = 0 AND t.IsDisDoc = 0 AND t.IsGivDoc = 0 /*AND t.NRC = 0*/ 
      /* AND NOT EXISTS (SELECT EmpID, COUNT(EmpID) FROM @t1 WHERE EmpID = t.EmpID GROUP BY EmpID HAVING COUNT (EmpID) > 1)*/ 
      AND
      NOT EXISTS 
      (SELECT dd.WTSignID
       FROM p_CWTime m
       JOIN p_CWTimeD d ON m.ChID = d.ChID
       JOIN p_CWTimeDD dd ON d.AChID = dd.AChID
       WHERE m.OurID = @OurID AND m.DocDate BETWEEN @PeriodBegin AND @PeriodEnd AND d.EmpID = t.EmpID AND dd.WTSignID IN (16))    
GROUP BY
  t.StepID, t.EmpID, t.LN, t.NM, t.FTN, t.UKR_GROMAD, t.PERIOD_Y, t.PERIOD_M, t.EXP, t.PAY_YEAR, t.PAY_MNTH, t.ST, t.OTK,
  t.NRM, t.NUMIDENT, t.KD_NZP, t.KD_VP, t.NRC, t.UniSocDedRate, t.UniSocChargeRate, t1.UniSocChargeСС  
HAVING  SUM(t.SUM_TOTAL) < @MinSalary
END

GO
