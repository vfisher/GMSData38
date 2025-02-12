CREATE TABLE [dbo].[v_MapSG] (
  [RepID] [int] NOT NULL,
  [SourceGrName] [varchar](250) NOT NULL,
  [SourceID] [smallint] NOT NULL,
  [ReverseSign] [bit] NOT NULL,
  [UseSourceGrName] [bit] NOT NULL,
  [RangeType] [tinyint] NOT NULL,
  [SQLStr] [varchar](8000) NULL,
  [LFilter] [varchar](1000) NULL,
  [EFilter] [varchar](1000) NULL,
  [LHaving] [varchar](1000) NULL,
  [EHaving] [varchar](1000) NULL,
  [ObjectDef] [text] NULL,
  [RangeValue] [bigint] NOT NULL CONSTRAINT [DF__v_MapSG__RangeVa__3B266106] DEFAULT (0),
  CONSTRAINT [_pk_v_MapSG] PRIMARY KEY CLUSTERED ([RepID], [SourceGrName], [SourceID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [RepID]
  ON [dbo].[v_MapSG] ([RepID])
  ON [PRIMARY]
GO

CREATE INDEX [SourceID]
  ON [dbo].[v_MapSG] ([SourceID])
  ON [PRIMARY]
GO

CREATE INDEX [v_SourceGrsv_MapSG]
  ON [dbo].[v_MapSG] ([RepID], [SourceGrName])
  ON [PRIMARY]
GO

CREATE INDEX [v_Sourcesv_MapSG]
  ON [dbo].[v_MapSG] ([RepID], [SourceID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_MapSG.RepID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_MapSG.SourceID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_MapSG.ReverseSign'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_MapSG.UseSourceGrName'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_MapSG.RangeType'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_v_MapSG] ON [v_MapSG]FOR INSERT AS/* v_MapSG - Анализатор - Источники групп - INSERT TRIGGER */BEGIN  DECLARE @RCount Int  SELECT @RCount = @@RowCount  IF @RCount = 0 RETURN  SET NOCOUNT ON/* v_MapSG ^ v_SourceGrs - Проверка в PARENT *//* Анализатор - Источники групп ^ Анализатор - Группы источников - Проверка в PARENT */  IF (SELECT COUNT(*) FROM v_SourceGrs m WITH(NOLOCK), inserted i WHERE i.RepID = m.RepID AND i.SourceGrName = m.SourceGrName) <> @RCount    BEGIN      EXEC z_RelationError 'v_SourceGrs', 'v_MapSG', 0      RETURN    END/* v_MapSG ^ v_Sources - Проверка в PARENT *//* Анализатор - Источники групп ^ Анализатор - Источники - Проверка в PARENT */  IF (SELECT COUNT(*) FROM v_Sources m WITH(NOLOCK), inserted i WHERE i.RepID = m.RepID AND i.SourceID = m.SourceID) <> @RCount    BEGIN      EXEC z_RelationError 'v_Sources', 'v_MapSG', 0      RETURN    ENDEND
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_v_MapSG', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_v_MapSG] ON [v_MapSG]
FOR UPDATE AS
/* v_MapSG - Анализатор - Источники групп - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* v_MapSG ^ v_SourceGrs - Проверка в PARENT */
/* Анализатор - Источники групп ^ Анализатор - Группы источников - Проверка в PARENT */
  IF UPDATE(RepID) OR UPDATE(SourceGrName)
    IF (SELECT COUNT(*) FROM v_SourceGrs m WITH(NOLOCK), inserted i WHERE i.RepID = m.RepID AND i.SourceGrName = m.SourceGrName) <> @RCount
      BEGIN
        EXEC z_RelationError 'v_SourceGrs', 'v_MapSG', 1
        RETURN
      END

/* v_MapSG ^ v_Sources - Проверка в PARENT */
/* Анализатор - Источники групп ^ Анализатор - Источники - Проверка в PARENT */
  IF UPDATE(RepID) OR UPDATE(SourceID)
    IF (SELECT COUNT(*) FROM v_Sources m WITH(NOLOCK), inserted i WHERE i.RepID = m.RepID AND i.SourceID = m.SourceID) <> @RCount
      BEGIN
        EXEC z_RelationError 'v_Sources', 'v_MapSG', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldRepID int, @NewRepID int
  DECLARE @OldSourceGrName varchar(250), @NewSourceGrName varchar(250)
  DECLARE @OldSourceID smallint, @NewSourceID smallint

/* v_MapSG ^ v_Replace - Обновление CHILD */
/* Анализатор - Источники групп ^ Анализатор - Замена формул - Обновление CHILD */
  IF UPDATE(RepID) OR UPDATE(SourceGrName) OR UPDATE(SourceID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.RepID = i.RepID, a.SourceGrName = i.SourceGrName, a.SourceID = i.SourceID
          FROM v_Replace a, inserted i, deleted d WHERE a.RepID = d.RepID AND a.SourceGrName = d.SourceGrName AND a.SourceID = d.SourceID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(SourceGrName) AND NOT UPDATE(SourceID) AND (SELECT COUNT(DISTINCT RepID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT RepID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldRepID = RepID FROM deleted
          SELECT TOP 1 @NewRepID = RepID FROM inserted
          UPDATE v_Replace SET v_Replace.RepID = @NewRepID FROM v_Replace, deleted d WHERE v_Replace.RepID = @OldRepID AND v_Replace.SourceGrName = d.SourceGrName AND v_Replace.SourceID = d.SourceID
        END
      ELSE IF NOT UPDATE(RepID) AND NOT UPDATE(SourceID) AND (SELECT COUNT(DISTINCT SourceGrName) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT SourceGrName) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldSourceGrName = SourceGrName FROM deleted
          SELECT TOP 1 @NewSourceGrName = SourceGrName FROM inserted
          UPDATE v_Replace SET v_Replace.SourceGrName = @NewSourceGrName FROM v_Replace, deleted d WHERE v_Replace.SourceGrName = @OldSourceGrName AND v_Replace.RepID = d.RepID AND v_Replace.SourceID = d.SourceID
        END
      ELSE IF NOT UPDATE(RepID) AND NOT UPDATE(SourceGrName) AND (SELECT COUNT(DISTINCT SourceID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT SourceID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldSourceID = SourceID FROM deleted
          SELECT TOP 1 @NewSourceID = SourceID FROM inserted
          UPDATE v_Replace SET v_Replace.SourceID = @NewSourceID FROM v_Replace, deleted d WHERE v_Replace.SourceID = @OldSourceID AND v_Replace.RepID = d.RepID AND v_Replace.SourceGrName = d.SourceGrName
        END
      ELSE IF EXISTS (SELECT * FROM v_Replace a, deleted d WHERE a.RepID = d.RepID AND a.SourceGrName = d.SourceGrName AND a.SourceID = d.SourceID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Анализатор - Источники групп'' => ''Анализатор - Замена формул''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_v_MapSG', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_v_MapSG] ON [v_MapSG]FOR DELETE AS/* v_MapSG - Анализатор - Источники групп - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* v_MapSG ^ v_Replace - Удаление в CHILD *//* Анализатор - Источники групп ^ Анализатор - Замена формул - Удаление в CHILD */  DELETE v_Replace FROM v_Replace a, deleted d WHERE a.RepID = d.RepID AND a.SourceGrName = d.SourceGrName AND a.SourceID = d.SourceID  IF @@ERROR > 0 RETURNEND
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_v_MapSG', N'Last', N'DELETE'
GO