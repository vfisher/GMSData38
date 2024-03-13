SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_NewDocID](@DocCode int, @TableName varchar(250), @OurID int, @DocID bigint OUTPUT)
/* Возвращает новый номер документа для таблицы */
AS 
BEGIN  
  DECLARE 
    @SQLStr nvarchar(500),
    @Params nvarchar(500),
    @DocIDStart bigint,
    @DocIDEnd bigint

  SELECT @DocIDStart = DocIDStart, @DocIDEnd = DocIDEnd FROM dbo.zf_DocIDRange()

  SELECT @SQLStr = N'SELECT @DocIDOUT = ISNULL(MAX(DocID), @ADocIDStart - 1) + 1 FROM ' + @TableName + ' WITH(XLOCK, HOLDLOCK) WHERE OurID = @AOurID AND DocID BETWEEN @ADocIDStart AND @ADocIDEnd'
  SELECT @Params = N'@DocIDOUT bigint OUTPUT, @AOurID int, @ADocIDStart bigint, @ADocIDEnd bigint'

  EXECUTE sp_executesql @SQLStr, @Params, @DocIDOUT = @DocID OUTPUT, @AOurID = @OurID, @ADocIDStart = @DocIDStart, @ADocIDEnd = @DocIDEnd

  IF @DocID > @DocIDEnd
    BEGIN
      SET @DocID = NULL
      RAISERROR('Новый номер документа для таблицы %s находится вне допустимого диапазона', 18, 1, @TableName)
    END
END
GO
