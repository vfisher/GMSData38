SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_CanChangeState] (@DocCode int, @ChID bigint, @StateCodeFrom int, @StateCodeTo int) 
/* Возможно ли изменение статуса */
RETURNS BIT AS 
BEGIN 
  IF @StateCodeFrom = @StateCodeTo RETURN 1

  /* Может ли документ находиться в указанном статусе */
  IF dbo.zf_IsValidDocState(@DocCode, @StateCodeTo) = 0 RETURN 0

  /* Разрешен ли переход между указанными статусами */  
  DECLARE @StateRuleCode int
  SELECT TOP 1 @StateRuleCode = StateRuleCode FROM r_StateRules WHERE StateCodeFrom = @StateCodeFrom AND StateCodeTo = @StateCodeTo
  IF @StateRuleCode IS NULL RETURN 0

  /* Разрешен ли переход между указанными статусами текущему пользователю */  
  IF (SELECT TOP 1 DenyUsers FROM r_StateRules WHERE StateRuleCode = @StateRuleCode) = 1
    BEGIN
      IF NOT EXISTS(SELECT TOP 1 1 FROM r_StateRuleUsers WHERE UserCode = dbo.zf_GetUserCode() AND StateRuleCode = @StateRuleCode) RETURN 0
    END
  ELSE
    BEGIN
      IF EXISTS(SELECT TOP 1 1 FROM r_StateRuleUsers WHERE UserCode = dbo.zf_GetUserCode() AND StateRuleCode = @StateRuleCode) RETURN 0
    END
  RETURN 1    
END
GO
