SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_ReplicaGetFieldsValuesExpression](@Fields varchar(MAX), @Values varchar(MAX), @Delim varchar(200), @JointText varchar(200))
RETURNS VARCHAR(MAX)
/* Возвращает выражение полей и их значений для подстановки в SQL-запрос */
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
      SET @set_value = SUBSTRING(@Values, 1, @CharIndex - 1)
      SET @Values = SUBSTRING(@Values, @CharIndex + LEN(@Delim), LEN(@Values))

      IF @set_expr <> '' SET @set_expr = @set_expr + @JointText
      SET @set_expr = @set_expr + @set_field + ' = ' + @set_value

      SET @CharIndex = CHARINDEX(@Delim, @Fields)  
    END   

  RETURN @set_expr
END
GO