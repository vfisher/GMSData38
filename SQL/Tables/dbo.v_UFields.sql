CREATE TABLE [dbo].[v_UFields] (
  [RepID] [int] NOT NULL,
  [FieldName] [varchar](250) NOT NULL,
  [UserID] [smallint] NOT NULL,
  [Location] [int] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [Visible] [bit] NOT NULL,
  [VisibleNote] [bit] NOT NULL,
  [Width] [int] NOT NULL,
  [Alignment] [tinyint] NOT NULL,
  [Layout] [tinyint] NOT NULL,
  [WordWrap] [bit] NOT NULL,
  [Negatives] [bit] NOT NULL,
  [Operation] [tinyint] NOT NULL,
  [Sorting] [tinyint] NOT NULL,
  [SubTotals] [bit] NOT NULL,
  [Separator] [bit] NOT NULL,
  [DecimalCount] [tinyint] NOT NULL,
  [FixedCount] [tinyint] NOT NULL,
  [Caption] [varchar](250) NOT NULL,
  [FieldLevel] [tinyint] NOT NULL,
  [FieldKind] [tinyint] NOT NULL,
  [DataType] [tinyint] NOT NULL,
  [FilterOnly] [bit] NOT NULL,
  [HideInFilter] [bit] NOT NULL,
  [Grouping] [smallint] NOT NULL,
  [GroupFactor] [smallint] NOT NULL,
  [GroupField] [varchar](250) NULL,
  [LExpr] [varchar](250) NULL,
  [EExpr] [varchar](250) NULL,
  [OFilter] [varchar](4000) NULL,
  [PFilter] [varchar](1000) NULL,
  [FieldPosID] [int] NOT NULL DEFAULT (0),
  CONSTRAINT [_pk_v_UFields] PRIMARY KEY CLUSTERED ([UserID], [RepID], [FieldName])
)
ON [PRIMARY]
GO

CREATE INDEX [FieldName]
  ON [dbo].[v_UFields] ([FieldName])
  ON [PRIMARY]
GO

CREATE INDEX [Location]
  ON [dbo].[v_UFields] ([Location])
  ON [PRIMARY]
GO

CREATE INDEX [PosID]
  ON [dbo].[v_UFields] ([SrcPosID])
  ON [PRIMARY]
GO

CREATE INDEX [RepID]
  ON [dbo].[v_UFields] ([RepID])
  ON [PRIMARY]
GO

CREATE INDEX [UserID]
  ON [dbo].[v_UFields] ([UserID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UFields.RepID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UFields.UserID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UFields.Location'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UFields.SrcPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UFields.Visible'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UFields.VisibleNote'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UFields.Width'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UFields.Alignment'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UFields.Layout'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UFields.WordWrap'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UFields.Negatives'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UFields.Operation'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UFields.Sorting'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UFields.SubTotals'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UFields.Separator'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UFields.DecimalCount'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UFields.FixedCount'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UFields.FilterOnly'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UFields.HideInFilter'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_v_UFields] ON [v_UFields]
FOR INSERT AS
/* v_UFields - Анализатор - Поля пользователя - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* v_UFields ^ r_Users - Проверка в PARENT */
/* Анализатор - Поля пользователя ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'v_UFields', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_v_UFields', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_v_UFields] ON [v_UFields]
FOR UPDATE AS
/* v_UFields - Анализатор - Поля пользователя - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* v_UFields ^ r_Users - Проверка в PARENT */
/* Анализатор - Поля пользователя ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'v_UFields', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_v_UFields', N'Last', N'UPDATE'
GO

ALTER TABLE [dbo].[v_UFields]
  ADD CONSTRAINT [FK_v_UFields_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO