CREATE TABLE [dbo].[z_OpenAge] (
  [OurID] [int] NOT NULL,
  [BDate] [smalldatetime] NOT NULL,
  [EDate] [smalldatetime] NOT NULL,
  [OpenAgeBType] [tinyint] NOT NULL,
  [OpenAgeEType] [tinyint] NOT NULL,
  [OpenAgeBQty] [smallint] NOT NULL,
  [OpenAgeEQty] [smallint] NOT NULL,
  [ChUserID] [smallint] NULL,
  CONSTRAINT [pk_z_OpenAge] PRIMARY KEY CLUSTERED ([OurID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[GMSOpenAge_UD] ON [z_OpenAge]FOR DELETE, UPDATE AS  IF @@ROWCOUNT = 0 RETURN  DECLARE @ChDate smalldatetime  SELECT @ChDate = GETDATE()  SET NOCOUNT ON  DELETE h FROM z_OpenAgeH h JOIN DELETED d ON h.OurID = d.OurID AND h.ChDate = @ChDate  INSERT INTO z_OpenAgeH (    OurID, BDate, EDate, OpenAgeBType, OpenAgeEType, OpenAgeBQty, OpenAgeEQty, ChUserID, ChDate )  SELECT    OurID, BDate, EDate, OpenAgeBType, OpenAgeEType, OpenAgeBQty, OpenAgeEQty, ChUserID, @ChDate  FROM DELETED
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_OpenAge] ON [z_OpenAge]
FOR INSERT AS
/* z_OpenAge - Открытый период: Фирмы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_OpenAge ^ r_Ours - Проверка в PARENT */
/* Открытый период: Фирмы ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_OpenAge', 0
      RETURN
    END

/* z_OpenAge ^ r_Users - Проверка в PARENT */
/* Открытый период: Фирмы ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChUserID IS NOT NULL AND i.ChUserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_OpenAge', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_OpenAge', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_OpenAge] ON [z_OpenAge]
FOR UPDATE AS
/* z_OpenAge - Открытый период: Фирмы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_OpenAge ^ r_Ours - Проверка в PARENT */
/* Открытый период: Фирмы ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'z_OpenAge', 1
        RETURN
      END

/* z_OpenAge ^ r_Users - Проверка в PARENT */
/* Открытый период: Фирмы ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(ChUserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChUserID IS NOT NULL AND i.ChUserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_OpenAge', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_OpenAge', N'Last', N'UPDATE'
GO