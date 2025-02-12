CREATE TABLE [dbo].[z_UserCodes4] (
  [UserID] [smallint] NOT NULL,
  [CodeID4] [smallint] NOT NULL,
  [AccRead] [tinyint] NOT NULL DEFAULT (0),
  [AccInsert] [tinyint] NOT NULL DEFAULT (0),
  [AccUpdate] [tinyint] NOT NULL DEFAULT (0),
  [AccDelete] [tinyint] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_z_UserCodes4] PRIMARY KEY CLUSTERED ([UserID], [CodeID4])
)
ON [PRIMARY]
GO

CREATE INDEX [AccDelete]
  ON [dbo].[z_UserCodes4] ([AccDelete])
  ON [PRIMARY]
GO

CREATE INDEX [AccInsert]
  ON [dbo].[z_UserCodes4] ([AccInsert])
  ON [PRIMARY]
GO

CREATE INDEX [AccRead]
  ON [dbo].[z_UserCodes4] ([AccRead])
  ON [PRIMARY]
GO

CREATE INDEX [AccUpdate]
  ON [dbo].[z_UserCodes4] ([AccUpdate])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID4]
  ON [dbo].[z_UserCodes4] ([CodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [UserID]
  ON [dbo].[z_UserCodes4] ([UserID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_UserCodes4] ON [z_UserCodes4]
FOR INSERT AS
/* z_UserCodes4 - Доступные значения - Справочник признаков 4 - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserCodes4 ^ r_Codes4 - Проверка в PARENT */
/* Доступные значения - Справочник признаков 4 ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'z_UserCodes4', 0
      RETURN
    END

/* z_UserCodes4 ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник признаков 4 ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserCodes4', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_UserCodes4', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_UserCodes4] ON [z_UserCodes4]
FOR UPDATE AS
/* z_UserCodes4 - Доступные значения - Справочник признаков 4 - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserCodes4 ^ r_Codes4 - Проверка в PARENT */
/* Доступные значения - Справочник признаков 4 ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'z_UserCodes4', 1
        RETURN
      END

/* z_UserCodes4 ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник признаков 4 ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_UserCodes4', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_UserCodes4', N'Last', N'UPDATE'
GO