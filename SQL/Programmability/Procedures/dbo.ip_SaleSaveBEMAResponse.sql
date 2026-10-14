SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ip_SaleSaveBEMAResponse](@DocCode int, @ChID bigint, @ParamsIN nvarchar(max))
AS
BEGIN
  IF @DocCode <> 1011 RETURN

  /*
  Структура JSONData
  {
  "t": {} - объект с данными, которые пишет ТК для своей работы. Временная инфа от ПЦ и т.п. 
  "i": {} - объект с данными для внедренцев, внутреннюю структуру определяете сами под свои нужды
  }
  */

  DECLARE @JSONData nvarchar(max)
  SELECT @JSONData = ISNULL(JSONData, '{}')
  FROM t_SaleTemp
  WHERE Chid = @ChID

  IF JSON_QUERY(@JSONData, '$.t') IS NULL
    SET @JSONData = JSON_MODIFY(@JSONData, '$.t', JSON_QUERY('{}'));
  IF JSON_QUERY(@JSONData, '$.t.bema') IS NULL
    SET @JSONData = JSON_MODIFY(@JSONData, '$.t.bema', JSON_QUERY('{}'));
  --IF JSON_QUERY(@JSONData, '$.t.bema.data') IS NULL
  SET @JSONData = JSON_MODIFY(@JSONData, '$.t.bema.data', JSON_QUERY(@ParamsIN, '$.data'));

  update t_SaleTemp Set JSONData = @JSONData where ChID = @ChID
END
GO