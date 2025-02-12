CREATE TABLE [dbo].[r_PayTypes] (
  [ChID] [bigint] NOT NULL,
  [PayTypeID] [smallint] NOT NULL,
  [PayTypeCatID] [smallint] NOT NULL,
  [PayTypeName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  [UseTotPensFund] [bit] NOT NULL,
  [UseTotUnEmploy] [bit] NOT NULL,
  [UseTotSocInsure] [bit] NOT NULL,
  [UseTotAccident] [bit] NOT NULL,
  [UseIncomeTax] [bit] NOT NULL,
  [UsePensFund] [bit] NOT NULL,
  [UseUnEmploy] [bit] NOT NULL,
  [UseSocInsure] [bit] NOT NULL,
  [GrossOutlay] [bit] NOT NULL,
  [UseToIndexing] [bit] NOT NULL,
  [UsePrivIncomeTax] [bit] NOT NULL,
  [FundType] [tinyint] NOT NULL,
  [UseInSick] [bit] NOT NULL,
  [UseInLeav] [bit] NOT NULL,
  [UseInTrn] [bit] NOT NULL,
  [SrcDocTypeR] [varchar](255) NULL,
  [SrcDocTypeE] [varchar](255) NULL,
  [DocDateFieldR] [varchar](255) NULL,
  [DocDateFieldE] [varchar](255) NULL,
  [SrcDocFilterR] [varchar](255) NULL,
  [SrcDocFilterE] [varchar](255) NULL,
  [SrcDocExpR] [varchar](255) NULL,
  [SrcDocExpE] [varchar](255) NULL,
  [IsDeduction] [bit] NOT NULL,
  [UseInDisPay] [bit] NOT NULL DEFAULT (0),
  [UseInMainSalaryType] [bit] NOT NULL DEFAULT (0),
  [UseInAdvanceSalaryType] [bit] NOT NULL DEFAULT (0),
  [UseInLeavSalaryType] [bit] NOT NULL DEFAULT (0),
  [UseInPregSick] [bit] NOT NULL DEFAULT (0),
  [UniSocChargeRateExpR] [varchar](250) NOT NULL DEFAULT ('0'),
  [UniSocChargeRateExpE] [varchar](250) NOT NULL DEFAULT ('0'),
  [UniSocDedRateExpR] [varchar](250) NOT NULL DEFAULT ('0'),
  [UniSocDedRateExpE] [varchar](250) NOT NULL DEFAULT ('0'),
  [UniSocPriority] [int] NOT NULL DEFAULT (0),
  [BIncomeTaxExpE] [varchar](250) NOT NULL DEFAULT (''),
  [BIncomeTaxExpR] [varchar](250) NOT NULL DEFAULT (''),
  [UseMilitaryTax] [bit] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_r_PayTypes] PRIMARY KEY CLUSTERED ([PayTypeID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_PayTypes] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [PayTypeCatID]
  ON [dbo].[r_PayTypes] ([PayTypeCatID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [PayTypeName]
  ON [dbo].[r_PayTypes] ([PayTypeName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypes.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypes.PayTypeID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypes.PayTypeCatID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypes.UseTotPensFund'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypes.UseTotUnEmploy'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypes.UseTotSocInsure'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypes.UseTotAccident'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypes.UseIncomeTax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypes.UsePensFund'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypes.UseUnEmploy'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypes.UseSocInsure'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypes.GrossOutlay'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypes.UseToIndexing'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypes.UsePrivIncomeTax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypes.FundType'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypes.UseInSick'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypes.UseInLeav'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypes.UseInTrn'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypes.IsDeduction'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_PayTypes] ON [r_PayTypes]
FOR INSERT AS
/* r_PayTypes - Справочник выплат/удержаний - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PayTypes ^ r_PayTypeCats - Проверка в PARENT */
/* Справочник выплат/удержаний ^ Справочник выплат/удержаний: категории - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PayTypeCatID NOT IN (SELECT PayTypeCatID FROM r_PayTypeCats))
    BEGIN
      EXEC z_RelationError 'r_PayTypeCats', 'r_PayTypes', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10090001, ChID, 
    '[' + cast(i.PayTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_PayTypes', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_PayTypes] ON [r_PayTypes]
FOR UPDATE AS
/* r_PayTypes - Справочник выплат/удержаний - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PayTypes ^ r_PayTypeCats - Проверка в PARENT */
/* Справочник выплат/удержаний ^ Справочник выплат/удержаний: категории - Проверка в PARENT */
  IF UPDATE(PayTypeCatID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PayTypeCatID NOT IN (SELECT PayTypeCatID FROM r_PayTypeCats))
      BEGIN
        EXEC z_RelationError 'r_PayTypeCats', 'r_PayTypes', 1
        RETURN
      END

/* r_PayTypes ^ r_EmpAcc - Обновление CHILD */
/* Справочник выплат/удержаний ^ Справочник служащих - Дополнительные периодические расходы - Обновление CHILD */
  IF UPDATE(PayTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PayTypeID = i.PayTypeID
          FROM r_EmpAcc a, inserted i, deleted d WHERE a.PayTypeID = d.PayTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpAcc a, deleted d WHERE a.PayTypeID = d.PayTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник выплат/удержаний'' => ''Справочник служащих - Дополнительные периодические расходы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PayTypes ^ r_EmpInc - Обновление CHILD */
/* Справочник выплат/удержаний ^ Справочник служащих - Дополнительные периодические доходы - Обновление CHILD */
  IF UPDATE(PayTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PayTypeID = i.PayTypeID
          FROM r_EmpInc a, inserted i, deleted d WHERE a.PayTypeID = d.PayTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpInc a, deleted d WHERE a.PayTypeID = d.PayTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник выплат/удержаний'' => ''Справочник служащих - Дополнительные периодические доходы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PayTypes ^ p_EmpInLRec - Обновление CHILD */
/* Справочник выплат/удержаний ^ Входящие данные по служащим: Начисления - Обновление CHILD */
  IF UPDATE(PayTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PayTypeID = i.PayTypeID
          FROM p_EmpInLRec a, inserted i, deleted d WHERE a.PayTypeID = d.PayTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EmpInLRec a, deleted d WHERE a.PayTypeID = d.PayTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник выплат/удержаний'' => ''Входящие данные по служащим: Начисления''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PayTypes ^ p_EWriP - Обновление CHILD */
/* Справочник выплат/удержаний ^ Исполнительный лист (Удержания) - Обновление CHILD */
  IF UPDATE(PayTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PayTypeID = i.PayTypeID
          FROM p_EWriP a, inserted i, deleted d WHERE a.PayTypeID = d.PayTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EWriP a, deleted d WHERE a.PayTypeID = d.PayTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник выплат/удержаний'' => ''Исполнительный лист (Удержания)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PayTypes ^ p_LRecDCor - Обновление CHILD */
/* Справочник выплат/удержаний ^ Заработная плата: Начисление (Корректировка выплат) - Обновление CHILD */
  IF UPDATE(PayTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PayTypeID = i.PayTypeID
          FROM p_LRecDCor a, inserted i, deleted d WHERE a.PayTypeID = d.PayTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LRecDCor a, deleted d WHERE a.PayTypeID = d.PayTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник выплат/удержаний'' => ''Заработная плата: Начисление (Корректировка выплат)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PayTypes ^ p_LRecDD - Обновление CHILD */
/* Справочник выплат/удержаний ^ Заработная плата: Начисление (Подробно) - Обновление CHILD */
  IF UPDATE(PayTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PayTypeID = i.PayTypeID
          FROM p_LRecDD a, inserted i, deleted d WHERE a.PayTypeID = d.PayTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LRecDD a, deleted d WHERE a.PayTypeID = d.PayTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник выплат/удержаний'' => ''Заработная плата: Начисление (Подробно)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PayTypes ^ p_OPWrk - Обновление CHILD */
/* Справочник выплат/удержаний ^ Приказ: Производственный (Заголовок) - Обновление CHILD */
  IF UPDATE(PayTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PayTypeID = i.PayTypeID
          FROM p_OPWrk a, inserted i, deleted d WHERE a.PayTypeID = d.PayTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_OPWrk a, deleted d WHERE a.PayTypeID = d.PayTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник выплат/удержаний'' => ''Приказ: Производственный (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PayTypes ^ z_Vars - Обновление CHILD */
/* Справочник выплат/удержаний ^ Системные переменные - Обновление CHILD */
  IF UPDATE(PayTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 'p_AdvancePayTypeID', a.VarValue = i.PayTypeID
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 'p_AdvancePayTypeID' AND a.VarValue = d.PayTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 'p_AdvancePayTypeID' AND a.VarValue = d.PayTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник выплат/удержаний'' => ''Системные переменные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PayTypes ^ z_Vars - Обновление CHILD */
/* Справочник выплат/удержаний ^ Системные переменные - Обновление CHILD */
  IF UPDATE(PayTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 'p_IndexPayTypeID', a.VarValue = i.PayTypeID
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 'p_IndexPayTypeID' AND a.VarValue = d.PayTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 'p_IndexPayTypeID' AND a.VarValue = d.PayTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник выплат/удержаний'' => ''Системные переменные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PayTypes ^ z_Vars - Обновление CHILD */
/* Справочник выплат/удержаний ^ Системные переменные - Обновление CHILD */
  IF UPDATE(PayTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 'p_LeavAdvPayTypeID', a.VarValue = i.PayTypeID
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 'p_LeavAdvPayTypeID' AND a.VarValue = d.PayTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 'p_LeavAdvPayTypeID' AND a.VarValue = d.PayTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник выплат/удержаний'' => ''Системные переменные''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10090001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10090001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(PayTypeID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10090001 AND l.PKValue = 
        '[' + cast(i.PayTypeID as varchar(200)) + ']' AND i.PayTypeID = d.PayTypeID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10090001 AND l.PKValue = 
        '[' + cast(i.PayTypeID as varchar(200)) + ']' AND i.PayTypeID = d.PayTypeID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10090001, ChID, 
          '[' + cast(d.PayTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10090001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10090001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10090001, ChID, 
          '[' + cast(i.PayTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(PayTypeID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT PayTypeID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT PayTypeID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.PayTypeID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10090001 AND l.PKValue = 
          '[' + cast(d.PayTypeID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.PayTypeID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10090001 AND l.PKValue = 
          '[' + cast(d.PayTypeID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10090001, ChID, 
          '[' + cast(d.PayTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10090001 AND PKValue IN (SELECT 
          '[' + cast(PayTypeID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10090001 AND PKValue IN (SELECT 
          '[' + cast(PayTypeID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10090001, ChID, 
          '[' + cast(i.PayTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10090001, ChID, 
    '[' + cast(i.PayTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_PayTypes', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_PayTypes] ON [r_PayTypes]
FOR DELETE AS
/* r_PayTypes - Справочник выплат/удержаний - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_PayTypes ^ r_EmpAcc - Проверка в CHILD */
/* Справочник выплат/удержаний ^ Справочник служащих - Дополнительные периодические расходы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_EmpAcc a WITH(NOLOCK), deleted d WHERE a.PayTypeID = d.PayTypeID)
    BEGIN
      EXEC z_RelationError 'r_PayTypes', 'r_EmpAcc', 3
      RETURN
    END

/* r_PayTypes ^ r_EmpInc - Проверка в CHILD */
/* Справочник выплат/удержаний ^ Справочник служащих - Дополнительные периодические доходы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_EmpInc a WITH(NOLOCK), deleted d WHERE a.PayTypeID = d.PayTypeID)
    BEGIN
      EXEC z_RelationError 'r_PayTypes', 'r_EmpInc', 3
      RETURN
    END

/* r_PayTypes ^ p_EmpInLRec - Проверка в CHILD */
/* Справочник выплат/удержаний ^ Входящие данные по служащим: Начисления - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EmpInLRec a WITH(NOLOCK), deleted d WHERE a.PayTypeID = d.PayTypeID)
    BEGIN
      EXEC z_RelationError 'r_PayTypes', 'p_EmpInLRec', 3
      RETURN
    END

/* r_PayTypes ^ p_EWriP - Проверка в CHILD */
/* Справочник выплат/удержаний ^ Исполнительный лист (Удержания) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EWriP a WITH(NOLOCK), deleted d WHERE a.PayTypeID = d.PayTypeID)
    BEGIN
      EXEC z_RelationError 'r_PayTypes', 'p_EWriP', 3
      RETURN
    END

/* r_PayTypes ^ p_LRecDCor - Проверка в CHILD */
/* Справочник выплат/удержаний ^ Заработная плата: Начисление (Корректировка выплат) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LRecDCor a WITH(NOLOCK), deleted d WHERE a.PayTypeID = d.PayTypeID)
    BEGIN
      EXEC z_RelationError 'r_PayTypes', 'p_LRecDCor', 3
      RETURN
    END

/* r_PayTypes ^ p_LRecDD - Проверка в CHILD */
/* Справочник выплат/удержаний ^ Заработная плата: Начисление (Подробно) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LRecDD a WITH(NOLOCK), deleted d WHERE a.PayTypeID = d.PayTypeID)
    BEGIN
      EXEC z_RelationError 'r_PayTypes', 'p_LRecDD', 3
      RETURN
    END

/* r_PayTypes ^ p_OPWrk - Проверка в CHILD */
/* Справочник выплат/удержаний ^ Приказ: Производственный (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_OPWrk a WITH(NOLOCK), deleted d WHERE a.PayTypeID = d.PayTypeID)
    BEGIN
      EXEC z_RelationError 'r_PayTypes', 'p_OPWrk', 3
      RETURN
    END

/* r_PayTypes ^ z_Vars - Проверка в CHILD */
/* Справочник выплат/удержаний ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 'p_AdvancePayTypeID' AND a.VarValue = d.PayTypeID)
    BEGIN
      EXEC z_RelationError 'r_PayTypes', 'z_Vars', 3
      RETURN
    END

/* r_PayTypes ^ z_Vars - Проверка в CHILD */
/* Справочник выплат/удержаний ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 'p_IndexPayTypeID' AND a.VarValue = d.PayTypeID)
    BEGIN
      EXEC z_RelationError 'r_PayTypes', 'z_Vars', 3
      RETURN
    END

/* r_PayTypes ^ z_Vars - Проверка в CHILD */
/* Справочник выплат/удержаний ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 'p_LeavAdvPayTypeID' AND a.VarValue = d.PayTypeID)
    BEGIN
      EXEC z_RelationError 'r_PayTypes', 'z_Vars', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10090001 AND m.PKValue = 
    '[' + cast(i.PayTypeID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10090001 AND m.PKValue = 
    '[' + cast(i.PayTypeID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10090001, -ChID, 
    '[' + cast(d.PayTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10090 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_PayTypes', N'Last', N'DELETE'
GO