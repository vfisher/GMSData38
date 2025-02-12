SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGetProcessingOPs](@CRID int, @Operation tinyint, @RetryTime datetime, @RetryPeriod int, @AllDocs bit)
/* Формирует список операций для отправки на процессинг */
AS
BEGIN
  /*
    Если указан @RetryPeriod, то @RetryTime не обрабатывается.
    Если @AllDocs = 1, то периоды и время не учитывается (отправка всех документов)
    Если @CRID = -1, то не учитывается и РРО документа (отправка по всем РРО)
  */

  DECLARE @DocTime datetime

  IF @RetryPeriod > 0
    SET @DocTime = DATEADD(HOUR, -@RetryPeriod, GetDate())
  ELSE
    BEGIN
     SET @DocTime =  DATEADD(day, 0, DATEDIFF(day, 0, GetDate())) +
     DATEADD(day, 0 - DATEDIFF(day, 0, @RetryTime), @RetryTime)
    END

  SELECT DocCode, ChID, RRN, CardInfo, DocTime, Operation, Note1, Note2, Note3, UserName, UserPassword, Status
  FROM (
    SELECT z.DocCode, z.ChID, z.RRN, z.CardInfo, s.DocTime, Operation, Note1, Note2, Note3, w.UserName, w.UserPassword, z.Status
    FROM z_LogProcessings z
    INNER JOIN z_LogProcessingOPs s ON z.ChID = s.ChID AND z.DocCode = 1030 AND (s.DocTime >= @DocTime OR @AllDocs = 1) AND (@CRID = -1 OR s.CRID = @CRID)
    INNER JOIN r_WPs w ON w.CRID = s.CRID    
    WHERE z.STATUS = 0 AND (s.Operation = @Operation OR @Operation IS NULL OR @Operation = 0)
       ) a
  ORDER BY DocTime DESC
END
GO