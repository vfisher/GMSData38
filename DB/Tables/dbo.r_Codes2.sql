CREATE TABLE [dbo].[r_Codes2]
(
[ChID] [bigint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeName2] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Codes2] ADD CONSTRAINT [pk_r_Codes2] PRIMARY KEY CLUSTERED ([CodeID2]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Codes2] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CodeName2] ON [dbo].[r_Codes2] ([CodeName2]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Codes2].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Codes2].[CodeID2]'
GO
