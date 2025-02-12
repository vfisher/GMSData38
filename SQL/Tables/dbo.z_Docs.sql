CREATE TABLE [dbo].[z_Docs] (
  [DocCatCode] [int] NOT NULL,
  [DocGrpCode] [int] NOT NULL DEFAULT (0),
  [DocCode] [int] NOT NULL,
  [DocName] [varchar](250) NOT NULL,
  [DocInfo] [varchar](250) NULL,
  [FormClass] [varchar](250) NULL,
  [CodeField] [varchar](250) NULL,
  [NameField] [varchar](250) NULL,
  [SyncCode] [int] NOT NULL DEFAULT (0),
  [SyncType] [tinyint] NOT NULL DEFAULT (0),
  [SyncFields] [varchar](250) NULL,
  [FilterBeforeOpen] [bit] NOT NULL DEFAULT (0),
  [HaveTax] [bit] NOT NULL DEFAULT (0),
  [HaveTrans] [bit] NOT NULL DEFAULT (0),
  [CopyType] [tinyint] NOT NULL DEFAULT (0),
  [HaveState] [bit] NOT NULL DEFAULT (0),
  [UpdateExtLog] [bit] NOT NULL DEFAULT (0),
  [BalanceType] [smallint] NOT NULL DEFAULT (0),
  [LinkEExp] [varchar](250) NULL,
  [LinkLExp] [varchar](250) NULL,
  [BalanceFESign] [smallint] NOT NULL DEFAULT (0),
  [TaxDocType] [int] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_z_Docs] PRIMARY KEY CLUSTERED ([DocCode])
)
ON [PRIMARY]
GO

CREATE INDEX [CodeField]
  ON [dbo].[z_Docs] ([CodeField])
  ON [PRIMARY]
GO

CREATE INDEX [DocCatCode]
  ON [dbo].[z_Docs] ([DocCatCode])
  ON [PRIMARY]
GO

CREATE INDEX [DocGrpCode]
  ON [dbo].[z_Docs] ([DocGrpCode])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [DocName]
  ON [dbo].[z_Docs] ([DocName])
  ON [PRIMARY]
GO

CREATE INDEX [NameField]
  ON [dbo].[z_Docs] ([NameField])
  ON [PRIMARY]
GO

CREATE INDEX [SyncCode]
  ON [dbo].[z_Docs] ([SyncCode])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_Docs] ON [z_Docs]
