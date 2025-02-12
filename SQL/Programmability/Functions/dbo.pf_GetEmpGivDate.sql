SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetEmpGivDate](@Date datetime, @EmpID int, @OurID int)
/* Возвращает дату приема на работу */
RETURNS datetime AS
BEGIN

 DECLARE @tmpDate datetime
 SET @tmpDate = ISNULL((
   SELECT TOP 1 BDate
   FROM r_EmpMPst a
   WHERE OurID = @OurID AND EmpID = @EmpID AND BDate <= @Date AND IsGivDoc = 1 AND NOT EXISTS (SELECT 1 FROM r_EmpMPst WHERE OurID = a.OurID AND EmpID = a.EmpID AND BDate > a.BDate AND BDate <= @Date AND IsDisDoc = 1)
   ORDER BY BDate DESC
                       ), '20790101')
 RETURN @tmpDate
END
GO