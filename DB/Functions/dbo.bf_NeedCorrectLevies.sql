SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[bf_NeedCorrectLevies](@DocCode int, @ChID bigint)
/* Указывает необходимо ли пересчитывать сборы в документе */
RETURNS bit
BEGIN
  DECLARE @ChequeCompID int, @DocCompID int, @Result bit
  SELECT @ChequeCompID = CAST(dbo.zf_Var('t_ChequeCompID') AS int), @Result = 0 

  IF @DocCode = 14111 SELECT @DocCompID = CompID FROM b_Inv WHERE ChID = @ChID
  ELSE IF @DocCode = 14112 SELECT @DocCompID = CompID FROM b_Exp WHERE ChID = @ChID
  ELSE IF @DocCode = 14103 SELECT @DocCompID = CompID FROM b_Ret WHERE ChID = @ChID

  IF @ChequeCompID = @DocCompID
    SELECT @Result = 1
  RETURN @Result
END
GO
