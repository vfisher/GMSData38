﻿CREATE TABLE [dbo].[r_ProdME] (
  [ProdID] [int] NOT NULL,
  [CodeID1] [smallint] NOT NULL,
  [CodeID2] [smallint] NOT NULL,
  [CodeID3] [smallint] NOT NULL,
  [CodeID4] [smallint] NOT NULL,
  [CodeID5] [smallint] NOT NULL,
  [LExp] [varchar](255) NOT NULL,
  [EExp] [varchar](255) NOT NULL,
  [ExpType] [tinyint] NOT NULL,
  CONSTRAINT [_pk_r_ProdME] PRIMARY KEY CLUSTERED ([ProdID], [CodeID1], [CodeID2], [CodeID3], [CodeID4], [CodeID5])
)
ON [PRIMARY]
GO

CREATE INDEX [CodeID1]
  ON [dbo].[r_ProdME] ([CodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID2]
  ON [dbo].[r_ProdME] ([CodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID3]
  ON [dbo].[r_ProdME] ([CodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID4]
  ON [dbo].[r_ProdME] ([CodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID5]
  ON [dbo].[r_ProdME] ([CodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [EExp]
  ON [dbo].[r_ProdME] ([EExp])
  ON [PRIMARY]
GO

CREATE INDEX [ExpType]
  ON [dbo].[r_ProdME] ([ExpType])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[r_ProdME] ([ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [RExp]
  ON [dbo].[r_ProdME] ([LExp])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdME.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdME.CodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdME.CodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdME.CodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdME.CodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdME.CodeID5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdME.ExpType'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ProdME] ON [r_ProdME]
FOR INSERT AS
/* r_ProdME - Справочник товаров - Затраты на комплекты - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdME ^ r_Codes1 - Проверка в PARENT */
/* Справочник товаров - Затраты на комплекты ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'r_ProdME', 0
      RETURN
    END

/* r_ProdME ^ r_Codes2 - Проверка в PARENT */
/* Справочник товаров - Затраты на комплекты ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'r_ProdME', 0
      RETURN
    END

/* r_ProdME ^ r_Codes3 - Проверка в PARENT */
/* Справочник товаров - Затраты на комплекты ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'r_ProdME', 0
      RETURN
    END

/* r_ProdME ^ r_Codes4 - Проверка в PARENT */
/* Справочник товаров - Затраты на комплекты ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'r_ProdME', 0
      RETURN
    END

/* r_ProdME ^ r_Codes5 - Проверка в PARENT */
/* Справочник товаров - Затраты на комплекты ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'r_ProdME', 0
      RETURN
    END

/* r_ProdME ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Затраты на комплекты ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_ProdME', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350008, m.ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID1 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID2 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID3 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID4 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID5 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_ProdME', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ProdME] ON [r_ProdME]
FOR UPDATE AS
/* r_ProdME - Справочник товаров - Затраты на комплекты - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdME ^ r_Codes1 - Проверка в PARENT */
/* Справочник товаров - Затраты на комплекты ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'r_ProdME', 1
        RETURN
      END

/* r_ProdME ^ r_Codes2 - Проверка в PARENT */
/* Справочник товаров - Затраты на комплекты ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'r_ProdME', 1
        RETURN
      END

/* r_ProdME ^ r_Codes3 - Проверка в PARENT */
/* Справочник товаров - Затраты на комплекты ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'r_ProdME', 1
        RETURN
      END

/* r_ProdME ^ r_Codes4 - Проверка в PARENT */
/* Справочник товаров - Затраты на комплекты ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'r_ProdME', 1
        RETURN
      END

/* r_ProdME ^ r_Codes5 - Проверка в PARENT */
/* Справочник товаров - Затраты на комплекты ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'r_ProdME', 1
        RETURN
      END

/* r_ProdME ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Затраты на комплекты ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_ProdME', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(ProdID) OR UPDATE(CodeID1) OR UPDATE(CodeID2) OR UPDATE(CodeID3) OR UPDATE(CodeID4) OR UPDATE(CodeID5)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ProdID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5 FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ProdID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5 FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CodeID1 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CodeID2 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CodeID3 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CodeID4 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CodeID5 as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10350008 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CodeID1 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CodeID2 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CodeID3 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CodeID4 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CodeID5 as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CodeID1 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CodeID2 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CodeID3 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CodeID4 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CodeID5 as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10350008 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CodeID1 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CodeID2 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CodeID3 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CodeID4 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CodeID5 as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10350008, m.ChID, 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CodeID1 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CodeID2 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CodeID3 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CodeID4 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CodeID5 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Prods m ON m.ProdID = d.ProdID
          DELETE FROM z_LogCreate WHERE TableCode = 10350008 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CodeID1 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CodeID2 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CodeID3 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CodeID4 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CodeID5 as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10350008 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CodeID1 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CodeID2 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CodeID3 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CodeID4 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CodeID5 as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10350008, m.ChID, 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CodeID1 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CodeID2 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CodeID3 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CodeID4 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CodeID5 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350008, m.ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID1 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID2 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID3 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID4 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID5 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_ProdME', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ProdME] ON [r_ProdME]
FOR DELETE AS
/* r_ProdME - Справочник товаров - Затраты на комплекты - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10350008 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID1 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID2 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID3 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID4 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID5 as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10350008 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID1 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID2 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID3 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID4 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CodeID5 as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10350008, m.ChID, 
    '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.CodeID1 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.CodeID2 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.CodeID3 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.CodeID4 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.CodeID5 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Prods m ON m.ProdID = d.ProdID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_ProdME', N'Last', N'DELETE'
GO