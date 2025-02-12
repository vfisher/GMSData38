CREATE TABLE [dbo].[z_Tables] (
  [DocCode] [int] NOT NULL,
  [TableCode] [int] NOT NULL,
  [TableName] [varchar](250) NOT NULL,
  [TableDesc] [varchar](250) NOT NULL,
  [TableInfo] [varchar](250) NULL,
  [DateField] [varchar](250) NULL,
  [PKFields] [varchar](250) NULL,
  [SortFields] [varchar](250) NULL,
  [IntFilter] [varchar](250) NULL,
  [OpenFilter] [varchar](250) NULL,
  [IsView] [bit] NOT NULL DEFAULT (0),
  [IsDefault] [bit] NOT NULL DEFAULT (0),
  [HaveOur] [bit] NOT NULL DEFAULT (0),
  [ForSync] [bit] NOT NULL DEFAULT (0),
  [UpdateLog] [bit] NOT NULL DEFAULT (0),
  [SyncAUFields] [bit] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_z_Tables] PRIMARY KEY CLUSTERED ([TableCode])
)
ON [PRIMARY]
GO

CREATE INDEX [DocCode]
  ON [dbo].[z_Tables] ([DocCode])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [TableDesc]
  ON [dbo].[z_Tables] ([TableDesc])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [TableName]
  ON [dbo].[z_Tables] ([TableName])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [Unique_DocCode_IsDefault]
  ON [dbo].[z_Tables] ([DocCode], [IsDefault])
  WHERE ([IsDefault]=(1))
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_Tables] ON [z_Tables]
FOR UPDATE AS
/* z_Tables - Таблицы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_Tables ^ r_DiscChargeDT - Обновление CHILD */
/* Таблицы ^ Справочник акций: Накопление бонусов - Источники данных - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CTableCode = i.TableCode
          FROM r_DiscChargeDT a, inserted i, deleted d WHERE a.CTableCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DiscChargeDT a, deleted d WHERE a.CTableCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Справочник акций: Накопление бонусов - Источники данных''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tables ^ r_DiscChargeDT - Обновление CHILD */
/* Таблицы ^ Справочник акций: Накопление бонусов - Источники данных - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PTableCode = i.TableCode
          FROM r_DiscChargeDT a, inserted i, deleted d WHERE a.PTableCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DiscChargeDT a, deleted d WHERE a.PTableCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Справочник акций: Накопление бонусов - Источники данных''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tables ^ r_DiscMessagesT - Обновление CHILD */
/* Таблицы ^ Справочник акций: Сообщения - Источники данных - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CTableCode = i.TableCode
          FROM r_DiscMessagesT a, inserted i, deleted d WHERE a.CTableCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DiscMessagesT a, deleted d WHERE a.CTableCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Справочник акций: Сообщения - Источники данных''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tables ^ r_DiscMessagesT - Обновление CHILD */
/* Таблицы ^ Справочник акций: Сообщения - Источники данных - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PTableCode = i.TableCode
          FROM r_DiscMessagesT a, inserted i, deleted d WHERE a.PTableCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DiscMessagesT a, deleted d WHERE a.PTableCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Справочник акций: Сообщения - Источники данных''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tables ^ r_DiscSaleDT - Обновление CHILD */
/* Таблицы ^ Справочник акций: Скидка по товарам - Источники данных - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CTableCode = i.TableCode
          FROM r_DiscSaleDT a, inserted i, deleted d WHERE a.CTableCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DiscSaleDT a, deleted d WHERE a.CTableCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Справочник акций: Скидка по товарам - Источники данных''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tables ^ r_DiscSaleDT - Обновление CHILD */
/* Таблицы ^ Справочник акций: Скидка по товарам - Источники данных - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PTableCode = i.TableCode
          FROM r_DiscSaleDT a, inserted i, deleted d WHERE a.PTableCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DiscSaleDT a, deleted d WHERE a.PTableCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Справочник акций: Скидка по товарам - Источники данных''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tables ^ r_DiscSaleT - Обновление CHILD */
