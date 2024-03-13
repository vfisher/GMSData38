CREATE TABLE [dbo].[r_EmpAdd]
(
[EmpID] [int] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[RegRegion] [varchar] (200) NULL,
[RegDistrict] [varchar] (200) NULL,
[RegCity] [varchar] (200) NULL,
[RegStreet] [varchar] (200) NULL,
[RegHouse] [varchar] (200) NULL,
[RegBlock] [varchar] (200) NULL,
[RegAptNo] [varchar] (200) NULL,
[RegPostIndex] [varchar] (50) NULL,
[FactRegion] [varchar] (200) NULL,
[FactDistrict] [varchar] (200) NULL,
[FactCity] [varchar] (200) NULL,
[FactStreet] [varchar] (200) NULL,
[FactHouse] [varchar] (200) NULL,
[FactBlock] [varchar] (200) NULL,
[FactAptNo] [varchar] (200) NULL,
[FactPostIndex] [varchar] (50) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_EmpAdd] ON [dbo].[r_EmpAdd]
FOR INSERT AS
/* r_EmpAdd - Справочник служащих - Прописка и место жительства - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_EmpAdd ^ r_Emps - Проверка в PARENT */
/* Справочник служащих - Прописка и место жительства ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_EmpAdd', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10120005, m.ChID, 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Emps m ON m.EmpID = i.EmpID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_EmpAdd]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_EmpAdd] ON [dbo].[r_EmpAdd]
FOR UPDATE AS
/* r_EmpAdd - Справочник служащих - Прописка и место жительства - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_EmpAdd ^ r_Emps - Проверка в PARENT */
/* Справочник служащих - Прописка и место жительства ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'r_EmpAdd', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(EmpID) OR UPDATE(BDate) OR UPDATE(EDate)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT EmpID, BDate, EDate FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT EmpID, BDate, EDate FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.BDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EDate as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10120005 AND l.PKValue = 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.BDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EDate as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.BDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EDate as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10120005 AND l.PKValue = 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.BDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EDate as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10120005, m.ChID, 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.BDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Emps m ON m.EmpID = d.EmpID
          DELETE FROM z_LogCreate WHERE TableCode = 10120005 AND PKValue IN (SELECT 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(BDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(EDate as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10120005 AND PKValue IN (SELECT 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(BDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(EDate as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10120005, m.ChID, 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.BDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Emps m ON m.EmpID = i.EmpID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10120005, m.ChID, 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Emps m ON m.EmpID = i.EmpID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_EmpAdd]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_EmpAdd] ON [dbo].[r_EmpAdd]
FOR DELETE AS
/* r_EmpAdd - Справочник служащих - Прописка и место жительства - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10120005 AND m.PKValue = 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EDate as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10120005 AND m.PKValue = 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EDate as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10120005, m.ChID, 
    '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.BDate as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.EDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Emps m ON m.EmpID = d.EmpID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_EmpAdd]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_EmpAdd] ADD CONSTRAINT [_pk_r_EmpAdd] PRIMARY KEY CLUSTERED ([EmpID], [BDate], [EDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BDate] ON [dbo].[r_EmpAdd] ([BDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EDate] ON [dbo].[r_EmpAdd] ([EDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[r_EmpAdd] ([EmpID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpAdd].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpAdd].[EmpID]'
GO
