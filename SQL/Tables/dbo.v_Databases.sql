CREATE TABLE [dbo].[v_Databases] (
  [RepID] [int] NOT NULL,
  [DBName] [varchar](250) NOT NULL,
  [UseDB] [bit] NOT NULL,
  [ObjectDef] [text] NULL,
  CONSTRAINT [_pk_v_Databases] PRIMARY KEY CLUSTERED ([RepID], [DBName])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [RepID]
  ON [dbo].[v_Databases] ([RepID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_Databases.RepID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_Databases.UseDB'
GO

ALTER TABLE [dbo].[v_Databases]
  ADD CONSTRAINT [FK_v_Databases_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO