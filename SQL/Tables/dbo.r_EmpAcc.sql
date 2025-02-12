CREATE TABLE [dbo].[r_EmpAcc] (
  [OurID] [int] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [EmpID] [int] NOT NULL,
  [Priority] [int] NOT NULL,
  [BDate] [smalldatetime] NOT NULL,
  [EDate] [smalldatetime] NOT NULL,
  [PayTypeID] [smallint] NOT NULL,
  [SumExpE] [varchar](255) NOT NULL,
  [SumExpR] [varchar](255) NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [_pk_r_EmpAcc] PRIMARY KEY CLUSTERED ([SrcPosID], [EmpID])
)
ON [PRIMARY]
GO

CREATE INDEX [BDate]
  ON [dbo].[r_EmpAcc] ([BDate])
  ON [PRIMARY]
GO

CREATE INDEX [EDate]
  ON [dbo].[r_EmpAcc] ([EDate])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [NoDuplicate]
  ON [dbo].[r_EmpAcc] ([OurID], [Priority], [EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [PayTypeID]
  ON [dbo].[r_EmpAcc] ([PayTypeID])
  ON [PRIMARY]
GO

CREATE INDEX [r_EmpMOr_EmpAcc]
  ON [dbo].[r_EmpAcc] ([OurID], [EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [SrcPosID]
  ON [dbo].[r_EmpAcc] ([SrcPosID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpAcc.OurID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpAcc.SrcPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpAcc.EmpID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpAcc.PayTypeID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_EmpAcc] ON [r_EmpAcc]
FOR INSERT AS
/* r_EmpAcc - Справочник служащих - Дополнительные периодические расходы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_EmpAcc ^ r_EmpMO - Проверка в PARENT */
/* Справочник служащих - Дополнительные периодические расходы ^ Справочник служащих - Внутренние фирмы - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_EmpMO m WITH(NOLOCK), inserted i WHERE i.EmpID = m.EmpID AND i.OurID = m.OurID) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_EmpMO', 'r_EmpAcc', 0
      RETURN
    END

/* r_EmpAcc ^ r_PayTypes - Проверка в PARENT */
/* Справочник служащих - Дополнительные периодические расходы ^ Справочник выплат/удержаний - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PayTypeID NOT IN (SELECT PayTypeID FROM r_PayTypes))
    BEGIN
      EXEC z_RelationError 'r_PayTypes', 'r_EmpAcc', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10120007, m.ChID, 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Emps m ON m.EmpID = i.EmpID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_EmpAcc', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_EmpAcc] ON [r_EmpAcc]
FOR UPDATE AS
/* r_EmpAcc - Справочник служащих - Дополнительные периодические расходы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_EmpAcc ^ r_EmpMO - Проверка в PARENT */
/* Справочник служащих - Дополнительные периодические расходы ^ Справочник служащих - Внутренние фирмы - Проверка в PARENT */
  IF UPDATE(EmpID) OR UPDATE(OurID)
    IF (SELECT COUNT(*) FROM r_EmpMO m WITH(NOLOCK), inserted i WHERE i.EmpID = m.EmpID AND i.OurID = m.OurID) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_EmpMO', 'r_EmpAcc', 1
        RETURN
      END

/* r_EmpAcc ^ r_PayTypes - Проверка в PARENT */
/* Справочник служащих - Дополнительные периодические расходы ^ Справочник выплат/удержаний - Проверка в PARENT */
  IF UPDATE(PayTypeID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PayTypeID NOT IN (SELECT PayTypeID FROM r_PayTypes))
      BEGIN
        EXEC z_RelationError 'r_PayTypes', 'r_EmpAcc', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(EmpID) OR UPDATE(SrcPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT EmpID, SrcPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT EmpID, SrcPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10120007 AND l.PKValue = 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10120007 AND l.PKValue = 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10120007, m.ChID, 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Emps m ON m.EmpID = d.EmpID
          DELETE FROM z_LogCreate WHERE TableCode = 10120007 AND PKValue IN (SELECT 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10120007 AND PKValue IN (SELECT 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10120007, m.ChID, 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Emps m ON m.EmpID = i.EmpID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10120007, m.ChID, 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Emps m ON m.EmpID = i.EmpID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_EmpAcc', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_EmpAcc] ON [r_EmpAcc]
FOR DELETE AS
/* r_EmpAcc - Справочник служащих - Дополнительные периодические расходы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10120007 AND m.PKValue = 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10120007 AND m.PKValue = 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10120007, m.ChID, 
    '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Emps m ON m.EmpID = d.EmpID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_EmpAcc', N'Last', N'DELETE'
GO