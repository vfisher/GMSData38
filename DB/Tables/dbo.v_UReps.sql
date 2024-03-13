CREATE TABLE [dbo].[v_UReps]
(
[RepID] [int] NOT NULL,
[UserID] [smallint] NOT NULL,
[BDate] [smalldatetime] NULL,
[EDate] [smalldatetime] NULL,
[DataWidth] [int] NULL,
[RowHeight] [int] NULL,
[Processors] [tinyint] NOT NULL,
[FromLeft] [smallint] NOT NULL,
[FromTop] [smallint] NOT NULL,
[Width] [int] NOT NULL,
[Height] [smallint] NOT NULL,
[WindowState] [tinyint] NOT NULL,
[GrandCols] [bit] NOT NULL,
[GrandRows] [bit] NOT NULL,
[AlwaysPrepare] [bit] NOT NULL,
[Optimization] [int] NULL,
[TempTable] [bit] NOT NULL,
[FilterOnOpen] [bit] NOT NULL,
[FilterOnPrepare] [bit] NULL,
[DateField] [varchar] (250) NULL,
[RepNotesOpen] [bit] NOT NULL,
[AzPrepareTime] [varchar] (250) NULL,
[TotalTime] [varchar] (250) NULL,
[LastOpen] [varchar] (250) NULL,
[OpenCount] [int] NOT NULL,
[SendError] [bit] NOT NULL DEFAULT (0),
[VerID] [int] NOT NULL DEFAULT (1),
[VerDateTime] [smalldatetime] NULL,
[VerName] [varchar] (200) NULL,
[FixCols] [bit] NOT NULL DEFAULT (0),
[FixRows] [bit] NOT NULL DEFAULT (1),
[ObjectDef] [text] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_UReps] ADD CONSTRAINT [pk_v_UReps] PRIMARY KEY CLUSTERED ([RepID], [UserID], [VerID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RepID] ON [dbo].[v_UReps] ([RepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[v_UReps] ([UserID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_UReps] ADD CONSTRAINT [FK_v_UReps_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UReps].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UReps].[UserID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UReps].[DataWidth]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UReps].[RowHeight]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UReps].[Processors]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UReps].[FromLeft]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UReps].[FromTop]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UReps].[Width]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UReps].[Height]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UReps].[WindowState]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UReps].[GrandCols]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UReps].[GrandRows]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UReps].[AlwaysPrepare]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UReps].[Optimization]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UReps].[TempTable]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UReps].[FilterOnOpen]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UReps].[FilterOnPrepare]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UReps].[RepNotesOpen]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UReps].[OpenCount]'
GO
