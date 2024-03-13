CREATE TABLE [dbo].[r_Codes5]
(
[ChID] [bigint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[CodeName5] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Codes5] ADD CONSTRAINT [pk_r_Codes5] PRIMARY KEY CLUSTERED ([CodeID5]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Codes5] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CodeName5] ON [dbo].[r_Codes5] ([CodeName5]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Codes5].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Codes5].[CodeID5]'
GO
