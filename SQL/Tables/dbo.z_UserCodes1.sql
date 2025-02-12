CREATE TABLE [dbo].[z_UserCodes1] (
  [UserID] [smallint] NOT NULL,
  [CodeID1] [smallint] NOT NULL,
  [AccRead] [tinyint] NOT NULL DEFAULT (0),
  [AccInsert] [tinyint] NOT NULL DEFAULT (0),
  [AccUpdate] [tinyint] NOT NULL DEFAULT (0),
  [AccDelete] [tinyint] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_z_UserCodes1] PRIMARY KEY CLUSTERED ([UserID], [CodeID1])
)
ON [PRIMARY]
GO

CREATE INDEX [AccDelete]
  ON [dbo].[z_UserCodes1] ([AccDelete])
  ON [PRIMARY]
GO

CREATE INDEX [AccInsert]
  ON [dbo].[z_UserCodes1] ([AccInsert])
  ON [PRIMARY]
GO

CREATE INDEX [AccRead]
  ON [dbo].[z_UserCodes1] ([AccRead])
  ON [PRIMARY]
GO

CREATE INDEX [AccUpdate]
  ON [dbo].[z_UserCodes1] ([AccUpdate])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID1]
  ON [dbo].[z_UserCodes1] ([CodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [UserID]
  ON [dbo].[z_UserCodes1] ([UserID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_UserCodes1] ON [z_UserCodes1]
FOR INSERT AS
/* z_UserCodes1 - Доступные значения - Справочник признаков 1 - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserCodes1 ^ r_Codes1 - Проверка в PARENT */
/* Доступные значения - Справочник признаков 1 ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'z_UserCodes1', 0
      RETURN
    END

/* z_UserCodes1 ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник признаков 1 ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserCodes1', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_UserCodes1', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_UserCodes1] ON [z_UserCodes1]
FOR UPDATE AS
/* z_UserCodes1 - Доступные значения - Справочник признаков 1 - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserCodes1 ^ r_Codes1 - Проверка в PARENT */
/* Доступные значения - Справочник признаков 1 ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'z_UserCodes1', 1
        RETURN
      END

/* z_UserCodes1 ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник признаков 1 ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_UserCodes1', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_UserCodes1', N'Last', N'UPDATE'
GO