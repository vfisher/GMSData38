CREATE TABLE [dbo].[b_GViewD]
(
[ViewID] [int] NOT NULL,
[DimName] [varchar] (200) NOT NULL,
[DimCaption] [varchar] (200) NOT NULL,
[DimState] [tinyint] NOT NULL,
[DimLastState] [tinyint] NOT NULL,
[DimIndex] [tinyint] NOT NULL,
[DimSort] [tinyint] NOT NULL,
[DimLoc] [tinyint] NOT NULL,
[DimWidth] [smallint] NOT NULL,
[DimGroup] [tinyint] NOT NULL,
[DimGroupType] [tinyint] NULL,
[ParentCaption] [varchar] (200) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_GViewD] ON [dbo].[b_GViewD]
FOR INSERT AS
/* b_GViewD - Бухгалтерия: Виды отчетов (Данные) - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_GViewD ^ b_GView - Проверка в PARENT */
/* Бухгалтерия: Виды отчетов (Данные) ^ Бухгалтерия: Виды отчетов (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ViewID NOT IN (SELECT ViewID FROM b_GView))
    BEGIN
      EXEC z_RelationError 'b_GView', 'b_GViewD', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_b_GViewD]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_GViewD] ON [dbo].[b_GViewD]
FOR UPDATE AS
/* b_GViewD - Бухгалтерия: Виды отчетов (Данные) - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_GViewD ^ b_GView - Проверка в PARENT */
/* Бухгалтерия: Виды отчетов (Данные) ^ Бухгалтерия: Виды отчетов (Заголовок) - Проверка в PARENT */
  IF UPDATE(ViewID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ViewID NOT IN (SELECT ViewID FROM b_GView))
      BEGIN
        EXEC z_RelationError 'b_GView', 'b_GViewD', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_b_GViewD]', 'last', 'update', null
GO
ALTER TABLE [dbo].[b_GViewD] ADD CONSTRAINT [_pk_b_GViewD] PRIMARY KEY CLUSTERED ([ViewID], [DimName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DimCaption] ON [dbo].[b_GViewD] ([DimCaption]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DimGroup] ON [dbo].[b_GViewD] ([DimGroup]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DimIndex] ON [dbo].[b_GViewD] ([DimIndex]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DimLastState] ON [dbo].[b_GViewD] ([DimLastState]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DimLoc] ON [dbo].[b_GViewD] ([DimLoc]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DimName] ON [dbo].[b_GViewD] ([DimName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DimSort] ON [dbo].[b_GViewD] ([DimSort]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DimState] ON [dbo].[b_GViewD] ([DimState]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DimWidth] ON [dbo].[b_GViewD] ([DimWidth]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ParentCaption] ON [dbo].[b_GViewD] ([ParentCaption]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ViewID] ON [dbo].[b_GViewD] ([ViewID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewD].[ViewID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewD].[DimState]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewD].[DimLastState]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewD].[DimIndex]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewD].[DimSort]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewD].[DimLoc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewD].[DimWidth]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewD].[DimGroup]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewD].[DimGroupType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewD].[ViewID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewD].[DimState]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewD].[DimLastState]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewD].[DimIndex]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewD].[DimSort]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewD].[DimLoc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewD].[DimWidth]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewD].[DimGroup]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewD].[DimGroupType]'
GO
