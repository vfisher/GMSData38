SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_Replica_Del](@ReplicaSubCode int, @TableName varchar(200), @PKs varchar(MAX), @PKValues varchar(MAX), @Version int)
/* Применение изменений репликации таблицы - удаление */
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @Delim varchar(3)
  DECLARE @sql_expr varchar(MAX), @pk_expr varchar (MAX)

  SET @Delim = '^;^'  
  SELECT @pk_expr = dbo.zf_ReplicaGetFieldsValuesExpression(@PKs, @PKValues, @Delim, ' AND ')

  SET @sql_expr = 'DELETE FROM ' + @TableName +  ' WHERE ' + @pk_expr  
  EXEC (@sql_expr)
END
GO
