CREATE TABLE [dbo].[r_Codes1]
(
[ChID] [bigint] NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeName1] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Codes1] ADD CONSTRAINT [pk_r_Codes1] PRIMARY KEY CLUSTERED ([CodeID1]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Codes1] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CodeName1] ON [dbo].[r_Codes1] ([CodeName1]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Codes1].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Codes1].[CodeID1]'
GO
