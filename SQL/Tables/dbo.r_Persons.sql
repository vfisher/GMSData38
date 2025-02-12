CREATE TABLE [dbo].[r_Persons] (
  [ChID] [bigint] NOT NULL,
  [PersonID] [bigint] NOT NULL,
  [PersonName] [varchar](250) NOT NULL,
  [BarCode] [varchar](50) NULL,
  [Birthday] [smalldatetime] NULL,
  [Phone] [varchar](20) NULL,
  [EMail] [varchar](200) NULL,
  [Address] [varchar](200) NULL,
  [Preferences] [varchar](2000) NULL,
  [ReferalPersonID] [bigint] NULL,
  [State] [int] NOT NULL,
  [Picture] [image] NULL,
  [Sex] [tinyint] NOT NULL DEFAULT (0),
  [PhoneHome] [varchar](250) NULL,
  [PhoneWork] [varchar](250) NULL,
  [FactRegion] [varchar](250) NULL,
  [FactDistrict] [varchar](250) NULL,
  [FactCity] [varchar](250) NULL,
  [FactStreet] [varchar](250) NULL,
  [FactHouse] [varchar](250) NULL,
  [FactBlock] [varchar](250) NULL,
  [FactAptNo] [varchar](250) NULL,
  CONSTRAINT [pk_r_Persons] PRIMARY KEY CLUSTERED ([PersonID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [BarCode]
  ON [dbo].[r_Persons] ([BarCode])
  WHERE ([BarCode] IS NOT NULL AND [BarCode]<>'')
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Persons] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [EMail]
  ON [dbo].[r_Persons] ([EMail])
  WHERE ([EMail] IS NOT NULL AND [EMail]<>'')
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [Phone]
  ON [dbo].[r_Persons] ([Phone])
  WHERE ([Phone] IS NOT NULL AND [Phone]<>'')
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Persons] ON [r_Persons]
FOR INSERT AS
/* r_Persons - Справочник персон - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Persons ^ r_Uni - Проверка в PARENT */
/* Справочник персон ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.Sex NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10011))
    BEGIN
      EXEC z_RelationErrorUni 'r_Persons', 10011, 0
      RETURN
    END

/* r_Persons ^ r_Uni - Проверка в PARENT */
/* Справочник персон ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.State NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10701))
    BEGIN
      EXEC z_RelationErrorUni 'r_Persons', 10701, 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11118001, ChID, 
    '[' + cast(i.PersonID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_Persons', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Persons] ON [r_Persons]
FOR UPDATE AS
/* r_Persons - Справочник персон - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Persons ^ r_Uni - Проверка в PARENT */
/* Справочник персон ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(Sex)
    IF EXISTS (SELECT * FROM inserted i WHERE i.Sex NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10011))
      BEGIN
        EXEC z_RelationErrorUni 'r_Persons', 10011, 1
        RETURN
      END

/* r_Persons ^ r_Uni - Проверка в PARENT */
/* Справочник персон ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(State)
    IF EXISTS (SELECT * FROM inserted i WHERE i.State NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10701))
      BEGIN
        EXEC z_RelationErrorUni 'r_Persons', 10701, 1
        RETURN
      END

/* r_Persons ^ r_PersonDC - Обновление CHILD */
/* Справочник персон ^ Справочник персон - дисконтные карты - Обновление CHILD */
  IF UPDATE(PersonID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PersonID = i.PersonID
          FROM r_PersonDC a, inserted i, deleted d WHERE a.PersonID = d.PersonID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_PersonDC a, deleted d WHERE a.PersonID = d.PersonID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник персон'' => ''Справочник персон - дисконтные карты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Persons ^ r_PersonExecutorsBL - Обновление CHILD */
/* Справочник персон ^ Справочник персон - черный список исполнителей - Обновление CHILD */
  IF UPDATE(PersonID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PersonID = i.PersonID
          FROM r_PersonExecutorsBL a, inserted i, deleted d WHERE a.PersonID = d.PersonID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_PersonExecutorsBL a, deleted d WHERE a.PersonID = d.PersonID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник персон'' => ''Справочник персон - черный список исполнителей''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Persons ^ r_PersonKin - Обновление CHILD */
/* Справочник персон ^ Справочник персон - члены семьи - Обновление CHILD */
  IF UPDATE(PersonID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PersonID = i.PersonID
          FROM r_PersonKin a, inserted i, deleted d WHERE a.PersonID = d.PersonID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_PersonKin a, deleted d WHERE a.PersonID = d.PersonID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник персон'' => ''Справочник персон - члены семьи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Persons ^ r_PersonPreferences - Обновление CHILD */
/* Справочник персон ^ Справочник персон - предпочтения - Обновление CHILD */
  IF UPDATE(PersonID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PersonID = i.PersonID
          FROM r_PersonPreferences a, inserted i, deleted d WHERE a.PersonID = d.PersonID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_PersonPreferences a, deleted d WHERE a.PersonID = d.PersonID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник персон'' => ''Справочник персон - предпочтения''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Persons ^ r_PersonResourcesBL - Обновление CHILD */
/* Справочник персон ^ Справочник персон - черный список ресурсов - Обновление CHILD */
  IF UPDATE(PersonID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PersonID = i.PersonID
          FROM r_PersonResourcesBL a, inserted i, deleted d WHERE a.PersonID = d.PersonID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_PersonResourcesBL a, deleted d WHERE a.PersonID = d.PersonID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник персон'' => ''Справочник персон - черный список ресурсов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Persons ^ t_Booking - Обновление CHILD */
/* Справочник персон ^ Заявки - Обновление CHILD */
  IF UPDATE(PersonID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PersonID = i.PersonID
          FROM t_Booking a, inserted i, deleted d WHERE a.PersonID = d.PersonID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Booking a, deleted d WHERE a.PersonID = d.PersonID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник персон'' => ''Заявки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Persons ^ t_DeskRes - Обновление CHILD */
/* Справочник персон ^ Ресторан: Резервирование столиков - Обновление CHILD */
  IF UPDATE(PersonID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PersonID = i.PersonID
          FROM t_DeskRes a, inserted i, deleted d WHERE a.PersonID = d.PersonID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_DeskRes a, deleted d WHERE a.PersonID = d.PersonID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник персон'' => ''Ресторан: Резервирование столиков''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11118001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11118001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(PersonID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11118001 AND l.PKValue = 
        '[' + cast(i.PersonID as varchar(200)) + ']' AND i.PersonID = d.PersonID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11118001 AND l.PKValue = 
        '[' + cast(i.PersonID as varchar(200)) + ']' AND i.PersonID = d.PersonID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11118001, ChID, 
          '[' + cast(d.PersonID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11118001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11118001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11118001, ChID, 
          '[' + cast(i.PersonID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(PersonID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT PersonID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT PersonID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.PersonID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11118001 AND l.PKValue = 
          '[' + cast(d.PersonID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.PersonID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11118001 AND l.PKValue = 
          '[' + cast(d.PersonID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11118001, ChID, 
          '[' + cast(d.PersonID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11118001 AND PKValue IN (SELECT 
          '[' + cast(PersonID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11118001 AND PKValue IN (SELECT 
          '[' + cast(PersonID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11118001, ChID, 
          '[' + cast(i.PersonID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11118001, ChID, 
    '[' + cast(i.PersonID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Persons', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Persons] ON [r_Persons]
FOR DELETE AS
/* r_Persons - Справочник персон - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Persons ^ r_PersonDC - Проверка в CHILD */
/* Справочник персон ^ Справочник персон - дисконтные карты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_PersonDC a WITH(NOLOCK), deleted d WHERE a.PersonID = d.PersonID)
    BEGIN
      EXEC z_RelationError 'r_Persons', 'r_PersonDC', 3
      RETURN
    END

/* r_Persons ^ r_PersonExecutorsBL - Удаление в CHILD */
/* Справочник персон ^ Справочник персон - черный список исполнителей - Удаление в CHILD */
  DELETE r_PersonExecutorsBL FROM r_PersonExecutorsBL a, deleted d WHERE a.PersonID = d.PersonID
  IF @@ERROR > 0 RETURN

/* r_Persons ^ r_PersonKin - Удаление в CHILD */
/* Справочник персон ^ Справочник персон - члены семьи - Удаление в CHILD */
  DELETE r_PersonKin FROM r_PersonKin a, deleted d WHERE a.PersonID = d.PersonID
  IF @@ERROR > 0 RETURN

/* r_Persons ^ r_PersonPreferences - Удаление в CHILD */
/* Справочник персон ^ Справочник персон - предпочтения - Удаление в CHILD */
  DELETE r_PersonPreferences FROM r_PersonPreferences a, deleted d WHERE a.PersonID = d.PersonID
  IF @@ERROR > 0 RETURN

/* r_Persons ^ r_PersonResourcesBL - Удаление в CHILD */
/* Справочник персон ^ Справочник персон - черный список ресурсов - Удаление в CHILD */
  DELETE r_PersonResourcesBL FROM r_PersonResourcesBL a, deleted d WHERE a.PersonID = d.PersonID
  IF @@ERROR > 0 RETURN

/* r_Persons ^ t_Booking - Проверка в CHILD */
/* Справочник персон ^ Заявки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Booking a WITH(NOLOCK), deleted d WHERE a.PersonID = d.PersonID)
    BEGIN
      EXEC z_RelationError 'r_Persons', 't_Booking', 3
      RETURN
    END

/* r_Persons ^ t_DeskRes - Проверка в CHILD */
/* Справочник персон ^ Ресторан: Резервирование столиков - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_DeskRes a WITH(NOLOCK), deleted d WHERE a.PersonID = d.PersonID)
    BEGIN
      EXEC z_RelationError 'r_Persons', 't_DeskRes', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11118001 AND m.PKValue = 
    '[' + cast(i.PersonID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11118001 AND m.PKValue = 
    '[' + cast(i.PersonID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11118001, -ChID, 
    '[' + cast(d.PersonID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 11118 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Persons', N'Last', N'DELETE'
GO