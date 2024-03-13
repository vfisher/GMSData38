CREATE TABLE [dbo].[p_SubStrucD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[SubID] [smallint] NOT NULL,
[ParentSubID] [smallint] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_SubStrucD] ADD CONSTRAINT [pk_p_SubStrucD] PRIMARY KEY CLUSTERED ([ChID], [SubID], [ParentSubID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[p_SubStrucD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Notes] ON [dbo].[p_SubStrucD] ([Notes]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ParentSubID] ON [dbo].[p_SubStrucD] ([ParentSubID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubID] ON [dbo].[p_SubStrucD] ([SubID]) ON [PRIMARY]
GO
