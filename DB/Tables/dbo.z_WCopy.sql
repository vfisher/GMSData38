CREATE TABLE [dbo].[z_WCopy]
(
[CopyID] [int] NOT NULL,
[CopyName] [varchar] (200) NOT NULL,
[CopyDesc] [varchar] (200) NULL,
[SrcDocType] [int] NOT NULL,
[DstDocType] [int] NOT NULL,
[IsSaved] [bit] NOT NULL,
[IsChange] [bit] NOT NULL,
[IsAutoChange] [bit] NOT NULL,
[StartDesc1] [varchar] (200) NULL,
[StartDesc2] [varchar] (200) NULL,
[DBSourceMode] [tinyint] NOT NULL,
[DBServerName] [varchar] (200) NULL,
[DBBaseName] [varchar] (200) NULL,
[DBUserName] [varchar] (200) NULL,
[UseDisableControls] [bit] NOT NULL,
[UseMasterField] [bit] NOT NULL,
[MarkCopyInBKeep] [bit] NOT NULL,
[UpdateStatID] [bit] NOT NULL,
[ScBeforeRun] [text] NULL,
[ScAfterRun] [text] NULL,
[AllowUpdateStateCode] [bit] NOT NULL,
[StateCode] [int] NOT NULL,
[LinkDocs] [bit] NOT NULL,
[SrcDocIsParent] [bit] NOT NULL,
[AllowLinkDocs] [bit] NOT NULL,
[RunFrom] [int] NOT NULL DEFAULT (0),
[LinkDocsWithSum] [bit] NOT NULL DEFAULT (1),
[DocLinkTypeID] [int] NOT NULL DEFAULT (0),
[SendDoneMsgToForm] [bit] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_WCopy] ON [dbo].[z_WCopy]
FOR INSERT AS
/* z_WCopy - Мастер Копирования - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopy ^ r_States - Проверка в PARENT */
/* Мастер Копирования ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'z_WCopy', 0
      RETURN
    END

/* z_WCopy ^ z_Docs - Проверка в PARENT */
/* Мастер Копирования ^ Документы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DstDocType NOT IN (SELECT DocCode FROM z_Docs))
    BEGIN
      EXEC z_RelationError 'z_Docs', 'z_WCopy', 0
      RETURN
    END

/* z_WCopy ^ z_Docs - Проверка в PARENT */
/* Мастер Копирования ^ Документы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SrcDocType NOT IN (SELECT DocCode FROM z_Docs))
    BEGIN
      EXEC z_RelationError 'z_Docs', 'z_WCopy', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_WCopy]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_WCopy] ON [dbo].[z_WCopy]
FOR UPDATE AS
/* z_WCopy - Мастер Копирования - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopy ^ r_States - Проверка в PARENT */
/* Мастер Копирования ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'z_WCopy', 1
        RETURN
      END

/* z_WCopy ^ z_Docs - Проверка в PARENT */
/* Мастер Копирования ^ Документы - Проверка в PARENT */
  IF UPDATE(DstDocType)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DstDocType NOT IN (SELECT DocCode FROM z_Docs))
      BEGIN
        EXEC z_RelationError 'z_Docs', 'z_WCopy', 1
        RETURN
      END

/* z_WCopy ^ z_Docs - Проверка в PARENT */
/* Мастер Копирования ^ Документы - Проверка в PARENT */
  IF UPDATE(SrcDocType)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SrcDocType NOT IN (SELECT DocCode FROM z_Docs))
      BEGIN
        EXEC z_RelationError 'z_Docs', 'z_WCopy', 1
        RETURN
      END

