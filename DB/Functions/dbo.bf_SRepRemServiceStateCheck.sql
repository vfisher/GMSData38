SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[bf_SRepRemServiceStateCheck] (@CheckState int , @AssID int , @Date smalldatetime)
/* ОС выведено из эксплуатации на дату значения @CheckState: 2 - ОС законсервировано, 3 - ОС расконсервировано */
RETURNS bigint AS
BEGIN
  DECLARE @ChID bigint, @RepType INT
  IF @CheckState = 2
  SELECT TOP 1 @ChID = ChID, @RepType = RepType
  FROM    b_SRep
  WHERE   DocDate < @Date AND AssID = @AssID AND RepType = 2
  ORDER BY DocDate DESC, ChID DESC

  IF @CheckState = 3
  SELECT TOP 1 @ChID = ChID, @RepType = RepType
  FROM    b_SRep
  WHERE   DocDate < @Date AND AssID = @AssID AND RepType = 3
  ORDER BY DocDate DESC, ChID DESC

  IF @RepType = @CheckState
    RETURN @ChID
  RETURN NULL
END
GO
