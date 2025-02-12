SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_ReplicaReplaceFieldsValues](@Fields varchar(MAX) OUTPUT, @Values varchar(MAX) OUTPUT, @FieldsToReplcace varchar(MAX), @ValuesToReplace varchar(MAX), @Delim varchar(200))
AS
/* Возвращает список полей из фильтра и их значений с заменой значений */
BEGIN
  IF (ISNULL(@FieldsToReplcace, '') = '') OR (ISNULL(@ValuesToReplace, '') = '') 
    RETURN

  DECLARE @FieldsCopy varchar(MAX), @ValuesCopy varchar(MAX)
  DECLARE @set_field varchar(255), @set_value varchar(MAX)
  DECLARE @CharIndex int
  DECLARE @NewFields varchar(MAX), @NewValues varchar(MAX) 

  /* проверка на закрывающийся разделитель */
  IF CHARINDEX(@Delim, REVERSE(@Fields)) <> 1
    SET @Fields = @Fields + @Delim   
  IF CHARINDEX(@Delim, REVERSE(@Values)) <> 1
    SET @Values = @Values + @Delim 
  IF CHARINDEX(@Delim, REVERSE(@FieldsToReplcace)) <> 1
    SET @FieldsToReplcace = @FieldsToReplcace + @Delim 
  IF CHARINDEX(@Delim, REVERSE(@ValuesToReplace)) <> 1
    SET @ValuesToReplace = @ValuesToReplace + @Delim 

  SELECT @FieldsCopy = @Fields, @ValuesCopy = @Values, @NewFields = '', @NewValues = ''
  DECLARE @SrcTable TABLE (Field varchar(250), Value varchar(MAX))
  DECLARE @ReplaceTable TABLE (Field varchar(250), Value varchar(MAX)) 

  SET @CharIndex = CHARINDEX(@Delim, @FieldsCopy)  
  WHILE @CharIndex > 0
    BEGIN
      SET @set_field = SUBSTRING(@FieldsCopy, 1, @CharIndex - 1)
      SET @FieldsCopy = SUBSTRING(@FieldsCopy, @CharIndex + LEN(@Delim), LEN(@FieldsCopy))        
      SET @CharIndex = CHARINDEX(@Delim, @ValuesCopy) 
      SET @set_value = SUBSTRING(@ValuesCopy, 1, @CharIndex - 1)
      SET @ValuesCopy = SUBSTRING(@ValuesCopy, @CharIndex + LEN(@Delim), LEN(@ValuesCopy))    
      INSERT INTO @SrcTable VALUES(@set_field, @set_value)
      SET @CharIndex = CHARINDEX(@Delim, @FieldsCopy)  
    END   

  SET @CharIndex = CHARINDEX(@Delim, @FieldsToReplcace)  
  WHILE @CharIndex > 0
    BEGIN
      SET @set_field = SUBSTRING(@FieldsToReplcace, 1, @CharIndex - 1)
      SET @FieldsToReplcace = SUBSTRING(@FieldsToReplcace, @CharIndex + LEN(@Delim), LEN(@FieldsToReplcace))        
      SET @CharIndex = CHARINDEX(@Delim, @ValuesToReplace) 
      SET @set_value = SUBSTRING(@ValuesToReplace, 1, @CharIndex - 1)
      SET @ValuesToReplace = SUBSTRING(@ValuesToReplace, @CharIndex + LEN(@Delim), LEN(@ValuesToReplace))    
      INSERT INTO @ReplaceTable VALUES(@set_field, @set_value)
      SET @CharIndex = CHARINDEX(@Delim, @FieldsToReplcace)
    END  

  DECLARE ReplaceCursor CURSOR FAST_FORWARD FOR
  SELECT m.Field, CASE WHEN d.Value IS NULL THEN m.Value ELSE d.Value END Value 
  FROM @SrcTable m LEFT JOIN @ReplaceTable d ON m.Field = d.Field

  OPEN ReplaceCursor
  FETCH NEXT FROM ReplaceCursor INTO @set_field, @set_value
  WHILE @@FETCH_STATUS = 0
    BEGIN
      SET @NewFields = @NewFields + @set_field + @Delim
      SET @NewValues = @NewValues + @set_value + @Delim
      FETCH NEXT FROM ReplaceCursor INTO @set_field, @set_value
    END
  CLOSE ReplaceCursor
  DEALLOCATE ReplaceCursor

  IF @NewFields <> '' AND @NewValues <> ''
    SELECT @Fields = @NewFields, @Values = @NewValues
END
GO