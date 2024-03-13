CREATE TABLE [dbo].[r_Scales]
(
[ChID] [bigint] NOT NULL,
[SrvID] [tinyint] NOT NULL,
[ScaleGrID] [int] NOT NULL,
[ScaleID] [int] NOT NULL,
[ScaleName] [varchar] (250) NOT NULL,
[ScaleInfo] [varchar] (250) NULL,
[ScaleType] [int] NULL DEFAULT (0),
[ScaleSerial] [varchar] (250) NULL,
[IP] [varchar] (250) NULL,
[NetPort] [int] NULL,
[ComPort] [int] NULL,
[BaudRate] [smallint] NULL,
[MaxProdQty] [int] NOT NULL DEFAULT (0),
[MaxProdID] [int] NOT NULL DEFAULT (0),
[ScaleDefID] [int] NOT NULL,
[StockID] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Scales] ON [dbo].[r_Scales]
FOR INSERT AS
/* r_Scales - Справочник весов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Scales ^ r_CRSrvs - Проверка в PARENT */
/* Справочник весов ^ Справочник торговых серверов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SrvID NOT IN (SELECT SrvID FROM r_CRSrvs))
    BEGIN
      EXEC z_RelationError 'r_CRSrvs', 'r_Scales', 0
      RETURN
    END

/* r_Scales ^ r_ScaleDefs - Проверка в PARENT */
/* Справочник весов ^ Справочник весов: конфигурации - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ScaleDefID NOT IN (SELECT ScaleDefID FROM r_ScaleDefs))
    BEGIN
      EXEC z_RelationError 'r_ScaleDefs', 'r_Scales', 0
      RETURN
    END

/* r_Scales ^ r_ScaleGrs - Проверка в PARENT */
/* Справочник весов ^ Справочник весов: группы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ScaleGrID NOT IN (SELECT ScaleGrID FROM r_ScaleGrs))
    BEGIN
      EXEC z_RelationError 'r_ScaleGrs', 'r_Scales', 0
      RETURN
    END

/* r_Scales ^ r_Stocks - Проверка в PARENT */
/* Справочник весов ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'r_Scales', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10421001, ChID, 
    '[' + cast(i.ScaleID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_Scales]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Scales] ON [dbo].[r_Scales]
FOR UPDATE AS
/* r_Scales - Справочник весов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Scales ^ r_CRSrvs - Проверка в PARENT */
/* Справочник весов ^ Справочник торговых серверов - Проверка в PARENT */
  IF UPDATE(SrvID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SrvID NOT IN (SELECT SrvID FROM r_CRSrvs))
      BEGIN
        EXEC z_RelationError 'r_CRSrvs', 'r_Scales', 1
        RETURN
      END

/* r_Scales ^ r_ScaleDefs - Проверка в PARENT */
/* Справочник весов ^ Справочник весов: конфигурации - Проверка в PARENT */
  IF UPDATE(ScaleDefID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ScaleDefID NOT IN (SELECT ScaleDefID FROM r_ScaleDefs))
      BEGIN
        EXEC z_RelationError 'r_ScaleDefs', 'r_Scales', 1
        RETURN
      END

/* r_Scales ^ r_ScaleGrs - Проверка в PARENT */
/* Справочник весов ^ Справочник весов: группы - Проверка в PARENT */
  IF UPDATE(ScaleGrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ScaleGrID NOT IN (SELECT ScaleGrID FROM r_ScaleGrs))
      BEGIN
        EXEC z_RelationError 'r_ScaleGrs', 'r_Scales', 1
        RETURN
      END

/* r_Scales ^ r_Stocks - Проверка в PARENT */
/* Справочник весов ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'r_Scales', 1
        RETURN
      END

/* r_Scales ^ r_WPs - Обновление CHILD */
/* Справочник весов ^ Справочник рабочих мест - Обновление CHILD */
  IF UPDATE(ScaleID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ScaleID = i.ScaleID
          FROM r_WPs a, inserted i, deleted d WHERE a.ScaleID = d.ScaleID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_WPs a, deleted d WHERE a.ScaleID = d.ScaleID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник весов'' => ''Справочник рабочих мест''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10421001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10421001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ScaleID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10421001 AND l.PKValue = 
        '[' + cast(i.ScaleID as varchar(200)) + ']' AND i.ScaleID = d.ScaleID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10421001 AND l.PKValue = 
        '[' + cast(i.ScaleID as varchar(200)) + ']' AND i.ScaleID = d.ScaleID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10421001, ChID, 
          '[' + cast(d.ScaleID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10421001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10421001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10421001, ChID, 
          '[' + cast(i.ScaleID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ScaleID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ScaleID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ScaleID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ScaleID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10421001 AND l.PKValue = 
          '[' + cast(d.ScaleID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ScaleID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10421001 AND l.PKValue = 
          '[' + cast(d.ScaleID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10421001, ChID, 
          '[' + cast(d.ScaleID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10421001 AND PKValue IN (SELECT 
          '[' + cast(ScaleID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10421001 AND PKValue IN (SELECT 
          '[' + cast(ScaleID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10421001, ChID, 
          '[' + cast(i.ScaleID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10421001, ChID, 
    '[' + cast(i.ScaleID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_Scales]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Scales] ON [dbo].[r_Scales]
FOR DELETE AS
/* r_Scales - Справочник весов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Scales ^ r_WPs - Проверка в CHILD */
/* Справочник весов ^ Справочник рабочих мест - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_WPs a WITH(NOLOCK), deleted d WHERE a.ScaleID = d.ScaleID)
    BEGIN
      EXEC z_RelationError 'r_Scales', 'r_WPs', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10421001 AND m.PKValue = 
    '[' + cast(i.ScaleID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10421001 AND m.PKValue = 
    '[' + cast(i.ScaleID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10421001, -ChID, 
    '[' + cast(d.ScaleID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10421 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_Scales]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_Scales] ADD CONSTRAINT [pk_r_Scales] PRIMARY KEY CLUSTERED ([ScaleID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Scales] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ScaleName] ON [dbo].[r_Scales] ([ScaleName]) ON [PRIMARY]
GO
