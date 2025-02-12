CREATE TABLE [dbo].[z_Objects] (
  [ObjCode] [int] NOT NULL,
  [ObjName] [varchar](250) NOT NULL,
  [ObjDesc] [varchar](250) NOT NULL,
  [ObjInfo] [varchar](250) NULL,
  [ObjType] [varchar](250) NOT NULL,
  [RevID] [int] NOT NULL,
  CONSTRAINT [pk_z_Objects] PRIMARY KEY CLUSTERED ([ObjCode])
)
ON [PRIMARY]
GO

CREATE INDEX [ObjDesc]
  ON [dbo].[z_Objects] ([ObjDesc])
  ON [PRIMARY]
GO

CREATE INDEX [ObjName]
  ON [dbo].[z_Objects] ([ObjName])
  ON [PRIMARY]
GO