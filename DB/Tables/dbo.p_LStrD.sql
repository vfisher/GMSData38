CREATE TABLE [dbo].[p_LStrD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[DepID] [smallint] NOT NULL,
[PostID] [int] NOT NULL,
[EmpCount] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_LStrD] ADD CONSTRAINT [_pk_p_LStrD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[p_LStrD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DepID] ON [dbo].[p_LStrD] ([DepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PostID] ON [dbo].[p_LStrD] ([PostID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LStrD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LStrD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LStrD].[DepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LStrD].[PostID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LStrD].[EmpCount]'
GO
