SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  FUNCTION [dbo].[zf_IsValidDocState] (@DocCode int, @StateCode int) 
/* Допустим ли статус для документа */
RETURNS BIT AS 
BEGIN 
  RETURN (CASE WHEN NOT EXISTS (SELECT TOP 1 1 FROM r_StateDocs WHERE DocCode = @DocCode) OR EXISTS (SELECT TOP 1 1 FROM r_StateDocs WHERE StateCode = @StateCode AND DocCode = @DocCode) THEN 1 ELSE 0 END)
END 
GO
