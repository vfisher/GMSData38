SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetBookingResourceClientsCount](@ResourceID int, @BTime smalldatetime, @ETime smalldatetime, @ExcludeChID bigint, @ExcludeSrcPosID int)
/* Возвращает количество заявок задействующих данный ресурс в указанный период времени */
RETURNS int AS
BEGIN
  DECLARE @Count int
  SELECT @Count = COUNT(*) 
  FROM t_BookingD
  WHERE ResourceID = @ResourceID AND ForRet = 0 AND
    ((BTime BETWEEN @BTime AND DATEADD(mi, -1, @ETime)) OR (ETime BETWEEN DATEADD(mi, 1, @BTime) AND @ETime))
    AND NOT (ChID = @ExcludeChID AND SrcPosID = @ExcludeSrcPosID) 

RETURN @Count
END
GO