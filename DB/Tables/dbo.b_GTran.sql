CREATE TABLE [dbo].[b_GTran]
(
[GTranID] [int] NOT NULL,
[GOperID] [int] NOT NULL,
[DocCode] [int] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[OurID] [int] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[GPosID] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_GTran] ON [dbo].[b_GTran]
FOR INSERT AS
/* b_GTran - Таблица проводок (Общие данные) - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_GTran ^ r_GOpers - Проверка в PARENT */
/* Таблица проводок (Общие данные) ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_GTran', 0
      RETURN
    END

/* b_GTran ^ r_Ours - Проверка в PARENT */
/* Таблица проводок (Общие данные) ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_GTran', 0
      RETURN
    END

/* b_GTran ^ z_Docs - Проверка в PARENT */
/* Таблица проводок (Общие данные) ^ Документы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode NOT IN (SELECT DocCode FROM z_Docs))
    BEGIN
      EXEC z_RelationError 'z_Docs', 'b_GTran', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_b_GTran]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_GTran] ON [dbo].[b_GTran]
FOR UPDATE AS
/* b_GTran - Таблица проводок (Общие данные) - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_GTran ^ r_GOpers - Проверка в PARENT */
/* Таблица проводок (Общие данные) ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'b_GTran', 1
        RETURN
      END

/* b_GTran ^ r_Ours - Проверка в PARENT */
/* Таблица проводок (Общие данные) ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'b_GTran', 1
        RETURN
      END

/* b_GTran ^ z_Docs - Проверка в PARENT */
/* Таблица проводок (Общие данные) ^ Документы - Проверка в PARENT */
  IF UPDATE(DocCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode NOT IN (SELECT DocCode FROM z_Docs))
      BEGIN
        EXEC z_RelationError 'z_Docs', 'b_GTran', 1
        RETURN
      END

/* b_GTran ^ b_GTranD - Обновление CHILD */
/* Таблица проводок (Общие данные) ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(GTranID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTranID = i.GTranID
          FROM b_GTranD a, inserted i, deleted d WHERE a.GTranID = d.GTranID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.GTranID = d.GTranID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Таблица проводок (Общие данные)'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_b_GTran]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_GTran] ON [dbo].[b_GTran]FOR DELETE AS/* b_GTran - Таблица проводок (Общие данные) - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* b_GTran ^ b_GTranD - Удаление в CHILD *//* Таблица проводок (Общие данные) ^ Таблица проводок (Проводки) - Удаление в CHILD */  DELETE b_GTranD FROM b_GTranD a, deleted d WHERE a.GTranID = d.GTranID  IF @@ERROR > 0 RETURNEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_b_GTran]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[b_GTran] ADD CONSTRAINT [_pk_b_GTran] PRIMARY KEY CLUSTERED ([GTranID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_GTran] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID] ON [dbo].[b_GTran] ([IntDocID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTran].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTran].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTran].[DocCode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTran].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTran].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTran].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTran].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTran].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTran].[DocCode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTran].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTran].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTran].[KursMC]'
GO
