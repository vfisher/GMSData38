CREATE TABLE [dbo].[r_PLs] (
  [ChID] [bigint] NOT NULL,
  [PLID] [int] NOT NULL,
  [PLName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [pk_r_PLs] PRIMARY KEY CLUSTERED ([PLID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_PLs] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [PLName]
  ON [dbo].[r_PLs] ([PLName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PLs.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PLs.PLID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_PLs] ON [r_PLs]
FOR DELETE AS
/* r_PLs - Справочник прайс-листов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_PLs ^ r_ProdAC - Удаление в CHILD */
/* Справочник прайс-листов ^ Справочник товаров - Автосоздание цен - Удаление в CHILD */
  DELETE r_ProdAC FROM r_ProdAC a, deleted d WHERE a.ChPLID = d.PLID
  IF @@ERROR > 0 RETURN

/* r_PLs ^ r_ProdMP - Удаление в CHILD */
/* Справочник прайс-листов ^ Справочник товаров - Цены для прайс-листов - Удаление в CHILD */
  DELETE r_ProdMP FROM r_ProdMP a, deleted d WHERE a.PLID = d.PLID
  IF @@ERROR > 0 RETURN

/* r_PLs ^ r_ProdMQ - Проверка в CHILD */
/* Справочник прайс-листов ^ Справочник товаров - Виды упаковок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ProdMQ a WITH(NOLOCK), deleted d WHERE a.PLID = d.PLID)
    BEGIN
      EXEC z_RelationError 'r_PLs', 'r_ProdMQ', 3
      RETURN
    END

/* r_PLs ^ r_Stocks - Проверка в CHILD */
/* Справочник прайс-листов ^ Справочник складов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Stocks a WITH(NOLOCK), deleted d WHERE a.PLID = d.PLID)
    BEGIN
      EXEC z_RelationError 'r_PLs', 'r_Stocks', 3
      RETURN
    END

/* r_PLs ^ r_Comps - Проверка в CHILD */
/* Справочник прайс-листов ^ Справочник предприятий - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Comps a WITH(NOLOCK), deleted d WHERE a.PLID = d.PLID)
    BEGIN
      EXEC z_RelationError 'r_PLs', 'r_Comps', 3
      RETURN
    END

/* r_PLs ^ r_ProdMPCh - Удаление в CHILD */
/* Справочник прайс-листов ^ Изменение цен продажи (Таблица) - Удаление в CHILD */
  DELETE r_ProdMPCh FROM r_ProdMPCh a, deleted d WHERE a.PLID = d.PLID
  IF @@ERROR > 0 RETURN

/* r_PLs ^ t_SaleD - Проверка в CHILD */
/* Справочник прайс-листов ^ Продажа товара оператором: Продажи товара - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SaleD a WITH(NOLOCK), deleted d WHERE a.PLID = d.PLID)
    BEGIN
      EXEC z_RelationError 'r_PLs', 't_SaleD', 3
      RETURN
    END

/* r_PLs ^ t_SEstD - Проверка в CHILD */
/* Справочник прайс-листов ^ Переоценка цен продажи: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SEstD a WITH(NOLOCK), deleted d WHERE a.PLID = d.PLID)
    BEGIN
      EXEC z_RelationError 'r_PLs', 't_SEstD', 3
      RETURN
    END

/* r_PLs ^ z_UserPLs - Удаление в CHILD */
/* Справочник прайс-листов ^ Доступные значения - Справочник прайс-листов - Удаление в CHILD */
  DELETE z_UserPLs FROM z_UserPLs a, deleted d WHERE a.PLID = d.PLID
  IF @@ERROR > 0 RETURN


/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10170001 AND m.PKValue = 
    '[' + cast(i.PLID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10170001 AND m.PKValue = 
    '[' + cast(i.PLID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10170001, -ChID, 
    '[' + cast(d.PLID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10170 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_PLs', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_PLs] ON [r_PLs]
FOR UPDATE AS
/* r_PLs - Справочник прайс-листов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PLs ^ r_ProdAC - Обновление CHILD */
/* Справочник прайс-листов ^ Справочник товаров - Автосоздание цен - Обновление CHILD */
  IF UPDATE(PLID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChPLID = i.PLID
          FROM r_ProdAC a, inserted i, deleted d WHERE a.ChPLID = d.PLID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdAC a, deleted d WHERE a.ChPLID = d.PLID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник прайс-листов'' => ''Справочник товаров - Автосоздание цен''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PLs ^ r_ProdMP - Обновление CHILD */
/* Справочник прайс-листов ^ Справочник товаров - Цены для прайс-листов - Обновление CHILD */
  IF UPDATE(PLID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PLID = i.PLID
          FROM r_ProdMP a, inserted i, deleted d WHERE a.PLID = d.PLID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdMP a, deleted d WHERE a.PLID = d.PLID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник прайс-листов'' => ''Справочник товаров - Цены для прайс-листов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PLs ^ r_ProdMQ - Обновление CHILD */
/* Справочник прайс-листов ^ Справочник товаров - Виды упаковок - Обновление CHILD */
  IF UPDATE(PLID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PLID = i.PLID
          FROM r_ProdMQ a, inserted i, deleted d WHERE a.PLID = d.PLID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdMQ a, deleted d WHERE a.PLID = d.PLID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник прайс-листов'' => ''Справочник товаров - Виды упаковок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PLs ^ r_Stocks - Обновление CHILD */
/* Справочник прайс-листов ^ Справочник складов - Обновление CHILD */
  IF UPDATE(PLID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PLID = i.PLID
          FROM r_Stocks a, inserted i, deleted d WHERE a.PLID = d.PLID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Stocks a, deleted d WHERE a.PLID = d.PLID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник прайс-листов'' => ''Справочник складов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PLs ^ r_Comps - Обновление CHILD */
/* Справочник прайс-листов ^ Справочник предприятий - Обновление CHILD */
  IF UPDATE(PLID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PLID = i.PLID
          FROM r_Comps a, inserted i, deleted d WHERE a.PLID = d.PLID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Comps a, deleted d WHERE a.PLID = d.PLID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник прайс-листов'' => ''Справочник предприятий''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PLs ^ r_ProdMPCh - Обновление CHILD */
/* Справочник прайс-листов ^ Изменение цен продажи (Таблица) - Обновление CHILD */
  IF UPDATE(PLID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PLID = i.PLID
          FROM r_ProdMPCh a, inserted i, deleted d WHERE a.PLID = d.PLID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdMPCh a, deleted d WHERE a.PLID = d.PLID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник прайс-листов'' => ''Изменение цен продажи (Таблица)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PLs ^ t_SaleD - Обновление CHILD */
/* Справочник прайс-листов ^ Продажа товара оператором: Продажи товара - Обновление CHILD */
  IF UPDATE(PLID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PLID = i.PLID
          FROM t_SaleD a, inserted i, deleted d WHERE a.PLID = d.PLID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleD a, deleted d WHERE a.PLID = d.PLID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник прайс-листов'' => ''Продажа товара оператором: Продажи товара''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PLs ^ t_SEstD - Обновление CHILD */
/* Справочник прайс-листов ^ Переоценка цен продажи: Товар - Обновление CHILD */
  IF UPDATE(PLID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PLID = i.PLID
          FROM t_SEstD a, inserted i, deleted d WHERE a.PLID = d.PLID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SEstD a, deleted d WHERE a.PLID = d.PLID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник прайс-листов'' => ''Переоценка цен продажи: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PLs ^ z_UserPLs - Обновление CHILD */
/* Справочник прайс-листов ^ Доступные значения - Справочник прайс-листов - Обновление CHILD */
  IF UPDATE(PLID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PLID = i.PLID
          FROM z_UserPLs a, inserted i, deleted d WHERE a.PLID = d.PLID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserPLs a, deleted d WHERE a.PLID = d.PLID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник прайс-листов'' => ''Доступные значения - Справочник прайс-листов''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10170001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10170001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(PLID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10170001 AND l.PKValue = 
        '[' + cast(i.PLID as varchar(200)) + ']' AND i.PLID = d.PLID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10170001 AND l.PKValue = 
        '[' + cast(i.PLID as varchar(200)) + ']' AND i.PLID = d.PLID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10170001, ChID, 
          '[' + cast(d.PLID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10170001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10170001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10170001, ChID, 
          '[' + cast(i.PLID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(PLID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT PLID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT PLID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.PLID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10170001 AND l.PKValue = 
          '[' + cast(d.PLID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.PLID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10170001 AND l.PKValue = 
          '[' + cast(d.PLID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10170001, ChID, 
          '[' + cast(d.PLID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10170001 AND PKValue IN (SELECT 
          '[' + cast(PLID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10170001 AND PKValue IN (SELECT 
          '[' + cast(PLID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10170001, ChID, 
          '[' + cast(i.PLID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10170001, ChID, 
    '[' + cast(i.PLID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_PLs', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_PLs] ON [r_PLs]
FOR INSERT AS
/* r_PLs - Справочник прайс-листов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON


/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10170001, ChID, 
    '[' + cast(i.PLID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_PLs', N'Last', N'INSERT'
GO









SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO