CREATE TABLE [dbo].[z_UserOpenAgeH]
(
[OurID] [int] NOT NULL,
[UserID] [smallint] NOT NULL,
[UseOpenAge] [bit] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[OpenAgeBType] [tinyint] NOT NULL,
[OpenAgeEType] [tinyint] NOT NULL,
[OpenAgeBQty] [smallint] NOT NULL,
[OpenAgeEQty] [smallint] NOT NULL,
[ChUserID] [smallint] NOT NULL,
[ChDate] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_UserOpenAgeH] ON [dbo].[z_UserOpenAgeH]
FOR INSERT AS
/* z_UserOpenAgeH - Открытый период: Пользователи: История - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserOpenAgeH ^ r_Ours - Проверка в PARENT */
/* Открытый период: Пользователи: История ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_UserOpenAgeH', 0
      RETURN
    END

/* z_UserOpenAgeH ^ r_Users - Проверка в PARENT */
/* Открытый период: Пользователи: История ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserOpenAgeH', 0
      RETURN
    END

/* z_UserOpenAgeH ^ r_Users - Проверка в PARENT */
/* Открытый период: Пользователи: История ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChUserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserOpenAgeH', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_UserOpenAgeH]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_UserOpenAgeH] ON [dbo].[z_UserOpenAgeH]
FOR UPDATE AS
/* z_UserOpenAgeH - Открытый период: Пользователи: История - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserOpenAgeH ^ r_Ours - Проверка в PARENT */
/* Открытый период: Пользователи: История ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'z_UserOpenAgeH', 1
        RETURN
      END

/* z_UserOpenAgeH ^ r_Users - Проверка в PARENT */
/* Открытый период: Пользователи: История ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_UserOpenAgeH', 1
        RETURN
      END

/* z_UserOpenAgeH ^ r_Users - Проверка в PARENT */
/* Открытый период: Пользователи: История ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(ChUserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChUserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_UserOpenAgeH', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_UserOpenAgeH]', 'last', 'update', null
GO
ALTER TABLE [dbo].[z_UserOpenAgeH] ADD CONSTRAINT [pk_z_UserOpenAgeH] PRIMARY KEY CLUSTERED ([OurID], [UserID], [ChDate]) ON [PRIMARY]
GO