/* z_WCopy ^ z_WCopyD - Обновление CHILD */
/* Мастер Копирования ^ Мастер Копирования - Получатели - Обновление CHILD */
  IF UPDATE(CopyID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CopyID = i.CopyID
          FROM z_WCopyD a, inserted i, deleted d WHERE a.CopyID = d.CopyID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopyD a, deleted d WHERE a.CopyID = d.CopyID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Мастер Копирования'' => ''Мастер Копирования - Получатели''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_WCopy ^ z_WCopyP - Обновление CHILD */
/* Мастер Копирования ^ Мастер Копирования - Параметры - Обновление CHILD */
  IF UPDATE(CopyID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CopyID = i.CopyID
          FROM z_WCopyP a, inserted i, deleted d WHERE a.CopyID = d.CopyID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopyP a, deleted d WHERE a.CopyID = d.CopyID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Мастер Копирования'' => ''Мастер Копирования - Параметры''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_WCopy ^ z_WCopyT - Обновление CHILD */
/* Мастер Копирования ^ Мастер Копирования - Источники - Обновление CHILD */
  IF UPDATE(CopyID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CopyID = i.CopyID
          FROM z_WCopyT a, inserted i, deleted d WHERE a.CopyID = d.CopyID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopyT a, deleted d WHERE a.CopyID = d.CopyID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Мастер Копирования'' => ''Мастер Копирования - Источники''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_WCopy ^ z_WCopyU - Обновление CHILD */
/* Мастер Копирования ^ Мастер Копирования - Параметры пользователя - Обновление CHILD */
  IF UPDATE(CopyID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CopyID = i.CopyID
          FROM z_WCopyU a, inserted i, deleted d WHERE a.CopyID = d.CopyID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopyU a, deleted d WHERE a.CopyID = d.CopyID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Мастер Копирования'' => ''Мастер Копирования - Параметры пользователя''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_WCopy ^ z_WCopyUV - Обновление CHILD */
/* Мастер Копирования ^ Мастер Копирования - Журнал вариантов - Обновление CHILD */
  IF UPDATE(CopyID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CopyID = i.CopyID
          FROM z_WCopyUV a, inserted i, deleted d WHERE a.CopyID = d.CopyID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopyUV a, deleted d WHERE a.CopyID = d.CopyID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Мастер Копирования'' => ''Мастер Копирования - Журнал вариантов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_WCopy]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_WCopy] ON [dbo].[z_WCopy]FOR DELETE AS/* z_WCopy - Мастер Копирования - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* z_WCopy ^ z_WCopyD - Удаление в CHILD *//* Мастер Копирования ^ Мастер Копирования - Получатели - Удаление в CHILD */  DELETE z_WCopyD FROM z_WCopyD a, deleted d WHERE a.CopyID = d.CopyID  IF @@ERROR > 0 RETURN/* z_WCopy ^ z_WCopyP - Удаление в CHILD *//* Мастер Копирования ^ Мастер Копирования - Параметры - Удаление в CHILD */  DELETE z_WCopyP FROM z_WCopyP a, deleted d WHERE a.CopyID = d.CopyID  IF @@ERROR > 0 RETURN/* z_WCopy ^ z_WCopyT - Удаление в CHILD *//* Мастер Копирования ^ Мастер Копирования - Источники - Удаление в CHILD */  DELETE z_WCopyT FROM z_WCopyT a, deleted d WHERE a.CopyID = d.CopyID  IF @@ERROR > 0 RETURN/* z_WCopy ^ z_WCopyU - Удаление в CHILD *//* Мастер Копирования ^ Мастер Копирования - Параметры пользователя - Удаление в CHILD */  DELETE z_WCopyU FROM z_WCopyU a, deleted d WHERE a.CopyID = d.CopyID  IF @@ERROR > 0 RETURN/* z_WCopy ^ z_WCopyUV - Удаление в CHILD *//* Мастер Копирования ^ Мастер Копирования - Журнал вариантов - Удаление в CHILD */  DELETE z_WCopyUV FROM z_WCopyUV a, deleted d WHERE a.CopyID = d.CopyID  IF @@ERROR > 0 RETURNEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_z_WCopy]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[z_WCopy] ADD CONSTRAINT [_pk_z_WCopy] PRIMARY KEY CLUSTERED ([CopyID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CopyName] ON [dbo].[z_WCopy] ([CopyName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DstDocType] ON [dbo].[z_WCopy] ([DstDocType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrcDocType] ON [dbo].[z_WCopy] ([SrcDocType]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[CopyID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[SrcDocType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[DstDocType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[IsSaved]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[IsChange]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[IsAutoChange]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[DBSourceMode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[UseDisableControls]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[UseMasterField]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[MarkCopyInBKeep]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[UpdateStatID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[CopyID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[SrcDocType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[DstDocType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[IsSaved]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[IsChange]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[IsAutoChange]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[DBSourceMode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[UseDisableControls]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[UseMasterField]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[MarkCopyInBKeep]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopy].[UpdateStatID]'
GO
