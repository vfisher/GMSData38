CREATE TABLE [dbo].[r_EmpMPst]
(
[OurID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[SubID] [smallint] NOT NULL,
[DepID] [smallint] NOT NULL,
[PostID] [int] NOT NULL,
[EmpClass] [tinyint] NOT NULL,
[WorkCond] [tinyint] NOT NULL,
[ShedID] [smallint] NOT NULL,
[SalaryType] [tinyint] NOT NULL,
[SalaryForm] [tinyint] NOT NULL,
[SalaryMethod] [tinyint] NOT NULL,
[BSalary] [numeric] (21, 9) NOT NULL,
[BSalaryPrc] [numeric] (21, 9) NOT NULL,
[AdvSum] [numeric] (21, 9) NOT NULL,
[PensMethod] [tinyint] NOT NULL CONSTRAINT [df_r_EmpMPSt_PensMethod] DEFAULT (1),
[SalaryQty] [numeric] (21, 9) NULL,
[Joint] [bit] NOT NULL,
[Notes] [varchar] (200) NULL,
[IsDisDoc] [bit] NOT NULL,
[IsGivDoc] [bit] NOT NULL,
[TimeNormType] [tinyint] NOT NULL,
[IndexBaseMonth] [smalldatetime] NOT NULL,
[LeavDays] [smallint] NOT NULL DEFAULT (0),
[LeavDaysExtra] [smallint] NOT NULL DEFAULT (0),
[PensCatID] [tinyint] NOT NULL DEFAULT (1),
[IndexExtSumCC] [numeric] (21, 9) NOT NULL DEFAULT (0),
[GEmpType] [tinyint] NOT NULL DEFAULT ((0)),
[StrucPostID] [int] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_EmpMPst] ON [dbo].[r_EmpMPst]
FOR INSERT AS
/* r_EmpMPst - Справочник служащих - Должности и оплата труда - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_EmpMPst ^ r_Deps - Проверка в PARENT */
/* Справочник служащих - Должности и оплата труда ^ Справочник отделов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
    BEGIN
      EXEC z_RelationError 'r_Deps', 'r_EmpMPst', 0
      RETURN
    END

/* r_EmpMPst ^ r_EmpMO - Проверка в PARENT */
/* Справочник служащих - Должности и оплата труда ^ Справочник служащих - Внутренние фирмы - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_EmpMO m WITH(NOLOCK), inserted i WHERE i.EmpID = m.EmpID AND i.OurID = m.OurID) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_EmpMO', 'r_EmpMPst', 0
      RETURN
    END

/* r_EmpMPst ^ r_PostMC - Проверка в PARENT */
/* Справочник служащих - Должности и оплата труда ^ Справочник должностей - Разряды - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_PostMC m WITH(NOLOCK), inserted i WHERE i.EmpClass = m.EmpClass AND i.PostID = m.PostID) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_PostMC', 'r_EmpMPst', 0
      RETURN
    END

/* r_EmpMPst ^ r_Sheds - Проверка в PARENT */
/* Справочник служащих - Должности и оплата труда ^ Справочник работ: графики - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ShedID NOT IN (SELECT ShedID FROM r_Sheds))
    BEGIN
      EXEC z_RelationError 'r_Sheds', 'r_EmpMPst', 0
      RETURN
    END

/* r_EmpMPst ^ r_Subs - Проверка в PARENT */
/* Справочник служащих - Должности и оплата труда ^ Справочник работ: подразделения - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
    BEGIN
      EXEC z_RelationError 'r_Subs', 'r_EmpMPst', 0
      RETURN
    END

/* r_EmpMPst ^ r_Uni - Проверка в PARENT */
/* Справочник служащих - Должности и оплата труда ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PensMethod NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10057))
    BEGIN
      EXEC z_RelationErrorUni 'r_EmpMPst', 10057, 0
      RETURN
    END

/* r_EmpMPst ^ r_Uni - Проверка в PARENT */
/* Справочник служащих - Должности и оплата труда ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PensCatID NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10058))
    BEGIN
      EXEC z_RelationErrorUni 'r_EmpMPst', 10058, 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10120008, m.ChID, 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Emps m ON m.EmpID = i.EmpID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_EmpMPst]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_EmpMPst] ON [dbo].[r_EmpMPst]
FOR UPDATE AS
/* r_EmpMPst - Справочник служащих - Должности и оплата труда - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_EmpMPst ^ r_Deps - Проверка в PARENT */
/* Справочник служащих - Должности и оплата труда ^ Справочник отделов - Проверка в PARENT */
  IF UPDATE(DepID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
      BEGIN
        EXEC z_RelationError 'r_Deps', 'r_EmpMPst', 1
        RETURN
      END

/* r_EmpMPst ^ r_EmpMO - Проверка в PARENT */
/* Справочник служащих - Должности и оплата труда ^ Справочник служащих - Внутренние фирмы - Проверка в PARENT */
  IF UPDATE(EmpID) OR UPDATE(OurID)
    IF (SELECT COUNT(*) FROM r_EmpMO m WITH(NOLOCK), inserted i WHERE i.EmpID = m.EmpID AND i.OurID = m.OurID) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_EmpMO', 'r_EmpMPst', 1
        RETURN
      END

/* r_EmpMPst ^ r_PostMC - Проверка в PARENT */
/* Справочник служащих - Должности и оплата труда ^ Справочник должностей - Разряды - Проверка в PARENT */
  IF UPDATE(EmpClass) OR UPDATE(PostID)
    IF (SELECT COUNT(*) FROM r_PostMC m WITH(NOLOCK), inserted i WHERE i.EmpClass = m.EmpClass AND i.PostID = m.PostID) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_PostMC', 'r_EmpMPst', 1
        RETURN
      END

/* r_EmpMPst ^ r_Sheds - Проверка в PARENT */
/* Справочник служащих - Должности и оплата труда ^ Справочник работ: графики - Проверка в PARENT */
  IF UPDATE(ShedID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ShedID NOT IN (SELECT ShedID FROM r_Sheds))
      BEGIN
        EXEC z_RelationError 'r_Sheds', 'r_EmpMPst', 1
        RETURN
      END

/* r_EmpMPst ^ r_Subs - Проверка в PARENT */
/* Справочник служащих - Должности и оплата труда ^ Справочник работ: подразделения - Проверка в PARENT */
  IF UPDATE(SubID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
      BEGIN
        EXEC z_RelationError 'r_Subs', 'r_EmpMPst', 1
        RETURN
      END

/* r_EmpMPst ^ r_Uni - Проверка в PARENT */
/* Справочник служащих - Должности и оплата труда ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(PensMethod)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PensMethod NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10057))
      BEGIN
        EXEC z_RelationErrorUni 'r_EmpMPst', 10057, 1
        RETURN
      END

/* r_EmpMPst ^ r_Uni - Проверка в PARENT */
/* Справочник служащих - Должности и оплата труда ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(PensCatID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PensCatID NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10058))
      BEGIN
        EXEC z_RelationErrorUni 'r_EmpMPst', 10058, 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(EmpID) OR UPDATE(OurID) OR UPDATE(BDate)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT EmpID, OurID, BDate FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT EmpID, OurID, BDate FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.BDate as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10120008 AND l.PKValue = 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.BDate as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.BDate as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10120008 AND l.PKValue = 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.BDate as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10120008, m.ChID, 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.BDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Emps m ON m.EmpID = d.EmpID
          DELETE FROM z_LogCreate WHERE TableCode = 10120008 AND PKValue IN (SELECT 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(BDate as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10120008 AND PKValue IN (SELECT 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(BDate as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10120008, m.ChID, 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.BDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Emps m ON m.EmpID = i.EmpID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10120008, m.ChID, 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Emps m ON m.EmpID = i.EmpID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_EmpMPst]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_EmpMPst] ON [dbo].[r_EmpMPst]
FOR DELETE AS
/* r_EmpMPst - Справочник служащих - Должности и оплата труда - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10120008 AND m.PKValue = 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10120008 AND m.PKValue = 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10120008, m.ChID, 
    '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.BDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Emps m ON m.EmpID = d.EmpID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_EmpMPst]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_EmpMPst] ADD CONSTRAINT [_pk_r_EmpMPst] PRIMARY KEY CLUSTERED ([OurID], [EmpID], [BDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BDate] ON [dbo].[r_EmpMPst] ([BDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DepID] ON [dbo].[r_EmpMPst] ([DepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EDate] ON [dbo].[r_EmpMPst] ([EDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_EmpMOr_EmpMPst] ON [dbo].[r_EmpMPst] ([OurID], [EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_PostMCr_EmpMPst] ON [dbo].[r_EmpMPst] ([PostID], [EmpClass]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ShedID] ON [dbo].[r_EmpMPst] ([ShedID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubID] ON [dbo].[r_EmpMPst] ([SubID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[DepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[PostID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[EmpClass]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[WorkCond]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[ShedID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[SalaryType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[SalaryForm]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[SalaryMethod]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[BSalary]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[BSalaryPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[AdvSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[SalaryQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[Joint]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[IsDisDoc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[IsGivDoc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[TimeNormType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[DepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[PostID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[EmpClass]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[WorkCond]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[ShedID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[SalaryType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[SalaryForm]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[SalaryMethod]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[BSalary]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[BSalaryPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[AdvSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[SalaryQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[Joint]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[IsDisDoc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[IsGivDoc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[TimeNormType]'
GO
