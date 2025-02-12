CREATE TABLE [dbo].[r_EmpAct] (
  [EmpID] [int] NOT NULL,
  [BDate] [smalldatetime] NOT NULL,
  [EDate] [smalldatetime] NOT NULL,
  [PrvPlEmp] [varchar](200) NOT NULL,
  [DisReasonText] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [_pk_r_EmpAct] PRIMARY KEY CLUSTERED ([EmpID], [BDate], [EDate])
)
ON [PRIMARY]
GO

CREATE INDEX [BDate]
  ON [dbo].[r_EmpAct] ([BDate])
  ON [PRIMARY]
GO

CREATE INDEX [EDate]
  ON [dbo].[r_EmpAct] ([EDate])
  ON [PRIMARY]
GO

CREATE INDEX [EmpID]
  ON [dbo].[r_EmpAct] ([EmpID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpAct.EmpID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_EmpAct] ON [r_EmpAct]
FOR INSERT AS
/* r_EmpAct - Справочник служащих - Трудовая деятельность - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_EmpAct ^ r_Emps - Проверка в PARENT */
/* Справочник служащих - Трудовая деятельность ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_EmpAct', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10120004, m.ChID, 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Emps m ON m.EmpID = i.EmpID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_EmpAct', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_EmpAct] ON [r_EmpAct]
FOR UPDATE AS
/* r_EmpAct - Справочник служащих - Трудовая деятельность - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_EmpAct ^ r_Emps - Проверка в PARENT */
/* Справочник служащих - Трудовая деятельность ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'r_EmpAct', 1
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10120004 AND l.PKValue = 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.BDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EDate as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.BDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EDate as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10120004 AND l.PKValue = 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.BDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EDate as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10120004, m.ChID, 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.BDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Emps m ON m.EmpID = d.EmpID
          DELETE FROM z_LogCreate WHERE TableCode = 10120004 AND PKValue IN (SELECT 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(BDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(EDate as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10120004 AND PKValue IN (SELECT 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(BDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(EDate as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10120004, m.ChID, 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.BDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Emps m ON m.EmpID = i.EmpID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10120004, m.ChID, 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Emps m ON m.EmpID = i.EmpID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_EmpAct', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_EmpAct] ON [r_EmpAct]
FOR DELETE AS
/* r_EmpAct - Справочник служащих - Трудовая деятельность - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10120004 AND m.PKValue = 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EDate as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10120004 AND m.PKValue = 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EDate as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10120004, m.ChID, 
    '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.BDate as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.EDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Emps m ON m.EmpID = d.EmpID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_EmpAct', N'Last', N'DELETE'
GO