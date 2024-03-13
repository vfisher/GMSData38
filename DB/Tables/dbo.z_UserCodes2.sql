CREATE TABLE [dbo].[z_UserCodes2]
(
[UserID] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[AccRead] [tinyint] NOT NULL DEFAULT (0),
[AccInsert] [tinyint] NOT NULL DEFAULT (0),
[AccUpdate] [tinyint] NOT NULL DEFAULT (0),
[AccDelete] [tinyint] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_UserCodes2] ON [dbo].[z_UserCodes2]
FOR INSERT AS
/* z_UserCodes2 - Доступные значения - Справочник признаков 2 - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserCodes2 ^ r_Codes2 - Проверка в PARENT */
/* Доступные значения - Справочник признаков 2 ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'z_UserCodes2', 0
      RETURN
    END

/* z_UserCodes2 ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник признаков 2 ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserCodes2', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_UserCodes2]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_UserCodes2] ON [dbo].[z_UserCodes2]
FOR UPDATE AS
/* z_UserCodes2 - Доступные значения - Справочник признаков 2 - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserCodes2 ^ r_Codes2 - Проверка в PARENT */
/* Доступные значения - Справочник признаков 2 ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'z_UserCodes2', 1
        RETURN
      END

/* z_UserCodes2 ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник признаков 2 ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_UserCodes2', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_UserCodes2]', 'last', 'update', null
GO
ALTER TABLE [dbo].[z_UserCodes2] ADD CONSTRAINT [pk_z_UserCodes2] PRIMARY KEY CLUSTERED ([UserID], [CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccDelete] ON [dbo].[z_UserCodes2] ([AccDelete]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccInsert] ON [dbo].[z_UserCodes2] ([AccInsert]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccRead] ON [dbo].[z_UserCodes2] ([AccRead]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccUpdate] ON [dbo].[z_UserCodes2] ([AccUpdate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[z_UserCodes2] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[z_UserCodes2] ([UserID]) ON [PRIMARY]
GO
