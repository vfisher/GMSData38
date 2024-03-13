CREATE TABLE [dbo].[z_WCopyU]
(
[CopyID] [int] NOT NULL,
[SrcDocType] [int] NOT NULL,
[UserID] [smallint] NOT NULL,
[DataType] [tinyint] NOT NULL DEFAULT ((1)),
[ParamPosID] [int] NOT NULL DEFAULT ((0)),
[ParamDesc] [varchar] (250) NULL,
[ParamEExp] [varchar] (250) NULL,
[ParamRExp] [varchar] (250) NULL,
[AskParam] [bit] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_WCopyU] ADD CONSTRAINT [pk_z_WCopyU] PRIMARY KEY NONCLUSTERED ([CopyID], [SrcDocType], [UserID], [ParamPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CopyID] ON [dbo].[z_WCopyU] ([CopyID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[z_WCopyU] ([UserID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyU].[CopyID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyU].[SrcDocType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyU].[UserID]'
GO
