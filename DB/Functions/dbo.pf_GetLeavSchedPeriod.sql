SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetLeavSchedPeriod](@DocName VARCHAR(8000), @DocDate datetime, @EmpID int, @OurID int, @LeavType int)
/* Возвращает период за который берется отпуск, количество дней отпуска по указанному коду типа отпуска */
RETURNS @tmpLeavSchedPeriod TABLE (AgeBDate datetime, AgeEDate datetime, LeavDays int)
AS
BEGIN
  DECLARE @tmpBDate datetime
  SET @tmpBDate = dbo.pf_GetEmpGivDate(@DocDate, @EmpID, @OurID)

  IF @DocName = dbo.zf_Translate('Отпуск: Лимиты по видам')
  BEGIN
    INSERT INTO @tmpLeavSchedPeriod
    SELECT
      CASE 
        WHEN @LeavType IN (11,12,13) THEN @tmpBDate 
        WHEN @LeavType IN (43,44,45,46,47) THEN CAST(CAST(YEAR(@DocDate) AS VARCHAR(4)) + '0101' AS DATETIME)  
      END AgeBDate,
      CASE
        WHEN @LeavType IN (11,12,13) THEN DATEADD(m,12,@tmpBDate) - 1 
        WHEN @LeavType IN (43,44,45,46,47) THEN CAST(CAST(YEAR(@DocDate) AS VARCHAR(4)) + '1231' AS DATETIME)  
      END AgeEDate, 
      CASE 
        WHEN @LeavType IN (11) THEN 24 
        WHEN @LeavType IN (43,44,45,46) THEN 10
        WHEN @LeavType IN (47) THEN 16
     END LeavDays
  END
 ELSE
  BEGIN 
    INSERT INTO @tmpLeavSchedPeriod
    SELECT
      CASE 
        WHEN @LeavType IN (11,12,13) THEN @tmpBDate 
        WHEN @LeavType IN (43,44,45,46,47,51,52,53,54,55,56,57,58,59) THEN CAST(CAST(YEAR(@DocDate) AS VARCHAR(4)) + '0101' AS DATETIME)
        ELSE CAST('19010101' AS DATETIME)  
      END AgeBDate,
      CASE
        WHEN @LeavType IN (11,12,13) THEN DATEADD(m,12,@tmpBDate) - 1 
        WHEN @LeavType IN (43,44,45,46,47,51,52,53,54,55,56,57,58,59) THEN CAST(CAST(YEAR(@DocDate) AS VARCHAR(4)) + '1231' AS DATETIME)
        ELSE CAST('19010101' AS DATETIME)
      END AgeEDate, 
      CASE 
        WHEN @LeavType IN (11) THEN 24 
        WHEN @LeavType IN (43,44,45,46,56) THEN 10
        WHEN @LeavType IN (47) THEN 16
        WHEN @LeavType IN (51,59) THEN 15
        WHEN @LeavType IN (52,53,55) THEN 30
        WHEN @LeavType IN (54) THEN 60
        WHEN @LeavType IN (57) THEN 14
        WHEN @LeavType IN (58) THEN 7
        ELSE 0
     END LeavDays  
  END 
RETURN
END

GO
