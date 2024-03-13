CREATE TABLE [dbo].[r_BServParams]
(
[BServID] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[MaxPayPartsQty] [int] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[PProdFilter] [varchar] (4000) NULL,
[PCatFilter] [varchar] (4000) NULL,
[PGrFilter] [varchar] (4000) NULL,
[PGr1Filter] [varchar] (4000) NULL,
[PGr2Filter] [varchar] (4000) NULL,
[PGr3Filter] [varchar] (4000) NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_BServParams] ON [dbo].[r_BServParams]
FOR INSERT AS
/* r_BServParams - Справочник банковских услуг: параметры - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_BServParams ^ r_BServs - Проверка в PARENT */
/* Справочник банковских услуг: параметры ^ Справочник банковских услуг - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.BServID NOT IN (SELECT BServID FROM r_BServs))
    BEGIN
      EXEC z_RelationError 'r_BServs', 'r_BServParams', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_BServParams]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_BServParams] ON [dbo].[r_BServParams]
FOR UPDATE AS
/* r_BServParams - Справочник банковских услуг: параметры - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_BServParams ^ r_BServs - Проверка в PARENT */
/* Справочник банковских услуг: параметры ^ Справочник банковских услуг - Проверка в PARENT */
  IF UPDATE(BServID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.BServID NOT IN (SELECT BServID FROM r_BServs))
      BEGIN
        EXEC z_RelationError 'r_BServs', 'r_BServParams', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_BServParams]', 'last', 'update', null
GO
ALTER TABLE [dbo].[r_BServParams] ADD CHECK (([MaxPayPartsQty]>=(1) AND [MaxPayPartsQty]<=(25)))
GO
ALTER TABLE [dbo].[r_BServParams] ADD CONSTRAINT [pk_r_BServParams] PRIMARY KEY CLUSTERED ([BServID], [SrcPosID]) ON [PRIMARY]
GO
