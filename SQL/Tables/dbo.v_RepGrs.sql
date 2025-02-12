CREATE TABLE [dbo].[v_RepGrs] (
  [RepGrID] [smallint] NOT NULL,
  [RepGrName] [varchar](250) NOT NULL,
  CONSTRAINT [_pk_v_RepGrs] PRIMARY KEY CLUSTERED ([RepGrID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [RepGrName]
  ON [dbo].[v_RepGrs] ([RepGrName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_RepGrs.RepGrID'
GO