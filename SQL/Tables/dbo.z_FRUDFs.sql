CREATE TABLE [dbo].[z_FRUDFs] (
  [OperName] [varchar](255) NOT NULL,
  [RFormula] [varchar](400) NOT NULL,
  [EFormula] [varchar](400) NOT NULL,
  [RFormula1] [varchar](400) NULL,
  [EFormula1] [varchar](400) NULL,
  [RFormula2] [varchar](400) NULL,
  [EFormula2] [varchar](400) NULL,
  [OperDesc] [varchar](255) NULL,
  [ArgDesc1] [varchar](255) NULL,
  [ArgDesc2] [varchar](255) NULL,
  [ArgDesc3] [varchar](255) NULL,
  [RevID] [int] NOT NULL DEFAULT (0),
  CONSTRAINT [_pk_z_FRUDFs] PRIMARY KEY CLUSTERED ([OperName])
)
ON [PRIMARY]
GO

CREATE INDEX [EFormula]
  ON [dbo].[z_FRUDFs] ([EFormula])
  ON [PRIMARY]
GO

CREATE INDEX [EFormula1]
  ON [dbo].[z_FRUDFs] ([EFormula1])
  ON [PRIMARY]
GO

CREATE INDEX [EFormula2]
  ON [dbo].[z_FRUDFs] ([EFormula2])
  ON [PRIMARY]
GO

CREATE INDEX [RFormula]
  ON [dbo].[z_FRUDFs] ([RFormula])
  ON [PRIMARY]
GO

CREATE INDEX [RFormula1]
  ON [dbo].[z_FRUDFs] ([RFormula1])
  ON [PRIMARY]
GO

CREATE INDEX [RFormula2]
  ON [dbo].[z_FRUDFs] ([RFormula2])
  ON [PRIMARY]
GO