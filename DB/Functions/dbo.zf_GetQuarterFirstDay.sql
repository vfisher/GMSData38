SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetQuarterFirstDay](@Date datetime)
/* Возвращает дату первого дня квартала */
RETURNS datetime
AS
BEGIN
  RETURN CONVERT(datetime,CONVERT(varchar(2),(MONTH(@Date)-1)/3*3+1)+'/1/'+CONVERT(char(4),YEAR(@Date)),101)
END
GO
