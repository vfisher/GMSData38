SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_GetIndexUnifiedSocialTax]
/* Возвращает понижающий коэффициент для начисления ЕСВ (Документ Заработная плата: Начисление). */
(
@DocDate datetime, @OurID int, @IndexUSTLast numeric(21, 9) OUTPUT
)
AS
SET NOCOUNT ON

DECLARE @AvgSumCC numeric(21, 9), @AvgEmpMonth INT, @AvgUniSocChargeCC numeric(21, 9)
SET @AvgSumCC = (SELECT AvgSumCC FROM dbo.pf_GetCalcAvgSalary(@DocDate, @OurID))
SET @AvgEmpMonth = (SELECT AvgEmpMonth FROM dbo.pf_GetCalcAvgSalary(@DocDate, @OurID))
SET @AvgUniSocChargeCC = (SELECT AvgUniSocChargeСС FROM dbo.pf_GetCalcAvgSalary(@DocDate, @OurID))

DECLARE @Condition1 int, @Condition2 int, @Condition3 int, @IndexUST numeric(21, 9)

DECLARE @TEMPXML XML
SET @TEMPXML = (
                SELECT Doc.*, DocD.* FROM p_LrecD DocD
                INNER JOIN p_Lrec Doc ON DocD.ChID = Doc.ChID
                WHERE Doc.DocDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate) AND
                      Doc.OurID = @OurID AND Doc.LRecType = 0
                FOR XML AUTO )

DECLARE @EmpID int, @MainSumCC numeric(21, 9), @ExtraSumCC numeric(21, 9),
        @MoreSumCC numeric(21, 9), @NeglibleSumCC numeric(21, 9),
        @UniSocChargeСС numeric(21, 9),
        @Sum numeric(21, 9), @SumUniSocChargeСС numeric(21, 9), @EmpCount int, @IsInvalid int  
DECLARE Cur CURSOR FAST_FORWARD FOR
SELECT
  DocD.EmpID,
  DocD.MainSumCC AS MainSumCC,
  DocD.ExtraSumCC AS ExtraSumCC,
  DocD.MoreSumCC AS MoreSumCC,
  DocD.NeglibleSumCC AS NeglibleSumCC,
  DocD.UniSocChargeСС  AS UniSocChargeСC,
  ISNULL((SELECT TOP 1 1
          FROM r_EmpMP mp
          WHERE mp.IsInvalid = 1 AND @DocDate BETWEEN mp.BDate AND mp.EDate AND mp.OurID = @OurID AND mp.EmpID = DocD.EmpID),0) AS IsInvalid
FROM (
      SELECT
        DocD.value('./@EmpID', 'int') as EmpID,
        DocD.value('./@MainSumCC', 'numeric(21, 9)') as MainSumCC,
        DocD.value('./@ExtraSumCC', 'numeric(21, 9)') as ExtraSumCC,
        DocD.value('./@MoreSumCC', 'numeric(21, 9)') as MoreSumCC,
        DocD.value('./@NeglibleSumCC', 'numeric(21, 9)') as NeglibleSumCC,
        DocD.value('./@UniSocChargeСС', 'numeric(21, 9)') as UniSocChargeСС
      FROM @TEMPXML.nodes('/Doc/DocD') col(DocD)) DocD
      ORDER BY DocD.EmpID 

SELECT @Sum = 0
SELECT @SumUniSocChargeСС = 0
SELECT @EmpCount = 0

OPEN Cur
  FETCH NEXT FROM Cur INTO @EmpID, @MainSumCC, @ExtraSumCC, @MoreSumCC, @NeglibleSumCC, @UniSocChargeСС, @IsInvalid
  WHILE @@FETCH_STATUS = 0
    BEGIN
      IF @IsInvalid = 0
      SELECT @Sum = @Sum + @MainSumCC + @ExtraSumCC + @MoreSumCC + @NeglibleSumCC,
             @SumUniSocChargeСС = @SumUniSocChargeСС + @UniSocChargeСС,
             @EmpCount = @EmpCount + 1

      FETCH NEXT FROM Cur INTO @EmpID, @MainSumCC, @ExtraSumCC, @MoreSumCC, @NeglibleSumCC, @UniSocChargeСС, @IsInvalid
    END

CLOSE Cur
DEALLOCATE Cur


IF (ISNULL(@Sum,0) <> 0) AND (ISNULL(@SumUniSocChargeСС,0) <> 0)
BEGIN

/*----------------------------------Проверка условий----------------------------------*/
/*Условие 1*/
IF @Sum/@EmpCount/@AvgSumCC * 100 - 100 >= 20
  SET @Condition1 = 1
ELSE SET @Condition1 = 0

/*----------------------------------Расчет коэффициента----------------------------------*/
SET @IndexUST = ROUND(@AvgSumCC/CASE WHEN @Sum = 0 THEN @AvgSumCC ELSE ROUND(@Sum/@EmpCount,2) END,3)
IF @Condition1 = 1
  BEGIN
    IF @IndexUST < 0.4
      SET @IndexUST = 0.4
    IF @IndexUST > 1
      SET @IndexUST = 1
  END
