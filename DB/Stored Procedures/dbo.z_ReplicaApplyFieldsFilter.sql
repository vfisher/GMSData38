SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_ReplicaApplyFieldsFilter](@Fields varchar(MAX) OUTPUT, @Values varchar(MAX) OUTPUT, @FieldsFilter varchar(MAX), @Delim varchar(200))
AS
/* Возвращает список полей из фильтра и их значений */
/* EXEC z_ReplicaApplyFieldsFilter @Fields OUTPUT, @Values OUTPUT, @FieldsFilter, '^;^' */
BEGIN
  IF ISNULL(@FieldsFilter, '') = '' 
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
  IF CHARINDEX(@Delim, REVERSE(@FieldsFilter)) <> 1
    SET @FieldsFilter = @FieldsFilter + @Delim 

  SELECT @FieldsCopy = @Fields, @ValuesCopy = @Values, @NewFields = '', @NewValues = ''   
  SET @CharIndex = CHARINDEX(@Delim, @FieldsCopy)  
  WHILE @CharIndex > 0
    BEGIN
      SET @set_field = SUBSTRING(@FieldsCopy, 1, @CharIndex - 1)
      SET @FieldsCopy = SUBSTRING(@FieldsCopy, @CharIndex + LEN(@Delim), LEN(@FieldsCopy))  

      SET @CharIndex = CHARINDEX(@Delim, @ValuesCopy) 
      SET @set_value = SUBSTRING(@ValuesCopy, 1, @CharIndex - 1)
      SET @ValuesCopy = SUBSTRING(@ValuesCopy, @CharIndex + LEN(@Delim), LEN(@ValuesCopy))    
      SET @CharIndex = CHARINDEX(@Delim, @FieldsCopy)

      IF CHARINDEX(@Delim + @set_field + @Delim, @Delim + @FieldsFilter) > 0
        BEGIN
          SET @NewFields = @NewFields + @set_field + @Delim
          SET @NewValues = @NewValues + @set_value + @Delim
        END      
    END   
  IF @NewFields <> '' AND @NewValues <> ''
    SELECT @Fields = @NewFields, @Values = @NewValues
END
GO
