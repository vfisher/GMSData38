CREATE TABLE [dbo].[r_GAccs1] (
  [ChID] [bigint] NOT NULL,
  [GAccID1] [tinyint] NOT NULL,
  [GAccName1] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [pk_r_GAccs1] PRIMARY KEY CLUSTERED ([GAccID1])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_GAccs1] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [GAccName1]
  ON [dbo].[r_GAccs1] ([GAccName1])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs1.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs1.GAccID1'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_GAccs1] ON [r_GAccs1]
FOR INSERT AS
/* r_GAccs1 - План счетов - Классы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10707002, ChID, 
    '[' + cast(i.GAccID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_GAccs1', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_GAccs1] ON [r_GAccs1]
FOR UPDATE AS
/* r_GAccs1 - План счетов - Классы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_GAccs1 ^ r_GAccs2 - Обновление CHILD */
/* План счетов - Классы ^ План счетов - Первый порядок - Обновление CHILD */
  IF UPDATE(GAccID1)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GAccID1 = i.GAccID1
          FROM r_GAccs2 a, inserted i, deleted d WHERE a.GAccID1 = d.GAccID1
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GAccs2 a, deleted d WHERE a.GAccID1 = d.GAccID1)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов - Классы'' => ''План счетов - Первый порядок''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10707002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10707002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(GAccID1))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10707002 AND l.PKValue = 
        '[' + cast(i.GAccID1 as varchar(200)) + ']' AND i.GAccID1 = d.GAccID1
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10707002 AND l.PKValue = 
        '[' + cast(i.GAccID1 as varchar(200)) + ']' AND i.GAccID1 = d.GAccID1
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10707002, ChID, 
          '[' + cast(d.GAccID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10707002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10707002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10707002, ChID, 
          '[' + cast(i.GAccID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(GAccID1)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT GAccID1 FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT GAccID1 FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.GAccID1 as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10707002 AND l.PKValue = 
          '[' + cast(d.GAccID1 as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.GAccID1 as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10707002 AND l.PKValue = 
          '[' + cast(d.GAccID1 as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10707002, ChID, 
          '[' + cast(d.GAccID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10707002 AND PKValue IN (SELECT 
          '[' + cast(GAccID1 as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10707002 AND PKValue IN (SELECT 
          '[' + cast(GAccID1 as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10707002, ChID, 
          '[' + cast(i.GAccID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10707002, ChID, 
    '[' + cast(i.GAccID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_GAccs1', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_GAccs1] ON [r_GAccs1]
FOR DELETE AS
/* r_GAccs1 - План счетов - Классы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_GAccs1 ^ r_GAccs2 - Удаление в CHILD */
/* План счетов - Классы ^ План счетов - Первый порядок - Удаление в CHILD */
  DELETE r_GAccs2 FROM r_GAccs2 a, deleted d WHERE a.GAccID1 = d.GAccID1
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10707002 AND m.PKValue = 
    '[' + cast(i.GAccID1 as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10707002 AND m.PKValue = 
    '[' + cast(i.GAccID1 as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10707002, -ChID, 
    '[' + cast(d.GAccID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10707 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_GAccs1', N'Last', N'DELETE'
GO