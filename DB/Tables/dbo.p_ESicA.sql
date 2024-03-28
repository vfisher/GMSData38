CREATE TABLE [dbo].[p_ESicA]
(
[ChID] [bigint] NOT NULL,
[DetSrcDate] [smalldatetime] NOT NULL,
[DetTillFiveSumCC] [numeric] (21, 9) NOT NULL,
[DetAfterFiveSumCC] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_ESicA] ADD CONSTRAINT [_pk_p_ESicA] PRIMARY KEY CLUSTERED ([ChID], [DetSrcDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[p_ESicA] ([ChID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESicA].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESicA].[DetTillFiveSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESicA].[DetAfterFiveSumCC]'
GO
