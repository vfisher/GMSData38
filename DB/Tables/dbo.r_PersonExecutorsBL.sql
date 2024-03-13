CREATE TABLE [dbo].[r_PersonExecutorsBL]
(
[PersonID] [bigint] NOT NULL,
[ExecutorID] [int] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_PersonExecutorsBL] ON [dbo].[r_PersonExecutorsBL]
FOR INSERT AS
/* r_PersonExecutorsBL - Справочник персон - черный список исполнителей - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PersonExecutorsBL ^ r_Executors - Проверка в PARENT */
/* Справочник персон - черный список исполнителей ^ Справочник исполнителей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ExecutorID NOT IN (SELECT ExecutorID FROM r_Executors))
    BEGIN
      EXEC z_RelationError 'r_Executors', 'r_PersonExecutorsBL', 0
      RETURN
    END

/* r_PersonExecutorsBL ^ r_Persons - Проверка в PARENT */
/* Справочник персон - черный список исполнителей ^ Справочник персон - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PersonID NOT IN (SELECT PersonID FROM r_Persons))
    BEGIN
      EXEC z_RelationError 'r_Persons', 'r_PersonExecutorsBL', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_PersonExecutorsBL]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_PersonExecutorsBL] ON [dbo].[r_PersonExecutorsBL]
FOR UPDATE AS
/* r_PersonExecutorsBL - Справочник персон - черный список исполнителей - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PersonExecutorsBL ^ r_Executors - Проверка в PARENT */
/* Справочник персон - черный список исполнителей ^ Справочник исполнителей - Проверка в PARENT */
  IF UPDATE(ExecutorID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ExecutorID NOT IN (SELECT ExecutorID FROM r_Executors))
      BEGIN
        EXEC z_RelationError 'r_Executors', 'r_PersonExecutorsBL', 1
        RETURN
      END

/* r_PersonExecutorsBL ^ r_Persons - Проверка в PARENT */
/* Справочник персон - черный список исполнителей ^ Справочник персон - Проверка в PARENT */
  IF UPDATE(PersonID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PersonID NOT IN (SELECT PersonID FROM r_Persons))
      BEGIN
        EXEC z_RelationError 'r_Persons', 'r_PersonExecutorsBL', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_PersonExecutorsBL]', 'last', 'update', null
GO
ALTER TABLE [dbo].[r_PersonExecutorsBL] ADD CONSTRAINT [pk_r_PersonExecutorsBL] PRIMARY KEY CLUSTERED ([PersonID], [ExecutorID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ExecutorID] ON [dbo].[r_PersonExecutorsBL] ([ExecutorID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PersonID] ON [dbo].[r_PersonExecutorsBL] ([PersonID]) ON [PRIMARY]
GO
