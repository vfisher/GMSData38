SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_CheckOnStaffList](@DocDate datetime, @EmpID INT, @OurID int, @SubID int, @PostID int, @BSalary numeric(21,9), @BSalaryQty numeric(21,9))/* Проверяет возможность приема сотрудника на должность в подразделение */RETURNS bit ASBEGIN DECLARE @VacCount numeric(21,9) DECLARE @VacBusy numeric(21,9) SET @VacCount = ISNULL((SELECT TOP 1 VacTotal FROM p_LMem m INNER JOIN p_LMemD d ON m.ChID = d.ChID WHERE OurID = @OurID AND OrderDocDate <= @DocDate AND SubID = @SubID AND PostID = @PostID AND BSalary = @BSalary ORDER BY DocDate DESC), 0) SET @VacBusy = ISNULL((SELECT SUM(SalaryQty) FROM r_EmpMPst WHERE @DocDate BETWEEN BDate AND EDate AND OurID = @OurID AND SubID = @SubID AND PostID = @PostID AND BSalary = @BSalary AND EmpID <> @EmpID), 0) RETURN CASE WHEN ROUND(@VacBusy + @BSalaryQty , 2) > ROUND(@VacCount, 2) THEN 0 ELSE 1 ENDEND
GO
