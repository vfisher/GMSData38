﻿CREATE TABLE [dbo].[z_Tools] (
  [RepToolCode] [int] NOT NULL,
  [ToolCode] [int] NOT NULL,
  [ToolName] [varchar](250) NOT NULL,
  [DocCode] [int] NOT NULL,
  [ExecStr] [varchar](max) NULL,
  [ConfirmText] [varchar](250) NULL,
  [CompleteText] [varchar](250) NULL,
  [RefreshOnComplete] [bit] NOT NULL,
  [ShortCut] [varchar](250) NULL,
  CONSTRAINT [pk_z_Tools] PRIMARY KEY CLUSTERED ([ToolCode])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ToolName]
  ON [dbo].[z_Tools] ([ToolName])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_Tools] ON [z_Tools]
FOR DELETE AS
/* z_Tools - Инструменты - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* z_Tools ^ r_DocShed - Проверка в CHILD */
/* Инструменты ^ Шаблоны процессов: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_DocShed a WITH(NOLOCK), deleted d WHERE a.ToolCode = d.ToolCode)
    BEGIN
      EXEC z_RelationError 'z_Tools', 'r_DocShed', 3
      RETURN
    END

/* z_Tools ^ z_Translations - Удаление в CHILD */
/* Инструменты ^ Перевод - Удаление в CHILD */
  DELETE z_Translations FROM z_Translations a, deleted d WHERE a.TypeID = 5 AND a.MsgID = d.ToolCode
  IF @@ERROR > 0 RETURN

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_z_Tools', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_Tools] ON [z_Tools]
FOR UPDATE AS
/* z_Tools - Инструменты - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_Tools ^ z_Docs - Проверка в PARENT */
/* Инструменты ^ Документы - Проверка в PARENT */
  IF UPDATE(DocCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode NOT IN (SELECT DocCode FROM z_Docs))
      BEGIN
        EXEC z_RelationError 'z_Docs', 'z_Tools', 1
        RETURN
      END

/* z_Tools ^ r_DocShed - Обновление CHILD */
/* Инструменты ^ Шаблоны процессов: Заголовок - Обновление CHILD */
  IF UPDATE(ToolCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ToolCode = i.ToolCode
          FROM r_DocShed a, inserted i, deleted d WHERE a.ToolCode = d.ToolCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DocShed a, deleted d WHERE a.ToolCode = d.ToolCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Инструменты'' => ''Шаблоны процессов: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_Tools ^ z_Translations - Обновление CHILD */
/* Инструменты ^ Перевод - Обновление CHILD */
  IF UPDATE(ToolCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TypeID = 5, a.MsgID = i.ToolCode
          FROM z_Translations a, inserted i, deleted d WHERE a.TypeID = 5 AND a.MsgID = d.ToolCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Translations a, deleted d WHERE a.TypeID = 5 AND a.MsgID = d.ToolCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Инструменты'' => ''Перевод''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_Tools', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_Tools] ON [z_Tools]
FOR INSERT AS
/* z_Tools - Инструменты - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_Tools ^ z_Docs - Проверка в PARENT */
/* Инструменты ^ Документы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode NOT IN (SELECT DocCode FROM z_Docs))
    BEGIN
      EXEC z_RelationError 'z_Docs', 'z_Tools', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_Tools', N'Last', N'INSERT'
GO

ALTER TABLE [dbo].[z_Tools]
  ADD CONSTRAINT [FK_z_Tools_z_ToolRep] FOREIGN KEY ([RepToolCode]) REFERENCES [dbo].[z_ToolRep] ([RepToolCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO