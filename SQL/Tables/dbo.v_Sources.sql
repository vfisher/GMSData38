CREATE TABLE [dbo].[v_Sources] (
  [RepID] [int] NOT NULL,
  [SourceID] [smallint] NOT NULL,
  [SourceName] [varchar](250) NOT NULL,
  [DocCode] [int] NOT NULL,
  [SourceType] [int] NOT NULL DEFAULT (0),
  [ObjectDef] [text] NULL,
  CONSTRAINT [_pk_v_Sources] PRIMARY KEY CLUSTERED ([RepID], [SourceID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [DocCode]
  ON [dbo].[v_Sources] ([DocCode])
  ON [PRIMARY]
GO

CREATE INDEX [NoDuplicates]
  ON [dbo].[v_Sources] ([RepID], [SourceName])
  ON [PRIMARY]
GO

CREATE INDEX [RepID]
  ON [dbo].[v_Sources] ([RepID])
  ON [PRIMARY]
GO

CREATE INDEX [SourceID]
  ON [dbo].[v_Sources] ([SourceID])
  ON [PRIMARY]
GO

CREATE INDEX [SourceName]
  ON [dbo].[v_Sources] ([SourceName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_Sources.RepID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_Sources.SourceID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_Sources.DocCode'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_v_Sources] ON [v_Sources]
FOR UPDATE AS
/* v_Sources - Анализатор - Источники - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldRepID int, @NewRepID int
  DECLARE @OldSourceID smallint, @NewSourceID smallint

/* v_Sources ^ v_Formulas - Обновление CHILD */
/* Анализатор - Источники ^ Анализатор - Формулы - Обновление CHILD */
  IF UPDATE(RepID) OR UPDATE(SourceID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.RepID = i.RepID, a.SourceID = i.SourceID
          FROM v_Formulas a, inserted i, deleted d WHERE a.RepID = d.RepID AND a.SourceID = d.SourceID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(SourceID) AND (SELECT COUNT(DISTINCT RepID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT RepID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldRepID = RepID FROM deleted
          SELECT TOP 1 @NewRepID = RepID FROM inserted
          UPDATE v_Formulas SET v_Formulas.RepID = @NewRepID FROM v_Formulas, deleted d WHERE v_Formulas.RepID = @OldRepID AND v_Formulas.SourceID = d.SourceID
        END
      ELSE IF NOT UPDATE(RepID) AND (SELECT COUNT(DISTINCT SourceID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT SourceID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldSourceID = SourceID FROM deleted
          SELECT TOP 1 @NewSourceID = SourceID FROM inserted
          UPDATE v_Formulas SET v_Formulas.SourceID = @NewSourceID FROM v_Formulas, deleted d WHERE v_Formulas.SourceID = @OldSourceID AND v_Formulas.RepID = d.RepID
        END
      ELSE IF EXISTS (SELECT * FROM v_Formulas a, deleted d WHERE a.RepID = d.RepID AND a.SourceID = d.SourceID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Анализатор - Источники'' => ''Анализатор - Формулы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* v_Sources ^ v_MapSG - Обновление CHILD */
/* Анализатор - Источники ^ Анализатор - Источники групп - Обновление CHILD */
  IF UPDATE(RepID) OR UPDATE(SourceID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.RepID = i.RepID, a.SourceID = i.SourceID
          FROM v_MapSG a, inserted i, deleted d WHERE a.RepID = d.RepID AND a.SourceID = d.SourceID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(SourceID) AND (SELECT COUNT(DISTINCT RepID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT RepID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldRepID = RepID FROM deleted
          SELECT TOP 1 @NewRepID = RepID FROM inserted
          UPDATE v_MapSG SET v_MapSG.RepID = @NewRepID FROM v_MapSG, deleted d WHERE v_MapSG.RepID = @OldRepID AND v_MapSG.SourceID = d.SourceID
        END
      ELSE IF NOT UPDATE(RepID) AND (SELECT COUNT(DISTINCT SourceID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT SourceID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldSourceID = SourceID FROM deleted
          SELECT TOP 1 @NewSourceID = SourceID FROM inserted
          UPDATE v_MapSG SET v_MapSG.SourceID = @NewSourceID FROM v_MapSG, deleted d WHERE v_MapSG.SourceID = @OldSourceID AND v_MapSG.RepID = d.RepID
        END
      ELSE IF EXISTS (SELECT * FROM v_MapSG a, deleted d WHERE a.RepID = d.RepID AND a.SourceID = d.SourceID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Анализатор - Источники'' => ''Анализатор - Источники групп''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* v_Sources ^ v_Tables - Обновление CHILD */
/* Анализатор - Источники ^ Анализатор - Таблицы - Обновление CHILD */
  IF UPDATE(RepID) OR UPDATE(SourceID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.RepID = i.RepID, a.SourceID = i.SourceID
          FROM v_Tables a, inserted i, deleted d WHERE a.RepID = d.RepID AND a.SourceID = d.SourceID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(SourceID) AND (SELECT COUNT(DISTINCT RepID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT RepID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldRepID = RepID FROM deleted
          SELECT TOP 1 @NewRepID = RepID FROM inserted
          UPDATE v_Tables SET v_Tables.RepID = @NewRepID FROM v_Tables, deleted d WHERE v_Tables.RepID = @OldRepID AND v_Tables.SourceID = d.SourceID
        END
      ELSE IF NOT UPDATE(RepID) AND (SELECT COUNT(DISTINCT SourceID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT SourceID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldSourceID = SourceID FROM deleted
          SELECT TOP 1 @NewSourceID = SourceID FROM inserted
          UPDATE v_Tables SET v_Tables.SourceID = @NewSourceID FROM v_Tables, deleted d WHERE v_Tables.SourceID = @OldSourceID AND v_Tables.RepID = d.RepID
        END
      ELSE IF EXISTS (SELECT * FROM v_Tables a, deleted d WHERE a.RepID = d.RepID AND a.SourceID = d.SourceID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Анализатор - Источники'' => ''Анализатор - Таблицы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_v_Sources', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_v_Sources] ON [v_Sources]FOR DELETE AS/* v_Sources - Анализатор - Источники - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* v_Sources ^ v_Formulas - Удаление в CHILD *//* Анализатор - Источники ^ Анализатор - Формулы - Удаление в CHILD */  DELETE v_Formulas FROM v_Formulas a, deleted d WHERE a.RepID = d.RepID AND a.SourceID = d.SourceID  IF @@ERROR > 0 RETURN/* v_Sources ^ v_MapSG - Удаление в CHILD *//* Анализатор - Источники ^ Анализатор - Источники групп - Удаление в CHILD */  DELETE v_MapSG FROM v_MapSG a, deleted d WHERE a.RepID = d.RepID AND a.SourceID = d.SourceID  IF @@ERROR > 0 RETURN/* v_Sources ^ v_Tables - Удаление в CHILD *//* Анализатор - Источники ^ Анализатор - Таблицы - Удаление в CHILD */  DELETE v_Tables FROM v_Tables a, deleted d WHERE a.RepID = d.RepID AND a.SourceID = d.SourceID  IF @@ERROR > 0 RETURNEND
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_v_Sources', N'Last', N'DELETE'
GO

ALTER TABLE [dbo].[v_Sources]
  ADD CONSTRAINT [FK_v_Sources_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO