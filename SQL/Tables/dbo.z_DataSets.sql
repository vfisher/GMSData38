CREATE TABLE [dbo].[z_DataSets] (
  [DSCode] [int] NOT NULL,
  [DSName] [varchar](250) NOT NULL,
  [DocCode] [int] NOT NULL,
  [TableCode] [int] NOT NULL DEFAULT (0),
  [PageIndex] [int] NOT NULL,
  [PageName] [varchar](250) NOT NULL,
  [PageStyle] [int] NOT NULL DEFAULT (0),
  [PageVisible] [bit] NOT NULL DEFAULT (1),
  [SQLStr] [varchar](8000) NULL,
  [SQLType] [int] NOT NULL,
  [IntName] [varchar](250) NULL,
  [SortFields] [varchar](250) NULL,
  [IntFilter] [varchar](250) NULL,
  [OpenFilter] [varchar](250) NULL,
  [FilterBeforeOpen] [bit] NOT NULL DEFAULT (0),
  [IsDefault] [bit] NOT NULL DEFAULT (0),
  [MasterSource] [varchar](250) NULL,
  [MasterFields] [varchar](250) NULL,
  [ReadOnly] [bit] NOT NULL DEFAULT (0),
  [UserCode] [smallint] NOT NULL DEFAULT (0),
  [AFColCount] [tinyint] NOT NULL DEFAULT (0),
  [DSLevel] [int] NOT NULL DEFAULT (0),
  [ColWidth] [int] NOT NULL DEFAULT (0),
  [DescWidth] [int] NOT NULL DEFAULT (0),
  [PageHeight] [int] NOT NULL DEFAULT (0),
  [AFCodeWidth] [int] NOT NULL,
  [OptimizeData] [bit] NOT NULL DEFAULT (0),
  [LockMode] [tinyint] NOT NULL DEFAULT (1),
  CONSTRAINT [pk_z_DataSets] PRIMARY KEY CLUSTERED ([DSCode])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [DSName]
  ON [dbo].[z_DataSets] ([DSName])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniquePageIndex]
  ON [dbo].[z_DataSets] ([DocCode], [PageIndex], [UserCode])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniquePageName]
  ON [dbo].[z_DataSets] ([DocCode], [PageName], [UserCode])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_DataSets] ON [z_DataSets]
FOR INSERT AS
/* z_DataSets - Источники данных - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_DataSets ^ z_Docs - Проверка в PARENT */
/* Источники данных ^ Документы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode NOT IN (SELECT DocCode FROM z_Docs))
    BEGIN
      EXEC z_RelationError 'z_Docs', 'z_DataSets', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_DataSets', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_DataSets] ON [z_DataSets]
FOR UPDATE AS
/* z_DataSets - Источники данных - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_DataSets ^ z_Docs - Проверка в PARENT */
/* Источники данных ^ Документы - Проверка в PARENT */
  IF UPDATE(DocCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode NOT IN (SELECT DocCode FROM z_Docs))
      BEGIN
        EXEC z_RelationError 'z_Docs', 'z_DataSets', 1
        RETURN
      END

/* z_DataSets ^ b_GOperDocs - Обновление CHILD */
/* Источники данных ^ Проводки для документов - Обновление CHILD */
  IF UPDATE(DSCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DSCode = i.DSCode
          FROM b_GOperDocs a, inserted i, deleted d WHERE a.DSCode = d.DSCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GOperDocs a, deleted d WHERE a.DSCode = d.DSCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Источники данных'' => ''Проводки для документов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_DataSets ^ z_DataSetFields - Обновление CHILD */
/* Источники данных ^ Источники данных - Поля - Обновление CHILD */
  IF UPDATE(DSCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DSCode = i.DSCode
          FROM z_DataSetFields a, inserted i, deleted d WHERE a.DSCode = d.DSCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DataSetFields a, deleted d WHERE a.DSCode = d.DSCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Источники данных'' => ''Источники данных - Поля''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_DataSets ^ z_DatasetLinks - Обновление CHILD */
/* Источники данных ^ Источники данных - Связи - Обновление CHILD */
  IF UPDATE(DSCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DSCode = i.DSCode
          FROM z_DatasetLinks a, inserted i, deleted d WHERE a.DSCode = d.DSCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DatasetLinks a, deleted d WHERE a.DSCode = d.DSCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Источники данных'' => ''Источники данных - Связи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_DataSets ^ z_DatasetLinks - Обновление CHILD */
/* Источники данных ^ Источники данных - Связи - Обновление CHILD */
  IF UPDATE(DSCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.LinkDSCode = i.DSCode
          FROM z_DatasetLinks a, inserted i, deleted d WHERE a.LinkDSCode = d.DSCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DatasetLinks a, deleted d WHERE a.LinkDSCode = d.DSCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Источники данных'' => ''Источники данных - Связи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_DataSets', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_DataSets] ON [z_DataSets]
FOR DELETE AS
/* z_DataSets - Источники данных - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* z_DataSets ^ b_GOperDocs - Проверка в CHILD */
/* Источники данных ^ Проводки для документов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GOperDocs a WITH(NOLOCK), deleted d WHERE a.DSCode = d.DSCode)
    BEGIN
      EXEC z_RelationError 'z_DataSets', 'b_GOperDocs', 3
      RETURN
    END

/* z_DataSets ^ z_DataSetFields - Удаление в CHILD */
/* Источники данных ^ Источники данных - Поля - Удаление в CHILD */
  DELETE z_DataSetFields FROM z_DataSetFields a, deleted d WHERE a.DSCode = d.DSCode
  IF @@ERROR > 0 RETURN

/* z_DataSets ^ z_DatasetLinks - Удаление в CHILD */
/* Источники данных ^ Источники данных - Связи - Удаление в CHILD */
  DELETE z_DatasetLinks FROM z_DatasetLinks a, deleted d WHERE a.DSCode = d.DSCode
  IF @@ERROR > 0 RETURN

/* z_DataSets ^ z_DatasetLinks - Удаление в CHILD */
/* Источники данных ^ Источники данных - Связи - Удаление в CHILD */
  DELETE z_DatasetLinks FROM z_DatasetLinks a, deleted d WHERE a.LinkDSCode = d.DSCode
  IF @@ERROR > 0 RETURN

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_z_DataSets', N'Last', N'DELETE'
GO

ALTER TABLE [dbo].[z_DataSets]
  ADD CONSTRAINT [FK_z_DataSets_r_Users] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[r_Users] ([UserID]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[z_DataSets]
  ADD CONSTRAINT [FK_z_DataSets_z_Tables] FOREIGN KEY ([TableCode]) REFERENCES [dbo].[z_Tables] ([TableCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO