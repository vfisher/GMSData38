CREATE TABLE [dbo].[z_WCopyP]
(
[CopyID] [int] NOT NULL,
[ParamPosID] [int] NOT NULL,
[ParamDesc] [varchar] (200) NOT NULL,
[ParamEExp] [varchar] (200) NOT NULL,
[ParamRExp] [varchar] (200) NOT NULL,
[AskParam] [bit] NOT NULL,
[DataType] [tinyint] NOT NULL DEFAULT (1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_WCopyP] ADD CONSTRAINT [_pk_z_WCopyP] PRIMARY KEY CLUSTERED ([CopyID], [ParamPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CopyID] ON [dbo].[z_WCopyP] ([CopyID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [NoDuplicate] ON [dbo].[z_WCopyP] ([CopyID], [ParamDesc]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyP].[CopyID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyP].[ParamPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyP].[AskParam]'
GO
