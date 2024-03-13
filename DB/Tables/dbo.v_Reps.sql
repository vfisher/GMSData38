CREATE TABLE [dbo].[v_Reps]
(
[RepID] [int] NOT NULL,
[RepName] [varchar] (250) NOT NULL,
[RepInfo] [varchar] (250) NULL,
[Creator] [varchar] (250) NOT NULL,
[Created] [smalldatetime] NOT NULL,
[Changer] [varchar] (250) NULL,
[Changed] [smalldatetime] NULL,
[RepGrID] [smallint] NOT NULL,
[BDate] [smalldatetime] NULL,
[EDate] [smalldatetime] NULL,
[DataWidth] [int] NULL,
[RowHeight] [int] NULL,
[Processors] [tinyint] NOT NULL,
[DateField] [varchar] (250) NULL,
[GrandCols] [bit] NOT NULL,
[GrandRows] [bit] NOT NULL,
[AlwaysPrepare] [bit] NOT NULL,
[Optimization] [int] NULL,
[TempTable] [bit] NOT NULL,
[FilterOnOpen] [bit] NOT NULL,
[FilterOnPrepare] [bit] NULL,
[IsReady] [bit] NOT NULL,
[RepNotes] [text] NULL,
[RepNotesOpen] [bit] NOT NULL,
[RepNotesEdit] [bit] NOT NULL,
[SendError] [bit] NOT NULL DEFAULT (0),
[FilterValid] [bit] NOT NULL DEFAULT (0),
[PrintFontName] [varchar] (250) NULL,
[PrintFontSize] [int] NOT NULL DEFAULT (0),
[PrintLandscape] [bit] NULL DEFAULT (0),
[ObjectDef] [text] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_Reps] ADD CONSTRAINT [_pk_v_Reps] PRIMARY KEY CLUSTERED ([RepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RepGrID] ON [dbo].[v_Reps] ([RepGrID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [RepName] ON [dbo].[v_Reps] ([RepName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_Reps] ADD CONSTRAINT [FK_v_Reps_v_RepGrs] FOREIGN KEY ([RepGrID]) REFERENCES [dbo].[v_RepGrs] ([RepGrID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Reps].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Reps].[RepGrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Reps].[DataWidth]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Reps].[RowHeight]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Reps].[Processors]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Reps].[GrandCols]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Reps].[GrandRows]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Reps].[AlwaysPrepare]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Reps].[Optimization]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Reps].[TempTable]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Reps].[FilterOnOpen]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Reps].[FilterOnPrepare]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Reps].[IsReady]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Reps].[RepNotesOpen]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Reps].[RepNotesEdit]'
GO
