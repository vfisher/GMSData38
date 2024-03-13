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
