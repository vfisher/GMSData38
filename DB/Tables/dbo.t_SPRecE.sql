CREATE TABLE [dbo].[t_SPRecE]
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
ALTER TABLE [dbo].[t_SPRecE] ADD CONSTRAINT [_pk_t_SPRecE] PRIMARY KEY CLUSTERED ([AChID], [SetCodeID1], [SetCodeID2], [SetCodeID3], [SetCodeID4], [SetCodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[t_SPRecE] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SetCodeID1] ON [dbo].[t_SPRecE] ([SetCodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SetCodeID2] ON [dbo].[t_SPRecE] ([SetCodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SetCodeID3] ON [dbo].[t_SPRecE] ([SetCodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SetCodeID4] ON [dbo].[t_SPRecE] ([SetCodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SetCodeID5] ON [dbo].[t_SPRecE] ([SetCodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SetSumCC] ON [dbo].[t_SPRecE] ([SetSumCC]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecE].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecE].[SetCodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecE].[SetCodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecE].[SetCodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecE].[SetCodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecE].[SetCodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecE].[SetSumCC]'
GO
