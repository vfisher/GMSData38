CREATE TABLE [dbo].[t_SPRecM]
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
ALTER TABLE [dbo].[t_SPRecM] ADD CONSTRAINT [_pk_t_SPRecM] PRIMARY KEY CLUSTERED ([ChID], [CostCodeID1], [CostCodeID2], [CostCodeID3], [CostCodeID4], [CostCodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[t_SPRecM] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CostCodeID1] ON [dbo].[t_SPRecM] ([CostCodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CostCodeID2] ON [dbo].[t_SPRecM] ([CostCodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CostCodeID3] ON [dbo].[t_SPRecM] ([CostCodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CostCodeID4] ON [dbo].[t_SPRecM] ([CostCodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CostCodeID5] ON [dbo].[t_SPRecM] ([CostCodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CostSumCC] ON [dbo].[t_SPRecM] ([CostSumCC]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecM].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecM].[CostCodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecM].[CostCodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecM].[CostCodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecM].[CostCodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecM].[CostCodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecM].[CostSumCC]'
GO
