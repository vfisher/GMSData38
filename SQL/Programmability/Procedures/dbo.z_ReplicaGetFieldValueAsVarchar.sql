SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_ReplicaGetFieldValueAsVarchar](@Fields varchar(MAX), @Values varchar(MAX), @Delim varchar(200), @FieldName varchar(200), @Value varchar(MAX) OUTPUT)
/* Возвращает значение поля в виде varchar(MAX) */
AS
BEGIN
  DECLARE @sql NVARCHAR(MAX)
  SELECT @sql = 'SELECT @ValueOUT = CAST(' + dbo.zf_ReplicaGetField(@Fields, @Values, @Delim, @FieldName) + ' AS Varchar(MAX))'
  EXEC sp_executesql @sql, N'@ValueOUT varchar(max) OUTPUT', @ValueOUT=@Value OUTPUT 
END
GO