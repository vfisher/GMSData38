SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_TripIsAdvOverdue](@DocCode int, @ChID bigint, @AdvDate datetime)
/* Возвращает 1 если нарушен срок сдачи авансового отчета */
RETURNS bit AS
BEGIN
  DECLARE @tmpDate datetime, @days integer
  SELECT @tmpDate = m.TripEDate FROM  p_ETrpsE m, z_DocLinks l WHERE l.ParentDocCode = 15024 AND m.ParentChID = l.ParentChID AND l.ChildDocCode = @DocCode AND l.ChildChID = @ChID
  /* посчитать количество рабочих дней с момента окончания командировки до сдачи авансового отчета */
  SET @days = 0
  WHILE @tmpDate < @AdvDate
    BEGIN
      SET @tmpDate = DATEADD(d, 1, @tmpDate)
      IF ((DATEPART(dw, @tmpDate)+@@DATEFIRST - 1)%7 IN (0, 6)) OR EXISTS(SELECT 1 FROM r_Holidays WHERE HolidayDate = @tmpDate) CONTINUE
      SET @days = @days + 1
    END
  IF @days > 3 RETURN 1
  RETURN 0
END
GO
