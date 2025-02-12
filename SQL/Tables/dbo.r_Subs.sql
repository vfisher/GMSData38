CREATE TABLE [dbo].[r_Subs] (
  [ChID] [bigint] NOT NULL,
  [SubID] [smallint] NOT NULL,
  [SubName] [varchar](200) NOT NULL,
  [FormDate] [smalldatetime] NULL,
  [DisbDate] [smalldatetime] NULL,
  [ShedID] [smallint] NOT NULL,
  [Notes] [varchar](200) NULL,
  [TaxRegionID] [int] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_r_Subs] PRIMARY KEY CLUSTERED ([SubID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Subs] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [ShedID]
  ON [dbo].[r_Subs] ([ShedID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [SubName]
  ON [dbo].[r_Subs] ([SubName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Subs.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Subs.SubID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Subs.ShedID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Subs] ON [r_Subs]
FOR INSERT AS
/* r_Subs - Справочник работ: подразделения - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Subs ^ r_Sheds - Проверка в PARENT */
/* Справочник работ: подразделения ^ Справочник работ: графики - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ShedID NOT IN (SELECT ShedID FROM r_Sheds))
    BEGIN
      EXEC z_RelationError 'r_Sheds', 'r_Subs', 0
      RETURN
    END

/* r_Subs ^ r_TaxRegions - Проверка в PARENT */
/* Справочник работ: подразделения ^ Справочник местных налогов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TaxRegionID NOT IN (SELECT TaxRegionID FROM r_TaxRegions))
    BEGIN
      EXEC z_RelationError 'r_TaxRegions', 'r_Subs', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10096001, ChID, 
    '[' + cast(i.SubID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_Subs', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Subs] ON [r_Subs]
FOR UPDATE AS
/* r_Subs - Справочник работ: подразделения - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Subs ^ r_Sheds - Проверка в PARENT */
/* Справочник работ: подразделения ^ Справочник работ: графики - Проверка в PARENT */
  IF UPDATE(ShedID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ShedID NOT IN (SELECT ShedID FROM r_Sheds))
      BEGIN
        EXEC z_RelationError 'r_Sheds', 'r_Subs', 1
        RETURN
      END

/* r_Subs ^ r_TaxRegions - Проверка в PARENT */
/* Справочник работ: подразделения ^ Справочник местных налогов - Проверка в PARENT */
  IF UPDATE(TaxRegionID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TaxRegionID NOT IN (SELECT TaxRegionID FROM r_TaxRegions))
      BEGIN
        EXEC z_RelationError 'r_TaxRegions', 'r_Subs', 1
        RETURN
      END

/* r_Subs ^ r_EmpMPst - Обновление CHILD */
/* Справочник работ: подразделения ^ Справочник служащих - Должности и оплата труда - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM r_EmpMPst a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpMPst a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Справочник служащих - Должности и оплата труда''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_CWTimeD - Обновление CHILD */
/* Справочник работ: подразделения ^ Табель учета рабочего времени (Данные) - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_CWTimeD a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CWTimeD a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Табель учета рабочего времени (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_DTran - Обновление CHILD */
/* Справочник работ: подразделения ^ Перенос рабочих дней - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_DTran a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_DTran a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Перенос рабочих дней''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_EDis - Обновление CHILD */
/* Справочник работ: подразделения ^ Приказ: Увольнение - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_EDis a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EDis a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Приказ: Увольнение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_EExc - Обновление CHILD */
/* Справочник работ: подразделения ^ Приказ: Кадровое перемещение - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_EExc a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EExc a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Приказ: Кадровое перемещение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_EGiv - Обновление CHILD */
/* Справочник работ: подразделения ^ Приказ: Прием на работу - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_EGiv a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EGiv a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Приказ: Прием на работу''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_ELeavD - Обновление CHILD */
/* Справочник работ: подразделения ^ Приказ: Отпуск (Данные) - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_ELeavD a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ELeavD a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Приказ: Отпуск (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_EmpSchedExtD - Обновление CHILD */
/* Справочник работ: подразделения ^ Приказ: Дополнительный график работы (Список) - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_EmpSchedExtD a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EmpSchedExtD a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Приказ: Дополнительный график работы (Список)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_ESic - Обновление CHILD */
/* Справочник работ: подразделения ^ Больничный лист (Заголовок) - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_ESic a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ESic a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Больничный лист (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_ETrp - Обновление CHILD */
/* Справочник работ: подразделения ^ Приказ: Командировка - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_ETrp a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ETrp a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Приказ: Командировка''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_EWri - Обновление CHILD */
/* Справочник работ: подразделения ^ Исполнительный лист - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_EWri a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EWri a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Исполнительный лист''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_EWrkD - Обновление CHILD */
/* Справочник работ: подразделения ^ Выполнение работ (Служащие) - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_EWrkD a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EWrkD a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Выполнение работ (Служащие)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_LExcD - Обновление CHILD */
/* Справочник работ: подразделения ^ Приказ: Кадровое перемещение списком (Данные) - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_LExcD a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LExcD a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Приказ: Кадровое перемещение списком (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_LExpD - Обновление CHILD */
/* Справочник работ: подразделения ^ Заработная плата: Выплата (Данные) - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_LExpD a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LExpD a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Заработная плата: Выплата (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_LMemD - Обновление CHILD */
/* Справочник работ: подразделения ^ Штатное расписание (Данные) - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_LMemD a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LMemD a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Штатное расписание (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_LRecD - Обновление CHILD */
/* Справочник работ: подразделения ^ Заработная плата: Начисление (Данные) - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DetSubID = i.SubID
          FROM p_LRecD a, inserted i, deleted d WHERE a.DetSubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LRecD a, deleted d WHERE a.DetSubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Заработная плата: Начисление (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_LRecDCor - Обновление CHILD */
/* Справочник работ: подразделения ^ Заработная плата: Начисление (Корректировка выплат) - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_LRecDCor a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LRecDCor a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Заработная плата: Начисление (Корректировка выплат)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_LRecDD - Обновление CHILD */
/* Справочник работ: подразделения ^ Заработная плата: Начисление (Подробно) - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_LRecDD a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LRecDD a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Заработная плата: Начисление (Подробно)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_LStr - Обновление CHILD */
/* Справочник работ: подразделения ^ Штатная численность сотрудников (Заголовок) - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_LStr a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LStr a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Штатная численность сотрудников (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_OPWrkD - Обновление CHILD */
/* Справочник работ: подразделения ^ Приказ: Производственный (Данные) - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_OPWrkD a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_OPWrkD a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Приказ: Производственный (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_PostStrucD - Обновление CHILD */
/* Справочник работ: подразделения ^ Структура должностей (Список) - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_PostStrucD a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_PostStrucD a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Структура должностей (Список)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_SubStrucD - Обновление CHILD */
/* Справочник работ: подразделения ^ Структура предприятия (Список) - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ParentSubID = i.SubID
          FROM p_SubStrucD a, inserted i, deleted d WHERE a.ParentSubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_SubStrucD a, deleted d WHERE a.ParentSubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Структура предприятия (Список)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_SubStrucD - Обновление CHILD */
/* Справочник работ: подразделения ^ Структура предприятия (Список) - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_SubStrucD a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_SubStrucD a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Структура предприятия (Список)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Subs ^ p_WExc - Обновление CHILD */
/* Справочник работ: подразделения ^ Привлечение на другую работу - Обновление CHILD */
  IF UPDATE(SubID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubID = i.SubID
          FROM p_WExc a, inserted i, deleted d WHERE a.SubID = d.SubID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_WExc a, deleted d WHERE a.SubID = d.SubID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: подразделения'' => ''Привлечение на другую работу''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10096001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10096001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(SubID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10096001 AND l.PKValue = 
        '[' + cast(i.SubID as varchar(200)) + ']' AND i.SubID = d.SubID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10096001 AND l.PKValue = 
        '[' + cast(i.SubID as varchar(200)) + ']' AND i.SubID = d.SubID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10096001, ChID, 
          '[' + cast(d.SubID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10096001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10096001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10096001, ChID, 
          '[' + cast(i.SubID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(SubID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT SubID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT SubID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.SubID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10096001 AND l.PKValue = 
          '[' + cast(d.SubID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.SubID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10096001 AND l.PKValue = 
          '[' + cast(d.SubID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10096001, ChID, 
          '[' + cast(d.SubID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10096001 AND PKValue IN (SELECT 
          '[' + cast(SubID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10096001 AND PKValue IN (SELECT 
          '[' + cast(SubID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10096001, ChID, 
          '[' + cast(i.SubID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10096001, ChID, 
    '[' + cast(i.SubID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Subs', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Subs] ON [r_Subs]
FOR DELETE AS
/* r_Subs - Справочник работ: подразделения - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Subs ^ r_EmpMPst - Проверка в CHILD */
/* Справочник работ: подразделения ^ Справочник служащих - Должности и оплата труда - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_EmpMPst a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'r_EmpMPst', 3
      RETURN
    END

/* r_Subs ^ p_CWTimeD - Проверка в CHILD */
/* Справочник работ: подразделения ^ Табель учета рабочего времени (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CWTimeD a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_CWTimeD', 3
      RETURN
    END

/* r_Subs ^ p_DTran - Проверка в CHILD */
/* Справочник работ: подразделения ^ Перенос рабочих дней - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_DTran a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_DTran', 3
      RETURN
    END

/* r_Subs ^ p_EDis - Проверка в CHILD */
/* Справочник работ: подразделения ^ Приказ: Увольнение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EDis a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_EDis', 3
      RETURN
    END

/* r_Subs ^ p_EExc - Проверка в CHILD */
/* Справочник работ: подразделения ^ Приказ: Кадровое перемещение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EExc a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_EExc', 3
      RETURN
    END

/* r_Subs ^ p_EGiv - Проверка в CHILD */
/* Справочник работ: подразделения ^ Приказ: Прием на работу - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EGiv a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_EGiv', 3
      RETURN
    END

/* r_Subs ^ p_ELeavD - Проверка в CHILD */
/* Справочник работ: подразделения ^ Приказ: Отпуск (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ELeavD a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_ELeavD', 3
      RETURN
    END

/* r_Subs ^ p_EmpSchedExtD - Проверка в CHILD */
/* Справочник работ: подразделения ^ Приказ: Дополнительный график работы (Список) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EmpSchedExtD a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_EmpSchedExtD', 3
      RETURN
    END

/* r_Subs ^ p_ESic - Проверка в CHILD */
/* Справочник работ: подразделения ^ Больничный лист (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ESic a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_ESic', 3
      RETURN
    END

/* r_Subs ^ p_ETrp - Проверка в CHILD */
/* Справочник работ: подразделения ^ Приказ: Командировка - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ETrp a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_ETrp', 3
      RETURN
    END

/* r_Subs ^ p_EWri - Проверка в CHILD */
/* Справочник работ: подразделения ^ Исполнительный лист - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EWri a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_EWri', 3
      RETURN
    END

/* r_Subs ^ p_EWrkD - Проверка в CHILD */
/* Справочник работ: подразделения ^ Выполнение работ (Служащие) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EWrkD a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_EWrkD', 3
      RETURN
    END

/* r_Subs ^ p_LExcD - Проверка в CHILD */
/* Справочник работ: подразделения ^ Приказ: Кадровое перемещение списком (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LExcD a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_LExcD', 3
      RETURN
    END

/* r_Subs ^ p_LExpD - Проверка в CHILD */
/* Справочник работ: подразделения ^ Заработная плата: Выплата (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LExpD a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_LExpD', 3
      RETURN
    END

/* r_Subs ^ p_LMemD - Проверка в CHILD */
/* Справочник работ: подразделения ^ Штатное расписание (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LMemD a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_LMemD', 3
      RETURN
    END

/* r_Subs ^ p_LRecD - Проверка в CHILD */
/* Справочник работ: подразделения ^ Заработная плата: Начисление (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LRecD a WITH(NOLOCK), deleted d WHERE a.DetSubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_LRecD', 3
      RETURN
    END

/* r_Subs ^ p_LRecDCor - Проверка в CHILD */
/* Справочник работ: подразделения ^ Заработная плата: Начисление (Корректировка выплат) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LRecDCor a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_LRecDCor', 3
      RETURN
    END

/* r_Subs ^ p_LRecDD - Проверка в CHILD */
/* Справочник работ: подразделения ^ Заработная плата: Начисление (Подробно) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LRecDD a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_LRecDD', 3
      RETURN
    END

/* r_Subs ^ p_LStr - Проверка в CHILD */
/* Справочник работ: подразделения ^ Штатная численность сотрудников (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LStr a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_LStr', 3
      RETURN
    END

/* r_Subs ^ p_OPWrkD - Проверка в CHILD */
/* Справочник работ: подразделения ^ Приказ: Производственный (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_OPWrkD a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_OPWrkD', 3
      RETURN
    END

/* r_Subs ^ p_PostStrucD - Проверка в CHILD */
/* Справочник работ: подразделения ^ Структура должностей (Список) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_PostStrucD a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_PostStrucD', 3
      RETURN
    END

/* r_Subs ^ p_SubStrucD - Проверка в CHILD */
/* Справочник работ: подразделения ^ Структура предприятия (Список) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_SubStrucD a WITH(NOLOCK), deleted d WHERE a.ParentSubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_SubStrucD', 3
      RETURN
    END

/* r_Subs ^ p_SubStrucD - Проверка в CHILD */
/* Справочник работ: подразделения ^ Структура предприятия (Список) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_SubStrucD a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_SubStrucD', 3
      RETURN
    END

/* r_Subs ^ p_WExc - Проверка в CHILD */
/* Справочник работ: подразделения ^ Привлечение на другую работу - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_WExc a WITH(NOLOCK), deleted d WHERE a.SubID = d.SubID)
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_WExc', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10096001 AND m.PKValue = 
    '[' + cast(i.SubID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10096001 AND m.PKValue = 
    '[' + cast(i.SubID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10096001, -ChID, 
    '[' + cast(d.SubID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10096 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Subs', N'Last', N'DELETE'
GO