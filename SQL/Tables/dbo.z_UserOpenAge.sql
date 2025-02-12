CREATE TABLE [dbo].[z_UserOpenAge] (
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
  CONSTRAINT [pk_z_UserOpenAge] PRIMARY KEY CLUSTERED ([OurID], [UserID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[GMSUserOpenAge_UD] ON [z_UserOpenAge]FOR DELETE, UPDATE AS  IF @@ROWCOUNT = 0 RETURN  DECLARE    @ChDate smalldatetime,    @UserCode int  SELECT    @ChDate = GETDATE(),    @UserCode = dbo.zf_GetUserCode()  SET NOCOUNT ON  DELETE h FROM z_UserOpenAgeH h JOIN DELETED d ON h.OurID = d.OurID AND h.UserID = d.UserID AND h.ChDate = @ChDate  INSERT INTO z_UserOpenAgeH (    OurID, UserID, UseOpenAge, BDate, EDate, OpenAgeBType, OpenAgeEType, OpenAgeBQty, OpenAgeEQty, ChUserID, ChDate )  SELECT    OurID, UserID, UseOpenAge, BDate, EDate, OpenAgeBType, OpenAgeEType, OpenAgeBQty, OpenAgeEQty, ChUserID, @ChDate  FROM DELETED
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_UserOpenAge] ON [z_UserOpenAge]
FOR INSERT AS
/* z_UserOpenAge - Открытый период: Пользователи - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserOpenAge ^ r_Ours - Проверка в PARENT */
/* Открытый период: Пользователи ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_UserOpenAge', 0
      RETURN
    END

/* z_UserOpenAge ^ r_Users - Проверка в PARENT */
/* Открытый период: Пользователи ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserOpenAge', 0
      RETURN
    END

/* z_UserOpenAge ^ r_Users - Проверка в PARENT */
/* Открытый период: Пользователи ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChUserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserOpenAge', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_UserOpenAge', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_UserOpenAge] ON [z_UserOpenAge]
FOR UPDATE AS
/* z_UserOpenAge - Открытый период: Пользователи - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserOpenAge ^ r_Ours - Проверка в PARENT */
/* Открытый период: Пользователи ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'z_UserOpenAge', 1
        RETURN
      END

/* z_UserOpenAge ^ r_Users - Проверка в PARENT */
/* Открытый период: Пользователи ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_UserOpenAge', 1
        RETURN
      END

/* z_UserOpenAge ^ r_Users - Проверка в PARENT */
/* Открытый период: Пользователи ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(ChUserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChUserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_UserOpenAge', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_UserOpenAge', N'Last', N'UPDATE'
GO