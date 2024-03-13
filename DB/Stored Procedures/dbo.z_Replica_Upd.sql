SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_Replica_Upd](@ReplicaSubCode int, @TableName varchar(200), @Fields varchar(MAX), @Values varchar(MAX), @PKs varchar(MAX), @PKValues varchar(MAX), @Version int)
/* Применение изменений репликации таблицы - изменение */
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @Delim varchar(3)
  DECLARE @sql_expr varchar(MAX), @set_expr varchar(MAX), @pk_expr varchar (MAX)

  SET @Delim = '^;^'
  SELECT @set_expr = dbo.zf_ReplicaGetFieldsValuesExpression(@Fields, @Values, @Delim, ', ')
  SELECT @pk_expr = dbo.zf_ReplicaGetFieldsValuesExpression(@PKs, @PKValues, @Delim, ' AND ')

  SET @sql_expr = 'UPDATE ' + @TableName + ' SET ' + @set_expr + ' WHERE ' + @pk_expr  
  EXEC (@sql_expr)
END
GO
