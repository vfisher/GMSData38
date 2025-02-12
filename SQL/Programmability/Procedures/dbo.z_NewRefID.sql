SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_NewRefID] (@TableName varchar(250), @FieldName varchar(250), @RefID int OUTPUT)
/* Возвращает новый код справочника для таблицы */
AS
BEGIN
  DECLARE
    @SQLStr nvarchar(500),
    @Params nvarchar(500),
    @RefID_Start int,
    @RefID_End int
/* @FieldName должно иметь тип, в который поместится @RefID_End, т.е. int или больше */

  SELECT @RefID_Start = RefID_Start, @RefID_End = RefID_End FROM dbo.zf_RefIDRange()

  SELECT @SQLStr = N'SELECT @RefIDOUT = ISNULL(MAX('+@FieldName+'), @ARefID_Start - 1) + 1 FROM ' + @TableName + ' WITH(XLOCK, HOLDLOCK) WHERE '+@FieldName+' BETWEEN @ARefID_Start AND @ARefID_End'
  SELECT @Params = N'@RefIDOUT int OUTPUT, @ARefID_Start int, @ARefID_End int'

  EXECUTE sp_executesql @SQLStr, @Params, @RefIDOUT = @RefID OUTPUT, @ARefID_Start = @RefID_Start, @ARefID_End = @RefID_End

  IF @RefID > @RefID_End
    BEGIN
      SET @RefID = NULL
      BEGIN

      DECLARE @Error_msg1 varchar(2000) = dbo.zf_Translate('Новый код справочника(%s) для таблицы %s находится вне допустимого диапазона(%d-%d)')

      RAISERROR(@Error_msg1, 18, 1, @FieldName, @TableName, @RefID_Start, @RefID_End)
      END

    END
END
GO