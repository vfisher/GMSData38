SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[z_ReplicaGetTriggerInfo](@PublisherCode int, @UseWasChanged bit)
as begin

DECLARE @TableCode int
DECLARE @SyncAUFields bit

DECLARE @Replica TABLE(ReplicaPubCode INT, Flds VARCHAR(Max))
DECLARE @ReplicaPubs TABLE(ReplicaPubCode INT)
DECLARE @ReplicaPubCode int
DECLARE @s VARCHAR(MAX), @fielddef VARCHAR(MAX)

CREATE TABLE #ReplicaTriggerCache
(tablecode int,
                  [ReplicaPubCode] int,
                  [ReplicaPubName] varchar(200),
                  [Flds] varchar(max),
                  [EFilterExp] varchar(max),
                  [LFilterExp] varchar(max),
                  [Cnt] int,
                  [FilterCnt] int,
                  SyncAUFields bit,
                  MainReplicaPubCode int, 
                  DestPCCode int)


DECLARE ReplicaMainCur CURSOR LOCAL FAST_FORWARD FOR

SELECT distinct t.TableCode, t.SyncAUFields
FROM z_ReplicaTables a WITH (NOLOCK)  
JOIN z_Tables t WITH (NOLOCK) ON t.TableCode = a.TableCode 
JOIN z_ReplicaPubs p WITH (NOLOCK) ON a.ReplicaPubCode = p.ReplicaPubCode 
WHERE GenTriggers = 1 AND (p.ReplicaPubCode IN (SELECT ReplicaPubCode FROM z_ReplicaSubs WITH (NOLOCK) WHERE PublisherCode = @PublisherCode) Or 
                           p.ReplicaPubCode IN (SELECT ReplicaPubCode FROM z_ReplicaPubs WITH (NOLOCK) WHERE MainReplicaPubCode IN (SELECT ReplicaPubCode FROM z_ReplicaSubs WITH (NOLOCK) WHERE PublisherCode = @PublisherCode)))
AND ((@UseWasChanged = 0) or (@UseWasChanged = 1 and a.WasChanged = 1))

