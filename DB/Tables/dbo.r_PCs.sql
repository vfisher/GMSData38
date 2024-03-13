CREATE TABLE [dbo].[r_PCs]
(
[ChID] [bigint] NOT NULL,
[PCCode] [int] NOT NULL,
[PCName] [varchar] (200) NOT NULL,
[Host] [varchar] (250) NULL,
[Notes] [varchar] (200) NULL,
[Email] [varchar] (250) NULL,
[SyncBy] [int] NULL DEFAULT (0),
[UseRAS] [bit] NOT NULL DEFAULT (0),
[RASConnection] [varchar] (250) NULL,
[NetPort] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_PCs] ADD CONSTRAINT [pk_r_PCs] PRIMARY KEY CLUSTERED ([PCCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_PCs] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PCName] ON [dbo].[r_PCs] ([PCName]) ON [PRIMARY]
GO
