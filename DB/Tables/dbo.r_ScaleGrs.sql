CREATE TABLE [dbo].[r_ScaleGrs]
(
[ChID] [bigint] NOT NULL,
[ScaleGrID] [int] NOT NULL,
[ScaleGrName] [varchar] (250) NOT NULL,
[ScaleGrInfo] [varchar] (250) NULL,
[ScaleType] [int] NOT NULL DEFAULT (0),
[IPRange] [varchar] (250) NULL,
[MaxProdQty] [int] NOT NULL DEFAULT (0),
[MaxProdID] [int] NOT NULL DEFAULT (0),
[Shed] [varchar] (250) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ScaleGrs] ON [dbo].[r_ScaleGrs]
FOR INSERT AS
/* r_ScaleGrs - Справочник весов: группы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10420001, ChID, 
    '[' + cast(i.ScaleGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_ScaleGrs]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ScaleGrs] ON [dbo].[r_ScaleGrs]
FOR UPDATE AS
/* r_ScaleGrs - Справочник весов: группы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ScaleGrs ^ r_Prods - Обновление CHILD */
/* Справочник весов: группы ^ Справочник товаров - Обновление CHILD */
  IF UPDATE(ScaleGrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ScaleGrID = i.ScaleGrID
          FROM r_Prods a, inserted i, deleted d WHERE a.ScaleGrID = d.ScaleGrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Prods a, deleted d WHERE a.ScaleGrID = d.ScaleGrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник весов: группы'' => ''Справочник товаров''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_ScaleGrs ^ r_ScaleGrMW - Обновление CHILD */
/* Справочник весов: группы ^ Справочник весов: группы - префиксы - Обновление CHILD */
  IF UPDATE(ScaleGrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ScaleGrID = i.ScaleGrID
          FROM r_ScaleGrMW a, inserted i, deleted d WHERE a.ScaleGrID = d.ScaleGrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ScaleGrMW a, deleted d WHERE a.ScaleGrID = d.ScaleGrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник весов: группы'' => ''Справочник весов: группы - префиксы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_ScaleGrs ^ r_Scales - Обновление CHILD */
/* Справочник весов: группы ^ Справочник весов - Обновление CHILD */
  IF UPDATE(ScaleGrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ScaleGrID = i.ScaleGrID
          FROM r_Scales a, inserted i, deleted d WHERE a.ScaleGrID = d.ScaleGrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Scales a, deleted d WHERE a.ScaleGrID = d.ScaleGrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник весов: группы'' => ''Справочник весов''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10420001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10420001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ScaleGrID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10420001 AND l.PKValue = 
        '[' + cast(i.ScaleGrID as varchar(200)) + ']' AND i.ScaleGrID = d.ScaleGrID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10420001 AND l.PKValue = 
        '[' + cast(i.ScaleGrID as varchar(200)) + ']' AND i.ScaleGrID = d.ScaleGrID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10420001, ChID, 
          '[' + cast(d.ScaleGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10420001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10420001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10420001, ChID, 
          '[' + cast(i.ScaleGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ScaleGrID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ScaleGrID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ScaleGrID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ScaleGrID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10420001 AND l.PKValue = 
          '[' + cast(d.ScaleGrID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ScaleGrID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10420001 AND l.PKValue = 
          '[' + cast(d.ScaleGrID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10420001, ChID, 
          '[' + cast(d.ScaleGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10420001 AND PKValue IN (SELECT 
          '[' + cast(ScaleGrID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10420001 AND PKValue IN (SELECT 
          '[' + cast(ScaleGrID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10420001, ChID, 
          '[' + cast(i.ScaleGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10420001, ChID, 
    '[' + cast(i.ScaleGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_ScaleGrs]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ScaleGrs] ON [dbo].[r_ScaleGrs]
FOR DELETE AS
/* r_ScaleGrs - Справочник весов: группы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_ScaleGrs ^ r_Prods - Проверка в CHILD */
/* Справочник весов: группы ^ Справочник товаров - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Prods a WITH(NOLOCK), deleted d WHERE a.ScaleGrID = d.ScaleGrID)
    BEGIN
      EXEC z_RelationError 'r_ScaleGrs', 'r_Prods', 3
      RETURN
    END

/* r_ScaleGrs ^ r_ScaleGrMW - Проверка в CHILD */
/* Справочник весов: группы ^ Справочник весов: группы - префиксы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ScaleGrMW a WITH(NOLOCK), deleted d WHERE a.ScaleGrID = d.ScaleGrID)
    BEGIN
      EXEC z_RelationError 'r_ScaleGrs', 'r_ScaleGrMW', 3
      RETURN
    END

/* r_ScaleGrs ^ r_Scales - Проверка в CHILD */
/* Справочник весов: группы ^ Справочник весов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Scales a WITH(NOLOCK), deleted d WHERE a.ScaleGrID = d.ScaleGrID)
    BEGIN
      EXEC z_RelationError 'r_ScaleGrs', 'r_Scales', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10420001 AND m.PKValue = 
    '[' + cast(i.ScaleGrID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10420001 AND m.PKValue = 
    '[' + cast(i.ScaleGrID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10420001, -ChID, 
    '[' + cast(d.ScaleGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10420 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_ScaleGrs]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_ScaleGrs] ADD CONSTRAINT [pk_r_ScaleGrs] PRIMARY KEY CLUSTERED ([ScaleGrID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_ScaleGrs] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ScaleGrName] ON [dbo].[r_ScaleGrs] ([ScaleGrName]) ON [PRIMARY]
GO
