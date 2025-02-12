SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_ReplicaCleaner]
AS          
/* Удаляет выполненные транзакции, созданные более определенного количества дней назад */          
BEGIN          
  SET NOCOUNT OFF          
  SET DEADLOCK_PRIORITY LOW          
  SET XACT_ABORT ON /* Необходимо, чтобы при дедлоке процедура вылетела, а не пошла выполнять след. операцию */  

  DECLARE @Sync_MaxDays varchar(50)          
  DECLARE @DocTime datetime          
  DECLARE @ReplicaSubCode int          
  DECLARE @DeletedCount int             
  DECLARE @t TABLE (ReplicaEventID bigint)  

  DECLARE @ERR_MSG nvarchar(4000)
  DECLARE @ERR_SEV int
  DECLARE @ERR_STA int

  SELECT @Sync_MaxDays = ISNULL(dbo.zf_Var('Sync_MaxDays'), ISNULL(dbo.zf_Var('z_SyncMaxDays'), ''))          
  IF @Sync_MaxDays = '' SET @Sync_MaxDays = '14'          
  SET @DocTime = DATEADD(DAY, 0 - CAST(@Sync_MaxDays AS int), GETDATE())          
  /***************************************************************************/
  /*                                 z_ReplicaIn                             */
  BEGIN TRY  

  DECLARE SubCode_Cursor CURSOR LOCAL FAST_FORWARD FOR 
  SELECT ReplicaSubCode          
  FROM z_ReplicaSubs          

  OPEN SubCode_Cursor          

  FETCH NEXT FROM SubCode_Cursor          
  INTO @ReplicaSubCode          

  /* Оставляем последние 10000 входящих по каждой подписке */          
  /* Удаляем записи блоками. В случае возникновения взаимоблокировки не будет отката всех удаленных записей */           
  WHILE @@FETCH_STATUS = 0          
    BEGIN          
      SELECT @DeletedCount = 1 /* dummy */          
      WHILE @DeletedCount > 0                
        BEGIN          
          DELETE FROM z_ReplicaIn          
          WHERE ReplicaSubCode = @ReplicaSubCode AND ReplicaEventID IN            
          (          
             SELECT TOP 5000 ReplicaEventID           
             FROM z_ReplicaIn     
             WHERE Status = 1 AND ReplicaSubCode = @ReplicaSubCode AND DocTime <= @DocTime AND ReplicaEventID NOT IN (           
                   SELECT TOP 10000 ReplicaEventID           
                   FROM z_ReplicaIn
                   WHERE Status = 1 AND ReplicaSubCode = @ReplicaSubCode           
                   ORDER BY ReplicaEventID DESC          
             )                          
          )          
          SELECT @DeletedCount = @@ROWCOUNT          
        END          
      FETCH NEXT FROM SubCode_Cursor          
      INTO @ReplicaSubCode          
    END          

  CLOSE SubCode_Cursor  
  DEALLOCATE SubCode_Cursor          

  END TRY
  BEGIN CATCH
    SELECT @ERR_MSG = ERROR_MESSAGE(),
           @ERR_SEV = ERROR_SEVERITY(),
           @ERR_STA = ERROR_STATE()

    /* На случай LockTimeout чтобы продолжить дальнейшую очистку событий */
    IF Error_Number() <> 1222
      RAISERROR(@ERR_MSG, @ERR_SEV, @ERR_STA) 
  END CATCH;  

  /***************************************************************************/
  /*                                 z_ReplicaOut                            */
  BEGIN TRY    
    IF OBJECT_ID('tempdb..#t') IS NOT NULL
      DROP TABLE #t  
    CREATE TABLE #t(ReplicaEventID bigint PRIMARY KEY)

    /* Выборка занимает около 5% Reads от всего удаления */
    INSERT INTO #t(ReplicaEventID)
    SELECT TOP 200000 ReplicaEventID 
    FROM z_ReplicaOut o WITH (NOLOCK) 
    WHERE     DocTime <= @DocTime 
          AND o.Status = 1
          AND ReplicaEventID NOT IN (SELECT MAX(ReplicaEventID) FROM z_ReplicaOut WITH (NOLOCK) 
                                     GROUP BY ReplicaSubCode)

    WHILE EXISTS(SELECT * FROM #t)
      BEGIN
        WHILE EXISTS(SELECT * FROM #t)
          BEGIN
              DELETE FROM @t
              INSERT INTO @t(replicaeventid)
              SELECT TOP 10000 ReplicaEventID 
              FROM #t
              DELETE FROM z_ReplicaOut WHERE ReplicaEventID IN (SELECT ReplicaEventID FROM @t)
              DELETE FROM #t 
              WHERE ReplicaEventID IN (SELECT ReplicaEventID FROM @t)   
          END

        INSERT INTO #t(ReplicaEventID)
        SELECT TOP 200000 ReplicaEventID 
        FROM z_ReplicaOut o WITH (NOLOCK) 
        WHERE DocTime <= @DocTime 
              AND o.Status = 1
              AND ReplicaEventID NOT IN (SELECT MAX(ReplicaEventID) FROM z_ReplicaOut WITH (NOLOCK) 
                                         GROUP BY ReplicaSubCode )              
      END   
  END TRY
  BEGIN CATCH
    SELECT @ERR_MSG = ERROR_MESSAGE(),
           @ERR_SEV = ERROR_SEVERITY(),
           @ERR_STA = ERROR_STATE()

    /* На случай LockTimeout чтобы продолжить дальнейшую очистку событий */
    IF Error_Number() <> 1222
      RAISERROR(@ERR_MSG, @ERR_SEV, @ERR_STA) 
  END CATCH;  
  /***************************************************************************/

  DELETE FROM z_ReplicaConfigOut          
  WHERE DocTime <= @DocTime AND ReplicaConfigID IS NOT NULL
        AND ReplicaConfigID NOT IN (SELECT ReplicaConfigID FROM z_ReplicaConfigSent WITH(NOLOCK) WHERE Status <> 1)          

  DELETE FROM z_ReplicaConfigIn WHERE DocTime <= @DocTime AND Status = 1          
  DELETE FROM z_ReplicaConfigSent WHERE DocTime <= @DocTime AND Status = 1          
  DELETE FROM z_ReplicaConfigSent WHERE Status = 1 AND ReplicaConfigID NOT IN (SELECT ReplicaConfigID FROM z_ReplicaConfigOut)          

  /***************************************************************************/
  /* Удаление логов */

  DELETE FROM z_ReplicaExchangeLog
  WHERE DocTime < @DocTime And ChID Not In (
    SELECT Max(ChID) 
    FROM z_ReplicaExchangeLog WITH (NOLOCK)
    GROUP BY ReplicaSubCode, PCCode, Mode
  )

END
GO