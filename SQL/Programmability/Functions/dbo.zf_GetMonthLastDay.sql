SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE  FUNCTION [dbo].[zf_GetMonthLastDay] (@BDate datetime) 
/* Возвращает дату последнего дня месяца */
RETURNS datetime AS 
BEGIN  
  RETURN DATEADD(MONTH, 1, DATEADD(DAY, 1 - DAY(@BDate), @BDate)) - 1 
END
GO