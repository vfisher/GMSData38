SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetBookingExecutorClientsCount](@ExecutorID int, @BTime smalldatetime, @ETime smalldatetime, @ExcludeChID bigint, @ExcludeSrcPosID int)
/* Возвращает количество заявок исполнителя в указанный период времени */
RETURNS int AS
BEGIN
  DECLARE @Count int

  SELECT @Count = COUNT(*) 
  FROM t_BookingD
  WHERE dbo.tf_GetBookingExecutorID(ChID, SrcPosID) = @ExecutorID AND ForRet = 0 AND
    ((BTime BETWEEN @BTime AND DATEADD(mi, -1, @ETime)) OR (ETime BETWEEN DATEADD(mi, 1, @BTime) AND @ETime))
    AND NOT (ChID = @ExcludeChID AND SrcPosID = @ExcludeSrcPosID) 

RETURN @Count
END
GO
