CREATE TABLE [dbo].[r_DeskG]
(
[ChID] [bigint] NOT NULL,
[DeskGCode] [int] NOT NULL,
[DeskGName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DeskG] ADD CONSTRAINT [pk_r_DeskG] PRIMARY KEY CLUSTERED ([DeskGCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_DeskG] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DeskGName] ON [dbo].[r_DeskG] ([DeskGName]) ON [PRIMARY]
GO
