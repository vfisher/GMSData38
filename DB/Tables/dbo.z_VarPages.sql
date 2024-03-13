CREATE TABLE [dbo].[z_VarPages]
(
[VarPageCode] [int] NOT NULL,
[VarPageName] [varchar] (250) NOT NULL,
[VarPagePosID] [int] NOT NULL,
[VarPageVisible] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_VarPages] ADD CONSTRAINT [pk_z_VarPages] PRIMARY KEY CLUSTERED ([VarPageCode]) ON [PRIMARY]
GO
