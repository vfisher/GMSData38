SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_Split](@text NVARCHAR(MAX), @delimiter NVARCHAR(20) = N' ')
/* Разделяет текст по указанному разделителю */
RETURNS @Strings TABLE (Position INT IDENTITY(1,1), AValue NVARCHAR(MAX)) AS 
BEGIN
  DECLARE @index INT
  DECLARE @value NVARCHAR(MAX)
  
  IF @delimiter = N' '
    SET @text = LTRIM(RTRIM(@text))

  WHILE LEN(@text) > 0 
    BEGIN
      SET @index = CHARINDEX(@delimiter, @text)
 
      IF @index = 0
      BEGIN
        INSERT INTO @Strings (AValue)
        VALUES (@text)
        BREAK
      END

      SET @value = LEFT(@text, @index - 1)
  
      IF LEN(@value) > 0
        BEGIN
            INSERT INTO @Strings (AValue)
            VALUES (@value)
        END
       
      SET @text = SUBSTRING(@text,@index + LEN(@delimiter),LEN(@text))  
    END
RETURN
END
GO