SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetSalaryIndexation](@BDate datetime, @EDate datetime)
/* Возвращает индекс потребительских цен базового месяца @BDate в месяце @EDate */
RETURNS numeric(21, 9) AS
BEGIN
  DECLARE @BDateInt int
  DECLARE @EDateInt int
  SET @BDateInt = YEAR(@BDate) * 100 + MONTH(@BDate)
  SET @EDate = DATEADD(m,-1, @EDate)
  SET @EDateInt = YEAR(@EDate) * 100 + MONTH(@EDate)

  DECLARE @ind numeric (21, 9)
  DECLARE @CPI numeric (21, 9), @YearID int
  DECLARE @ICPI numeric (21, 9), @AICPI numeric (21, 9)
  DECLARE @b bit
  SET @ind = 100
  SET @ICPI = 100
  SET @b = 0
  DECLARE cur CURSOR FAST_FORWARD FOR
  SELECT CPI, YearID * 100 + MonthID
  FROM p_CPIs
  WHERE YearID * 100 + MonthID > @BDateInt AND YearID * 100 + MonthID < @EDateInt
  ORDER BY YearID, MonthID

  OPEN cur
  FETCH NEXT FROM cur INTO @CPI, @YearID
  WHILE @@FETCH_STATUS = 0
    BEGIN
      SET @ICPI = @ICPI * @CPI / 100
        IF @YearID > 201512     
        SET @AICPI = 103
      ELSE 
        SET @AICPI = 101

      IF @ICPI > @AICPI
        BEGIN
          SET @ind = @ind * ROUND(@ICPI,1) / 100
          SET @ICPI = 100
          SET @b = 1
        END

      FETCH NEXT FROM cur INTO @CPI, @YearID 
    END
  CLOSE cur
  DEALLOCATE cur
  RETURN CASE @b WHEN 1 THEN ROUND(@ind - 100, 1) ELSE 0 END
END
GO