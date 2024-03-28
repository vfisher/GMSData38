CREATE TABLE [dbo].[r_MenuM]
(
[MenuID] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[SubmenuID] [int] NOT NULL DEFAULT ((0)),
[OrderID] [int] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_MenuM] ADD CONSTRAINT [pk_r_MenuM] PRIMARY KEY CLUSTERED ([MenuID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubmenuID] ON [dbo].[r_MenuM] ([SubmenuID]) ON [PRIMARY]
GO
