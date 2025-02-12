CREATE TABLE [dbo].[z_VarPages] (
  [VarPageCode] [int] NOT NULL,
  [VarPageName] [varchar](250) NOT NULL,
  [VarPagePosID] [int] NOT NULL,
  [VarPageVisible] [bit] NOT NULL,
  CONSTRAINT [pk_z_VarPages] PRIMARY KEY CLUSTERED ([VarPageCode])
)
ON [PRIMARY]
GO