SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create FUNCTION [dbo].[zf_ReplicaGetFieldAsBigint](@Fields varchar(MAX), @Values varchar(MAX), @Delim varchar(200), @FieldName varchar(200))
RETURNS bigint
/* Возвращает значение поля из данных синхронизации */
BEGIN
  DECLARE @set_field varchar(255), @set_value varchar(max)
  DECLARE @CharIndex int
  DECLARE @sql_expr varchar(MAX), @set_expr varchar(MAX), @pk_expr varchar (MAX)

  /* проверка на закрывающийся разделитель */
  IF CHARINDEX(@Delim, REVERSE(@Fields)) <> 1
    SET @Fields = @Fields + @Delim   
  IF CHARINDEX(@Delim, REVERSE(@Values)) <> 1
    SET @Values = @Values + @Delim 
  SET @set_expr = ''
  SET @CharIndex = CHARINDEX(@Delim, @Fields)  
  WHILE @CharIndex > 0
    BEGIN
      SET @set_field = SUBSTRING(@Fields, 1, @CharIndex - 1)
      SET @Fields = SUBSTRING(@Fields, @CharIndex + LEN(@Delim), LEN(@Fields))  
      SET @CharIndex = CHARINDEX(@Delim, @Values)       

      IF UPPER(@set_field) = UPPER(@FieldName)
          RETURN cast(SUBSTRING(@Values, 1, @CharIndex - 1) as bigint)

      SET @Values = SUBSTRING(@Values, @CharIndex + LEN(@Delim), LEN(@Values))
      SET @CharIndex = CHARINDEX(@Delim, @Fields)  
    END   

  RETURN  NULL
END
GO