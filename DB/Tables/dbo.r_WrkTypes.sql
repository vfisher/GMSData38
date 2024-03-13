CREATE TABLE [dbo].[r_WrkTypes]
(
[ChID] [bigint] NOT NULL,
[WrkID] [int] NOT NULL,
[WrkName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[PriceCC] [numeric] (21, 9) NOT NULL,
[Value1] [numeric] (21, 9) NULL,
[Value2] [numeric] (21, 9) NULL,
[Value3] [numeric] (21, 9) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_WrkTypes] ON [dbo].[r_WrkTypes]
FOR INSERT AS
/* r_WrkTypes - Справочник работ: виды - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10716001, ChID, 
    '[' + cast(i.WrkID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_WrkTypes]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_WrkTypes] ON [dbo].[r_WrkTypes]
FOR UPDATE AS
/* r_WrkTypes - Справочник работ: виды - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_WrkTypes ^ p_EWrkD - Обновление CHILD */
/* Справочник работ: виды ^ Выполнение работ (Служащие) - Обновление CHILD */
  IF UPDATE(WrkID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.WrkID = i.WrkID
          FROM p_EWrkD a, inserted i, deleted d WHERE a.WrkID = d.WrkID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EWrkD a, deleted d WHERE a.WrkID = d.WrkID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: виды'' => ''Выполнение работ (Служащие)''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10716001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10716001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(WrkID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10716001 AND l.PKValue = 
        '[' + cast(i.WrkID as varchar(200)) + ']' AND i.WrkID = d.WrkID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10716001 AND l.PKValue = 
        '[' + cast(i.WrkID as varchar(200)) + ']' AND i.WrkID = d.WrkID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10716001, ChID, 
          '[' + cast(d.WrkID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10716001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10716001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10716001, ChID, 
          '[' + cast(i.WrkID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(WrkID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT WrkID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT WrkID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.WrkID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10716001 AND l.PKValue = 
          '[' + cast(d.WrkID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.WrkID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10716001 AND l.PKValue = 
          '[' + cast(d.WrkID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10716001, ChID, 
          '[' + cast(d.WrkID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10716001 AND PKValue IN (SELECT 
          '[' + cast(WrkID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10716001 AND PKValue IN (SELECT 
          '[' + cast(WrkID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10716001, ChID, 
          '[' + cast(i.WrkID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10716001, ChID, 
    '[' + cast(i.WrkID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_WrkTypes]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_WrkTypes] ON [dbo].[r_WrkTypes]
FOR DELETE AS
/* r_WrkTypes - Справочник работ: виды - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_WrkTypes ^ p_EWrkD - Проверка в CHILD */
/* Справочник работ: виды ^ Выполнение работ (Служащие) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EWrkD a WITH(NOLOCK), deleted d WHERE a.WrkID = d.WrkID)
    BEGIN
      EXEC z_RelationError 'r_WrkTypes', 'p_EWrkD', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10716001 AND m.PKValue = 
    '[' + cast(i.WrkID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10716001 AND m.PKValue = 
    '[' + cast(i.WrkID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10716001, -ChID, 
    '[' + cast(d.WrkID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10716 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_WrkTypes]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_WrkTypes] ADD CONSTRAINT [pk_r_WrkTypes] PRIMARY KEY CLUSTERED ([WrkID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_WrkTypes] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [WrkName] ON [dbo].[r_WrkTypes] ([WrkName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WrkTypes].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WrkTypes].[WrkID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WrkTypes].[PriceCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WrkTypes].[Value1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WrkTypes].[Value2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WrkTypes].[Value3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WrkTypes].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WrkTypes].[WrkID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WrkTypes].[PriceCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WrkTypes].[Value1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WrkTypes].[Value2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WrkTypes].[Value3]'
GO
