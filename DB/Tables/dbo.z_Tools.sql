CREATE TABLE [dbo].[z_Tools]
(
[RepToolCode] [int] NOT NULL,
[ToolCode] [int] NOT NULL,
[ToolName] [varchar] (250) NOT NULL,
[DocCode] [int] NOT NULL,
[ExecStr] [varchar] (max) NULL,
[ConfirmText] [varchar] (250) NULL,
[CompleteText] [varchar] (250) NULL,
[RefreshOnComplete] [bit] NOT NULL,
[ShortCut] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_Tools] ADD CONSTRAINT [pk_z_Tools] PRIMARY KEY CLUSTERED ([ToolCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ToolName] ON [dbo].[z_Tools] ([ToolName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_Tools] ADD CONSTRAINT [FK_z_Tools_z_ToolRep] FOREIGN KEY ([RepToolCode]) REFERENCES [dbo].[z_ToolRep] ([RepToolCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
