CREATE TABLE [dbo].[z_ToolRep] (
  [RepToolCode] [int] NOT NULL,
  [RepToolName] [varchar](250) NOT NULL,
  [FormClass] [varchar](250) NOT NULL,
  [IsInt] [bit] NOT NULL,
  [RepToolCatName] [varchar](250) NULL,
  [ShortCut] [varchar](250) NULL,
  CONSTRAINT [pk_z_ToolRep] PRIMARY KEY CLUSTERED ([RepToolCode])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [FormClass]
  ON [dbo].[z_ToolRep] ([FormClass])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [RepToolName]
  ON [dbo].[z_ToolRep] ([RepToolName])
  ON [PRIMARY]
GO