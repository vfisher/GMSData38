CREATE TABLE [dbo].[r_GAccs2] (
  [GAccID1] [tinyint] NOT NULL,
  [GAccID2] [tinyint] NOT NULL,
  [GAccName2] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [_pk_r_GAccs2] PRIMARY KEY CLUSTERED ([GAccID2])
)
ON [PRIMARY]
GO

CREATE INDEX [GAccID1]
  ON [dbo].[r_GAccs2] ([GAccID1])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [GAccName2]
  ON [dbo].[r_GAccs2] ([GAccName2])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [NoDuplicate]
  ON [dbo].[r_GAccs2] ([GAccID1], [GAccID2])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs2.GAccID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs2.GAccID2'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_GAccs2] ON [r_GAccs2]
FOR INSERT AS
/* r_GAccs2 - План счетов - Первый порядок - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_GAccs2 ^ r_GAccs1 - Проверка в PARENT */
/* План счетов - Первый порядок ^ План счетов - Классы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GAccID1 NOT IN (SELECT GAccID1 FROM r_GAccs1))
    BEGIN
      EXEC z_RelationError 'r_GAccs1', 'r_GAccs2', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10707003, m.ChID, 
    '[' + cast(i.GAccID2 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_GAccs1 m ON m.GAccID1 = i.GAccID1

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_GAccs2', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_GAccs2] ON [r_GAccs2]
FOR UPDATE AS
/* r_GAccs2 - План счетов - Первый порядок - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_GAccs2 ^ r_GAccs1 - Проверка в PARENT */
/* План счетов - Первый порядок ^ План счетов - Классы - Проверка в PARENT */
  IF UPDATE(GAccID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GAccID1 NOT IN (SELECT GAccID1 FROM r_GAccs1))
      BEGIN
        EXEC z_RelationError 'r_GAccs1', 'r_GAccs2', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldGAccID1 tinyint, @NewGAccID1 tinyint
  DECLARE @OldGAccID2 tinyint, @NewGAccID2 tinyint

/* r_GAccs2 ^ r_GAccs - Обновление CHILD */
/* План счетов - Первый порядок ^ План счетов - Обновление CHILD */
  IF UPDATE(GAccID1) OR UPDATE(GAccID2)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GAccID1 = i.GAccID1, a.GAccID2 = i.GAccID2
          FROM r_GAccs a, inserted i, deleted d WHERE a.GAccID1 = d.GAccID1 AND a.GAccID2 = d.GAccID2
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(GAccID2) AND (SELECT COUNT(DISTINCT GAccID1) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT GAccID1) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldGAccID1 = GAccID1 FROM deleted
          SELECT TOP 1 @NewGAccID1 = GAccID1 FROM inserted
          UPDATE r_GAccs SET r_GAccs.GAccID1 = @NewGAccID1 FROM r_GAccs, deleted d WHERE r_GAccs.GAccID1 = @OldGAccID1 AND r_GAccs.GAccID2 = d.GAccID2
        END
      ELSE IF NOT UPDATE(GAccID1) AND (SELECT COUNT(DISTINCT GAccID2) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT GAccID2) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldGAccID2 = GAccID2 FROM deleted
          SELECT TOP 1 @NewGAccID2 = GAccID2 FROM inserted
          UPDATE r_GAccs SET r_GAccs.GAccID2 = @NewGAccID2 FROM r_GAccs, deleted d WHERE r_GAccs.GAccID2 = @OldGAccID2 AND r_GAccs.GAccID1 = d.GAccID1
        END
      ELSE IF EXISTS (SELECT * FROM r_GAccs a, deleted d WHERE a.GAccID1 = d.GAccID1 AND a.GAccID2 = d.GAccID2)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов - Первый порядок'' => ''План счетов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(GAccID2)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT GAccID2 FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT GAccID2 FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.GAccID2 as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10707003 AND l.PKValue = 
          '[' + cast(d.GAccID2 as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.GAccID2 as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10707003 AND l.PKValue = 
          '[' + cast(d.GAccID2 as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10707003, m.ChID, 
          '[' + cast(d.GAccID2 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_GAccs1 m ON m.GAccID1 = d.GAccID1
          DELETE FROM z_LogCreate WHERE TableCode = 10707003 AND PKValue IN (SELECT 
          '[' + cast(GAccID2 as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10707003 AND PKValue IN (SELECT 
          '[' + cast(GAccID2 as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10707003, m.ChID, 
          '[' + cast(i.GAccID2 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_GAccs1 m ON m.GAccID1 = i.GAccID1

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10707003, m.ChID, 
    '[' + cast(i.GAccID2 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_GAccs1 m ON m.GAccID1 = i.GAccID1


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_GAccs2', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_GAccs2] ON [r_GAccs2]
FOR DELETE AS
/* r_GAccs2 - План счетов - Первый порядок - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_GAccs2 ^ r_GAccs - Удаление в CHILD */
/* План счетов - Первый порядок ^ План счетов - Удаление в CHILD */
  DELETE r_GAccs FROM r_GAccs a, deleted d WHERE a.GAccID1 = d.GAccID1 AND a.GAccID2 = d.GAccID2
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10707003 AND m.PKValue = 
    '[' + cast(i.GAccID2 as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10707003 AND m.PKValue = 
    '[' + cast(i.GAccID2 as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10707003, m.ChID, 
    '[' + cast(d.GAccID2 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_GAccs1 m ON m.GAccID1 = d.GAccID1

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_GAccs2', N'Last', N'DELETE'
GO