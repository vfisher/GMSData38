CREATE TABLE [dbo].[z_AUFields]
(
[AUID] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[AUFieldName] [varchar] (200) NOT NULL,
[AUFieldDesc] [varchar] (200) NOT NULL,
[EExp] [varchar] (4000) NULL,
[LExp] [varchar] (4000) NULL,
[Aggregate] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_AUFields] ADD CONSTRAINT [PK_z_AUFields] PRIMARY KEY CLUSTERED ([AUID], [AUFieldName]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [AUIDSrcPosID] ON [dbo].[z_AUFields] ([AUID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrcPosID] ON [dbo].[z_AUFields] ([SrcPosID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_AUFields] ADD CONSTRAINT [FK_z_AUFields_z_AutoUpdate] FOREIGN KEY ([AUID]) REFERENCES [dbo].[z_AutoUpdate] ([AUID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
