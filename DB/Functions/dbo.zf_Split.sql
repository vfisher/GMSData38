SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_Split](@text nvarchar(MAX), @delimiter nvarchar(20) = N' ')
/* Разделяет текст по указанному разделителю */
RETURNS @Strings TABLE (Position int IDENTITY(1,1), AValue nvarchar(MAX)) AS 
BEGIN
  DECLARE @index int
  SET @index = -1
  IF @delimiter = N' '
    SET @text = RTRIM(LTRIM(@text))

  WHILE (LEN(@text) > 0) 
    BEGIN
      SET @index = CHARINDEX(@delimiter, @text)
      IF (@index = 0) AND (LEN(@text) > 0) 
        BEGIN  
          INSERT INTO @Strings VALUES (@text)
          BREAK 
        END

      IF (@index > 1) 
        INSERT INTO @Strings VALUES (LEFT(@text, @index - 0))
      SET @text = RIGHT(@text, (LEN(@text) - @index - 1))    
    END
RETURN
END
GO
