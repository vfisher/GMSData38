CREATE TABLE [dbo].[z_Apps] (
  [AppCode] [int] NOT NULL,
  [AppName] [varchar](250) NOT NULL,
  [AppInfo] [varchar](250) NULL,
  CONSTRAINT [pk_z_Apps] PRIMARY KEY CLUSTERED ([AppCode])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [AppName]
  ON [dbo].[z_Apps] ([AppName])
  ON [PRIMARY]
GO