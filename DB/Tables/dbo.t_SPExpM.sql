CREATE TABLE [dbo].[t_SPExpM]
(
[ChID] [bigint] NOT NULL,
[CostCodeID1] [smallint] NOT NULL,
[CostCodeID2] [smallint] NOT NULL,
[CostCodeID3] [smallint] NOT NULL,
[CostCodeID4] [smallint] NOT NULL,
[CostCodeID5] [smallint] NOT NULL,
[CostSumCC] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_SPExpM] ADD CONSTRAINT [_pk_t_SPExpM] PRIMARY KEY CLUSTERED ([ChID], [CostCodeID1], [CostCodeID2], [CostCodeID3], [CostCodeID4], [CostCodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[t_SPExpM] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CostCodeID1] ON [dbo].[t_SPExpM] ([CostCodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CostCodeID2] ON [dbo].[t_SPExpM] ([CostCodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CostCodeID3] ON [dbo].[t_SPExpM] ([CostCodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CostCodeID4] ON [dbo].[t_SPExpM] ([CostCodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CostCodeID5] ON [dbo].[t_SPExpM] ([CostCodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CostSumCC] ON [dbo].[t_SPExpM] ([CostSumCC]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpM].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpM].[CostCodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpM].[CostCodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpM].[CostCodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpM].[CostCodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpM].[CostCodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpM].[CostSumCC]'
GO
