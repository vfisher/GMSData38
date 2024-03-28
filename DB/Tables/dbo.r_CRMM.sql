CREATE TABLE [dbo].[r_CRMM]
(
[MPayDesc] [varchar] (200) NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[IsRec] [bit] NOT NULL,
[WPRoleID] [int] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CRMM] ADD CONSTRAINT [pk_r_CRMM] PRIMARY KEY CLUSTERED ([WPRoleID], [MPayDesc]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MPayDesc] ON [dbo].[r_CRMM] ([MPayDesc]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMM].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMM].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMM].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMM].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMM].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMM].[IsRec]'
GO
