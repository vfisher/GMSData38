SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[bf_SRepRemServiceAge] (@AssID int , @Date smalldatetime)
/* Возвращает количество месяцев когда ОС было законсервировано */
RETURNS int AS
BEGIN
  DECLARE @Now datetime, @res int 
  SELECT @Now = dbo.zf_GetDate(Now) FROM vz_Now

  SELECT @res = ISNULL(

  (SELECT SUM(DATEDIFF(MONTH, DocDate, ISNULL(DocDate2, @Now)))
  FROM (
  SELECT
  CASE 
    WHEN (RepType = 2 AND DocDate = dbo.zf_GetMonthFirstDay(DocDate)) OR RepType = 3 THEN DocDate
    ELSE DATEADD(DAY, 1, dbo.zf_GetMonthLastDay(DocDate))
  END DocDate,
ISNULL(
  (
    SELECT TOP 1
    CASE
      WHEN (RepType = 2 AND DocDate = dbo.zf_GetMonthFirstDay(DocDate)) OR RepType = 3 THEN DocDate
      ELSE DATEADD(DAY, 1, dbo.zf_GetMonthLastDay(DocDate))
    END
    FROM b_SRep
    WHERE AssID = m1.AssID AND DocDate >= m1.DocDate AND DocDate < @Date AND RepType = 3
    ORDER BY DocDate
  ), @Date) DocDate2
  FROM b_SRep m1
  WHERE m1.RepType = 2 AND DocDate < @Date AND m1.AssID = @AssID) t1), 0)  

  RETURN @res
END
GO