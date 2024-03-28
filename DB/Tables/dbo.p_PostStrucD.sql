CREATE TABLE [dbo].[p_PostStrucD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[SubID] [smallint] NOT NULL,
[PostID] [int] NOT NULL,
[StrucPostID] [int] NOT NULL,
[VacTotal] [numeric] (21, 9) NOT NULL,
[VacOcc] [numeric] (21, 9) NOT NULL,
[VacFree] [numeric] (21, 9) NOT NULL,
[EDate] [smalldatetime] NULL,
[StrucParentPostID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_PostStrucD] ADD CONSTRAINT [pk_p_PostStrucD] PRIMARY KEY CLUSTERED ([ChID], [StrucPostID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[p_PostStrucD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PostID] ON [dbo].[p_PostStrucD] ([PostID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StrucParentPostID] ON [dbo].[p_PostStrucD] ([StrucParentPostID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StrucPostID] ON [dbo].[p_PostStrucD] ([StrucPostID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubID] ON [dbo].[p_PostStrucD] ([SubID]) ON [PRIMARY]
GO