/* Таблицы ^ Справочник акций: Скидка - Источники данных - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CTableCode = i.TableCode
          FROM r_DiscSaleT a, inserted i, deleted d WHERE a.CTableCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DiscSaleT a, deleted d WHERE a.CTableCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Справочник акций: Скидка - Источники данных''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tables ^ r_DiscSaleT - Обновление CHILD */
/* Таблицы ^ Справочник акций: Скидка - Источники данных - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PTableCode = i.TableCode
          FROM r_DiscSaleT a, inserted i, deleted d WHERE a.PTableCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DiscSaleT a, deleted d WHERE a.PTableCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Справочник акций: Скидка - Источники данных''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tables ^ r_DiscsT - Обновление CHILD */
/* Таблицы ^ Справочник акций - Источники данных - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CTableCode = i.TableCode
          FROM r_DiscsT a, inserted i, deleted d WHERE a.CTableCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DiscsT a, deleted d WHERE a.CTableCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Справочник акций - Источники данных''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tables ^ r_DiscsT - Обновление CHILD */
/* Таблицы ^ Справочник акций - Источники данных - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PTableCode = i.TableCode
          FROM r_DiscsT a, inserted i, deleted d WHERE a.PTableCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DiscsT a, deleted d WHERE a.PTableCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Справочник акций - Источники данных''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tables ^ v_Tables - Обновление CHILD */
/* Таблицы ^ Анализатор - Таблицы - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TableCode = i.TableCode
          FROM v_Tables a, inserted i, deleted d WHERE a.TableCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM v_Tables a, deleted d WHERE a.TableCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Анализатор - Таблицы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tables ^ z_AUTables - Обновление CHILD */
/* Таблицы ^ Автоизменение - Таблицы - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CTableCode = i.TableCode
          FROM z_AUTables a, inserted i, deleted d WHERE a.CTableCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_AUTables a, deleted d WHERE a.CTableCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Автоизменение - Таблицы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tables ^ z_AUTables - Обновление CHILD */
/* Таблицы ^ Автоизменение - Таблицы - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PTableCode = i.TableCode
          FROM z_AUTables a, inserted i, deleted d WHERE a.PTableCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_AUTables a, deleted d WHERE a.PTableCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Автоизменение - Таблицы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tables ^ z_AutoUpdate - Обновление CHILD */
/* Таблицы ^ Автоизменение - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AUTableCode = i.TableCode
          FROM z_AutoUpdate a, inserted i, deleted d WHERE a.AUTableCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_AutoUpdate a, deleted d WHERE a.AUTableCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Автоизменение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tables ^ z_AutoUpdate - Обновление CHILD */
/* Таблицы ^ Автоизменение - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TableCode = i.TableCode
          FROM z_AutoUpdate a, inserted i, deleted d WHERE a.TableCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_AutoUpdate a, deleted d WHERE a.TableCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Автоизменение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tables ^ z_Relations - Обновление CHILD */
/* Таблицы ^ Таблицы - Связи - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChildCode = i.TableCode
          FROM z_Relations a, inserted i, deleted d WHERE a.ChildCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Relations a, deleted d WHERE a.ChildCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Таблицы - Связи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tables ^ z_Relations - Обновление CHILD */
/* Таблицы ^ Таблицы - Связи - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ParentCode = i.TableCode
          FROM z_Relations a, inserted i, deleted d WHERE a.ParentCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Relations a, deleted d WHERE a.ParentCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Таблицы - Связи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tables ^ z_ReplicaFields - Обновление CHILD */
/* Таблицы ^ Объекты репликации: Поля - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TableCode = i.TableCode
          FROM z_ReplicaFields a, inserted i, deleted d WHERE a.TableCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_ReplicaFields a, deleted d WHERE a.TableCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Объекты репликации: Поля''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tables ^ z_ReplicaFilters - Обновление CHILD */
