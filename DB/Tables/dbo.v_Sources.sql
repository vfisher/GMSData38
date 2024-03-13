CREATE TABLE [dbo].[v_Sources]
(
[RepID] [int] NOT NULL,
[SourceID] [smallint] NOT NULL,
[SourceName] [varchar] (250) NOT NULL,
[DocCode] [int] NOT NULL,
[SourceType] [int] NOT NULL DEFAULT (0),
[ObjectDef] [text] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_Sources] ADD CONSTRAINT [_pk_v_Sources] PRIMARY KEY CLUSTERED ([RepID], [SourceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCode] ON [dbo].[v_Sources] ([DocCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RepID] ON [dbo].[v_Sources] ([RepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NoDuplicates] ON [dbo].[v_Sources] ([RepID], [SourceName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SourceID] ON [dbo].[v_Sources] ([SourceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SourceName] ON [dbo].[v_Sources] ([SourceName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_Sources] ADD CONSTRAINT [FK_v_Sources_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Sources].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Sources].[SourceID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Sources].[DocCode]'
GO
