SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_ReplicaIncludeField](@Fields varchar(MAX) OUTPUT, @Values varchar(MAX) OUTPUT, @Field varchar(MAX), @Value varchar(MAX), @Delim varchar(200))
AS
/* Добавляет поле и его значение. Существование поле не проверяется */
BEGIN
  IF ISNULL(@Field, '') = '' 
    RETURN

  /* проверка на закрывающийся разделитель */
  IF CHARINDEX(@Delim, REVERSE(@Fields)) <> 1
    SET @Fields = @Fields + @Delim   
  IF CHARINDEX(@Delim, REVERSE(@Values)) <> 1
    SET @Values = @Values + @Delim 

   SET @Fields = @Fields + @Field + @Delim      
   SET @Values = @Values + @Value + @Delim         
END
GO