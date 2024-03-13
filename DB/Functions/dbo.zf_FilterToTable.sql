SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_FilterToTable](@Filter varchar(1000))
RETURNS @out TABLE (AValue int) AS
BEGIN
  DECLARE @i int, @ABegVal int, @AEndVal int, @APos int, @ADashInd int, @ANumber varchar(25)
  SELECT @Filter = REPLACE(REPLACE(@Filter, ',', ';'), ' ', '') + ';'
  SET @i = 0
  SET @APos = 0
  WHILE @i <= LEN(@Filter)
    BEGIN
      IF SUBSTRING(@Filter, @i, 1)= ';'
        BEGIN
          SELECT @ANumber = SUBSTRING(@Filter, @APos, @i - @APos)
          SELECT @ADashInd = CHARINDEX('-', @ANumber) 
          IF @ADashInd <> 0
            BEGIN
              SELECT @ABegVal = CONVERT(int, (SUBSTRING(@ANumber, 0, @ADashInd)))
              SELECT @AEndVal = CONVERT(int, (SUBSTRING(@ANumber, @ADashInd + 1, LEN(@ANumber) - @ADashInd)))
              WHILE  @ABegVal <= @AEndVal
                BEGIN
                  IF NOT EXISTS (SELECT TOP 1 1 FROM @out WHERE AValue = @ABegVal) INSERT @out VALUES(@ABegVal)
                  SET @ABegVal = @ABegVal + 1
                END 
            END
          ELSE
            IF NOT EXISTS (SELECT TOP 1 1 FROM @out WHERE AValue = CONVERT(int, @ANumber)) INSERT @out VALUES(CONVERT(int, @ANumber))
          SET @APos = @i + 1
        END
      SET @i = @i + 1   
    END
  RETURN 
END
GO
