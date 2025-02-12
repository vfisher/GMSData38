CREATE TABLE [dbo].[b_GTranD] (
  [GTranID] [int] NOT NULL,
  [AChID] [bigint] NOT NULL,
  [CurrID] [smallint] NOT NULL,
  [SumAC] [numeric](21, 9) NOT NULL,
  [D_GAccID] [int] NOT NULL,
  [C_GAccID] [int] NOT NULL,
  [D_CompID] [int] NOT NULL,
  [C_CompID] [int] NOT NULL,
  [D_EmpID] [int] NOT NULL,
  [C_EmpID] [int] NOT NULL,
  [D_CodeID1] [smallint] NOT NULL,
  [C_CodeID1] [smallint] NOT NULL,
  [D_CodeID2] [smallint] NOT NULL,
  [C_CodeID2] [smallint] NOT NULL,
  [D_CodeID3] [smallint] NOT NULL,
  [C_CodeID3] [smallint] NOT NULL,
  [D_CodeID4] [smallint] NOT NULL,
  [C_CodeID4] [smallint] NOT NULL,
  [D_CodeID5] [smallint] NOT NULL,
  [C_CodeID5] [smallint] NOT NULL,
  [D_StockID] [int] NOT NULL,
  [C_StockID] [int] NOT NULL,
  [D_ProdID] [int] NOT NULL,
  [C_ProdID] [int] NOT NULL,
  [D_AssID] [int] NOT NULL,
  [C_AssID] [int] NOT NULL,
  [D_GVolID] [int] NOT NULL,
  [C_GVolID] [int] NOT NULL,
  [D_Qty] [numeric](21, 9) NOT NULL,
  [C_Qty] [numeric](21, 9) NOT NULL,
  [D_Vol1] [varchar](255) NULL,
  [D_Vol2] [varchar](255) NULL,
  [D_Vol3] [varchar](255) NULL,
  [C_Vol1] [varchar](255) NULL,
  [C_Vol2] [varchar](255) NULL,
  [C_Vol3] [varchar](255) NULL,
  [D_GrndLinkID] [int] NOT NULL DEFAULT (0),
  [C_GrndLinkID] [int] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_b_GTranD] PRIMARY KEY CLUSTERED ([GTranID], [AChID])
)
ON [PRIMARY]
GO

CREATE INDEX [AChID]
  ON [dbo].[b_GTranD] ([AChID])
  ON [PRIMARY]
GO

CREATE INDEX [C_AssID]
  ON [dbo].[b_GTranD] ([C_AssID])
  ON [PRIMARY]
GO

