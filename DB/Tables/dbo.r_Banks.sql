CREATE TABLE [dbo].[r_Banks]
(
[ChID] [bigint] NOT NULL,
[BankID] [int] NOT NULL,
[BankName] [varchar] (200) NOT NULL,
[Address] [varchar] (200) NULL,
[PostIndex] [varchar] (10) NULL,
[City] [varchar] (200) NOT NULL,
[Region] [varchar] (200) NULL,
[Phone] [varchar] (20) NULL,
[Fax] [varchar] (20) NULL,
[BankGrID] [int] NOT NULL DEFAULT ((0)),
[SWIFTBICCode] [varchar] (11) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Banks] ON [dbo].[r_Banks]
FOR INSERT AS
/* r_Banks - Справочник банков - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Banks ^ r_BankGrs - Проверка в PARENT */
/* Справочник банков ^ Справочник банков - группы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.BankGrID NOT IN (SELECT BankGrID FROM r_BankGrs))
    BEGIN
      EXEC z_RelationError 'r_BankGrs', 'r_Banks', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10101001, ChID, 
    '[' + cast(i.BankID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_Banks]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Banks] ON [dbo].[r_Banks]
FOR UPDATE AS
/* r_Banks - Справочник банков - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Banks ^ r_BankGrs - Проверка в PARENT */
/* Справочник банков ^ Справочник банков - группы - Проверка в PARENT */
  IF UPDATE(BankGrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.BankGrID NOT IN (SELECT BankGrID FROM r_BankGrs))
      BEGIN
        EXEC z_RelationError 'r_BankGrs', 'r_Banks', 1
        RETURN
      END

