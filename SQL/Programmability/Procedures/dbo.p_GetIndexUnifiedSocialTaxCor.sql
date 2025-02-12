SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_GetIndexUnifiedSocialTaxCor]
/* Возвращает коэффициент для корректировки начисления ЕСВ (Документ Заработная плата: Начисление). */
(
@DocDate datetime, @OurID int, @EmpID int, @IndexUSTLast numeric(21, 9) OUTPUT
)
AS
SET NOCOUNT ON
DECLARE  @MinSalary numeric(21, 9), @UniSocChargeRate numeric(21, 9), @SalaryAddToMin numeric(21, 9), @Joint bit, @IsGivOrDis bit

SET @MinSalary  = ISNULL((SELECT d.EExp FROM z_FRUDFR m, z_FRUDFRD d
                           WHERE m.UDFID = d.UDFID AND m.UDFName = 'НЗ_ЗК_МинимальнаяЗП' AND @DocDate BETWEEN d.BDate AND d.EDate),0)


SET @UniSocChargeRate = ISNULL((SELECT d.EExp FROM z_FRUDFR m, z_FRUDFRD d
                           WHERE m.UDFID = d.UDFID AND m.UDFName = 'ЗК_ЕСВ_СтавкаНачислений_ФОП_Прочие' AND @DocDate BETWEEN d.BDate AND d.EDate),0)
SET @Joint = ISNULL((SELECT TOP 1 Joint from r_EmpMPst WHERE OurID = @OurID AND EmpID = @EmpID AND IsDisDoc = 0 AND BDate <= @DocDate ORDER BY BDate DESC),0)
SET @IsGivOrDis = ISNULL((SELECT TOP 1 CASE WHEN (IsGivDoc = 1 OR IsDisDoc = 1) THEN 1 ELSE 0 END
                         FROM r_EmpMPst 
                         WHERE OurID = @OurID AND EmpID = @EmpID AND ((BDate <= @DocDate AND 
                         BDate between dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate)) OR (EDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate) AND IsDisDoc = 1))
                         ORDER BY BDate DESC),0)

DECLARE @TEMPXML XML
SET @TEMPXML = (
                SELECT Doc.*, DocD.* FROM p_LrecD DocD
                INNER JOIN p_Lrec Doc ON DocD.ChID = Doc.ChID
                WHERE Doc.DocDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate) AND
                      Doc.OurID = @OurID AND DocD.EmpID = @EmpID AND Doc.LRecType = 0
                FOR XML AUTO )

DECLARE @MainSumCC numeric(21, 9), @ExtraSumCC numeric(21, 9),
        @MoreSumCC numeric(21, 9), @NeglibleSumCC numeric(21, 9),
        @UniSocChargeСС numeric(21, 9), @TUniSocChargeССCor numeric(21, 9),  
        @Sum numeric(21, 9), @SumUniSocChargeСС numeric(21, 9), @SumTUniSocChargeССCor numeric(21, 9), @IsInvalid int  
DECLARE Cur CURSOR FAST_FORWARD FOR
SELECT
  DocD.EmpID,
  DocD.MainSumCC AS MainSumCC,
  DocD.ExtraSumCC AS ExtraSumCC,
  DocD.MoreSumCC AS MoreSumCC,
  DocD.NeglibleSumCC AS NeglibleSumCC,
  DocD.UniSocChargeСС  AS UniSocChargeСC,
  DocD.TUniSocChargeССCor AS TUniSocChargeССCor,
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
        DocD.value('./@UniSocChargeСС', 'numeric(21, 9)') as UniSocChargeСС,
        DocD.value('./@TUniSocChargeССCor', 'numeric(21, 9)') as TUniSocChargeССCor
      FROM @TEMPXML.nodes('/Doc/DocD') col(DocD)) DocD
      ORDER BY DocD.EmpID 

SELECT @Sum = 0
SELECT @SumUniSocChargeСС = 0
SELECT @SumTUniSocChargeССCor = 0

OPEN Cur
  FETCH NEXT FROM Cur INTO @EmpID, @MainSumCC, @ExtraSumCC, @MoreSumCC, @NeglibleSumCC, @UniSocChargeСС, @TUniSocChargeССCor, @IsInvalid
  WHILE @@FETCH_STATUS = 0
    BEGIN
      IF @IsInvalid = 0
      SELECT @Sum = @Sum + @MainSumCC + @ExtraSumCC + @MoreSumCC + @NeglibleSumCC,
             @SumUniSocChargeСС = @SumUniSocChargeСС + @UniSocChargeСС,
             @SumTUniSocChargeССCor = @SumTUniSocChargeССCor + @TUniSocChargeССCor    

      FETCH NEXT FROM Cur INTO @EmpID, @MainSumCC, @ExtraSumCC, @MoreSumCC, @NeglibleSumCC, @UniSocChargeСС, @TUniSocChargeССCor, @IsInvalid
    END

CLOSE Cur
DEALLOCATE Cur

IF (@Sum <= @MinSalary) AND (@Sum <> 0) AND (@Joint = 0)
  SET @IndexUSTLast = @MinSalary * @UniSocChargeRate / 100 / (@SumUniSocChargeСС - @SumTUniSocChargeССCor)  
ELSE
  SET @IndexUSTLast = 1 

/* DEV-3511: Увольнение или прием работника на основное место работы в течение месяца */
IF @IsGivOrDis = 1 
  SET @IndexUSTLast = 1

RETURN
GO