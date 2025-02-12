SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_ReplicaOnExchangeComplete](@xml XML)
AS
BEGIN
  DECLARE @ReplicaSubCode int
  DECLARE @PCCode int
  DECLARE @Mode int
  DECLARE @DocTime datetime
  DECLARE @StartTime datetime  
  DECLARE @MaxExchangedEventID bigint 
  DECLARE @LastProcessedEventID bigint
  DECLARE @LastEventCount bigint
  DECLARE @LastSessionBytesExchanged bigint
  DECLARE @Result int
  DECLARE @Msg varchar(max)

  SELECT 
      @ReplicaSubCode = n.value('ReplicaSubCode[1]', 'int') 
     ,@PCCode = n.value('PCCode[1]', 'int') 
     ,@Mode = n.value('Mode[1]', 'int')
     ,@DocTime = n.value('DocTime[1]', 'datetime')
     ,@MaxExchangedEventID = n.value('MaxExchangedEventID[1]', 'bigint')
     ,@LastProcessedEventID = n.value('LastProcessedEventID[1]', 'bigint') 
     ,@LastEventCount = n.value('LastEventCount[1]', 'bigint')
     ,@LastSessionBytesExchanged = n.value('LastSessionBytesExchanged[1]', 'bigint')
     ,@Result = n.value('Result[1]', 'int')
     ,@Msg = n.value('Msg[1]', 'varchar(max)')
     ,@StartTime = n.value('StartTime[1]', 'datetime')
  FROM @XML.nodes('sync') AS t(n)

  /* Сохранение события обмена в общий лог */
  INSERT INTO z_ReplicaExchangeLog(
    ReplicaSubCode, 
    PCCode, 
    Mode, 
    ExchangeStartTime,
    DocTime, 
    MaxExchangedEventID,
    LastProcessedEventID,
    LastEventCount,
    LastSessionBytesExchanged, 
    Result,
    Msg
  )
  VALUES(
    @ReplicaSubCode, 
    @PCCode, 
    @Mode, 
    @StartTime,
    @DocTime, 
    @MaxExchangedEventID,
    @LastProcessedEventID,
    @LastEventCount, 
    @LastSessionBytesExchanged, 
    @Result,
    @Msg
  )

MERGE z_ReplicaState AS TARGET
USING (
    Select 
    @ReplicaSubCode ReplicaSubCode, 
    @PCCode PCCode, 
    @Mode Mode, 
    @DocTime DocTime, 
    @MaxExchangedEventID MaxExchangedEventID,
    @LastProcessedEventID LastProcessedEventID,
    @LastEventCount LastEventCount, 
    @LastSessionBytesExchanged LastSessionBytesExchanged, 
    @Result Result,
    @Msg Msg
) AS SOURCE 
ON (TARGET.ReplicaSubCode = SOURCE.ReplicaSubCode AND TARGET.PCCode = SOURCE.PCCode) 
WHEN MATCHED THEN 
  UPDATE SET  
    Target.DocTime = Source.DocTime,
    Target.LastFullSync = CASE WHEN Source.LastEventCount = 0 AND Source.Mode In (0, 1) AND Source.Result = 1 THEN Source.DocTime ELSE Target.LastFullSync END,
    Target.MaxExchangedEventID = Source.MaxExchangedEventID,
    Target.LastProcessedEventID = Source.LastProcessedEventID,
    Target.LastEventCount = Source.LastEventCount,
    Target.LastSessionBytesExchanged = Source.LastSessionBytesExchanged,
    Target.LastResult = Source.Result,
    Target.LastErrorMsg = Source.Msg
WHEN NOT MATCHED BY TARGET THEN 
  INSERT (
    ReplicaSubCode,
    PCCode,
    IsPublisher,
    DocTime,
    LastFullSync,
    MaxExchangedEventID,
    LastProcessedEventID,
    LastEventCount,
    LastSessionBytesExchanged,
    LastResult,
    LastErrorMsg
  ) 
  VALUES (
    Source.ReplicaSubCode,
    Source.PCCode,
    CASE WHEN Source.Mode IN (0, 4) THEN 1 ELSE 0 END,
    Source.DocTime,
        CASE WHEN Source.LastEventCount = 0 AND Source.Mode In (0, 1) AND Source.Result = 1 THEN Source.DocTime ELSE NULL END,
    Source.MaxExchangedEventID,
    Source.LastProcessedEventID,
    Source.LastEventCount,
    Source.LastSessionBytesExchanged,
    Source.Result,
    Source.Msg
  );
END
GO