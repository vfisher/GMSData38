SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetSickPayPrc] (@Date datetime, @EmpID int, @OurID int)
/* Возвращает процент оплаты по больничным c учетом льгот c 01.01.2015г. */
RETURNS numeric(21,9) AS
BEGIN
DECLARE  @GivDate datetime,
         @SenYears int,
         @Prc numeric(21, 9)
SET @GivDate = dbo.pf_GetEmpGivDate(@Date, @EmpID, @OurID)
IF @GivDate = '20790101' RETURN 0
SET @SenYears = (SELECT InsurSenYears FROM dbo.pf_GetInsurSen(@Date, @EmpID, @OurID))

IF @SenYears < 3  SET @Prc = 50
ELSE
  IF (@SenYears >= 3) AND (@SenYears < 5) SET @Prc = 60
  ELSE
    IF (@SenYears >= 5) AND (@SenYears < 8) SET @Prc = 70
    ELSE SET @Prc = 100

SELECT TOP 1 @Prc = SickPayPrc  FROM r_EmpMP p JOIN r_Prevs r ON p.PrevID = r.PrevID WHERE OurID = @OurID AND EmpID = @EmpID AND @Date BETWEEN BDate AND EDate AND SickPayPrc > @Prc ORDER BY SickPayPrc DESC
RETURN @Prc
END
GO