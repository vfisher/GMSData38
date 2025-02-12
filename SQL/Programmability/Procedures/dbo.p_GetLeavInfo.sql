SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_GetLeavInfo] (@EDate datetime, @EmpID int, @OurID int, @NLeaveDays int OUTPUT, @BDate datetime OUTPUT)
/* Возвращает начало и конец рабочего года сотрудника, количество дней отпуска за этот период 
   с учетом уже использованного основного отпуска */ 
AS
BEGIN 
  DECLARE @s varchar(20)  
  SET @NLeaveDays = 0 
  IF @BDate <= '1/1/1900' 
    BEGIN  
      SET @BDate = dbo.pf_GetEmpGivDate(@EDate, @EmpID, @OurID)  
      SET @s = CAST(DATEPART(m, @BDate) AS varchar) + '/' + CAST(DATEPART(d, @BDate) AS varchar) + '/'
      IF @s + CAST(DATEPART(yy, @EDate) AS varchar) <= @EDate SET @BDate = @s + CAST(DATEPART(yy, @EDate) AS varchar)  
      ELSE SET @BDate = @s + CAST(DATEPART(yy, @EDate) - 1 AS varchar)    
    END   
  SET @NLeaveDays = ROUND((24 / (366.0 - dbo.pf_GetHolidaysCount(@BDate, @EDate, 1))) * DATEDIFF(d, @BDate, @EDate), 0) - dbo.pf_GetLeavDaysCount(@BDate, @EDate,  @EmpID, @OurID, 0) 
END
GO