/* Таблицы ^ Объекты репликации: Фильтры - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CTableCode = i.TableCode
          FROM z_ReplicaFilters a, inserted i, deleted d WHERE a.CTableCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_ReplicaFilters a, deleted d WHERE a.CTableCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Объекты репликации: Фильтры''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tables ^ z_ReplicaFilters - Обновление CHILD */
/* Таблицы ^ Объекты репликации: Фильтры - Обновление CHILD */
  IF UPDATE(TableCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PTableCode = i.TableCode
          FROM z_ReplicaFilters a, inserted i, deleted d WHERE a.PTableCode = d.TableCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_ReplicaFilters a, deleted d WHERE a.PTableCode = d.TableCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблицы'' => ''Объекты репликации: Фильтры''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_Tables', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_Tables] ON [z_Tables]
FOR DELETE AS
/* z_Tables - Таблицы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* z_Tables ^ r_DiscChargeDT - Проверка в CHILD */
/* Таблицы ^ Справочник акций: Накопление бонусов - Источники данных - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_DiscChargeDT a WITH(NOLOCK), deleted d WHERE a.CTableCode = d.TableCode)
    BEGIN
      EXEC z_RelationError 'z_Tables', 'r_DiscChargeDT', 3
      RETURN
    END

/* z_Tables ^ r_DiscChargeDT - Проверка в CHILD */
/* Таблицы ^ Справочник акций: Накопление бонусов - Источники данных - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_DiscChargeDT a WITH(NOLOCK), deleted d WHERE a.PTableCode = d.TableCode)
    BEGIN
      EXEC z_RelationError 'z_Tables', 'r_DiscChargeDT', 3
      RETURN
    END

/* z_Tables ^ r_DiscMessagesT - Удаление в CHILD */
/* Таблицы ^ Справочник акций: Сообщения - Источники данных - Удаление в CHILD */
  DELETE r_DiscMessagesT FROM r_DiscMessagesT a, deleted d WHERE a.CTableCode = d.TableCode
  IF @@ERROR > 0 RETURN

/* z_Tables ^ r_DiscMessagesT - Удаление в CHILD */
/* Таблицы ^ Справочник акций: Сообщения - Источники данных - Удаление в CHILD */
  DELETE r_DiscMessagesT FROM r_DiscMessagesT a, deleted d WHERE a.PTableCode = d.TableCode
  IF @@ERROR > 0 RETURN

/* z_Tables ^ r_DiscSaleDT - Проверка в CHILD */
/* Таблицы ^ Справочник акций: Скидка по товарам - Источники данных - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_DiscSaleDT a WITH(NOLOCK), deleted d WHERE a.CTableCode = d.TableCode)
    BEGIN
      EXEC z_RelationError 'z_Tables', 'r_DiscSaleDT', 3
      RETURN
    END

/* z_Tables ^ r_DiscSaleDT - Проверка в CHILD */
/* Таблицы ^ Справочник акций: Скидка по товарам - Источники данных - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_DiscSaleDT a WITH(NOLOCK), deleted d WHERE a.PTableCode = d.TableCode)
    BEGIN
      EXEC z_RelationError 'z_Tables', 'r_DiscSaleDT', 3
      RETURN
    END

/* z_Tables ^ r_DiscSaleT - Проверка в CHILD */
/* Таблицы ^ Справочник акций: Скидка - Источники данных - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_DiscSaleT a WITH(NOLOCK), deleted d WHERE a.CTableCode = d.TableCode)
    BEGIN
      EXEC z_RelationError 'z_Tables', 'r_DiscSaleT', 3
      RETURN
    END

/* z_Tables ^ r_DiscSaleT - Проверка в CHILD */
/* Таблицы ^ Справочник акций: Скидка - Источники данных - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_DiscSaleT a WITH(NOLOCK), deleted d WHERE a.PTableCode = d.TableCode)
    BEGIN
      EXEC z_RelationError 'z_Tables', 'r_DiscSaleT', 3
      RETURN
    END

/* z_Tables ^ r_DiscsT - Проверка в CHILD */
/* Таблицы ^ Справочник акций - Источники данных - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_DiscsT a WITH(NOLOCK), deleted d WHERE a.CTableCode = d.TableCode)
    BEGIN
      EXEC z_RelationError 'z_Tables', 'r_DiscsT', 3
      RETURN
    END

/* z_Tables ^ r_DiscsT - Проверка в CHILD */
/* Таблицы ^ Справочник акций - Источники данных - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_DiscsT a WITH(NOLOCK), deleted d WHERE a.PTableCode = d.TableCode)
    BEGIN
      EXEC z_RelationError 'z_Tables', 'r_DiscsT', 3
      RETURN
    END

/* z_Tables ^ v_Tables - Удаление в CHILD */
/* Таблицы ^ Анализатор - Таблицы - Удаление в CHILD */
  DELETE v_Tables FROM v_Tables a, deleted d WHERE a.TableCode = d.TableCode
  IF @@ERROR > 0 RETURN

/* z_Tables ^ z_AUTables - Проверка в CHILD */
/* Таблицы ^ Автоизменение - Таблицы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_AUTables a WITH(NOLOCK), deleted d WHERE a.CTableCode = d.TableCode)
    BEGIN
      EXEC z_RelationError 'z_Tables', 'z_AUTables', 3
      RETURN
    END

/* z_Tables ^ z_AUTables - Проверка в CHILD */
/* Таблицы ^ Автоизменение - Таблицы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_AUTables a WITH(NOLOCK), deleted d WHERE a.PTableCode = d.TableCode)
    BEGIN
      EXEC z_RelationError 'z_Tables', 'z_AUTables', 3
      RETURN
    END

/* z_Tables ^ z_AutoUpdate - Удаление в CHILD */
/* Таблицы ^ Автоизменение - Удаление в CHILD */
  DELETE z_AutoUpdate FROM z_AutoUpdate a, deleted d WHERE a.AUTableCode = d.TableCode
  IF @@ERROR > 0 RETURN

/* z_Tables ^ z_AutoUpdate - Удаление в CHILD */
/* Таблицы ^ Автоизменение - Удаление в CHILD */
  DELETE z_AutoUpdate FROM z_AutoUpdate a, deleted d WHERE a.TableCode = d.TableCode
  IF @@ERROR > 0 RETURN

/* z_Tables ^ z_Relations - Удаление в CHILD */
/* Таблицы ^ Таблицы - Связи - Удаление в CHILD */
  DELETE z_Relations FROM z_Relations a, deleted d WHERE a.ChildCode = d.TableCode
  IF @@ERROR > 0 RETURN

/* z_Tables ^ z_Relations - Удаление в CHILD */
/* Таблицы ^ Таблицы - Связи - Удаление в CHILD */
  DELETE z_Relations FROM z_Relations a, deleted d WHERE a.ParentCode = d.TableCode
  IF @@ERROR > 0 RETURN

/* z_Tables ^ z_ReplicaFields - Проверка в CHILD */
/* Таблицы ^ Объекты репликации: Поля - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_ReplicaFields a WITH(NOLOCK), deleted d WHERE a.TableCode = d.TableCode)
    BEGIN
      EXEC z_RelationError 'z_Tables', 'z_ReplicaFields', 3
      RETURN
    END

/* z_Tables ^ z_ReplicaFilters - Удаление в CHILD */
/* Таблицы ^ Объекты репликации: Фильтры - Удаление в CHILD */
  DELETE z_ReplicaFilters FROM z_ReplicaFilters a, deleted d WHERE a.CTableCode = d.TableCode
  IF @@ERROR > 0 RETURN

/* z_Tables ^ z_ReplicaFilters - Удаление в CHILD */
/* Таблицы ^ Объекты репликации: Фильтры - Удаление в CHILD */
  DELETE z_ReplicaFilters FROM z_ReplicaFilters a, deleted d WHERE a.PTableCode = d.TableCode
  IF @@ERROR > 0 RETURN

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_z_Tables', N'Last', N'DELETE'
GO

ALTER TABLE [dbo].[z_Tables]
  ADD CONSTRAINT [FK_z_Tables_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO