SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_NewPPID](@ProdID int)
/* Возвращает номер для новой партии (Бизнес) */
RETURNS int AS
BEGIN
  DECLARE @PPStart int, @PPEnd int, @PPID int
  SELECT @PPStart = PPIDStart, @PPEnd = PPIDEnd FROM dbo.zf_PPIDRange()

  IF @PPStart = @PPEnd
    SELECT @PPID = ISNULL(MAX(PPID) + 1, @PPStart) FROM t_pInP WHERE ProdID = @ProdID
  ELSE
    BEGIN
      SELECT @PPID = ISNULL(MAX(PPID) + 1, @PPStart) FROM t_pInP WHERE ProdID = @ProdID AND PPID BETWEEN @PPStart AND @PPEnd
      IF @PPID > @PPEnd SET @PPID = NULL
    END
  RETURN @PPID
END
GO
