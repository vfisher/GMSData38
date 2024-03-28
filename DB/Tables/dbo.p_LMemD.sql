CREATE TABLE [dbo].[p_LMemD]
(
[ChID] [bigint] NOT NULL,
[SubID] [smallint] NOT NULL,
[PostID] [int] NOT NULL,
[VacTotal] [numeric] (21, 9) NOT NULL,
[VacOcc] [numeric] (21, 9) NOT NULL,
[SrcPosID] [int] NOT NULL,
[BSalary] [numeric] (21, 9) NOT NULL DEFAULT (0),
[BExtraSalary] [numeric] (21, 9) NOT NULL DEFAULT (0),
[DepID] [smallint] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_LMemD] ADD CONSTRAINT [pk_p_LMemD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[p_LMemD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DepID] ON [dbo].[p_LMemD] ([DepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PostID] ON [dbo].[p_LMemD] ([PostID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubID] ON [dbo].[p_LMemD] ([SubID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LMemD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LMemD].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LMemD].[PostID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LMemD].[VacTotal]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LMemD].[VacOcc]'
GO
