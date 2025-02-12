CREATE TABLE [dbo].[r_Assets] (
  [ChID] [bigint] NOT NULL,
  [AssID] [int] NOT NULL,
  [AssName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  [IntID] [varchar](50) NULL,
  [FacID] [varchar](50) NULL,
  [AssDate] [smalldatetime] NULL,
  [OurID] [int] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_r_Assets] PRIMARY KEY CLUSTERED ([AssID])
)
ON [PRIMARY]
GO

CREATE INDEX [AssDate]
  ON [dbo].[r_Assets] ([AssDate])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [AssName]
  ON [dbo].[r_Assets] ([AssName])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Assets] ([ChID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Assets.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Assets.AssID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Assets] ON [r_Assets]
FOR INSERT AS
/* r_Assets - Справочник основных средств - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Assets ^ r_Ours - Проверка в PARENT */
/* Справочник основных средств ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'r_Assets', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10704001, ChID, 
    '[' + cast(i.AssID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_Assets', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Assets] ON [r_Assets]
FOR UPDATE AS
/* r_Assets - Справочник основных средств - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Assets ^ r_Ours - Проверка в PARENT */
/* Справочник основных средств ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'r_Assets', 1
        RETURN
      END

/* r_Assets ^ r_Carrs - Обновление CHILD */
/* Справочник основных средств ^ Справочник транспорта - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AssID = i.AssID
          FROM r_Carrs a, inserted i, deleted d WHERE a.AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Carrs a, deleted d WHERE a.AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Справочник транспорта''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ r_GOperD - Обновление CHILD */
/* Справочник основных средств ^ Справочник проводок - Проводки - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_AssID = i.AssID
          FROM r_GOperD a, inserted i, deleted d WHERE a.C_AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GOperD a, deleted d WHERE a.C_AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Справочник проводок - Проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ r_GOperD - Обновление CHILD */
/* Справочник основных средств ^ Справочник проводок - Проводки - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_AssID = i.AssID
          FROM r_GOperD a, inserted i, deleted d WHERE a.D_AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GOperD a, deleted d WHERE a.D_AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Справочник проводок - Проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ r_AssetH - Обновление CHILD */
/* Справочник основных средств ^ Справочник основных средств: История - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AssID = i.AssID
          FROM r_AssetH a, inserted i, deleted d WHERE a.AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_AssetH a, deleted d WHERE a.AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Справочник основных средств: История''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ r_GAccs - Обновление CHILD */
/* Справочник основных средств ^ План счетов - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.A_AssID = i.AssID
          FROM r_GAccs a, inserted i, deleted d WHERE a.A_AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GAccs a, deleted d WHERE a.A_AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''План счетов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_ARepADS - Обновление CHILD */
/* Справочник основных средств ^ Авансовый отчет валютный (Основные средства) - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AssID = i.AssID
          FROM b_ARepADS a, inserted i, deleted d WHERE a.AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepADS a, deleted d WHERE a.AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Авансовый отчет валютный (Основные средства)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_CRepADS - Обновление CHILD */
/* Справочник основных средств ^ Авансовый отчет с признаками (Основные средства) - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AssID = i.AssID
          FROM b_CRepADS a, inserted i, deleted d WHERE a.AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRepADS a, deleted d WHERE a.AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Авансовый отчет с признаками (Основные средства)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_GTranD - Обновление CHILD */
/* Справочник основных средств ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_AssID = i.AssID
          FROM b_GTranD a, inserted i, deleted d WHERE a.C_AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.C_AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_GTranD - Обновление CHILD */
/* Справочник основных средств ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_AssID = i.AssID
          FROM b_GTranD a, inserted i, deleted d WHERE a.D_AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.D_AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_RepADS - Обновление CHILD */
/* Справочник основных средств ^ Авансовый отчет (Основные средства) - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AssID = i.AssID
          FROM b_RepADS a, inserted i, deleted d WHERE a.AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_RepADS a, deleted d WHERE a.AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Авансовый отчет (Основные средства)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_SDepD - Обновление CHILD */
/* Справочник основных средств ^ Основные средства: Амортизация: Данные - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AssID = i.AssID
          FROM b_SDepD a, inserted i, deleted d WHERE a.AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SDepD a, deleted d WHERE a.AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Основные средства: Амортизация: Данные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_SExcD - Обновление CHILD */
/* Справочник основных средств ^ Основные средства: Перемещение (Данные) - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AssID = i.AssID
          FROM b_SExcD a, inserted i, deleted d WHERE a.AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExcD a, deleted d WHERE a.AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Основные средства: Перемещение (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_SExpD - Обновление CHILD */
/* Справочник основных средств ^ Основные средства: Списание (Данные) - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AssID = i.AssID
          FROM b_SExpD a, inserted i, deleted d WHERE a.AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExpD a, deleted d WHERE a.AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Основные средства: Списание (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_SInvD - Обновление CHILD */
/* Справочник основных средств ^ Основные средства: Продажа (Данные) - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AssID = i.AssID
          FROM b_SInvD a, inserted i, deleted d WHERE a.AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SInvD a, deleted d WHERE a.AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Основные средства: Продажа (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_SPutD - Обновление CHILD */
/* Справочник основных средств ^ Основные средства: Ввод в эксплуатацию (Данные) - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AssID = i.AssID
          FROM b_SPutD a, inserted i, deleted d WHERE a.AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SPutD a, deleted d WHERE a.AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Основные средства: Ввод в эксплуатацию (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_SRecD - Обновление CHILD */
/* Справочник основных средств ^ Основные средства: Приход (Данные) - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AssID = i.AssID
          FROM b_SRecD a, inserted i, deleted d WHERE a.AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRecD a, deleted d WHERE a.AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Основные средства: Приход (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_SRep - Обновление CHILD */
/* Справочник основных средств ^ Основные средства: Ремонт (Заголовок) - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AssID = i.AssID
          FROM b_SRep a, inserted i, deleted d WHERE a.AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRep a, deleted d WHERE a.AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Основные средства: Ремонт (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_SVenD - Обновление CHILD */
/* Справочник основных средств ^ Основные средства: Инвентаризация (Данные) - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AssID = i.AssID
          FROM b_SVenD a, inserted i, deleted d WHERE a.AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SVenD a, deleted d WHERE a.AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Основные средства: Инвентаризация (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_SWerD - Обновление CHILD */
/* Справочник основных средств ^ Основные средства: Износ (Данные) - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AssID = i.AssID
          FROM b_SWerD a, inserted i, deleted d WHERE a.AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SWerD a, deleted d WHERE a.AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Основные средства: Износ (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_TranH - Обновление CHILD */
/* Справочник основных средств ^ Ручные проводки - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_AssID = i.AssID
          FROM b_TranH a, inserted i, deleted d WHERE a.C_AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranH a, deleted d WHERE a.C_AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Ручные проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_TranH - Обновление CHILD */
/* Справочник основных средств ^ Ручные проводки - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_AssID = i.AssID
          FROM b_TranH a, inserted i, deleted d WHERE a.D_AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranH a, deleted d WHERE a.D_AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Ручные проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_TranS - Обновление CHILD */
/* Справочник основных средств ^ Основные средства: Проводка - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AssID = i.AssID
          FROM b_TranS a, inserted i, deleted d WHERE a.AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranS a, deleted d WHERE a.AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Основные средства: Проводка''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_zInH - Обновление CHILD */
/* Справочник основных средств ^ Ручные входящие - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_AssID = i.AssID
          FROM b_zInH a, inserted i, deleted d WHERE a.C_AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInH a, deleted d WHERE a.C_AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Ручные входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_zInH - Обновление CHILD */
/* Справочник основных средств ^ Ручные входящие - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_AssID = i.AssID
          FROM b_zInH a, inserted i, deleted d WHERE a.D_AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInH a, deleted d WHERE a.D_AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Ручные входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Assets ^ b_zInS - Обновление CHILD */
/* Справочник основных средств ^ Входящий баланс: Основные средства - Обновление CHILD */
  IF UPDATE(AssID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AssID = i.AssID
          FROM b_zInS a, inserted i, deleted d WHERE a.AssID = d.AssID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInS a, deleted d WHERE a.AssID = d.AssID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств'' => ''Входящий баланс: Основные средства''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10704001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10704001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(AssID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10704001 AND l.PKValue = 
        '[' + cast(i.AssID as varchar(200)) + ']' AND i.AssID = d.AssID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10704001 AND l.PKValue = 
        '[' + cast(i.AssID as varchar(200)) + ']' AND i.AssID = d.AssID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10704001, ChID, 
          '[' + cast(d.AssID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10704001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10704001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10704001, ChID, 
          '[' + cast(i.AssID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(AssID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT AssID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT AssID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.AssID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10704001 AND l.PKValue = 
          '[' + cast(d.AssID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.AssID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10704001 AND l.PKValue = 
          '[' + cast(d.AssID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10704001, ChID, 
          '[' + cast(d.AssID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10704001 AND PKValue IN (SELECT 
          '[' + cast(AssID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10704001 AND PKValue IN (SELECT 
          '[' + cast(AssID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10704001, ChID, 
          '[' + cast(i.AssID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10704001, ChID, 
    '[' + cast(i.AssID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Assets', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Assets] ON [r_Assets]
FOR DELETE AS
/* r_Assets - Справочник основных средств - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Assets ^ r_Carrs - Проверка в CHILD */
/* Справочник основных средств ^ Справочник транспорта - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Carrs a WITH(NOLOCK), deleted d WHERE a.AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'r_Carrs', 3
      RETURN
    END

/* r_Assets ^ r_GOperD - Проверка в CHILD */
/* Справочник основных средств ^ Справочник проводок - Проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GOperD a WITH(NOLOCK), deleted d WHERE a.C_AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'r_GOperD', 3
      RETURN
    END

/* r_Assets ^ r_GOperD - Проверка в CHILD */
/* Справочник основных средств ^ Справочник проводок - Проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GOperD a WITH(NOLOCK), deleted d WHERE a.D_AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'r_GOperD', 3
      RETURN
    END

/* r_Assets ^ r_AssetH - Удаление в CHILD */
/* Справочник основных средств ^ Справочник основных средств: История - Удаление в CHILD */
  DELETE r_AssetH FROM r_AssetH a, deleted d WHERE a.AssID = d.AssID
  IF @@ERROR > 0 RETURN

/* r_Assets ^ r_GAccs - Проверка в CHILD */
/* Справочник основных средств ^ План счетов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GAccs a WITH(NOLOCK), deleted d WHERE a.A_AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'r_GAccs', 3
      RETURN
    END

/* r_Assets ^ b_ARepADS - Проверка в CHILD */
/* Справочник основных средств ^ Авансовый отчет валютный (Основные средства) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepADS a WITH(NOLOCK), deleted d WHERE a.AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_ARepADS', 3
      RETURN
    END

/* r_Assets ^ b_CRepADS - Проверка в CHILD */
/* Справочник основных средств ^ Авансовый отчет с признаками (Основные средства) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRepADS a WITH(NOLOCK), deleted d WHERE a.AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_CRepADS', 3
      RETURN
    END

/* r_Assets ^ b_GTranD - Проверка в CHILD */
/* Справочник основных средств ^ Таблица проводок (Проводки) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTranD a WITH(NOLOCK), deleted d WHERE a.C_AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_GTranD', 3
      RETURN
    END

/* r_Assets ^ b_GTranD - Проверка в CHILD */
/* Справочник основных средств ^ Таблица проводок (Проводки) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTranD a WITH(NOLOCK), deleted d WHERE a.D_AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_GTranD', 3
      RETURN
    END

/* r_Assets ^ b_RepADS - Проверка в CHILD */
/* Справочник основных средств ^ Авансовый отчет (Основные средства) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_RepADS a WITH(NOLOCK), deleted d WHERE a.AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_RepADS', 3
      RETURN
    END

/* r_Assets ^ b_SDepD - Проверка в CHILD */
/* Справочник основных средств ^ Основные средства: Амортизация: Данные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SDepD a WITH(NOLOCK), deleted d WHERE a.AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_SDepD', 3
      RETURN
    END

/* r_Assets ^ b_SExcD - Проверка в CHILD */
/* Справочник основных средств ^ Основные средства: Перемещение (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExcD a WITH(NOLOCK), deleted d WHERE a.AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_SExcD', 3
      RETURN
    END

/* r_Assets ^ b_SExpD - Проверка в CHILD */
/* Справочник основных средств ^ Основные средства: Списание (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExpD a WITH(NOLOCK), deleted d WHERE a.AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_SExpD', 3
      RETURN
    END

/* r_Assets ^ b_SInvD - Проверка в CHILD */
/* Справочник основных средств ^ Основные средства: Продажа (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SInvD a WITH(NOLOCK), deleted d WHERE a.AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_SInvD', 3
      RETURN
    END

/* r_Assets ^ b_SPutD - Проверка в CHILD */
/* Справочник основных средств ^ Основные средства: Ввод в эксплуатацию (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SPutD a WITH(NOLOCK), deleted d WHERE a.AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_SPutD', 3
      RETURN
    END

/* r_Assets ^ b_SRecD - Проверка в CHILD */
/* Справочник основных средств ^ Основные средства: Приход (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRecD a WITH(NOLOCK), deleted d WHERE a.AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_SRecD', 3
      RETURN
    END

/* r_Assets ^ b_SRep - Проверка в CHILD */
/* Справочник основных средств ^ Основные средства: Ремонт (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRep a WITH(NOLOCK), deleted d WHERE a.AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_SRep', 3
      RETURN
    END

/* r_Assets ^ b_SVenD - Проверка в CHILD */
/* Справочник основных средств ^ Основные средства: Инвентаризация (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SVenD a WITH(NOLOCK), deleted d WHERE a.AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_SVenD', 3
      RETURN
    END

/* r_Assets ^ b_SWerD - Проверка в CHILD */
/* Справочник основных средств ^ Основные средства: Износ (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SWerD a WITH(NOLOCK), deleted d WHERE a.AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_SWerD', 3
      RETURN
    END

/* r_Assets ^ b_TranH - Проверка в CHILD */
/* Справочник основных средств ^ Ручные проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranH a WITH(NOLOCK), deleted d WHERE a.C_AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_TranH', 3
      RETURN
    END

/* r_Assets ^ b_TranH - Проверка в CHILD */
/* Справочник основных средств ^ Ручные проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranH a WITH(NOLOCK), deleted d WHERE a.D_AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_TranH', 3
      RETURN
    END

/* r_Assets ^ b_TranS - Проверка в CHILD */
/* Справочник основных средств ^ Основные средства: Проводка - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranS a WITH(NOLOCK), deleted d WHERE a.AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_TranS', 3
      RETURN
    END

/* r_Assets ^ b_zInH - Проверка в CHILD */
/* Справочник основных средств ^ Ручные входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInH a WITH(NOLOCK), deleted d WHERE a.C_AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_zInH', 3
      RETURN
    END

/* r_Assets ^ b_zInH - Проверка в CHILD */
/* Справочник основных средств ^ Ручные входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInH a WITH(NOLOCK), deleted d WHERE a.D_AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_zInH', 3
      RETURN
    END

/* r_Assets ^ b_zInS - Проверка в CHILD */
/* Справочник основных средств ^ Входящий баланс: Основные средства - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInS a WITH(NOLOCK), deleted d WHERE a.AssID = d.AssID)
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_zInS', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10704001 AND m.PKValue = 
    '[' + cast(i.AssID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10704001 AND m.PKValue = 
    '[' + cast(i.AssID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10704001, -ChID, 
    '[' + cast(d.AssID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10704 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Assets', N'Last', N'DELETE'
GO