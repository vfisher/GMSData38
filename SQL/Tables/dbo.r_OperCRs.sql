CREATE TABLE [dbo].[r_OperCRs] (
  [CRID] [smallint] NOT NULL,
  [OperID] [int] NOT NULL,
  [CROperID] [tinyint] NOT NULL,
  [OperMaxQty] [numeric](21, 9) NOT NULL,
  [CanEditDiscount] [bit] NULL,
  [CRVisible] [bit] NOT NULL,
  [OperPwd] [varchar](250) NOT NULL,
  [AllowChequeClose] [bit] NOT NULL DEFAULT (1),
  [AllowAddToChequeFromCat] [bit] NOT NULL DEFAULT (1),
  [CRAdmin] [bit] NOT NULL DEFAULT (0),
  [AllowChangeDCType] [bit] NOT NULL DEFAULT (0),
  [PrivateKeyPath] [varchar](250) NULL,
  CONSTRAINT [_pk_r_CRMO] PRIMARY KEY CLUSTERED ([CRID], [OperID])
)
ON [PRIMARY]
GO

CREATE INDEX [CRID]
  ON [dbo].[r_OperCRs] ([CRID])
  ON [PRIMARY]
GO

CREATE INDEX [CROperID]
  ON [dbo].[r_OperCRs] ([CROperID])
  ON [PRIMARY]
GO

CREATE INDEX [OperID]
  ON [dbo].[r_OperCRs] ([OperID])
  ON [PRIMARY]
GO

CREATE INDEX [OperPwd]
  ON [dbo].[r_OperCRs] ([OperPwd])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_OperCRs.CRID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_OperCRs.OperID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_OperCRs.CROperID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_OperCRs.OperMaxQty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_OperCRs.CanEditDiscount'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_OperCRs.CRVisible'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_OperCRs.OperPwd'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_OperCRs] ON [r_OperCRs]
FOR INSERT AS
/* r_OperCRs - Справочник ЭККА - Операторы ЭККА - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_OperCRs ^ r_CRs - Проверка в PARENT */
/* Справочник ЭККА - Операторы ЭККА ^ Справочник ЭККА - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CRID NOT IN (SELECT CRID FROM r_CRs))
    BEGIN
      EXEC z_RelationError 'r_CRs', 'r_OperCRs', 0
      RETURN
    END

/* r_OperCRs ^ r_Opers - Проверка в PARENT */
/* Справочник ЭККА - Операторы ЭККА ^ Справочник ЭККА: операторы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OperID NOT IN (SELECT OperID FROM r_Opers))
    BEGIN
      EXEC z_RelationError 'r_Opers', 'r_OperCRs', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10454002, m.ChID, 
    '[' + cast(i.CRID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.OperID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Opers m ON m.OperID = i.OperID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_OperCRs', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_OperCRs] ON [r_OperCRs]
FOR UPDATE AS
/* r_OperCRs - Справочник ЭККА - Операторы ЭККА - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_OperCRs ^ r_CRs - Проверка в PARENT */
/* Справочник ЭККА - Операторы ЭККА ^ Справочник ЭККА - Проверка в PARENT */
  IF UPDATE(CRID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CRID NOT IN (SELECT CRID FROM r_CRs))
      BEGIN
        EXEC z_RelationError 'r_CRs', 'r_OperCRs', 1
        RETURN
      END

/* r_OperCRs ^ r_Opers - Проверка в PARENT */
/* Справочник ЭККА - Операторы ЭККА ^ Справочник ЭККА: операторы - Проверка в PARENT */
  IF UPDATE(OperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OperID NOT IN (SELECT OperID FROM r_Opers))
      BEGIN
        EXEC z_RelationError 'r_Opers', 'r_OperCRs', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldCRID smallint, @NewCRID smallint
  DECLARE @OldOperID int, @NewOperID int

