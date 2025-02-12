SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_GetSalaryIndexation] (@BDate  datetime, @EDate  datetime, @Index numeric(21, 9) OUTPUT)
/* Возвращает индекс потребительских цен базового месяца @BDate в месяце @EDate */ 
AS
BEGIN 
  DECLARE @BDateInt int   
  SET @BDateInt = YEAR(@BDate) * 100 + MONTH(@BDate)

  DECLARE @EDateInt int   
  SET @EDate = DATEADD(m,-1, @EDate)
  SET @EDateInt = YEAR(@EDate) * 100 + MONTH(@EDate)

  DECLARE @ind numeric (21, 9)  
  DECLARE @CPI numeric (21, 9)  
  DECLARE @ZCPI numeric (21, 9) 
  DECLARE @ICPI numeric (21, 9) 
  DECLARE @b bit 

  SET @ind = 100 
  SET @ZCPI = 100 
  SET @ICPI = 100 
  SET @b = 0

  DECLARE cur CURSOR  FAST_FORWARD  FOR SELECT CPI FROM p_CPIs WHERE  YearID * 100 + MonthID > @BDateInt AND YearID * 100 + MonthID < @EDateInt  ORDER BY YearID, MonthID 

  OPEN cur
  FETCH NEXT FROM cur INTO @CPI 
  WHILE @@FETCH_STATUS = 0
    BEGIN    
      SET @ZCPI = ROUND(@ZCPI * @CPI / 100, 1)
      SET @ICPI = ROUND(@ICPI * @CPI / 100, 1)
      IF @ICPI > 101  
        BEGIN  
          SET @ind = ROUND(@ind * @ICPI / 100, 1)   
          SET @ICPI = 100  
          SET @b = 1
        END
      FETCH NEXT FROM cur INTO @CPI 
    END
  CLOSE cur
  DEALLOCATE cur

  IF @b = 1 SET @Index = @ind - 100  
  ELSE SET @Index = 0 

END
GO