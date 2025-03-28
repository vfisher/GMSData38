﻿CREATE TABLE [dbo].[v_Params] (
  [RepID] [int] NOT NULL,
  [ParamName] [varchar](250) NOT NULL,
  [LExp] [varchar](250) NOT NULL,
  [EExp] [varchar](250) NOT NULL,
  [DataType] [tinyint] NOT NULL,
  CONSTRAINT [_pk_v_Params] PRIMARY KEY CLUSTERED ([RepID], [ParamName])
)
ON [PRIMARY]
GO

CREATE INDEX [RepID]
  ON [dbo].[v_Params] ([RepID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_Params.RepID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_Params.DataType'
GO

ALTER TABLE [dbo].[v_Params]
  ADD CONSTRAINT [FK_v_Params_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO