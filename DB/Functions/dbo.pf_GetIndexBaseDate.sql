SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetIndexBaseDate](@DocDate DATETIME, @EmpID INT, @OurID INT, @SubID INT, @PostID INT, @BSalary numeric(21,9), @BSalaryQty numeric(21,9))
/* Возвращает базовый месяц индексации */
RETURNS datetime AS
BEGIN
  DECLARE @BDocDate datetime
  /* Проверка на возможность приема сотрудника на должность в подразделение */	
  IF (SELECT dbo.pf_CheckOnStaffList(@DocDate, @EmpID, @OurID, @SubID, @PostID, @BSalary, @BSalaryQty)) = 1 

  SET @BDocDate = (
    SELECT TOP 1 m.DocDate 
    FROM p_LMem m,
         p_LMemD d
    WHERE m.ChID = d.ChID AND OurID = @OurID AND d.PostID = @PostID AND d.SubID = @SubID AND d.BSalary = @BSalary AND m.DocDate <= @DocDate 
    ORDER BY DocDate ASC	
                   )
 RETURN @BDocDate
END
GO
