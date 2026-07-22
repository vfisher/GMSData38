SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[kso_ContextLoad] @wpid VARCHAR(50)
AS
BEGIN
  SELECT wpid, json_data
  FROM  
    dbo.kso_sessions
  WHERE  
    wpid = @wpid
END
GO