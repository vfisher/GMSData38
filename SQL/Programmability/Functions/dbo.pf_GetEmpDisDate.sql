SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetEmpDisDate](@Date datetime, @EmpID int, @OurID int)
/* Возвращает дату увольнения */
RETURNS datetime AS
BEGIN
 RETURN ISNULL((SELECT TOP 1 BDate FROM r_EmpMPst WHERE OurID = @OurID AND EmpID = @EmpID AND BDate >= @Date AND IsDisDoc = 1 ORDER BY BDate DESC),'20790101')
END
GO