SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_ReplicaFieldsContain](@SeekField varchar(MAX), @AllFields varchar(MAX), @Delim varchar(200))
/* Проверяет, содержится ли искомое поле в списке полей */
RETURNS bit
AS
BEGIN
  DECLARE @Result bit
  IF CHARINDEX(@SeekField + @Delim, @AllFields + @Delim) > 0
    SET @Result = 1
  ELSE
    SET @Result = 0
  RETURN @Result
END
GO
