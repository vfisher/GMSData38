SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  FUNCTION [dbo].[pf_GetLeavDaysCount] (@BDate datetime, @EDate datetime, @EmpID int, @OurID int, @LeavType int)
/* Количество дней отпуска в указанный период */
RETURNS int AS
BEGIN
  RETURN ISNULL((SELECT SUM(DATEDIFF(day,
                                     CASE WHEN @BDate <= d.BDate THEN d.BDate ELSE @BDate END,
                                     CASE WHEN @EDate <= d.EDate THEN @EDate ELSE d.EDate END
                                    ) + 1)
                 FROM p_ELeav m JOIN p_ELeavD d ON m.ChID = d.ChID
                 WHERE d.LeavType = @LeavType AND d.EmpID = @EmpID AND m.OurID = @OurID AND
                       ((BDate BETWEEN @BDate AND @EDate)
                       OR (EDate BETWEEN @BDate AND @EDate)
                       OR (BDate < @BDate AND EDate > @EDate))
                ), 0)
END
GO
