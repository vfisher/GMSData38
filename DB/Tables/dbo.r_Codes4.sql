CREATE TABLE [dbo].[r_Codes4]
(
[ChID] [bigint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeName4] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Codes4] ADD CONSTRAINT [pk_r_Codes4] PRIMARY KEY CLUSTERED ([CodeID4]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Codes4] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CodeName4] ON [dbo].[r_Codes4] ([CodeName4]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Codes4].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Codes4].[CodeID4]'
GO