/* r_Banks ^ r_EmpMO - Обновление CHILD */
/* Справочник банков ^ Справочник служащих - Внутренние фирмы - Обновление CHILD */
  IF UPDATE(BankID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.BankID = i.BankID
          FROM r_EmpMO a, inserted i, deleted d WHERE a.BankID = d.BankID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpMO a, deleted d WHERE a.BankID = d.BankID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник банков'' => ''Справочник служащих - Внутренние фирмы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Banks ^ r_CompsAC - Обновление CHILD */
/* Справочник банков ^ Справочник предприятий - Валютные счета - Обновление CHILD */
  IF UPDATE(BankID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.BankID = i.BankID
          FROM r_CompsAC a, inserted i, deleted d WHERE a.BankID = d.BankID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CompsAC a, deleted d WHERE a.BankID = d.BankID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник банков'' => ''Справочник предприятий - Валютные счета''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Banks ^ r_CompsCC - Обновление CHILD */
/* Справочник банков ^ Справочник предприятий - Расчетные счета - Обновление CHILD */
  IF UPDATE(BankID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.BankID = i.BankID
          FROM r_CompsCC a, inserted i, deleted d WHERE a.BankID = d.BankID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CompsCC a, deleted d WHERE a.BankID = d.BankID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник банков'' => ''Справочник предприятий - Расчетные счета''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Banks ^ r_POSPays - Обновление CHILD */
/* Справочник банков ^ Справочник платежных терминалов - Обновление CHILD */
  IF UPDATE(BankID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.BankID = i.BankID
          FROM r_POSPays a, inserted i, deleted d WHERE a.BankID = d.BankID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_POSPays a, deleted d WHERE a.BankID = d.BankID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник банков'' => ''Справочник платежных терминалов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Banks ^ r_OursAC - Обновление CHILD */
/* Справочник банков ^ Справочник внутренних фирм - Валютные счета - Обновление CHILD */
  IF UPDATE(BankID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.BankID = i.BankID
          FROM r_OursAC a, inserted i, deleted d WHERE a.BankID = d.BankID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_OursAC a, deleted d WHERE a.BankID = d.BankID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник банков'' => ''Справочник внутренних фирм - Валютные счета''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Banks ^ r_OursCC - Обновление CHILD */
/* Справочник банков ^ Справочник внутренних фирм - Расчетные счета - Обновление CHILD */
  IF UPDATE(BankID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.BankID = i.BankID
          FROM r_OursCC a, inserted i, deleted d WHERE a.BankID = d.BankID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_OursCC a, deleted d WHERE a.BankID = d.BankID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник банков'' => ''Справочник внутренних фирм - Расчетные счета''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Banks ^ b_BankPayCC - Обновление CHILD */
/* Справочник банков ^ Платежное поручение - Обновление CHILD */
  IF UPDATE(BankID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.BankID = i.BankID
          FROM b_BankPayCC a, inserted i, deleted d WHERE a.BankID = d.BankID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankPayCC a, deleted d WHERE a.BankID = d.BankID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник банков'' => ''Платежное поручение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Banks ^ p_EGiv - Обновление CHILD */
/* Справочник банков ^ Приказ: Прием на работу - Обновление CHILD */
  IF UPDATE(BankID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.BankID = i.BankID
          FROM p_EGiv a, inserted i, deleted d WHERE a.BankID = d.BankID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EGiv a, deleted d WHERE a.BankID = d.BankID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник банков'' => ''Приказ: Прием на работу''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Banks ^ p_EWri - Обновление CHILD */
/* Справочник банков ^ Исполнительный лист - Обновление CHILD */
  IF UPDATE(BankID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.BankID = i.BankID
          FROM p_EWri a, inserted i, deleted d WHERE a.BankID = d.BankID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EWri a, deleted d WHERE a.BankID = d.BankID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник банков'' => ''Исполнительный лист''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10101001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10101001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(BankID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10101001 AND l.PKValue = 
        '[' + cast(i.BankID as varchar(200)) + ']' AND i.BankID = d.BankID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10101001 AND l.PKValue = 
        '[' + cast(i.BankID as varchar(200)) + ']' AND i.BankID = d.BankID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10101001, ChID, 
          '[' + cast(d.BankID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10101001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10101001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10101001, ChID, 
          '[' + cast(i.BankID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(BankID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT BankID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT BankID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.BankID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10101001 AND l.PKValue = 
          '[' + cast(d.BankID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.BankID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10101001 AND l.PKValue = 
          '[' + cast(d.BankID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10101001, ChID, 
          '[' + cast(d.BankID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10101001 AND PKValue IN (SELECT 
          '[' + cast(BankID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10101001 AND PKValue IN (SELECT 
          '[' + cast(BankID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10101001, ChID, 
          '[' + cast(i.BankID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10101001, ChID, 
    '[' + cast(i.BankID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_Banks]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Banks] ON [dbo].[r_Banks]
FOR DELETE AS
/* r_Banks - Справочник банков - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Banks ^ r_EmpMO - Проверка в CHILD */
/* Справочник банков ^ Справочник служащих - Внутренние фирмы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_EmpMO a WITH(NOLOCK), deleted d WHERE a.BankID = d.BankID)
    BEGIN
      EXEC z_RelationError 'r_Banks', 'r_EmpMO', 3
      RETURN
    END

/* r_Banks ^ r_CompsAC - Проверка в CHILD */
/* Справочник банков ^ Справочник предприятий - Валютные счета - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_CompsAC a WITH(NOLOCK), deleted d WHERE a.BankID = d.BankID)
    BEGIN
      EXEC z_RelationError 'r_Banks', 'r_CompsAC', 3
      RETURN
    END

/* r_Banks ^ r_CompsCC - Проверка в CHILD */
/* Справочник банков ^ Справочник предприятий - Расчетные счета - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_CompsCC a WITH(NOLOCK), deleted d WHERE a.BankID = d.BankID)
    BEGIN
      EXEC z_RelationError 'r_Banks', 'r_CompsCC', 3
      RETURN
    END

/* r_Banks ^ r_POSPays - Проверка в CHILD */
/* Справочник банков ^ Справочник платежных терминалов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_POSPays a WITH(NOLOCK), deleted d WHERE a.BankID = d.BankID)
    BEGIN
      EXEC z_RelationError 'r_Banks', 'r_POSPays', 3
      RETURN
    END

/* r_Banks ^ r_OursAC - Проверка в CHILD */
/* Справочник банков ^ Справочник внутренних фирм - Валютные счета - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_OursAC a WITH(NOLOCK), deleted d WHERE a.BankID = d.BankID)
    BEGIN
      EXEC z_RelationError 'r_Banks', 'r_OursAC', 3
      RETURN
    END

/* r_Banks ^ r_OursCC - Проверка в CHILD */
/* Справочник банков ^ Справочник внутренних фирм - Расчетные счета - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_OursCC a WITH(NOLOCK), deleted d WHERE a.BankID = d.BankID)
    BEGIN
      EXEC z_RelationError 'r_Banks', 'r_OursCC', 3
      RETURN
    END

/* r_Banks ^ b_BankPayCC - Проверка в CHILD */
/* Справочник банков ^ Платежное поручение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankPayCC a WITH(NOLOCK), deleted d WHERE a.BankID = d.BankID)
    BEGIN
      EXEC z_RelationError 'r_Banks', 'b_BankPayCC', 3
      RETURN
    END

/* r_Banks ^ p_EGiv - Проверка в CHILD */
/* Справочник банков ^ Приказ: Прием на работу - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EGiv a WITH(NOLOCK), deleted d WHERE a.BankID = d.BankID)
    BEGIN
      EXEC z_RelationError 'r_Banks', 'p_EGiv', 3
      RETURN
    END

/* r_Banks ^ p_EWri - Проверка в CHILD */
/* Справочник банков ^ Исполнительный лист - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EWri a WITH(NOLOCK), deleted d WHERE a.BankID = d.BankID)
    BEGIN
      EXEC z_RelationError 'r_Banks', 'p_EWri', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10101001 AND m.PKValue = 
    '[' + cast(i.BankID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10101001 AND m.PKValue = 
    '[' + cast(i.BankID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10101001, -ChID, 
    '[' + cast(d.BankID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10101 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_Banks]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_Banks] ADD CONSTRAINT [pk_r_Banks] PRIMARY KEY CLUSTERED ([BankID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [BankName] ON [dbo].[r_Banks] ([BankName]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Banks] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [City] ON [dbo].[r_Banks] ([City]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Banks].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Banks].[BankID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Banks].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Banks].[BankID]'
GO
