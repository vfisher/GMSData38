SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_CRJournalGetMissedXMLDocID](@CRID int, @SerialID varchar(50), @FiscalID varchar(50), @XMLDocID bigint, @LastXMLDocID bigint)
AS
/* Возвращает пропущенные номера документов ЭКЛ */
BEGIN
  DECLARE @MaxXMLDocID bigint
  DECLARE @ChID bigint
  DECLARE @CashType int, @BackupCRJournalStartDate datetime

  SELECT TOP 1 @CashType = CashType, @BackupCRJournalStartDate = BackupCRJournalStartDate FROM r_CRS WHERE CRID = @CRID
  SELECT @MaxXMLDocID = ISNULL(MAX(XMLDocID), 0) FROM t_CRJournal WHERE CRID = @CRID AND SerialID = @SerialID AND FiscalID = @FiscalID

  IF @XMLDocID = 0
    SELECT TOP 1 @XMLDocID = ISNULL((NextLocalNum - 1),0)
    FROM t_CashRegInetcheques
    WHERE CRID = @CRID AND FinID = @FiscalID AND DocTime >= @BackupCRJournalStartDate
    ORDER BY NextLocalNum ASC, DocTime ASC option (fast 1)

  DROP TABLE IF EXISTS #tmp
  DROP TABLE IF EXISTS #interval
  DROP TABLE IF EXISTS #t_CRJournal
  DROP TABLE IF EXISTS #XMLDocID

  IF @CashType = 39
    BEGIN
      SELECT m.XMLDocID
	  INTO #XMLDocID
	  FROM t_CRJournal m WITH(NOLOCK)
	  INNER JOIN t_CashRegInetCheques d WITH(NOLOCK) ON d.CrID = m.CRID AND d.FinID = m.FiscalID
	  WHERE m.Data IS NULL AND m.IsFinished = 1 AND m.XMLDocID >= @XMLDocID AND m.CRID = @CRID AND m.FiscalID = @FiscalID AND m.XMLDocID = (d.NextLocalNum - 1)

      DELETE FROM t_CRJournal WHERE CRID = @CRID AND SerialID = @SerialID AND FiscalID = @FiscalID AND XMLDocID IN (SELECT XMLDOCID FROM #XMLDocID)
	END

  CREATE TABLE #tmp (ID bigint IDENTITY (1, 1), dummy bit)

  IF @MaxXMLDocID = 0
    BEGIN
      SELECT ID FROM #tmp
      RETURN
    END

  SELECT * INTO #t_CRJournal FROM t_CRJournal
  WHERE CRID = @CRID AND SerialID = @SerialID AND FiscalID = @FiscalID

  IF NOT EXISTS(SELECT TOP 1 1 FROM t_CRJournal WHERE CRID = @CRID AND SerialID = @SerialID AND FiscalID = @FiscalID AND XMLDocID = 1)
    BEGIN
	  EXEC z_NewChID '#t_CRJournal', @ChID OUTPUT
	  INSERT INTO #t_CRJournal(ChID,CRID,SerialID,FiscalID,[Data],DocTypeID,DocSubtypeID,XMLDocID,DocCode,DocChID,DocTime,IsFinished,InetChequeNum)
	  SELECT @ChID, @CRID, @SerialID, @FiscalID, Null, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 1, Null
	END
  INSERT INTO #tmp (dummy)
  SELECT TOP (@MaxXMLDocID-0+1) 0-1+row_number() over(order by t1.number) as ID
  FROM master..spt_values t1
  CROSS JOIN master..spt_values t2

  DELETE #tmp WHERE ID >= @MaxXMLDocID

 IF @LastXMLDocID <> 0
   DELETE #tmp WHERE ID > @LastXMLDocID

  /*-Вычисляем интервалы-*/
  SELECT t.ID + 1 AS StartInterval, t.NextID - 1 AS FinishInterval INTO #interval
  FROM (
	  SELECT XMLDocID ID, LEAD(XMLDocID) OVER(ORDER BY XMLDocID) AS NextID
	  FROM #t_CRJournal WHERE CRID = @CRID AND SerialID = @SerialID AND FiscalID = @FiscalID AND IsFinished <> 0) t
  WHERE t.ID + 1 <> t.NextID

  /*-Показываем пропущенные ИД-*/
  SELECT ID FROM #tmp t
  INNER JOIN #interval i ON t.ID BETWEEN i.StartInterval AND i.FinishInterval
  WHERE ID >= @XMLDocID
END
GO