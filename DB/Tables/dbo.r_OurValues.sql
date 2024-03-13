CREATE TABLE [dbo].[r_OurValues]
(
[OurID] [int] NOT NULL,
[VarName] [varchar] (250) NOT NULL,
[VarValue] [varchar] (250) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_OurValues] ON [dbo].[r_OurValues]
FOR INSERT AS
/* r_OurValues - Справочник внутренних фирм - Значения - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_OurValues ^ r_Ours - Проверка в PARENT */
/* Справочник внутренних фирм - Значения ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'r_OurValues', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10110004, m.ChID, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.VarName as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Ours m ON m.OurID = i.OurID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_OurValues]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_OurValues] ON [dbo].[r_OurValues]
FOR UPDATE AS
/* r_OurValues - Справочник внутренних фирм - Значения - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_OurValues ^ r_Ours - Проверка в PARENT */
/* Справочник внутренних фирм - Значения ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'r_OurValues', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(OurID) OR UPDATE(VarName)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID, VarName FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID, VarName FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.VarName as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10110004 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.VarName as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.VarName as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10110004 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.VarName as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10110004, m.ChID, 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.VarName as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Ours m ON m.OurID = d.OurID
          DELETE FROM z_LogCreate WHERE TableCode = 10110004 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(VarName as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10110004 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(VarName as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10110004, m.ChID, 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.VarName as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Ours m ON m.OurID = i.OurID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10110004, m.ChID, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.VarName as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Ours m ON m.OurID = i.OurID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_OurValues]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_OurValues] ON [dbo].[r_OurValues]
FOR DELETE AS
/* r_OurValues - Справочник внутренних фирм - Значения - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10110004 AND m.PKValue = 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.VarName as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10110004 AND m.PKValue = 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.VarName as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10110004, m.ChID, 
    '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.VarName as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Ours m ON m.OurID = d.OurID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_OurValues]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_OurValues] ADD CONSTRAINT [pk_r_OurValues] PRIMARY KEY CLUSTERED ([OurID], [VarName]) ON [PRIMARY]
GO
