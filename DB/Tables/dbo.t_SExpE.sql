CREATE TABLE [dbo].[t_SExpE]
(
[AChID] [bigint] NOT NULL,
[SetCodeID1] [smallint] NOT NULL,
[SetCodeID2] [smallint] NOT NULL,
[SetCodeID3] [smallint] NOT NULL,
[SetCodeID4] [smallint] NOT NULL,
[SetCodeID5] [smallint] NOT NULL,
[SetSumCC] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_SExpE] ADD CONSTRAINT [_pk_t_SExpE] PRIMARY KEY CLUSTERED ([AChID], [SetCodeID1], [SetCodeID2], [SetCodeID3], [SetCodeID4], [SetCodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[t_SExpE] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SetCodeID1] ON [dbo].[t_SExpE] ([SetCodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SetCodeID2] ON [dbo].[t_SExpE] ([SetCodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SetCodeID3] ON [dbo].[t_SExpE] ([SetCodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SetCodeID4] ON [dbo].[t_SExpE] ([SetCodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SetCodeID5] ON [dbo].[t_SExpE] ([SetCodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SetSumCC] ON [dbo].[t_SExpE] ([SetSumCC]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpE].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpE].[SetCodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpE].[SetCodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpE].[SetCodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpE].[SetCodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpE].[SetCodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpE].[SetSumCC]'
GO
