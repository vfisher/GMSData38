SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetActualStaffList](@DocDate datetime, @OurID int)
/* Формирует штатное расписание по кадровому состоянию на дату */
RETURNS @out TABLE (SubID int, DepID INT, PostID int, VacOcc numeric(21,9), BSalary numeric(21,9), BExtraSalary numeric(21,9))
BEGIN
  INSERT INTO @out (SubID, DepID, PostID, VacOcc, BSalary, BExtraSalary)
  SELECT SubID, DepID, PostID, SUM(SalaryQty) AS VacOcc, MIN(BSalary) AS BSalary, 0 BExtraSalary
  FROM r_EmpMPst WHERE OurID = @OurID AND @DocDate BETWEEN BDate AND EDate AND IsDisDoc = 0
  GROUP BY SubID, DepID, PostID,  BSalary
  RETURN
END
GO
