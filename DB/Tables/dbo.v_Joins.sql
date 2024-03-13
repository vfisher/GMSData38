CREATE TABLE [dbo].[v_Joins]
(
[RepID] [int] NOT NULL,
[SourceID] [smallint] NOT NULL,
[TableCode] [int] NOT NULL,
[JoinFields] [varchar] (250) NOT NULL,
[ParentCode] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_Joins] ADD CONSTRAINT [_pk_v_Joins] PRIMARY KEY CLUSTERED ([RepID], [SourceID], [ParentCode], [TableCode], [JoinFields]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [v_Sourcesv_Joins] ON [dbo].[v_Joins] ([RepID], [SourceID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_Joins] ADD CONSTRAINT [FK_v_Joins_v_Sources] FOREIGN KEY ([RepID], [SourceID]) REFERENCES [dbo].[v_Sources] ([RepID], [SourceID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Joins].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Joins].[SourceID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Joins].[TableCode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Joins].[ParentCode]'
GO
