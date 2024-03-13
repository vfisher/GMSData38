CREATE TABLE [dbo].[v_MapSG]
(
[RepID] [int] NOT NULL,
[SourceGrName] [varchar] (250) NOT NULL,
[SourceID] [smallint] NOT NULL,
[ReverseSign] [bit] NOT NULL,
[UseSourceGrName] [bit] NOT NULL,
[RangeType] [tinyint] NOT NULL,
[SQLStr] [varchar] (8000) NULL,
[LFilter] [varchar] (1000) NULL,
[EFilter] [varchar] (1000) NULL,
[LHaving] [varchar] (1000) NULL,
[EHaving] [varchar] (1000) NULL,
[ObjectDef] [text] NULL,
[RangeValue] [bigint] NOT NULL CONSTRAINT [DF__v_MapSG__RangeVa__3B266106] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_MapSG] ADD CONSTRAINT [_pk_v_MapSG] PRIMARY KEY CLUSTERED ([RepID], [SourceGrName], [SourceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RepID] ON [dbo].[v_MapSG] ([RepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [v_SourceGrsv_MapSG] ON [dbo].[v_MapSG] ([RepID], [SourceGrName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [v_Sourcesv_MapSG] ON [dbo].[v_MapSG] ([RepID], [SourceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SourceID] ON [dbo].[v_MapSG] ([SourceID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_MapSG].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_MapSG].[SourceID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_MapSG].[ReverseSign]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_MapSG].[UseSourceGrName]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_MapSG].[RangeType]'
GO