ELSE
  SET @IndexUST = 1
/*------------------------------------------------------------------------------------*/

/*Применение коэффициента*/
IF @IndexUST <> 1
BEGIN

DECLARE @CurDD TABLE (AEmpID int, AChID bigint, DetSrcPosID int, PayTypeID smallint, SumCCDD numeric(21, 9),
                      UniSocChargeССDD numeric(21, 9), IsDeduction BIT, AInvalid int)

DECLARE @AEmpID int, @AChID bigint, @DetSrcPosID int, @PayTypeID smallint, @SumCCDD numeric(21, 9), @UniSocChargeССDD numeric(21, 9), @IsDeduction bit, @Count int, @SumUniSocChargeССDD numeric(21, 9), @AInvalid int
DECLARE @TEMPXMLNew XML

SET @TEMPXML = (
                SELECT Doc.*, DocD.*, DocDD.* FROM p_LrecD DocD
                INNER JOIN p_Lrec Doc ON DocD.ChID = Doc.ChID
                INNER JOIN p_LrecDD DocDD ON DocD.AChID = DocDD.AChID
                WHERE Doc.DocDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate) AND
                      Doc.OurID = @OurID AND Doc.LRecType = 0
                FOR XML AUTO )

INSERT INTO @CurDD
SELECT 
  d.EmpID,
  dd.AChID,
  dd.DetSrcPosID,
  dd.PayTypeID,
  dd.SumCCDD,
  dd.UniSocChargeССDD,
  dd.IsDeduction,
  ISNULL((SELECT TOP 1 1
          FROM r_EmpMP mp
          WHERE mp.IsInvalid = 1 AND @DocDate BETWEEN mp.BDate AND mp.EDate AND mp.OurID = @OurID AND mp.EmpID = d.EmpID),0) AS AInvalid
FROM 
(SELECT
  DocD.value('./@AChID', 'bigint') AS AChID,
  DocD.value('./@EmpID', 'int') AS EmpID
FROM @TEMPXML.nodes('/Doc/DocD') col(DocD)) d, 
( 
SELECT
  DocDD.value('././@AChID', 'bigint') AS AChID,
  DocDD.value('././@DetSrcPosID', 'int') AS DetSrcPosID,
  DocDD.value('././@PayTypeID', 'smallint') AS PayTypeID,
  DocDD.value('././@SumCC', 'numeric(21, 9)') AS SumCCDD,
  DocDD.value('././@UniSocChargeСС', 'numeric(21, 9)') AS UniSocChargeССDD,
  DocDD.value('././@IsDeduction', 'bit') AS IsDeduction
FROM @TEMPXML.nodes('/Doc/DocD/DocDD') col(DocDD)) dd
WHERE d.AChID = dd.AChID

DECLARE CurDD CURSOR FAST_FORWARD FOR
  SELECT * FROM @CurDD

  SET @TEMPXMLNew = @TEMPXML
  SET @Count = 1
  SET @SumUniSocChargeССDD = 0
OPEN CurDD
  FETCH NEXT FROM CurDD INTO @AEmpID, @AChID, @DetSrcPosID, @PayTypeID, @SumCCDD, @UniSocChargeССDD, @IsDeduction, @AInvalid
  WHILE @@FETCH_STATUS = 0
    BEGIN
    IF @AInvalid = 0
    BEGIN
      SET @UniSocChargeСС = @UniSocChargeССDD * @IndexUST
      SET @SumUniSocChargeССDD = @SumUniSocChargeССDD + @UniSocChargeСС
    END
    ELSE
    BEGIN
      SET @UniSocChargeСС = @UniSocChargeССDD
      SET @SumUniSocChargeССDD = @SumUniSocChargeССDD
    END
      SET @TEMPXMLNew.modify(' replace value of (/Doc/DocD/DocDD/@UniSocChargeСС)[sql:variable("@Count")][1]
                               with   sql:variable("@UniSocChargeСС")
                             ')
      FETCH NEXT FROM CurDD INTO @AEmpID, @AChID, @DetSrcPosID, @PayTypeID, @SumCCDD, @UniSocChargeССDD, @IsDeduction, @AInvalid
      SET @Count = @Count + 1

    END
CLOSE CurDD
DEALLOCATE CurDD

IF @SumUniSocChargeССDD/@EmpCount/@AvgUniSocChargeCC >= 1
  SET @Condition2 = 1
ELSE
  SET @Condition2 = 0
/*----------------------*/
END
ELSE
  SET @Condition2 = 0

/*Условие 3*/
IF @EmpCount/@AvgEmpMonth * 100 <= 200
  SET @Condition3 = 1
ELSE
  SET @Condition3 = 0
/*------------------------------------------------------------------------------------*/

IF @Condition1 = 1 AND @Condition2 = 1 AND @Condition3 = 1
  SET @IndexUSTLast = @IndexUST
ELSE
  SET @IndexUSTLast = 1
END
ELSE
  SET @IndexUSTLast = 1
RETURN
GO
