SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_GetSalaryAddToMin]
/* Возвращает доплату до уровня минимальной заработной платы (Документ Заработная плата: Начисление) */
(
@OurID int, @EmpID int, @SubID int, @DepID int , @DocDate datetime, @SalaryAddToMin numeric(21, 9) OUTPUT
)
AS
SET NOCOUNT ON
DECLARE  @MinSalary numeric(21, 9), @appSalaryAddToMinPayIDList varchar(250), @IsInvalid bit, @IsPensioner bit, @BSalary numeric(21, 9), @SalaryQty numeric(21, 9),
@DetSubID INT, @DetDepID INT

SET @SalaryAddToMin = 0
SELECT TOP 1 @DetSubID = SubID, @DetDepID = DepID FROM r_EmpMPst WHERE OurID = @OurID AND EmpID = @EmpID AND IsDisDoc = 0 AND BDate <= @DocDate ORDER BY BDate DESC

IF (@DetSubID = @SubID) AND (@DetDepID = @DepID)
  BEGIN

  SET @MinSalary = ISNULL((SELECT d.EExp FROM z_FRUDFR m, z_FRUDFRD d
                           WHERE m.UDFID = d.UDFID AND m.UDFName = 'НЗ_ЗК_МинимальнаяЗП' AND @DocDate BETWEEN d.BDate AND d.EDate),0)

  SET @SalaryQty = ISNULL((SELECT TOP 1 SalaryQty FROM r_EmpMPst WHERE OurID = @OurID AND EmpID = @EmpID AND IsDisDoc = 0 AND BDate <= @DocDate ORDER BY BDate DESC),0)                           
  SET @BSalary = ISNULL((SELECT TOP 1 BSalary FROM r_EmpMPst WHERE OurID = @OurID AND EmpID = @EmpID AND IsDisDoc = 0 AND BDate <= @DocDate ORDER BY BDate DESC),0)

  SET @appSalaryAddToMinPayIDList = (SELECT VarValue FROM z_Vars WHERE VarName = 'p_SalaryAddToMinPayIDList') 
  SET @IsInvalid = ISNULL((SELECT TOP 1 IsInvalid from r_EmpMP WHERE OurID = @OurID AND EmpID = @EmpID AND @DocDate between BDate AND EDate),0)
  SET @IsPensioner = ISNULL((SELECT TOP 1 IsPensioner from r_EmpMP WHERE OurID = @OurID AND EmpID = @EmpID AND @DocDate between BDate AND EDate),0)

  SET @SalaryAddToMin =
  (SELECT SUM(ISNULL(DocDD.SumCC,0))
  FROM p_Lrec Doc
  INNER JOIN p_LrecD DocD ON Doc.ChID = DocD.ChID
  INNER JOIN p_LrecDD DocDD ON DocD.AChID = DocDD.AChID
  WHERE Doc.DocDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate) AND
    Doc.OurID = @OurID AND DocD.EmpID = @EmpID AND Doc.LRecType = 0 AND DocDD.PayTypeID IN (SELECT * FROM [zf_FilterToTable] (@appSalaryAddToMinPayIDList)))

  IF (@BSalary * @SalaryQty) >= (@MinSalary * @SalaryQty)
    SET @SalaryAddToMin = 0
  ELSE
    BEGIN 
    IF (@SalaryAddToMin < @MinSalary * (SELECT dbo.pf_GetIndexIndexationWorkHours(@DocDate, @OurID, @EmpID))) AND (@IsInvalid = 0) AND (@IsPensioner = 0)
      SET @SalaryAddToMin = @MinSalary * (SELECT dbo.pf_GetIndexIndexationWorkHours(@DocDate, @OurID, @EmpID)) - @SalaryAddToMin
    ELSE
      SET @SalaryAddToMin = 0
    IF @SalaryAddToMin < 0
      SET @SalaryAddToMin = 0 
    END
  END
RETURN
GO
