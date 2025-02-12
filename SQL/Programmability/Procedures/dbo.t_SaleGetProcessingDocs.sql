SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGetProcessingDocs](@CRID int, @RetryTime datetime, @RetryPeriod int, @AllDocs bit)
/* Формирует список документов для отправки на процессинг */
AS
BEGIN
/* Выбираем: Только напечатанные(22), продажные перед возвратными(order), в пределах периода отправки и по текущему РРО */
/*
Если указан @RetryPeriod, то @RetryTime не обрабатывается.
Если @AllDocs = 1, то периоды и время не учитывается (отправка всех документов)
Если @CRID = -1, то не учитывается и ЭККА документа (отправка по всем РРО)
*/
  DECLARE @DocTime datetime

  IF @RetryPeriod > 0
  SET @DocTime = DATEADD(HOUR, -@RetryPeriod, GetDate())
  ELSE
  BEGIN
  SET @DocTime = DATEADD(day, 0, DATEDIFF(day, 0, GetDate())) +
  DATEADD(day, 0 - DATEDIFF(day, 0, @RetryTime), @RetryTime)
  END

  SELECT DocCode, ChID, DocID, GUID, StockID, CRID, OperID, RRN, CardInfo, DocDate, UserName, UserPassword, Status, OperName
  FROM (
    SELECT z.DocCode, z.ChID, s.DocID, s.GUID, s.StockID, s.CRID, s.OperID, z.RRN, z.CardInfo, s.DocCreateTime AS DocDate, c.UserName, c.UserPassword, z.Status, OperName
    FROM z_LogProcessings z
    INNER JOIN t_Sale s ON z.ChID = s.ChID AND z.DocCode = 11035 AND (s.DocCreateTime >= @DocTime OR @AllDocs = 1) AND s.StateCode IN (22, 23) AND (@CRID = -1 OR s.CRID = @CRID)
    INNER JOIN r_WPs c ON c.CRID = s.CRID
    INNER JOIN r_Opers o ON o.OperID = s.OperID
    WHERE z.STATUS IN (0, 95, 96, 97, 98, 99)

    UNION ALL

    SELECT z.DocCode, z.ChID, r.DocID, r.GUID, r.StockID, r.CRID, r.OperID, z.RRN, z.CardInfo, r.DocTime AS DocDate, c.UserName, c.UserPassword, z.Status, OperName
    FROM z_LogProcessings z
    INNER JOIN t_CRRet r ON z.ChID = r.ChID AND z.DocCode = 11004 AND (r.DocTime >= @DocTime OR @AllDocs = 1) AND r.StateCode IN (22, 23) AND (@CRID = -1 OR r.CRID = @CRID)
    INNER JOIN r_WPs c ON c.CRID = r.CRID
    INNER JOIN r_Opers o ON o.OperID = r.OperID
    WHERE z.STATUS IN (0, 95, 96, 97, 98, 99)
  ) a
  ORDER BY DocCode DESC
END
GO