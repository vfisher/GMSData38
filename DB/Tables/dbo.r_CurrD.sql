CREATE TABLE [dbo].[r_CurrD]
(
[CurrID] [smallint] NOT NULL,
[NomValue] [int] NOT NULL,
[Picture] [image] NULL,
[Visible] [bit] NOT NULL,
[AskPwdBanknote] [bit] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CurrD] ON [dbo].[r_CurrD]
FOR INSERT AS
/* r_CurrD - Справочник валют: купюры - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CurrD ^ r_Currs - Проверка в PARENT */
/* Справочник валют: купюры ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'r_CurrD', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_CurrD]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CurrD] ON [dbo].[r_CurrD]
FOR UPDATE AS
/* r_CurrD - Справочник валют: купюры - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CurrD ^ r_Currs - Проверка в PARENT */
/* Справочник валют: купюры ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'r_CurrD', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_CurrD]', 'last', 'update', null
GO
ALTER TABLE [dbo].[r_CurrD] ADD CONSTRAINT [pk_r_CurrD] PRIMARY KEY CLUSTERED ([CurrID], [NomValue]) ON [PRIMARY]
GO
