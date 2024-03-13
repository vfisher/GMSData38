CREATE TABLE [dbo].[r_EmpMP]
(
[OurID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[PrevID] [int] NOT NULL,
[IsPensioner] [bit] NOT NULL,
[IsInvalid] [bit] NOT NULL,
[PrivDesc] [varchar] (200) NULL,
[PrevReason] [varchar] (200) NULL,
[DisGroup] [tinyint] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_EmpMP] ON [dbo].[r_EmpMP]
FOR INSERT AS
/* r_EmpMP - Справочник служащих - Список льгот - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_EmpMP ^ r_EmpMO - Проверка в PARENT */
/* Справочник служащих - Список льгот ^ Справочник служащих - Внутренние фирмы - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_EmpMO m WITH(NOLOCK), inserted i WHERE i.EmpID = m.EmpID AND i.OurID = m.OurID) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_EmpMO', 'r_EmpMP', 0
      RETURN
    END

/* r_EmpMP ^ r_Prevs - Проверка в PARENT */
/* Справочник служащих - Список льгот ^ Справочник льгот - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PrevID NOT IN (SELECT PrevID FROM r_Prevs))
    BEGIN
      EXEC z_RelationError 'r_Prevs', 'r_EmpMP', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10120003, m.ChID, 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Emps m ON m.EmpID = i.EmpID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_EmpMP]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_EmpMP] ON [dbo].[r_EmpMP]
FOR UPDATE AS
/* r_EmpMP - Справочник служащих - Список льгот - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_EmpMP ^ r_EmpMO - Проверка в PARENT */
/* Справочник служащих - Список льгот ^ Справочник служащих - Внутренние фирмы - Проверка в PARENT */
  IF UPDATE(EmpID) OR UPDATE(OurID)
    IF (SELECT COUNT(*) FROM r_EmpMO m WITH(NOLOCK), inserted i WHERE i.EmpID = m.EmpID AND i.OurID = m.OurID) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_EmpMO', 'r_EmpMP', 1
        RETURN
      END

/* r_EmpMP ^ r_Prevs - Проверка в PARENT */
/* Справочник служащих - Список льгот ^ Справочник льгот - Проверка в PARENT */
  IF UPDATE(PrevID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PrevID NOT IN (SELECT PrevID FROM r_Prevs))
      BEGIN
        EXEC z_RelationError 'r_Prevs', 'r_EmpMP', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(EmpID) OR UPDATE(OurID) OR UPDATE(SrcPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT EmpID, OurID, SrcPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT EmpID, OurID, SrcPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10120003 AND l.PKValue = 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10120003 AND l.PKValue = 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10120003, m.ChID, 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Emps m ON m.EmpID = d.EmpID
          DELETE FROM z_LogCreate WHERE TableCode = 10120003 AND PKValue IN (SELECT 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10120003 AND PKValue IN (SELECT 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10120003, m.ChID, 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Emps m ON m.EmpID = i.EmpID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10120003, m.ChID, 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Emps m ON m.EmpID = i.EmpID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_EmpMP]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_EmpMP] ON [dbo].[r_EmpMP]
FOR DELETE AS
/* r_EmpMP - Справочник служащих - Список льгот - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10120003 AND m.PKValue = 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10120003 AND m.PKValue = 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10120003, m.ChID, 
    '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Emps m ON m.EmpID = d.EmpID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_EmpMP]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_EmpMP] ADD CONSTRAINT [_pk_r_EmpMP] PRIMARY KEY CLUSTERED ([OurID], [EmpID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BDate] ON [dbo].[r_EmpMP] ([BDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EDate] ON [dbo].[r_EmpMP] ([EDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[r_EmpMP] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[r_EmpMP] ([OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_EmpMOr_EmpMP] ON [dbo].[r_EmpMP] ([OurID], [EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PrevID] ON [dbo].[r_EmpMP] ([PrevID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[PrevID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[IsPensioner]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[IsInvalid]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[DisGroup]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[PrevID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[IsPensioner]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[IsInvalid]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[DisGroup]'
GO
