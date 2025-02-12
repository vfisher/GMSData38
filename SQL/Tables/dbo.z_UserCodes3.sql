CREATE TABLE [dbo].[z_UserCodes3] (
  [UserID] [smallint] NOT NULL,
  [CodeID3] [smallint] NOT NULL,
  [AccRead] [tinyint] NOT NULL DEFAULT (0),
  [AccInsert] [tinyint] NOT NULL DEFAULT (0),
  [AccUpdate] [tinyint] NOT NULL DEFAULT (0),
  [AccDelete] [tinyint] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_z_UserCodes3] PRIMARY KEY CLUSTERED ([UserID], [CodeID3])
)
ON [PRIMARY]
GO

CREATE INDEX [AccDelete]
  ON [dbo].[z_UserCodes3] ([AccDelete])
  ON [PRIMARY]
GO

CREATE INDEX [AccInsert]
  ON [dbo].[z_UserCodes3] ([AccInsert])
  ON [PRIMARY]
GO

CREATE INDEX [AccRead]
  ON [dbo].[z_UserCodes3] ([AccRead])
  ON [PRIMARY]
GO

CREATE INDEX [AccUpdate]
  ON [dbo].[z_UserCodes3] ([AccUpdate])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID3]
  ON [dbo].[z_UserCodes3] ([CodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [UserID]
  ON [dbo].[z_UserCodes3] ([UserID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_UserCodes3] ON [z_UserCodes3]
FOR INSERT AS
/* z_UserCodes3 - Доступные значения - Справочник признаков 3 - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserCodes3 ^ r_Codes3 - Проверка в PARENT */
/* Доступные значения - Справочник признаков 3 ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'z_UserCodes3', 0
      RETURN
    END

/* z_UserCodes3 ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник признаков 3 ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserCodes3', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_UserCodes3', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_UserCodes3] ON [z_UserCodes3]
FOR UPDATE AS
/* z_UserCodes3 - Доступные значения - Справочник признаков 3 - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserCodes3 ^ r_Codes3 - Проверка в PARENT */
/* Доступные значения - Справочник признаков 3 ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'z_UserCodes3', 1
        RETURN
      END

/* z_UserCodes3 ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник признаков 3 ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_UserCodes3', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_UserCodes3', N'Last', N'UPDATE'
GO