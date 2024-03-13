CREATE TABLE [dbo].[r_PersonResourcesBL]
(
[PersonID] [bigint] NOT NULL,
[ResourceID] [int] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_PersonResourcesBL] ON [dbo].[r_PersonResourcesBL]
FOR INSERT AS
/* r_PersonResourcesBL - Справочник персон - черный список ресурсов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PersonResourcesBL ^ r_Persons - Проверка в PARENT */
/* Справочник персон - черный список ресурсов ^ Справочник персон - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PersonID NOT IN (SELECT PersonID FROM r_Persons))
    BEGIN
      EXEC z_RelationError 'r_Persons', 'r_PersonResourcesBL', 0
      RETURN
    END

/* r_PersonResourcesBL ^ r_Resources - Проверка в PARENT */
/* Справочник персон - черный список ресурсов ^ Справочник ресурсов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ResourceID NOT IN (SELECT ResourceID FROM r_Resources))
    BEGIN
      EXEC z_RelationError 'r_Resources', 'r_PersonResourcesBL', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_PersonResourcesBL]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_PersonResourcesBL] ON [dbo].[r_PersonResourcesBL]
FOR UPDATE AS
/* r_PersonResourcesBL - Справочник персон - черный список ресурсов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PersonResourcesBL ^ r_Persons - Проверка в PARENT */
/* Справочник персон - черный список ресурсов ^ Справочник персон - Проверка в PARENT */
  IF UPDATE(PersonID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PersonID NOT IN (SELECT PersonID FROM r_Persons))
      BEGIN
        EXEC z_RelationError 'r_Persons', 'r_PersonResourcesBL', 1
        RETURN
      END

/* r_PersonResourcesBL ^ r_Resources - Проверка в PARENT */
/* Справочник персон - черный список ресурсов ^ Справочник ресурсов - Проверка в PARENT */
  IF UPDATE(ResourceID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ResourceID NOT IN (SELECT ResourceID FROM r_Resources))
      BEGIN
        EXEC z_RelationError 'r_Resources', 'r_PersonResourcesBL', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_PersonResourcesBL]', 'last', 'update', null
GO
ALTER TABLE [dbo].[r_PersonResourcesBL] ADD CONSTRAINT [pk_r_PersonResourcesBL] PRIMARY KEY CLUSTERED ([PersonID], [ResourceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PersonID] ON [dbo].[r_PersonResourcesBL] ([PersonID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ResourceID] ON [dbo].[r_PersonResourcesBL] ([ResourceID]) ON [PRIMARY]
GO