/* r_OperCRs ^ t_CRRet - Обновление CHILD */
/* Справочник ЭККА - Операторы ЭККА ^ Возврат товара по чеку: Заголовок - Обновление CHILD */
  IF UPDATE(CRID) OR UPDATE(OperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CRID = i.CRID, a.OperID = i.OperID
          FROM t_CRRet a, inserted i, deleted d WHERE a.CRID = d.CRID AND a.OperID = d.OperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OperID) AND (SELECT COUNT(DISTINCT CRID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CRID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCRID = CRID FROM deleted
          SELECT TOP 1 @NewCRID = CRID FROM inserted
          UPDATE t_CRRet SET t_CRRet.CRID = @NewCRID FROM t_CRRet, deleted d WHERE t_CRRet.CRID = @OldCRID AND t_CRRet.OperID = d.OperID
        END
      ELSE IF NOT UPDATE(CRID) AND (SELECT COUNT(DISTINCT OperID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OperID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOperID = OperID FROM deleted
          SELECT TOP 1 @NewOperID = OperID FROM inserted
          UPDATE t_CRRet SET t_CRRet.OperID = @NewOperID FROM t_CRRet, deleted d WHERE t_CRRet.OperID = @OldOperID AND t_CRRet.CRID = d.CRID
        END
      ELSE IF EXISTS (SELECT * FROM t_CRRet a, deleted d WHERE a.CRID = d.CRID AND a.OperID = d.OperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ЭККА - Операторы ЭККА'' => ''Возврат товара по чеку: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OperCRs ^ t_MonIntExp - Обновление CHILD */
/* Справочник ЭККА - Операторы ЭККА ^ Служебный расход денег - Обновление CHILD */
  IF UPDATE(CRID) OR UPDATE(OperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CRID = i.CRID, a.OperID = i.OperID
          FROM t_MonIntExp a, inserted i, deleted d WHERE a.CRID = d.CRID AND a.OperID = d.OperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OperID) AND (SELECT COUNT(DISTINCT CRID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CRID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCRID = CRID FROM deleted
          SELECT TOP 1 @NewCRID = CRID FROM inserted
          UPDATE t_MonIntExp SET t_MonIntExp.CRID = @NewCRID FROM t_MonIntExp, deleted d WHERE t_MonIntExp.CRID = @OldCRID AND t_MonIntExp.OperID = d.OperID
        END
      ELSE IF NOT UPDATE(CRID) AND (SELECT COUNT(DISTINCT OperID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OperID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOperID = OperID FROM deleted
          SELECT TOP 1 @NewOperID = OperID FROM inserted
          UPDATE t_MonIntExp SET t_MonIntExp.OperID = @NewOperID FROM t_MonIntExp, deleted d WHERE t_MonIntExp.OperID = @OldOperID AND t_MonIntExp.CRID = d.CRID
        END
      ELSE IF EXISTS (SELECT * FROM t_MonIntExp a, deleted d WHERE a.CRID = d.CRID AND a.OperID = d.OperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ЭККА - Операторы ЭККА'' => ''Служебный расход денег''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OperCRs ^ t_MonIntRec - Обновление CHILD */
/* Справочник ЭККА - Операторы ЭККА ^ Служебный приход денег - Обновление CHILD */
  IF UPDATE(CRID) OR UPDATE(OperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CRID = i.CRID, a.OperID = i.OperID
          FROM t_MonIntRec a, inserted i, deleted d WHERE a.CRID = d.CRID AND a.OperID = d.OperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OperID) AND (SELECT COUNT(DISTINCT CRID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CRID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCRID = CRID FROM deleted
          SELECT TOP 1 @NewCRID = CRID FROM inserted
          UPDATE t_MonIntRec SET t_MonIntRec.CRID = @NewCRID FROM t_MonIntRec, deleted d WHERE t_MonIntRec.CRID = @OldCRID AND t_MonIntRec.OperID = d.OperID
        END
      ELSE IF NOT UPDATE(CRID) AND (SELECT COUNT(DISTINCT OperID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OperID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOperID = OperID FROM deleted
          SELECT TOP 1 @NewOperID = OperID FROM inserted
          UPDATE t_MonIntRec SET t_MonIntRec.OperID = @NewOperID FROM t_MonIntRec, deleted d WHERE t_MonIntRec.OperID = @OldOperID AND t_MonIntRec.CRID = d.CRID
        END
      ELSE IF EXISTS (SELECT * FROM t_MonIntRec a, deleted d WHERE a.CRID = d.CRID AND a.OperID = d.OperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ЭККА - Операторы ЭККА'' => ''Служебный приход денег''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OperCRs ^ t_Sale - Обновление CHILD */
/* Справочник ЭККА - Операторы ЭККА ^ Продажа товара оператором: Заголовок - Обновление CHILD */
  IF UPDATE(CRID) OR UPDATE(OperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CRID = i.CRID, a.OperID = i.OperID
          FROM t_Sale a, inserted i, deleted d WHERE a.CRID = d.CRID AND a.OperID = d.OperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OperID) AND (SELECT COUNT(DISTINCT CRID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CRID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCRID = CRID FROM deleted
          SELECT TOP 1 @NewCRID = CRID FROM inserted
          UPDATE t_Sale SET t_Sale.CRID = @NewCRID FROM t_Sale, deleted d WHERE t_Sale.CRID = @OldCRID AND t_Sale.OperID = d.OperID
        END
      ELSE IF NOT UPDATE(CRID) AND (SELECT COUNT(DISTINCT OperID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OperID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOperID = OperID FROM deleted
          SELECT TOP 1 @NewOperID = OperID FROM inserted
          UPDATE t_Sale SET t_Sale.OperID = @NewOperID FROM t_Sale, deleted d WHERE t_Sale.OperID = @OldOperID AND t_Sale.CRID = d.CRID
        END
      ELSE IF EXISTS (SELECT * FROM t_Sale a, deleted d WHERE a.CRID = d.CRID AND a.OperID = d.OperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ЭККА - Операторы ЭККА'' => ''Продажа товара оператором: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OperCRs ^ t_SaleTemp - Обновление CHILD */
/* Справочник ЭККА - Операторы ЭККА ^ Временные данные продаж: Заголовок - Обновление CHILD */
  IF UPDATE(CRID) OR UPDATE(OperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CRID = i.CRID, a.OperID = i.OperID
          FROM t_SaleTemp a, inserted i, deleted d WHERE a.CRID = d.CRID AND a.OperID = d.OperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OperID) AND (SELECT COUNT(DISTINCT CRID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CRID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCRID = CRID FROM deleted
          SELECT TOP 1 @NewCRID = CRID FROM inserted
          UPDATE t_SaleTemp SET t_SaleTemp.CRID = @NewCRID FROM t_SaleTemp, deleted d WHERE t_SaleTemp.CRID = @OldCRID AND t_SaleTemp.OperID = d.OperID
        END
      ELSE IF NOT UPDATE(CRID) AND (SELECT COUNT(DISTINCT OperID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OperID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOperID = OperID FROM deleted
          SELECT TOP 1 @NewOperID = OperID FROM inserted
          UPDATE t_SaleTemp SET t_SaleTemp.OperID = @NewOperID FROM t_SaleTemp, deleted d WHERE t_SaleTemp.OperID = @OldOperID AND t_SaleTemp.CRID = d.CRID
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleTemp a, deleted d WHERE a.CRID = d.CRID AND a.OperID = d.OperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ЭККА - Операторы ЭККА'' => ''Временные данные продаж: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OperCRs ^ t_zRep - Обновление CHILD */
/* Справочник ЭККА - Операторы ЭККА ^ Z-отчеты - Обновление CHILD */
  IF UPDATE(CRID) OR UPDATE(OperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CRID = i.CRID, a.OperID = i.OperID
          FROM t_zRep a, inserted i, deleted d WHERE a.CRID = d.CRID AND a.OperID = d.OperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OperID) AND (SELECT COUNT(DISTINCT CRID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CRID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCRID = CRID FROM deleted
          SELECT TOP 1 @NewCRID = CRID FROM inserted
          UPDATE t_zRep SET t_zRep.CRID = @NewCRID FROM t_zRep, deleted d WHERE t_zRep.CRID = @OldCRID AND t_zRep.OperID = d.OperID
        END
      ELSE IF NOT UPDATE(CRID) AND (SELECT COUNT(DISTINCT OperID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OperID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOperID = OperID FROM deleted
          SELECT TOP 1 @NewOperID = OperID FROM inserted
          UPDATE t_zRep SET t_zRep.OperID = @NewOperID FROM t_zRep, deleted d WHERE t_zRep.OperID = @OldOperID AND t_zRep.CRID = d.CRID
        END
      ELSE IF EXISTS (SELECT * FROM t_zRep a, deleted d WHERE a.CRID = d.CRID AND a.OperID = d.OperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ЭККА - Операторы ЭККА'' => ''Z-отчеты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(CRID) OR UPDATE(OperID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CRID, OperID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CRID, OperID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CRID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.OperID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10454002 AND l.PKValue = 
          '[' + cast(d.CRID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.OperID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CRID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.OperID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10454002 AND l.PKValue = 
          '[' + cast(d.CRID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.OperID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10454002, m.ChID, 
          '[' + cast(d.CRID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.OperID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Opers m ON m.OperID = d.OperID
          DELETE FROM z_LogCreate WHERE TableCode = 10454002 AND PKValue IN (SELECT 
          '[' + cast(CRID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(OperID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10454002 AND PKValue IN (SELECT 
          '[' + cast(CRID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(OperID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10454002, m.ChID, 
          '[' + cast(i.CRID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.OperID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Opers m ON m.OperID = i.OperID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10454002, m.ChID, 
    '[' + cast(i.CRID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.OperID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Opers m ON m.OperID = i.OperID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_OperCRs', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_OperCRs] ON [r_OperCRs]
FOR DELETE AS
/* r_OperCRs - Справочник ЭККА - Операторы ЭККА - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_OperCRs ^ t_CRRet - Проверка в CHILD */
/* Справочник ЭККА - Операторы ЭККА ^ Возврат товара по чеку: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRRet a WITH(NOLOCK), deleted d WHERE a.CRID = d.CRID AND a.OperID = d.OperID)
    BEGIN
      EXEC z_RelationError 'r_OperCRs', 't_CRRet', 3
      RETURN
    END

/* r_OperCRs ^ t_MonIntExp - Проверка в CHILD */
/* Справочник ЭККА - Операторы ЭККА ^ Служебный расход денег - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_MonIntExp a WITH(NOLOCK), deleted d WHERE a.CRID = d.CRID AND a.OperID = d.OperID)
    BEGIN
      EXEC z_RelationError 'r_OperCRs', 't_MonIntExp', 3
      RETURN
    END

/* r_OperCRs ^ t_MonIntRec - Проверка в CHILD */
/* Справочник ЭККА - Операторы ЭККА ^ Служебный приход денег - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_MonIntRec a WITH(NOLOCK), deleted d WHERE a.CRID = d.CRID AND a.OperID = d.OperID)
    BEGIN
      EXEC z_RelationError 'r_OperCRs', 't_MonIntRec', 3
      RETURN
    END

/* r_OperCRs ^ t_Sale - Проверка в CHILD */
/* Справочник ЭККА - Операторы ЭККА ^ Продажа товара оператором: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Sale a WITH(NOLOCK), deleted d WHERE a.CRID = d.CRID AND a.OperID = d.OperID)
    BEGIN
      EXEC z_RelationError 'r_OperCRs', 't_Sale', 3
      RETURN
    END

/* r_OperCRs ^ t_SaleTemp - Проверка в CHILD */
/* Справочник ЭККА - Операторы ЭККА ^ Временные данные продаж: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SaleTemp a WITH(NOLOCK), deleted d WHERE a.CRID = d.CRID AND a.OperID = d.OperID)
    BEGIN
      EXEC z_RelationError 'r_OperCRs', 't_SaleTemp', 3
      RETURN
    END

/* r_OperCRs ^ t_zRep - Проверка в CHILD */
/* Справочник ЭККА - Операторы ЭККА ^ Z-отчеты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_zRep a WITH(NOLOCK), deleted d WHERE a.CRID = d.CRID AND a.OperID = d.OperID)
    BEGIN
      EXEC z_RelationError 'r_OperCRs', 't_zRep', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10454002 AND m.PKValue = 
    '[' + cast(i.CRID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.OperID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10454002 AND m.PKValue = 
    '[' + cast(i.CRID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.OperID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10454002, m.ChID, 
    '[' + cast(d.CRID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.OperID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Opers m ON m.OperID = d.OperID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_OperCRs', N'Last', N'DELETE'
GO