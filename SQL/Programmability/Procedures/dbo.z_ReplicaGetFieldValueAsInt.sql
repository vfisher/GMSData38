SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_ReplicaGetFieldValueAsInt](@Fields varchar(MAX), @Values varchar(MAX), @Delim varchar(200), @FieldName varchar(200), @Value int OUTPUT)
/* Возвращает значение поля в виде int */
AS
BEGIN
  DECLARE @sql NVARCHAR(2000)
  SELECT @sql = 'SELECT @ValueOUT = ' + dbo.zf_ReplicaGetField(@Fields, @Values, @Delim, @FieldName)
  EXEC sp_executesql @sql, N'@ValueOUT int OUTPUT', @ValueOUT=@Value OUTPUT 
END
GO