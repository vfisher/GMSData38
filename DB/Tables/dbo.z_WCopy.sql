CREATE TABLE [dbo].[z_WCopy]
(
[CopyID] [int] NOT NULL,
[CopyName] [varchar] (200) NOT NULL,
[CopyDesc] [varchar] (200) NULL,
[SrcDocType] [int] NOT NULL,
[DstDocType] [int] NOT NULL,
[IsSaved] [bit] NOT NULL,
[IsChange] [bit] NOT NULL,
[IsAutoChange] [bit] NOT NULL,
[StartDesc1] [varchar] (200) NULL,
[StartDesc2] [varchar] (200) NULL,
[DBSourceMode] [tinyint] NOT NULL,
[DBServerName] [varchar] (200) NULL,
[DBBaseName] [varchar] (200) NULL,
[DBUserName] [varchar] (200) NULL,
[UseDisableControls] [bit] NOT NULL,
[UseMasterField] [bit] NOT NULL,
[MarkCopyInBKeep] [bit] NOT NULL,
[UpdateStatID] [bit] NOT NULL,
[ScBeforeRun] [text] NULL,
[ScAfterRun] [text] NULL,
[AllowUpdateStateCode] [bit] NOT NULL,
[StateCode] [int] NOT NULL,
[LinkDocs] [bit] NOT NULL,
[SrcDocIsParent] [bit] NOT NULL,
[AllowLinkDocs] [bit] NOT NULL,
[RunFrom] [int] NOT NULL DEFAULT (0),
[LinkDocsWithSum] [bit] NOT NULL DEFAULT (1),
[DocLinkTypeID] [int] NOT NULL DEFAULT (0),
[SendDoneMsgToForm] [bit] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_WCopy] ADD CONSTRAINT [_pk_z_WCopy] PRIMARY KEY CLUSTERED ([CopyID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CopyName] ON [dbo].[z_WCopy] ([CopyName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DstDocType] ON [dbo].[z_WCopy] ([DstDocType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrcDocType] ON [dbo].[z_WCopy] ([SrcDocType]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[CopyID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[SrcDocType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[DstDocType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[IsSaved]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[IsChange]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[IsAutoChange]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[DBSourceMode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[UseDisableControls]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[UseMasterField]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[MarkCopyInBKeep]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[UpdateStatID]'
GO
