CREATE TABLE [dbo].[z_OpenAgeH] (
  [OurID] [int] NOT NULL,
  [BDate] [smalldatetime] NOT NULL,
  [EDate] [smalldatetime] NOT NULL,
  [OpenAgeBType] [tinyint] NOT NULL,
  [OpenAgeEType] [tinyint] NOT NULL,
  [OpenAgeBQty] [smallint] NOT NULL,
  [OpenAgeEQty] [smallint] NOT NULL,
  [ChUserID] [smallint] NOT NULL,
  [ChDate] [smalldatetime] NOT NULL,
  CONSTRAINT [pk_z_OpenAgeH] PRIMARY KEY CLUSTERED ([OurID], [ChDate])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_OpenAgeH] ON [z_OpenAgeH]
FOR INSERT AS
/* z_OpenAgeH - Открытый период: Фирмы: История - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_OpenAgeH ^ r_Ours - Проверка в PARENT */
/* Открытый период: Фирмы: История ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_OpenAgeH', 0
      RETURN
    END

/* z_OpenAgeH ^ r_Users - Проверка в PARENT */
/* Открытый период: Фирмы: История ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChUserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_OpenAgeH', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_OpenAgeH', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_OpenAgeH] ON [z_OpenAgeH]
FOR UPDATE AS
/* z_OpenAgeH - Открытый период: Фирмы: История - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_OpenAgeH ^ r_Ours - Проверка в PARENT */
/* Открытый период: Фирмы: История ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'z_OpenAgeH', 1
        RETURN
      END

/* z_OpenAgeH ^ r_Users - Проверка в PARENT */
/* Открытый период: Фирмы: История ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(ChUserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChUserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_OpenAgeH', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_OpenAgeH', N'Last', N'UPDATE'
GO