CREATE TABLE [dbo].[z_DataSets]
(
[DSCode] [int] NOT NULL,
[DSName] [varchar] (250) NOT NULL,
[DocCode] [int] NOT NULL,
[TableCode] [int] NOT NULL DEFAULT (0),
[PageIndex] [int] NOT NULL,
[PageName] [varchar] (250) NOT NULL,
[PageStyle] [int] NOT NULL DEFAULT (0),
[PageVisible] [bit] NOT NULL DEFAULT (1),
[SQLStr] [varchar] (8000) NULL,
[SQLType] [int] NOT NULL,
[IntName] [varchar] (250) NULL,
[SortFields] [varchar] (250) NULL,
[IntFilter] [varchar] (250) NULL,
[OpenFilter] [varchar] (250) NULL,
[FilterBeforeOpen] [bit] NOT NULL DEFAULT (0),
[IsDefault] [bit] NOT NULL DEFAULT (0),
[MasterSource] [varchar] (250) NULL,
[MasterFields] [varchar] (250) NULL,
[ReadOnly] [bit] NOT NULL DEFAULT (0),
[UserCode] [smallint] NOT NULL DEFAULT (0),
[AFColCount] [tinyint] NOT NULL DEFAULT (0),
[DSLevel] [int] NOT NULL DEFAULT (0),
[ColWidth] [int] NOT NULL DEFAULT (0),
[DescWidth] [int] NOT NULL DEFAULT (0),
[PageHeight] [int] NOT NULL DEFAULT (0),
[AFCodeWidth] [int] NOT NULL,
[OptimizeData] [bit] NOT NULL DEFAULT ((0)),
[LockMode] [tinyint] NOT NULL DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_DataSets] ADD CONSTRAINT [pk_z_DataSets] PRIMARY KEY CLUSTERED ([DSCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniquePageIndex] ON [dbo].[z_DataSets] ([DocCode], [PageIndex], [UserCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniquePageName] ON [dbo].[z_DataSets] ([DocCode], [PageName], [UserCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DSName] ON [dbo].[z_DataSets] ([DSName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_DataSets] ADD CONSTRAINT [FK_z_DataSets_r_Users] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[r_Users] ([UserID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_DataSets] ADD CONSTRAINT [FK_z_DataSets_z_Tables] FOREIGN KEY ([TableCode]) REFERENCES [dbo].[z_Tables] ([TableCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
