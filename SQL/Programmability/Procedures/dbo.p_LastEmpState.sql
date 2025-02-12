SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_LastEmpState](@OurID INT, @EmpID INT, @DocDate DATETIME, @LastDate datetime OUTPUT)
/* Возвращает последнее состояние сотрудника на дату */
AS
BEGIN 
  SELECT @LastDate =
    ISNULL((
      SELECT TOP 1 EDate  
      FROM r_EmpMPst 
      WHERE OurID = @OurID AND EmpID = @EmpID AND IsDisDoc <> 1 AND @DocDate BETWEEN BDate AND EDate),
    (SELECT TOP 1 EDate 
     FROM r_EmpMPst   
     WHERE OurID = @OurID AND EmpID = @EmpID AND IsDisDoc <> 1 AND @DocDate <= dbo.zf_GetMonthLastDay(EDate)))
END
GO