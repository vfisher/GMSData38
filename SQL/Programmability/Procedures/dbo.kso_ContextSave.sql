SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[kso_ContextSave] @wpid INT, @json VARCHAR(4000)
AS
BEGIN
  UPDATE kso_sessions SET json_data = @json, updated = GETDATE() WHERE wpid = @wpid 
  IF @@ROWCOUNT = 0 
    INSERT INTO kso_sessions (wpid, json_data) VALUES (@wpid, @json)
END

GO