SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_NewChID](@TableName varchar(250), @ChID bigint OUTPUT)
/* Возвращает новый код регистрации для таблицы */
AS 
BEGIN  
  DECLARE 
    @SQLStr nvarchar(500),
    @Params nvarchar(500),
    @ChIDStart bigint,
    @ChIDEnd bigint

  SELECT @ChIDStart = ChStart, @ChIDEnd = ChEnd FROM dbo.zf_ChIDRange()

  SELECT @SQLStr = N'SELECT @ChIDOUT = ISNULL(MAX(ChID), @AChIDStart - 1) + 1 FROM ' + @TableName + ' WITH(XLOCK, HOLDLOCK) WHERE ChID BETWEEN @AChIDStart AND @AChIDEnd'
  SELECT @Params = N'@ChIDOUT bigint OUTPUT, @AChIDStart bigint, @AChIDEnd bigint'

  EXECUTE sp_executesql @SQLStr, @Params, @ChIDOUT = @ChID OUTPUT, @AChIDStart = @ChIDStart, @AChIDEnd = @ChIDEnd

  IF @ChID > @ChIDEnd
    BEGIN
      SET @ChID = NULL
      BEGIN

      DECLARE @Error_msg1 varchar(2000) = dbo.zf_Translate('Новый код регистрации для таблицы %s находится вне допустимого диапазона')

      RAISERROR(@Error_msg1, 18, 1, @TableName)
      END

    END
END

GO