CREATE INDEX [C_CodeID1]
  ON [dbo].[b_GTranD] ([C_CodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [C_CodeID2]
  ON [dbo].[b_GTranD] ([C_CodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [C_CodeID3]
  ON [dbo].[b_GTranD] ([C_CodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [C_CodeID4]
  ON [dbo].[b_GTranD] ([C_CodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [C_CodeID5]
  ON [dbo].[b_GTranD] ([C_CodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [C_CompID]
  ON [dbo].[b_GTranD] ([C_CompID])
  ON [PRIMARY]
GO

CREATE INDEX [C_EmpID]
  ON [dbo].[b_GTranD] ([C_EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [C_GAccID]
  ON [dbo].[b_GTranD] ([C_GAccID])
  ON [PRIMARY]
GO

CREATE INDEX [C_GVolID]
  ON [dbo].[b_GTranD] ([C_GVolID])
  ON [PRIMARY]
GO

CREATE INDEX [C_ProdID]
  ON [dbo].[b_GTranD] ([C_ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [C_StockID]
  ON [dbo].[b_GTranD] ([C_StockID])
  ON [PRIMARY]
GO

CREATE INDEX [CurrID]
  ON [dbo].[b_GTranD] ([CurrID])
  ON [PRIMARY]
GO

CREATE INDEX [D_AssID]
  ON [dbo].[b_GTranD] ([D_AssID])
  ON [PRIMARY]
GO

CREATE INDEX [D_CodeID1]
  ON [dbo].[b_GTranD] ([D_CodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [D_CodeID2]
  ON [dbo].[b_GTranD] ([D_CodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [D_CodeID3]
  ON [dbo].[b_GTranD] ([D_CodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [D_CodeID4]
  ON [dbo].[b_GTranD] ([D_CodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [D_CodeID5]
  ON [dbo].[b_GTranD] ([D_CodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [D_CompID]
  ON [dbo].[b_GTranD] ([D_CompID])
  ON [PRIMARY]
GO

CREATE INDEX [D_EmpID]
  ON [dbo].[b_GTranD] ([D_EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [D_GAccID]
  ON [dbo].[b_GTranD] ([D_GAccID])
  ON [PRIMARY]
GO

CREATE INDEX [D_GVolID]
  ON [dbo].[b_GTranD] ([D_GVolID])
  ON [PRIMARY]
GO

CREATE INDEX [D_ProdID]
  ON [dbo].[b_GTranD] ([D_ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [D_StockID]
  ON [dbo].[b_GTranD] ([D_StockID])
  ON [PRIMARY]
GO

CREATE INDEX [GTranID]
  ON [dbo].[b_GTranD] ([GTranID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.GTranID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.AChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.CurrID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.SumAC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.D_GAccID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.C_GAccID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.D_CompID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.C_CompID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.D_EmpID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.C_EmpID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.D_CodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.C_CodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.D_CodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.C_CodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.D_CodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.C_CodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.D_CodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.C_CodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.D_CodeID5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.C_CodeID5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.D_StockID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.C_StockID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.D_ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.C_ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.D_AssID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.C_AssID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.D_GVolID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.C_GVolID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.D_Qty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_GTranD.C_Qty'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_GTranD] ON [b_GTranD]
FOR INSERT AS
/* b_GTranD - Таблица проводок (Проводки) - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_GTranD ^ b_GTran - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Таблица проводок (Общие данные) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GTranID NOT IN (SELECT GTranID FROM b_GTran))
    BEGIN
      EXEC z_RelationError 'b_GTran', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Assets - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник основных средств - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_AssID NOT IN (SELECT AssID FROM r_Assets))
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Assets - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник основных средств - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_AssID NOT IN (SELECT AssID FROM r_Assets))
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Codes1 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Codes1 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Codes2 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Codes2 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Codes3 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Codes3 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Codes4 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Codes4 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Codes5 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Codes5 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Comps - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Comps - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Currs - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Emps - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Emps - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_GAccs - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_GAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_GAccs - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_GAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_GVols - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник проводок: виды аналитики - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_GVolID NOT IN (SELECT GVolID FROM r_GVols))
    BEGIN
      EXEC z_RelationError 'r_GVols', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_GVols - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник проводок: виды аналитики - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_GVolID NOT IN (SELECT GVolID FROM r_GVols))
    BEGIN
      EXEC z_RelationError 'r_GVols', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Prods - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Prods - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Stocks - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ r_Stocks - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ z_DocLinks - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Документы - Взаимосвязи - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_GrndLinkID NOT IN (SELECT LinkID FROM z_DocLinks))
    BEGIN
      EXEC z_RelationError 'z_DocLinks', 'b_GTranD', 0
      RETURN
    END

/* b_GTranD ^ z_DocLinks - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Документы - Взаимосвязи - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_GrndLinkID NOT IN (SELECT LinkID FROM z_DocLinks))
    BEGIN
      EXEC z_RelationError 'z_DocLinks', 'b_GTranD', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_GTranD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_GTranD] ON [b_GTranD]
FOR UPDATE AS
/* b_GTranD - Таблица проводок (Проводки) - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_GTranD ^ b_GTran - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Таблица проводок (Общие данные) - Проверка в PARENT */
  IF UPDATE(GTranID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GTranID NOT IN (SELECT GTranID FROM b_GTran))
      BEGIN
        EXEC z_RelationError 'b_GTran', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Assets - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник основных средств - Проверка в PARENT */
  IF UPDATE(C_AssID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_AssID NOT IN (SELECT AssID FROM r_Assets))
      BEGIN
        EXEC z_RelationError 'r_Assets', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Assets - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник основных средств - Проверка в PARENT */
  IF UPDATE(D_AssID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_AssID NOT IN (SELECT AssID FROM r_Assets))
      BEGIN
        EXEC z_RelationError 'r_Assets', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Codes1 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(C_CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Codes1 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(D_CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Codes2 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(C_CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Codes2 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(D_CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Codes3 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(C_CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Codes3 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(D_CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Codes4 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(C_CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Codes4 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(D_CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Codes5 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(C_CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Codes5 - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(D_CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Comps - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(C_CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Comps - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(D_CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Currs - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Emps - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(C_EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Emps - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(D_EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_GAccs - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ План счетов - Проверка в PARENT */
  IF UPDATE(C_GAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_GAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_GAccs - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ План счетов - Проверка в PARENT */
  IF UPDATE(D_GAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_GAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_GVols - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник проводок: виды аналитики - Проверка в PARENT */
  IF UPDATE(C_GVolID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_GVolID NOT IN (SELECT GVolID FROM r_GVols))
      BEGIN
        EXEC z_RelationError 'r_GVols', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_GVols - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник проводок: виды аналитики - Проверка в PARENT */
  IF UPDATE(D_GVolID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_GVolID NOT IN (SELECT GVolID FROM r_GVols))
      BEGIN
        EXEC z_RelationError 'r_GVols', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Prods - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(C_ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Prods - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(D_ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Stocks - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(C_StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ r_Stocks - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(D_StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ z_DocLinks - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Документы - Взаимосвязи - Проверка в PARENT */
  IF UPDATE(C_GrndLinkID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_GrndLinkID NOT IN (SELECT LinkID FROM z_DocLinks))
      BEGIN
        EXEC z_RelationError 'z_DocLinks', 'b_GTranD', 1
        RETURN
      END

/* b_GTranD ^ z_DocLinks - Проверка в PARENT */
/* Таблица проводок (Проводки) ^ Документы - Взаимосвязи - Проверка в PARENT */
  IF UPDATE(D_GrndLinkID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_GrndLinkID NOT IN (SELECT LinkID FROM z_DocLinks))
      BEGIN
        EXEC z_RelationError 'z_DocLinks', 'b_GTranD', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_GTranD', N'Last', N'UPDATE'
GO