CREATE TABLE [dbo].[z_AUGroups]
(
[AUGroupCode] [int] NOT NULL,
[AUGroupName] [varchar] (200) NOT NULL,
[SPName] [varchar] (50) NULL,
[FilterSPName] [varchar] (50) NULL,
[DateFilter] [bit] NOT NULL,
[SPType] [tinyint] NOT NULL,
[TableCode] [int] NOT NULL,
[FilterTableCode] [int] NOT NULL,
[GroupFields] [varchar] (250) NULL,
[TableDBO] [bit] NOT NULL,
[FilterTableDBO] [bit] NOT NULL,
[SrcTableCode] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_AUGroups] ADD CONSTRAINT [PK_z_AUGroups] PRIMARY KEY CLUSTERED ([AUGroupCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueName] ON [dbo].[z_AUGroups] ([AUGroupName]) ON [PRIMARY]
GO
