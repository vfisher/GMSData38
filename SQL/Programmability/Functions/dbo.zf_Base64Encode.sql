SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_Base64Encode](@Input VARBINARY(MAX))
RETURNS VARCHAR(MAX)
BEGIN
  RETURN CAST(N'' as xml).value('xs:base64Binary(sql:variable("@Input"))', 'VARCHAR(max)')
END
GO