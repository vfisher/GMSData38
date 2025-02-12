CREATE TABLE [dbo].[z_Translations] (
  [MsgID] [int] NOT NULL,
  [TypeID] [tinyint] NOT NULL,
  [RU] [varchar](max) NULL,
  [UK] [varchar](max) NULL,
  CONSTRAINT [pk_z_Translations] PRIMARY KEY CLUSTERED ([MsgID], [TypeID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO