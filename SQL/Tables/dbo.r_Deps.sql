CREATE TABLE [dbo].[r_Deps] (
  [ChID] [bigint] NOT NULL,
  [DepID] [smallint] NOT NULL,
  [DepName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [pk_r_Deps] PRIMARY KEY CLUSTERED ([DepID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Deps] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [DepName]
  ON [dbo].[r_Deps] ([DepName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Deps.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Deps.DepID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Deps] ON [r_Deps]
FOR INSERT AS
/* r_Deps - Справочник отделов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10115001, ChID, 
    '[' + cast(i.DepID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_Deps', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Deps] ON [r_Deps]
FOR UPDATE AS
/* r_Deps - Справочник отделов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Deps ^ r_ProdMP - Обновление CHILD */
/* Справочник отделов ^ Справочник товаров - Цены для прайс-листов - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM r_ProdMP a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdMP a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Справочник товаров - Цены для прайс-листов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ r_EmpMO - Обновление CHILD */
/* Справочник отделов ^ Справочник служащих - Внутренние фирмы - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.BOldDepID = i.DepID
          FROM r_EmpMO a, inserted i, deleted d WHERE a.BOldDepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpMO a, deleted d WHERE a.BOldDepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Справочник служащих - Внутренние фирмы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ r_EmpMPst - Обновление CHILD */
/* Справочник отделов ^ Справочник служащих - Должности и оплата труда - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM r_EmpMPst a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpMPst a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Справочник служащих - Должности и оплата труда''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ r_StockSubs - Обновление CHILD */
/* Справочник отделов ^ Справочник складов: Склады составляющих - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM r_StockSubs a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_StockSubs a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Справочник складов: Склады составляющих''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ r_AssetH - Обновление CHILD */
/* Справочник отделов ^ Справочник основных средств: История - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM r_AssetH a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_AssetH a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Справочник основных средств: История''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ b_SExc - Обновление CHILD */
/* Справочник отделов ^ Основные средства: Перемещение (Заголовок) - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM b_SExc a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExc a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Основные средства: Перемещение (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ b_SExc - Обновление CHILD */
/* Справочник отделов ^ Основные средства: Перемещение (Заголовок) - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.NewDepID = i.DepID
          FROM b_SExc a, inserted i, deleted d WHERE a.NewDepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExc a, deleted d WHERE a.NewDepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Основные средства: Перемещение (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_CWTimeD - Обновление CHILD */
/* Справочник отделов ^ Табель учета рабочего времени (Данные) - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM p_CWTimeD a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CWTimeD a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Табель учета рабочего времени (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_DTran - Обновление CHILD */
/* Справочник отделов ^ Перенос рабочих дней - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM p_DTran a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_DTran a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Перенос рабочих дней''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_EDis - Обновление CHILD */
/* Справочник отделов ^ Приказ: Увольнение - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM p_EDis a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EDis a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Приказ: Увольнение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_EExc - Обновление CHILD */
/* Справочник отделов ^ Приказ: Кадровое перемещение - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM p_EExc a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EExc a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Приказ: Кадровое перемещение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_EGiv - Обновление CHILD */
/* Справочник отделов ^ Приказ: Прием на работу - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM p_EGiv a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EGiv a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Приказ: Прием на работу''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_ELeavD - Обновление CHILD */
/* Справочник отделов ^ Приказ: Отпуск (Данные) - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM p_ELeavD a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ELeavD a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Приказ: Отпуск (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_EmpSchedExtD - Обновление CHILD */
/* Справочник отделов ^ Приказ: Дополнительный график работы (Список) - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM p_EmpSchedExtD a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EmpSchedExtD a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Приказ: Дополнительный график работы (Список)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_ESic - Обновление CHILD */
/* Справочник отделов ^ Больничный лист (Заголовок) - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM p_ESic a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ESic a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Больничный лист (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_ETrp - Обновление CHILD */
/* Справочник отделов ^ Приказ: Командировка - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM p_ETrp a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ETrp a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Приказ: Командировка''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_EWri - Обновление CHILD */
/* Справочник отделов ^ Исполнительный лист - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM p_EWri a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EWri a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Исполнительный лист''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_EWrkD - Обновление CHILD */
/* Справочник отделов ^ Выполнение работ (Служащие) - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM p_EWrkD a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EWrkD a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Выполнение работ (Служащие)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_LExcD - Обновление CHILD */
/* Справочник отделов ^ Приказ: Кадровое перемещение списком (Данные) - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM p_LExcD a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LExcD a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Приказ: Кадровое перемещение списком (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_LExpD - Обновление CHILD */
/* Справочник отделов ^ Заработная плата: Выплата (Данные) - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM p_LExpD a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LExpD a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Заработная плата: Выплата (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_LMemD - Обновление CHILD */
/* Справочник отделов ^ Штатное расписание (Данные) - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM p_LMemD a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LMemD a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Штатное расписание (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_LRecD - Обновление CHILD */
/* Справочник отделов ^ Заработная плата: Начисление (Данные) - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DetDepID = i.DepID
          FROM p_LRecD a, inserted i, deleted d WHERE a.DetDepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LRecD a, deleted d WHERE a.DetDepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Заработная плата: Начисление (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_LRecDCor - Обновление CHILD */
/* Справочник отделов ^ Заработная плата: Начисление (Корректировка выплат) - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM p_LRecDCor a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LRecDCor a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Заработная плата: Начисление (Корректировка выплат)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_LRecDD - Обновление CHILD */
/* Справочник отделов ^ Заработная плата: Начисление (Подробно) - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM p_LRecDD a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LRecDD a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Заработная плата: Начисление (Подробно)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_LStrD - Обновление CHILD */
/* Справочник отделов ^ Штатная численность сотрудников (Данные) - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM p_LStrD a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LStrD a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Штатная численность сотрудников (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_OPWrkD - Обновление CHILD */
/* Справочник отделов ^ Приказ: Производственный (Данные) - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM p_OPWrkD a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_OPWrkD a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Приказ: Производственный (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Deps ^ p_WExc - Обновление CHILD */
/* Справочник отделов ^ Привлечение на другую работу - Обновление CHILD */
  IF UPDATE(DepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DepID = i.DepID
          FROM p_WExc a, inserted i, deleted d WHERE a.DepID = d.DepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_WExc a, deleted d WHERE a.DepID = d.DepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник отделов'' => ''Привлечение на другую работу''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10115001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10115001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(DepID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10115001 AND l.PKValue = 
        '[' + cast(i.DepID as varchar(200)) + ']' AND i.DepID = d.DepID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10115001 AND l.PKValue = 
        '[' + cast(i.DepID as varchar(200)) + ']' AND i.DepID = d.DepID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10115001, ChID, 
          '[' + cast(d.DepID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10115001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10115001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10115001, ChID, 
          '[' + cast(i.DepID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(DepID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT DepID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT DepID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.DepID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10115001 AND l.PKValue = 
          '[' + cast(d.DepID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.DepID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10115001 AND l.PKValue = 
          '[' + cast(d.DepID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10115001, ChID, 
          '[' + cast(d.DepID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10115001 AND PKValue IN (SELECT 
          '[' + cast(DepID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10115001 AND PKValue IN (SELECT 
          '[' + cast(DepID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10115001, ChID, 
          '[' + cast(i.DepID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10115001, ChID, 
    '[' + cast(i.DepID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Deps', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Deps] ON [r_Deps]
FOR DELETE AS
/* r_Deps - Справочник отделов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Deps ^ r_ProdMP - Проверка в CHILD */
/* Справочник отделов ^ Справочник товаров - Цены для прайс-листов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ProdMP a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'r_ProdMP', 3
      RETURN
    END

/* r_Deps ^ r_EmpMO - Проверка в CHILD */
/* Справочник отделов ^ Справочник служащих - Внутренние фирмы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_EmpMO a WITH(NOLOCK), deleted d WHERE a.BOldDepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'r_EmpMO', 3
      RETURN
    END

/* r_Deps ^ r_EmpMPst - Проверка в CHILD */
/* Справочник отделов ^ Справочник служащих - Должности и оплата труда - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_EmpMPst a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'r_EmpMPst', 3
      RETURN
    END

/* r_Deps ^ r_StockSubs - Проверка в CHILD */
/* Справочник отделов ^ Справочник складов: Склады составляющих - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_StockSubs a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'r_StockSubs', 3
      RETURN
    END

/* r_Deps ^ r_AssetH - Проверка в CHILD */
/* Справочник отделов ^ Справочник основных средств: История - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_AssetH a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'r_AssetH', 3
      RETURN
    END

/* r_Deps ^ b_SExc - Проверка в CHILD */
/* Справочник отделов ^ Основные средства: Перемещение (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExc a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'b_SExc', 3
      RETURN
    END

/* r_Deps ^ b_SExc - Проверка в CHILD */
/* Справочник отделов ^ Основные средства: Перемещение (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExc a WITH(NOLOCK), deleted d WHERE a.NewDepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'b_SExc', 3
      RETURN
    END

/* r_Deps ^ p_CWTimeD - Проверка в CHILD */
/* Справочник отделов ^ Табель учета рабочего времени (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CWTimeD a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_CWTimeD', 3
      RETURN
    END

/* r_Deps ^ p_DTran - Проверка в CHILD */
/* Справочник отделов ^ Перенос рабочих дней - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_DTran a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_DTran', 3
      RETURN
    END

/* r_Deps ^ p_EDis - Проверка в CHILD */
/* Справочник отделов ^ Приказ: Увольнение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EDis a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_EDis', 3
      RETURN
    END

/* r_Deps ^ p_EExc - Проверка в CHILD */
/* Справочник отделов ^ Приказ: Кадровое перемещение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EExc a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_EExc', 3
      RETURN
    END

/* r_Deps ^ p_EGiv - Проверка в CHILD */
/* Справочник отделов ^ Приказ: Прием на работу - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EGiv a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_EGiv', 3
      RETURN
    END

/* r_Deps ^ p_ELeavD - Проверка в CHILD */
/* Справочник отделов ^ Приказ: Отпуск (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ELeavD a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_ELeavD', 3
      RETURN
    END

/* r_Deps ^ p_EmpSchedExtD - Проверка в CHILD */
/* Справочник отделов ^ Приказ: Дополнительный график работы (Список) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EmpSchedExtD a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_EmpSchedExtD', 3
      RETURN
    END

/* r_Deps ^ p_ESic - Проверка в CHILD */
/* Справочник отделов ^ Больничный лист (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ESic a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_ESic', 3
      RETURN
    END

/* r_Deps ^ p_ETrp - Проверка в CHILD */
/* Справочник отделов ^ Приказ: Командировка - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ETrp a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_ETrp', 3
      RETURN
    END

/* r_Deps ^ p_EWri - Проверка в CHILD */
/* Справочник отделов ^ Исполнительный лист - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EWri a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_EWri', 3
      RETURN
    END

/* r_Deps ^ p_EWrkD - Проверка в CHILD */
/* Справочник отделов ^ Выполнение работ (Служащие) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EWrkD a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_EWrkD', 3
      RETURN
    END

/* r_Deps ^ p_LExcD - Проверка в CHILD */
/* Справочник отделов ^ Приказ: Кадровое перемещение списком (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LExcD a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_LExcD', 3
      RETURN
    END

/* r_Deps ^ p_LExpD - Проверка в CHILD */
/* Справочник отделов ^ Заработная плата: Выплата (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LExpD a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_LExpD', 3
      RETURN
    END

/* r_Deps ^ p_LMemD - Проверка в CHILD */
/* Справочник отделов ^ Штатное расписание (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LMemD a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_LMemD', 3
      RETURN
    END

/* r_Deps ^ p_LRecD - Проверка в CHILD */
/* Справочник отделов ^ Заработная плата: Начисление (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LRecD a WITH(NOLOCK), deleted d WHERE a.DetDepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_LRecD', 3
      RETURN
    END

/* r_Deps ^ p_LRecDCor - Проверка в CHILD */
/* Справочник отделов ^ Заработная плата: Начисление (Корректировка выплат) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LRecDCor a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_LRecDCor', 3
      RETURN
    END

/* r_Deps ^ p_LRecDD - Проверка в CHILD */
/* Справочник отделов ^ Заработная плата: Начисление (Подробно) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LRecDD a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_LRecDD', 3
      RETURN
    END

/* r_Deps ^ p_LStrD - Проверка в CHILD */
/* Справочник отделов ^ Штатная численность сотрудников (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LStrD a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_LStrD', 3
      RETURN
    END

/* r_Deps ^ p_OPWrkD - Проверка в CHILD */
/* Справочник отделов ^ Приказ: Производственный (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_OPWrkD a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_OPWrkD', 3
      RETURN
    END

/* r_Deps ^ p_WExc - Проверка в CHILD */
/* Справочник отделов ^ Привлечение на другую работу - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_WExc a WITH(NOLOCK), deleted d WHERE a.DepID = d.DepID)
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_WExc', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10115001 AND m.PKValue = 
    '[' + cast(i.DepID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10115001 AND m.PKValue = 
    '[' + cast(i.DepID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10115001, -ChID, 
    '[' + cast(d.DepID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10115 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Deps', N'Last', N'DELETE'
GO