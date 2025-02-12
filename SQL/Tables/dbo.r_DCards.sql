CREATE TABLE [dbo].[r_DCards] (
  [ChID] [bigint] NOT NULL,
  [CompID] [int] NOT NULL,
  [DCardID] [varchar](250) NOT NULL,
  [Discount] [numeric](21, 9) NOT NULL,
  [SumCC] [numeric](21, 9) NULL,
  [InUse] [bit] NOT NULL,
  [Notes] [varchar](200) NULL,
  [Value1] [numeric](21, 9) NOT NULL,
  [Value2] [numeric](21, 9) NOT NULL,
  [Value3] [numeric](21, 9) NOT NULL,
  [IsCrdCard] [bit] NOT NULL,
  [Note1] [varchar](200) NULL,
  [EDate] [smalldatetime] NULL,
  [DCTypeCode] [int] NOT NULL DEFAULT (0),
  [FactPostIndex] [varchar](50) NULL,
  [SumBonus] [numeric](21, 9) NOT NULL CONSTRAINT [DF__r_DCards__SumBon__4813E5CB] DEFAULT (0),
  [Status] [int] NOT NULL DEFAULT (0),
  [BDate] [smalldatetime] NULL,
  [IsPayCard] [bit] NOT NULL DEFAULT (0),
  [AskPWDDCardEnter] [bit] NOT NULL DEFAULT (0),
  [AutoSaveOddMoneyToProcessing] [tinyint] NOT NULL CONSTRAINT [df_r_DCards_AutoSaveOddMoneyToProcessing] DEFAULT (0),
  CONSTRAINT [pk_r_DCards] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

CREATE INDEX [CompID]
  ON [dbo].[r_DCards] ([CompID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [DCardID]
  ON [dbo].[r_DCards] ([DCardID])
  ON [PRIMARY]
GO

CREATE INDEX [DCardID_DCTypeCode]
  ON [dbo].[r_DCards] ([DCardID], [DCTypeCode])
  ON [PRIMARY]
GO

CREATE INDEX [EDate]
  ON [dbo].[r_DCards] ([EDate])
  ON [PRIMARY]
GO

CREATE INDEX [SumCC]
  ON [dbo].[r_DCards] ([SumCC])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_DCards.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_DCards.CompID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_DCards.Discount'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_DCards.SumCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_DCards.InUse'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_DCards.Value1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_DCards.Value2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_DCards.Value3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_DCards.IsCrdCard'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_DCards] ON [r_DCards]
FOR INSERT AS
/* r_DCards - Справочник дисконтных карт - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DCards ^ r_Comps - Проверка в PARENT */
/* Справочник дисконтных карт ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'r_DCards', 0
      RETURN
    END

/* r_DCards ^ r_DCTypes - Проверка в PARENT */
/* Справочник дисконтных карт ^ Справочник дисконтных карт: типы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DCTypeCode NOT IN (SELECT DCTypeCode FROM r_DCTypes))
    BEGIN
      EXEC z_RelationError 'r_DCTypes', 'r_DCards', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10400001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_DCards', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_DCards] ON [r_DCards]
FOR UPDATE AS
/* r_DCards - Справочник дисконтных карт - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DCards ^ r_Comps - Проверка в PARENT */
/* Справочник дисконтных карт ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'r_DCards', 1
        RETURN
      END

/* r_DCards ^ r_DCTypes - Проверка в PARENT */
/* Справочник дисконтных карт ^ Справочник дисконтных карт: типы - Проверка в PARENT */
  IF UPDATE(DCTypeCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DCTypeCode NOT IN (SELECT DCTypeCode FROM r_DCTypes))
      BEGIN
        EXEC z_RelationError 'r_DCTypes', 'r_DCards', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10400001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10400001 AND l.ChID = d.ChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10400001, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10400001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10400001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10400001, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10400001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10400001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10400001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_DCards', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_DCards] ON [r_DCards]
FOR DELETE AS
/* r_DCards - Справочник дисконтных карт - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10400001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10400001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10400001, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10400 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_DCards', N'Last', N'DELETE'
GO