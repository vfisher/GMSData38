SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetQuarterLastDay](@Date datetime)
/* Возвращает дату последнего дня квартала */
RETURNS datetime
AS
BEGIN
 RETURN (DATEADD(MONTH,3,CONVERT(datetime,CONVERT(varchar(2),(MONTH(@Date)-1)/3*3+1)+'/1/'+CONVERT(char(4),YEAR(@Date)),101))-1)
END
GO