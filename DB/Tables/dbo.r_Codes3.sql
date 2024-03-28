CREATE TABLE [dbo].[r_Codes3]
(
[ChID] [bigint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeName3] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Codes3] ADD CONSTRAINT [pk_r_Codes3] PRIMARY KEY CLUSTERED ([CodeID3]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Codes3] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CodeName3] ON [dbo].[r_Codes3] ([CodeName3]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Codes3].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Codes3].[CodeID3]'
GO
