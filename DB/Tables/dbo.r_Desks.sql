CREATE TABLE [dbo].[r_Desks]
(
[ChID] [bigint] NOT NULL,
[DeskCode] [int] NOT NULL,
[DeskName] [varchar] (200) NOT NULL,
[DeskLeft] [int] NOT NULL DEFAULT (0),
[DeskTop] [int] NOT NULL DEFAULT (0),
[DeskWidth] [int] NOT NULL DEFAULT (90),
[DeskHeight] [int] NOT NULL DEFAULT (50),
[DeskRound] [bit] NOT NULL DEFAULT (0),
[DeskGCode] [int] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Desks] ADD CONSTRAINT [pk_r_Desks] PRIMARY KEY CLUSTERED ([DeskCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Desks] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DeskName] ON [dbo].[r_Desks] ([DeskName]) ON [PRIMARY]
GO
