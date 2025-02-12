SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_Replica_Ins](@ReplicaSubCode int, @TableName varchar(200), @Fields varchar(MAX), @Values varchar(MAX), @Version int)
/* Применение изменений репликации таблицы - добавление */
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @sql_expr varchar(MAX)
  SET @sql_expr = 'INSERT INTO ' + @TableName + '(' + REPLACE(@Fields, '^;^', ',') + ') VALUES(' + REPLACE(@Values, '^;^', ',') + ')'
  EXEC (@sql_expr)
END
GO