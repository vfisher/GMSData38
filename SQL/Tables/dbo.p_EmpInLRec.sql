CREATE TABLE [dbo].[p_EmpInLRec] (
  [ChID] [bigint] NOT NULL,
  [AccDate] [smalldatetime] NOT NULL,
  [PayTypeID] [smallint] NOT NULL,
  [LRecSumCC] [numeric](21, 9) NOT NULL,
  CONSTRAINT [pk_p_EmpInLRec] PRIMARY KEY CLUSTERED ([ChID], [AccDate], [PayTypeID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_p_EmpInLRec] ON [p_EmpInLRec]
FOR INSERT AS
/* p_EmpInLRec - Входящие данные по служащим: Начисления - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* p_EmpInLRec ^ p_EmpIn - Проверка в PARENT */
/* Входящие данные по служащим: Начисления ^ Входящие данные по служащим - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM p_EmpIn))
    BEGIN
      EXEC z_RelationError 'p_EmpIn', 'p_EmpInLRec', 0
      RETURN
    END

/* p_EmpInLRec ^ r_PayTypes - Проверка в PARENT */
/* Входящие данные по служащим: Начисления ^ Справочник выплат/удержаний - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PayTypeID NOT IN (SELECT PayTypeID FROM r_PayTypes))
    BEGIN
      EXEC z_RelationError 'r_PayTypes', 'p_EmpInLRec', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 15901002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AccDate as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PayTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_p_EmpInLRec', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_p_EmpInLRec] ON [p_EmpInLRec]
FOR UPDATE AS
/* p_EmpInLRec - Входящие данные по служащим: Начисления - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* p_EmpInLRec ^ p_EmpIn - Проверка в PARENT */
/* Входящие данные по служащим: Начисления ^ Входящие данные по служащим - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM p_EmpIn))
      BEGIN
        EXEC z_RelationError 'p_EmpIn', 'p_EmpInLRec', 1
        RETURN
      END

/* p_EmpInLRec ^ r_PayTypes - Проверка в PARENT */
/* Входящие данные по служащим: Начисления ^ Справочник выплат/удержаний - Проверка в PARENT */
  IF UPDATE(PayTypeID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PayTypeID NOT IN (SELECT PayTypeID FROM r_PayTypes))
      BEGIN
        EXEC z_RelationError 'r_PayTypes', 'p_EmpInLRec', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 15901002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 15901002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(AccDate) OR UPDATE(PayTypeID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15901002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.AccDate as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.PayTypeID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.AccDate = d.AccDate AND i.PayTypeID = d.PayTypeID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15901002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.AccDate as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.PayTypeID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.AccDate = d.AccDate AND i.PayTypeID = d.PayTypeID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15901002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AccDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PayTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15901002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15901002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15901002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AccDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PayTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(AccDate) OR UPDATE(PayTypeID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, AccDate, PayTypeID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, AccDate, PayTypeID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AccDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PayTypeID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15901002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AccDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PayTypeID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AccDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PayTypeID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15901002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AccDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PayTypeID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15901002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AccDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PayTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15901002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(AccDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(PayTypeID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15901002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(AccDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(PayTypeID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15901002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AccDate as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PayTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 15901002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AccDate as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PayTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_p_EmpInLRec', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_p_EmpInLRec] ON [p_EmpInLRec]
FOR DELETE AS
/* p_EmpInLRec - Входящие данные по служащим: Начисления - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 15901002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AccDate as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PayTypeID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 15901002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AccDate as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PayTypeID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 15901002, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.AccDate as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.PayTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_p_EmpInLRec', N'Last', N'DELETE'
GO