SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetCashRegInetSessionOffline] (@CRID int)
/* Возвращает параметры нулевого чека: DocTime, OfflineSessionID, OfflineSeed, NextLocalNum, OfflineNextLocalNum, OfflineLastHash, OfflineSessionDuration, OfflineSessionsMonthlyDuration, IsTesting, ShiftOpenedOperName, SubjectKeyID, LastChequeDocTime, LastDocCode, LastInetChequeNum */
AS
  BEGIN
  DECLARE @DocTime DATETIME, @OfflineSeed VARCHAR(250), @OfflineSessionId VARCHAR(250), @OfflineNextLocalNum INT,
          @NextLocalNum INT, @DocHash VARCHAR(250),
          @LastChequeDocTime DATETIME, @LastDocCode INT, @LastInetChequeNum VARCHAR(250), @LastChID BIGINT,
          @OfflineSessionsMonthlyDuration BIGINT, @OfflineSessionDuration BIGINT,
          @LastOfflineSessionDateTime DATETIME,
          @IsTesting BIT, @ExtraInfo VARCHAR(max), @ShiftOpenedOperName VARCHAR(250), @SubjectKeyID VARCHAR(250),
          @BDate DATETIME, @EDate DATETIME, @NextLocalNumBeginOfflineSession INT

  DROP TABLE IF EXISTS #BeginOfflineSession
  DROP TABLE IF EXISTS #OfflineSessionDurationTable
  CREATE TABLE #BeginOfflineSession (ID int IDENTITY (1, 1), CRID INT, DocCode INT, DocTime DATETIME, OfflineSeed VARCHAR(250), OfflineSessionId VARCHAR(250), NextLocalNum INT)
  CREATE TABLE #OfflineSessionDurationTable (ID int IDENTITY (1, 1), OfflineSeed VARCHAR(250), OfflineSessionId VARCHAR(250), BeginOfflineSessionDateTime DATETIME, EndOfflineSessionDateTime DATETIME, OfflineSessionDuration BIGINT)

  SELECT TOP 1 @LastChequeDocTime = DocTime, @LastDocCode = DocCode, @LastInetChequeNum = InetChequeNum, @LastChID = ChID 
  FROM t_CashRegInetCheques WHERE CRID = @CRID And [Status] in (0,1,3) ORDER BY DocTime DESC, NextLocalNum DESC

  SET @LastChequeDocTime = ISNULL(@LastChequeDocTime,CAST('1900-01-01T00:00:00' AS datetime))
  SET @LastDocCode= ISNULL(@LastDocCode ,0)
  SET @LastInetChequeNum = ISNULL(@LastInetChequeNum, '-1')
  SET @LastChID = ISNULL(@LastChID, '-1')

  SET @BDate = dbo.zf_GetMonthFirstDay(dbo.zf_GetDate(GETDATE()))
  SET @EDate = DATEADD(ss,-1,DATEADD(d,1,dbo.zf_GetMonthLastDay(dbo.zf_GetDate(GETDATE()))))

   /* Выборка всех документов открытий и закрытий офлайн сессий за текущий период */
  INSERT INTO #BeginOfflineSession(CRID, DocCode, DocTime, OfflineSeed, OfflineSessionId, NextLocalNum)
  SELECT
    CRID,
    DocCode,
    DocTime,
    OfflineSeed,
    OfflineSessionId,
    NextLocalNum
  FROM t_CashRegInetCheques WITH(NOLOCK)
  WHERE CRID = @CRID AND @EDate >= DocTime AND @BDate <= DocTime AND DocCode IN (4,3)
  And [Status] in (0,1,3)
  ORDER BY NextLocalNum ASC 

  /* Для переходящего документа закрытия офлайн сессии, например, последний зарегистрированный чек офлайн 01.12.2022 в 09:00,
   *  сессия закрыта в 12:00. Тогда учитываем время офлайна с 00:00 по 09:00 */
  /* !!! Налоговая не учитывает сессию переходящего месяца, а именно только полные сессии за текущий месяц (проведено исследование c 31.12.2022 по 01.01.2023)
  SET @NextLocalNumBeginOfflineSession = ISNULL((SELECT TOP 1 NextLocalNum 
                                                 FROM #BeginOfflineSession 
                                                 WHERE ID = 1 AND DocCode = 3),0)

  IF @NextLocalNumBeginOfflineSession <> 0
    BEGIN
  	  INSERT INTO #BeginOfflineSession(CRID, DocCode, DocTime, OfflineSeed, OfflineSessionId, NextLocalNum)
  	  SELECT TOP 1 CRID, 4, CASE WHEN DocTime > @BDate THEN @BDate ELSE NULL END, OfflineSeed, OfflineSessionId, 0
  	  FROM t_CashRegInetCheques WITH(NOLOCK)
  	  WHERE CRID = @CRID AND NextLocalNum < @NextLocalNumBeginOfflineSession AND DocTime >= @BDate
  	  ORDER BY NextLocalNum ASC 
    END

  IF NOT EXISTS (SELECT TOP 1 1 FROM #BeginOfflineSession)
    BEGIN
      INSERT INTO #BeginOfflineSession(CRID, DocCode, DocTime, OfflineSeed, OfflineSessionId, NextLocalNum)
  	  SELECT TOP 1 CRID, 4, CASE WHEN DocTime > @BDate THEN @BDate ELSE NULL END, OfflineSeed, OfflineSessionId, 0
      FROM t_CashRegInetCheques WITH(NOLOCK)
      WHERE CRID = @CRID AND DocTime >= @BDate
      ORDER BY NextLocalNum ASC
    END
  */

  SELECT TOP 1 @DocTime = DocTime, @IsTesting = IsTesting
  FROM t_CashRegInetCheques
  WHERE CRID = @CRID AND DocCode IN (1,2) AND [Status] IN (0,1,3)
  ORDER BY DocTime DESC

  IF NOT EXISTS (SELECT TOP 1 1 FROM t_CashRegInetCheques WITH (NOLOCK) WHERE CRID = @CRID AND DocCode IN (3) And [Status] IN (0,1,3))
    SELECT TOP 1 @OfflineSeed = OfflineSeed, @OfflineSessionId = OfflineSessionId
    FROM t_CashRegInetCheques
    WHERE CRID = @CRID AND DocCode IN (1) AND [Status] IN (0,1,3)
    ORDER BY DocTime DESC
  ELSE
    SELECT TOP 1 @OfflineSeed = OfflineSeed, @OfflineSessionId = OfflineSessionId
    FROM t_CashRegInetCheques
    WHERE CRID = @CRID /*AND DocCode IN (3,4)*/ AND [Status] IN (0,1,3)
    ORDER BY DocTime DESC
  /* ExtraInfo: Begin */
  SET @ExtraInfo = ISNULL(
    (SELECT TOP 1 ExtraInfo
    FROM t_CashRegInetCheques 
    WHERE CRID = @CRID AND DocCode IN (1) AND DocTime <= @DocTime ORDER BY DocTime DESC), '')

  If @ExtraInfo <> ''
    BEGIN
      SET @ShiftOpenedOperName = ISNULL(JSON_VALUE(@ExtraInfo, '$.OperName'), '')
      SET @SubjectKeyID = ISNULL(JSON_VALUE(@ExtraInfo, '$.SubjectKeyId'),'')
    END

  /* ExtraInfo: End */

  SET @NextLocalNum =  ISNULL((SELECT TOP 1 NextLocalNum FROM t_CashRegInetCheques
  WHERE OfflineSessionId = @OfflineSessionId AND OfflineSeed = @OfflineSeed AND CRID = @CRID
  And [Status] in (0,1,3)
  ORDER BY NextLocalNum DESC),0)

  SET @OfflineNextLocalNum =  ISNULL((SELECT TOP 1 OfflineNextLocalNum FROM t_CashRegInetCheques
  WHERE OfflineSessionId = @OfflineSessionId AND OfflineSeed = @OfflineSeed AND CRID = @CRID
  And [Status] in (0,1,3)
  ORDER BY NextLocalNum DESC),0)

  SET @DocHash =  ISNULL((SELECT TOP 1 DocHash FROM t_CashRegInetCheques
  WHERE OfflineSessionId = @OfflineSessionId AND OfflineSeed = @OfflineSeed AND CRID = @CRID
  And [Status] in (0,1,3)
  ORDER BY OfflineNextLocalNum DESC),'')

  SET @LastOfflineSessionDateTime = ISNULL((SELECT MAX(DocTime) FROM t_CashRegInetCheques
                                    WHERE CRID = @CRID AND [Status] in (0,1,3)
                                    AND IsOffline = 1 AND DocCode = 3), '1900-01-01T00:00:00')

  INSERT #OfflineSessionDurationTable(OfflineSeed, OfflineSessionId,
         BeginOfflineSessionDateTime, EndOfflineSessionDateTime, OfflineSessionDuration)
  SELECT
     m.OfflineSeed,
     m.OfflineSessionId,
     m.DocTime AS BeginOfflineSessionDateTime,
     CASE WHEN d.DocTime > @LastOfflineSessionDateTime THEN GETDATE() ELSE d.DocTime END AS EndOfflineSessionDateTime,
     ISNULL(DATEDIFF(second,m.DocTime,CASE WHEN d.DocTime > @LastOfflineSessionDateTime THEN GETDATE() ELSE d.DocTime END),0) AS OfflineSessionDuration

   FROM #BeginOfflineSession m 
     OUTER APPLY(
     	SELECT TOP 1 DocTime FROM t_CashRegInetCheques WITH(NOLOCK) 
     	WHERE CRID = m.CRID AND IsOffline = 1 AND DocCode <> 3 AND DocTime >= m.DocTime 
     	  AND OfflineSeed = m.OfflineSeed AND OfflineSessionId = m.OfflineSessionId 
     	ORDER BY DocTime desc
     ) d
   WHERE m.CRID = @CRID AND m.DocCode = 4 AND m.DocTime IS NOT NULL 
   ORDER BY m.NextLocalNum

  SET @OfflineSessionDuration = ISNULL((SELECT SUM(OfflineSessionDuration) FROM #OfflineSessionDurationTable WHERE OfflineSeed = @OfflineSeed AND OfflineSessionId = @OfflineSessionId),0) / 60

  SET @OfflineSessionsMonthlyDuration = ISNULL((SELECT SUM(ROUND((CAST(OfflineSessionDuration AS NUMERIC(21,9)) / 60),0)) FROM #OfflineSessionDurationTable),0)

  SELECT 
    ISNULL(@DocTime, CAST('1900-01-01T00:00:00' AS datetime)) AS DocTime,
    ISNULL(@OfflineSeed, '-1') AS OfflineSeed,
    ISNULL(@OfflineSessionId, '-1') AS OfflineSessionId,
    @OfflineNextLocalNum AS OfflineNextLocalNum,
    @NextLocalNum AS NextLocalNum,
    @DocHash AS DocHash,
    @OfflineSessionDuration AS OfflineSessionDuration,
    @OfflineSessionsMonthlyDuration AS OfflineSessionsMonthlyDuration,
    ISNULL(@IsTesting,0) AS IsTesting,
    ISNULL(@ShiftOpenedOperName,'') AS ShiftOpenedOperName,
    ISNULL(@SubjectKeyID, '') AS SubjectKeyID,
    @LastChequeDocTime AS LastChequeDocTime,
    @LastDocCode AS LastDocCode,
    @LastInetChequeNum AS LastInetChequeNum,
    @LastChID AS LastChID
END
GO