OPEN ReplicaMainCur
FETCH NEXT FROM ReplicaMainCur INTO @TableCode, @SyncAUFields
WHILE @@FETCH_STATUS = 0
  BEGIN

    INSERT INTO @ReplicaPubs(ReplicaPubCode)
    SELECT DISTINCT t.ReplicaPubCode
    FROM z_ReplicaTables t WITH (NOLOCK)
    JOIN z_ReplicaPubs p WITH (NOLOCK) ON t.ReplicaPubCode = p.ReplicaPubCode
    WHERE p.GenTriggers = 1 And TableCode = @TableCode AND (t.ReplicaPubCode IN (SELECT ReplicaPubCode FROM z_ReplicaSubs WITH (NOLOCK) WHERE PublisherCode = @PublisherCode) OR 
                                                            t.ReplicaPubCode IN (SELECT ReplicaPubCode FROM z_ReplicaPubs WITH (NOLOCK) WHERE MainReplicaPubCode IN 
                                                                       (SELECT ReplicaPubCode FROM z_ReplicaSubs WITH (NOLOCK) WHERE PublisherCode = @PublisherCode)))         
    DECLARE ReplicaCur CURSOR LOCAL FAST_FORWARD FOR
    SELECT ReplicaPubCode FROM @ReplicaPubs

    OPEN ReplicaCur
    FETCH NEXT FROM ReplicaCur INTO @ReplicaPubCode
    WHILE @@FETCH_STATUS = 0
      BEGIN

        IF EXISTS(SELECT * FROM z_ReplicaFields WHERE ReplicaPubCode = @ReplicaPubCode AND TableCode = @TableCode)
          DECLARE Cur CURSOR LOCAL FAST_FORWARD FOR
          SELECT UPPER(f.FieldName) + ';^;' + UPPER(f.SQLTypeName) + ';^;' + CAST(f.Required AS VARCHAR(10)) + ';^;' + ISNULL(r.EExp, '')
          FROM vz_Fields f WITH (NOLOCK)
        INNER JOIN z_ReplicaFields rf ON f.TableCode = rf.TableCode AND f.FieldName = rf.FieldName
          LEFT JOIN z_ReplicaReplace r ON rf.ReplicaPubCode = r.ReplicaPubCode AND f.FieldName = r.FieldName AND f.TableCode = r.TableCode
          WHERE rf.ReplicaPubCode = @ReplicaPubCode AND COLUMNPROPERTY(OBJECT_ID(f.TableName), f.FieldName, 'IsComputed') = 0 AND rf.TableCode = @TableCode
          ORDER BY f.FieldPosID
        ELSE
          DECLARE Cur CURSOR LOCAL FAST_FORWARD FOR
          SELECT UPPER(f.FieldName) + ';^;' + UPPER(f.SQLTypeName) + ';^;' + CAST(f.Required AS VARCHAR(10)) + ';^;' + ISNULL(r.EExp, '')
          FROM vz_Fields f WITH (NOLOCK)
          LEFT JOIN z_ReplicaReplace r ON r.ReplicaPubCode = @ReplicaPubCode AND f.FieldName = r.FieldName AND f.TableCode = r.TableCode
          WHERE f.TableCode = @TableCode AND COLUMNPROPERTY(OBJECT_ID(f.TableName), f.FieldName, 'IsComputed') = 0
          ORDER BY f.FieldPosID

        OPEN Cur
        FETCH NEXT FROM Cur INTO @s
        SET @fielddef = ''
        WHILE @@FETCH_STATUS = 0
        BEGIN
          SET @fielddef = @fielddef + ',' + @s
          FETCH NEXT FROM Cur INTO @s
        END
        CLOSE Cur
        DEALLOCATE Cur

        INSERT INTO @Replica(ReplicaPubCode, Flds)
        VALUES(@ReplicaPubCode, @fielddef)

        FETCH NEXT FROM ReplicaCur INTO @ReplicaPubCode  
      END
    CLOSE ReplicaCur
    DEALLOCATE ReplicaCur

    INSERT INTO @Replica (ReplicaPubCode, Flds)
    SELECT ReplicaPubCode, NULL AS Flds 
    FROM z_ReplicaTables WITH (NOLOCK)
    WHERE TableCode = @TableCode AND ReplicaPubCode NOT IN (SELECT ReplicaPubCode FROM @Replica)
          AND ReplicaPubCode IN (SELECT ReplicaPubCode FROM z_ReplicaSubs WITH (NOLOCK) WHERE PublisherCode = @PublisherCode) 

    insert into #ReplicaTriggerCache(tablecode,SyncAUFields, [ReplicaPubCode], [Flds], [EFilterExp], [LFilterExp], [Cnt], [FilterCnt], MainReplicaPubCode, DestPCCode)

    SELECT @tablecode, @SyncAUFields, r.ReplicaPubCode, r.Flds, CAST(t.EFilterExp AS VARCHAR(MAX)) as EFilterExp, CAST(t.LFilterExp AS VARCHAR(MAX)) As LFilterExp,
      (SELECT COUNT(ISNULL(rr.Flds, 'null'))
       FROM @Replica rr
       WHERE rr.Flds = r.Flds OR (r.Flds IS NULL AND rr.Flds IS NULL)
      ) Cnt,
      (SELECT COUNT(ISNULL(CAST(tt.EFilterExp AS VARCHAR(MAX)) , 'null'))
       FROM @Replica rr
       JOIN z_ReplicaTables tt ON tt.ReplicaPubCode = rr.ReplicaPubCode AND tt.TableCode = @TableCode
       WHERE CAST(tt.EFilterExp AS VARCHAR(MAX)) = CAST(t.EFilterExp AS VARCHAR(MAX)) OR (t.EFilterExp IS NULL AND tt.EFilterExp IS NULL)
      ) FilterCnt,
      p.MainReplicaPubCode,
      p.DestPCCode
    FROM @Replica r
    JOIN z_ReplicaTables t WITH (NOLOCK) ON r.ReplicaPubCode = t.ReplicaPubCode AND t.TableCode = @TableCode
    JOIN z_ReplicaPubs p WITH (NOLOCK) ON p.ReplicaPubCode = r.ReplicaPubCode AND p.GenTriggers = 1
   /* JOIN z_ReplicaSubs s WITH (NOLOCK) ON s.ReplicaPubCode = p.ReplicaPubCode  */
    ORDER BY Flds, CAST(t.EFilterExp AS VARCHAR(MAX)), r.ReplicaPubCode

    delete from @Replica
    delete from @ReplicaPubs

    FETCH NEXT FROM ReplicaMainCur INTO @TableCode, @SyncAUFields
  END
CLOSE ReplicaMainCur
DEALLOCATE ReplicaMainCur

select tablecode, c.ReplicaPubCode, p.ReplicaPubName, [Flds], [EFilterExp], [LFilterExp], [Cnt], [FilterCnt], SyncAUFields, ISNULL(c.MainReplicaPubCode, c.ReplicaPubCode) MainReplicaPubCode, c.DestPCCode from #ReplicaTriggerCache c
join z_replicaPubs p on c.ReplicaPubCode = p.ReplicaPubCode
order by tablecode, Flds, EFilterExp, ReplicaPubCode

end
GO
