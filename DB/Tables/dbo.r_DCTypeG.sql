CREATE TABLE [dbo].[r_DCTypeG]
(
[ChID] [bigint] NOT NULL,
[DCTypeGCode] [int] NOT NULL,
[DCTypeGName] [varchar] (250) NOT NULL,
[Notes] [varchar] (250) NULL,
[MainDialog] [bit] NOT NULL,
[CloseDialogAfterEnter] [bit] NOT NULL,
[ProcessingID] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DCTypeG] ADD CONSTRAINT [pk_r_DCTypeG] PRIMARY KEY CLUSTERED ([DCTypeGCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[r_DCTypeG] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DCTypeGName] ON [dbo].[r_DCTypeG] ([DCTypeGName]) ON [PRIMARY]
GO
