SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_CanChangeDoc](@DocCode int, @ChID bigint, @StateCode int) 
/* Возможно ли редактирование докумета */
RETURNS BIT AS 
BEGIN 
  IF (SELECT TOP 1 CanChangeDoc FROM r_States WHERE StateCode = @StateCode) = 0
    BEGIN
      IF NOT EXISTS(SELECT TOP 1 1 FROM r_StateDocsChange WHERE UserCode = dbo.zf_GetUserCode() AND StateCode = @StateCode) RETURN 0
    END
  ELSE
    BEGIN
      IF EXISTS(SELECT TOP 1 1 FROM r_StateDocsChange WHERE UserCode = dbo.zf_GetUserCode() AND StateCode = @StateCode) RETURN 0
    END
  RETURN 1    
END
GO