FOR UPDATE AS
/* z_Docs - Документы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_Docs ^ b_DStack - Обновление CHILD */
/* Документы ^ ТМЦ: Суммовой учет - Обновление CHILD */
  IF UPDATE(DocCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = i.DocCode
          FROM b_DStack a, inserted i, deleted d WHERE a.DocCode = d.DocCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_DStack a, deleted d WHERE a.DocCode = d.DocCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Документы'' => ''ТМЦ: Суммовой учет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Docs ^ b_GTran - Обновление CHILD */
/* Документы ^ Таблица проводок (Общие данные) - Обновление CHILD */
  IF UPDATE(DocCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = i.DocCode
          FROM b_GTran a, inserted i, deleted d WHERE a.DocCode = d.DocCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTran a, deleted d WHERE a.DocCode = d.DocCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Документы'' => ''Таблица проводок (Общие данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Docs ^ r_ProdMPCh - Обновление CHILD */
/* Документы ^ Изменение цен продажи (Таблица) - Обновление CHILD */
  IF UPDATE(DocCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = i.DocCode
          FROM r_ProdMPCh a, inserted i, deleted d WHERE a.DocCode = d.DocCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdMPCh a, deleted d WHERE a.DocCode = d.DocCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Документы'' => ''Изменение цен продажи (Таблица)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Docs ^ z_DataSets - Обновление CHILD */
/* Документы ^ Источники данных - Обновление CHILD */
  IF UPDATE(DocCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = i.DocCode
          FROM z_DataSets a, inserted i, deleted d WHERE a.DocCode = d.DocCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DataSets a, deleted d WHERE a.DocCode = d.DocCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Документы'' => ''Источники данных''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Docs ^ z_DocLinks - Обновление CHILD */
/* Документы ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(DocCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChildDocCode = i.DocCode
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ChildDocCode = d.DocCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = d.DocCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Документы'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Docs ^ z_DocLinks - Обновление CHILD */
/* Документы ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(DocCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ParentDocCode = i.DocCode
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ParentDocCode = d.DocCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ParentDocCode = d.DocCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Документы'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Docs ^ z_Tools - Обновление CHILD */
/* Документы ^ Инструменты - Обновление CHILD */
  IF UPDATE(DocCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = i.DocCode
          FROM z_Tools a, inserted i, deleted d WHERE a.DocCode = d.DocCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Tools a, deleted d WHERE a.DocCode = d.DocCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Документы'' => ''Инструменты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Docs ^ z_WCopy - Обновление CHILD */
/* Документы ^ Мастер Копирования - Обновление CHILD */
  IF UPDATE(DocCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DstDocType = i.DocCode
          FROM z_WCopy a, inserted i, deleted d WHERE a.DstDocType = d.DocCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopy a, deleted d WHERE a.DstDocType = d.DocCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Документы'' => ''Мастер Копирования''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Docs ^ z_WCopy - Обновление CHILD */
/* Документы ^ Мастер Копирования - Обновление CHILD */
  IF UPDATE(DocCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SrcDocType = i.DocCode
          FROM z_WCopy a, inserted i, deleted d WHERE a.SrcDocType = d.DocCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopy a, deleted d WHERE a.SrcDocType = d.DocCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Документы'' => ''Мастер Копирования''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_Docs', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_Docs] ON [z_Docs]
FOR DELETE AS
/* z_Docs - Документы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* z_Docs ^ b_DStack - Проверка в CHILD */
/* Документы ^ ТМЦ: Суммовой учет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_DStack a WITH(NOLOCK), deleted d WHERE a.DocCode = d.DocCode)
    BEGIN
      EXEC z_RelationError 'z_Docs', 'b_DStack', 3
      RETURN
    END

/* z_Docs ^ b_GTran - Проверка в CHILD */
/* Документы ^ Таблица проводок (Общие данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTran a WITH(NOLOCK), deleted d WHERE a.DocCode = d.DocCode)
    BEGIN
      EXEC z_RelationError 'z_Docs', 'b_GTran', 3
      RETURN
    END

/* z_Docs ^ r_ProdMPCh - Проверка в CHILD */
/* Документы ^ Изменение цен продажи (Таблица) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ProdMPCh a WITH(NOLOCK), deleted d WHERE a.DocCode = d.DocCode)
    BEGIN
      EXEC z_RelationError 'z_Docs', 'r_ProdMPCh', 3
      RETURN
    END

/* z_Docs ^ z_DataSets - Удаление в CHILD */
/* Документы ^ Источники данных - Удаление в CHILD */
  DELETE z_DataSets FROM z_DataSets a, deleted d WHERE a.DocCode = d.DocCode
  IF @@ERROR > 0 RETURN

/* z_Docs ^ z_DocLinks - Удаление в CHILD */
/* Документы ^ Документы - Взаимосвязи - Удаление в CHILD */
  DELETE z_DocLinks FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = d.DocCode
  IF @@ERROR > 0 RETURN

/* z_Docs ^ z_DocLinks - Удаление в CHILD */
/* Документы ^ Документы - Взаимосвязи - Удаление в CHILD */
  DELETE z_DocLinks FROM z_DocLinks a, deleted d WHERE a.ParentDocCode = d.DocCode
  IF @@ERROR > 0 RETURN

/* z_Docs ^ z_Tools - Удаление в CHILD */
/* Документы ^ Инструменты - Удаление в CHILD */
  DELETE z_Tools FROM z_Tools a, deleted d WHERE a.DocCode = d.DocCode
  IF @@ERROR > 0 RETURN

/* z_Docs ^ z_WCopy - Удаление в CHILD */
/* Документы ^ Мастер Копирования - Удаление в CHILD */
  DELETE z_WCopy FROM z_WCopy a, deleted d WHERE a.DstDocType = d.DocCode
  IF @@ERROR > 0 RETURN

/* z_Docs ^ z_WCopy - Удаление в CHILD */
/* Документы ^ Мастер Копирования - Удаление в CHILD */
  DELETE z_WCopy FROM z_WCopy a, deleted d WHERE a.SrcDocType = d.DocCode
  IF @@ERROR > 0 RETURN

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_z_Docs', N'Last', N'DELETE'
GO

ALTER TABLE [dbo].[z_Docs]
  ADD CONSTRAINT [FK_z_Docs_z_DocCats] FOREIGN KEY ([DocCatCode]) REFERENCES [dbo].[z_DocCats] ([DocCatCode]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[z_Docs]
  ADD CONSTRAINT [FK_z_Docs_z_DocGrps] FOREIGN KEY ([DocGrpCode]) REFERENCES [dbo].[z_DocGrps] ([DocGrpCode]) ON UPDATE CASCADE
GO