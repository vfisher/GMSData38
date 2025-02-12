CREATE TABLE [dbo].[r_GAccs] (
  [GAccID1] [tinyint] NOT NULL,
  [GAccID2] [tinyint] NOT NULL,
  [GAccID3] [smallint] NOT NULL,
  [GAccID] [int] NOT NULL,
  [GAccName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  [GAccRollUp] [bit] NOT NULL,
  [GAccType] [tinyint] NOT NULL,
  [GAccMain] [bit] NOT NULL,
  [A_CompID] [int] NOT NULL,
  [A_EmpID] [int] NOT NULL,
  [A_CodeID1] [smallint] NOT NULL,
  [A_CodeID2] [smallint] NOT NULL,
  [A_CodeID3] [smallint] NOT NULL,
  [A_CodeID4] [smallint] NOT NULL,
  [A_CodeID5] [smallint] NOT NULL,
  [A_StockID] [int] NOT NULL,
  [A_ProdID] [int] NOT NULL,
  [A_AssID] [int] NOT NULL,
  [A_VolID] [int] NOT NULL,
  [A_CompVol] [tinyint] NOT NULL,
  [A_EmpVol] [tinyint] NOT NULL,
  [A_CodeVol1] [tinyint] NOT NULL,
  [A_CodeVol2] [tinyint] NOT NULL,
  [A_CodeVol3] [tinyint] NOT NULL,
  [A_CodeVol4] [tinyint] NOT NULL,
  [A_CodeVol5] [tinyint] NOT NULL,
  [A_StockVol] [tinyint] NOT NULL,
  [A_ProdVol] [tinyint] NOT NULL,
  [A_AssVol] [tinyint] NOT NULL,
  [A_VolVol] [tinyint] NOT NULL,
  [A_IncQty] [bit] NOT NULL,
  [A_AddQty] [bit] NOT NULL,
  CONSTRAINT [_pk_r_GAccs] PRIMARY KEY CLUSTERED ([GAccID])
)
ON [PRIMARY]
GO

CREATE INDEX [A_AssID]
  ON [dbo].[r_GAccs] ([A_AssID])
  ON [PRIMARY]
GO

CREATE INDEX [A_CodeID1]
  ON [dbo].[r_GAccs] ([A_CodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [A_CodeID2]
  ON [dbo].[r_GAccs] ([A_CodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [A_CodeID3]
  ON [dbo].[r_GAccs] ([A_CodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [A_CodeID4]
  ON [dbo].[r_GAccs] ([A_CodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [A_CodeID5]
  ON [dbo].[r_GAccs] ([A_CodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [A_CompID]
  ON [dbo].[r_GAccs] ([A_CompID])
  ON [PRIMARY]
GO

CREATE INDEX [A_EmpID]
  ON [dbo].[r_GAccs] ([A_EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [A_ProdID]
  ON [dbo].[r_GAccs] ([A_ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [A_StockID]
  ON [dbo].[r_GAccs] ([A_StockID])
  ON [PRIMARY]
GO

CREATE INDEX [A_VolID]
  ON [dbo].[r_GAccs] ([A_VolID])
  ON [PRIMARY]
GO

CREATE INDEX [GAccID3]
  ON [dbo].[r_GAccs] ([GAccID3])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [GAccName]
  ON [dbo].[r_GAccs] ([GAccName])
  ON [PRIMARY]
GO

CREATE INDEX [GAccType]
  ON [dbo].[r_GAccs] ([GAccType])
  ON [PRIMARY]
GO

CREATE INDEX [r_GAccs2r_GAccs]
  ON [dbo].[r_GAccs] ([GAccID1], [GAccID2])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.GAccID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.GAccID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.GAccID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.GAccID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.GAccRollUp'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.GAccType'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.GAccMain'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_CompID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_EmpID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_CodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_CodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_CodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_CodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_CodeID5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_StockID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_AssID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_VolID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_CompVol'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_EmpVol'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_CodeVol1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_CodeVol2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_CodeVol3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_CodeVol4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_CodeVol5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_StockVol'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_ProdVol'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_AssVol'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_VolVol'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_IncQty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GAccs.A_AddQty'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_GAccs] ON [r_GAccs]
FOR INSERT AS
/* r_GAccs - План счетов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_GAccs ^ r_Assets - Проверка в PARENT */
/* План счетов ^ Справочник основных средств - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.A_AssID NOT IN (SELECT AssID FROM r_Assets))
    BEGIN
      EXEC z_RelationError 'r_Assets', 'r_GAccs', 0
      RETURN
    END

/* r_GAccs ^ r_Codes1 - Проверка в PARENT */
/* План счетов ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.A_CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'r_GAccs', 0
      RETURN
    END

/* r_GAccs ^ r_Codes2 - Проверка в PARENT */
/* План счетов ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.A_CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'r_GAccs', 0
      RETURN
    END

/* r_GAccs ^ r_Codes3 - Проверка в PARENT */
/* План счетов ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.A_CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'r_GAccs', 0
      RETURN
    END

/* r_GAccs ^ r_Codes4 - Проверка в PARENT */
/* План счетов ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.A_CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'r_GAccs', 0
      RETURN
    END

/* r_GAccs ^ r_Codes5 - Проверка в PARENT */
/* План счетов ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.A_CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'r_GAccs', 0
      RETURN
    END

/* r_GAccs ^ r_Comps - Проверка в PARENT */
/* План счетов ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.A_CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'r_GAccs', 0
      RETURN
    END

/* r_GAccs ^ r_Emps - Проверка в PARENT */
/* План счетов ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.A_EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_GAccs', 0
      RETURN
    END

/* r_GAccs ^ r_GAccs2 - Проверка в PARENT */
/* План счетов ^ План счетов - Первый порядок - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_GAccs2 m WITH(NOLOCK), inserted i WHERE i.GAccID1 = m.GAccID1 AND i.GAccID2 = m.GAccID2) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_GAccs2', 'r_GAccs', 0
      RETURN
    END

/* r_GAccs ^ r_GVols - Проверка в PARENT */
/* План счетов ^ Справочник проводок: виды аналитики - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.A_VolID NOT IN (SELECT GVolID FROM r_GVols))
    BEGIN
      EXEC z_RelationError 'r_GVols', 'r_GAccs', 0
      RETURN
    END

/* r_GAccs ^ r_Prods - Проверка в PARENT */
/* План счетов ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.A_ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_GAccs', 0
      RETURN
    END

/* r_GAccs ^ r_Stocks - Проверка в PARENT */
/* План счетов ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.A_StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'r_GAccs', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10707001, m.ChID, 
    '[' + cast(i.GAccID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_GAccs1 m ON m.GAccID1 = i.GAccID1

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_GAccs', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_GAccs] ON [r_GAccs]
FOR UPDATE AS
/* r_GAccs - План счетов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_GAccs ^ r_Assets - Проверка в PARENT */
/* План счетов ^ Справочник основных средств - Проверка в PARENT */
  IF UPDATE(A_AssID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.A_AssID NOT IN (SELECT AssID FROM r_Assets))
      BEGIN
        EXEC z_RelationError 'r_Assets', 'r_GAccs', 1
        RETURN
      END

/* r_GAccs ^ r_Codes1 - Проверка в PARENT */
/* План счетов ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(A_CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.A_CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'r_GAccs', 1
        RETURN
      END

/* r_GAccs ^ r_Codes2 - Проверка в PARENT */
/* План счетов ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(A_CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.A_CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'r_GAccs', 1
        RETURN
      END

/* r_GAccs ^ r_Codes3 - Проверка в PARENT */
/* План счетов ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(A_CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.A_CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'r_GAccs', 1
        RETURN
      END

/* r_GAccs ^ r_Codes4 - Проверка в PARENT */
/* План счетов ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(A_CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.A_CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'r_GAccs', 1
        RETURN
      END

/* r_GAccs ^ r_Codes5 - Проверка в PARENT */
/* План счетов ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(A_CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.A_CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'r_GAccs', 1
        RETURN
      END

/* r_GAccs ^ r_Comps - Проверка в PARENT */
/* План счетов ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(A_CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.A_CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'r_GAccs', 1
        RETURN
      END

/* r_GAccs ^ r_Emps - Проверка в PARENT */
/* План счетов ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(A_EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.A_EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'r_GAccs', 1
        RETURN
      END

/* r_GAccs ^ r_GAccs2 - Проверка в PARENT */
/* План счетов ^ План счетов - Первый порядок - Проверка в PARENT */
  IF UPDATE(GAccID1) OR UPDATE(GAccID2)
    IF (SELECT COUNT(*) FROM r_GAccs2 m WITH(NOLOCK), inserted i WHERE i.GAccID1 = m.GAccID1 AND i.GAccID2 = m.GAccID2) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_GAccs2', 'r_GAccs', 1
        RETURN
      END

/* r_GAccs ^ r_GVols - Проверка в PARENT */
/* План счетов ^ Справочник проводок: виды аналитики - Проверка в PARENT */
  IF UPDATE(A_VolID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.A_VolID NOT IN (SELECT GVolID FROM r_GVols))
      BEGIN
        EXEC z_RelationError 'r_GVols', 'r_GAccs', 1
        RETURN
      END

/* r_GAccs ^ r_Prods - Проверка в PARENT */
/* План счетов ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(A_ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.A_ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_GAccs', 1
        RETURN
      END

/* r_GAccs ^ r_Stocks - Проверка в PARENT */
/* План счетов ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(A_StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.A_StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'r_GAccs', 1
        RETURN
      END

/* r_GAccs ^ r_AssetG - Обновление CHILD */
/* План счетов ^ Справочник основных средств: подгруппы - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AssDepGAccID = i.GAccID
          FROM r_AssetG a, inserted i, deleted d WHERE a.AssDepGAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_AssetG a, deleted d WHERE a.AssDepGAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Справочник основных средств: подгруппы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ r_AssetG - Обновление CHILD */
/* План счетов ^ Справочник основных средств: подгруппы - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AssGrGAccID = i.GAccID
          FROM r_AssetG a, inserted i, deleted d WHERE a.AssGrGAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_AssetG a, deleted d WHERE a.AssGrGAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Справочник основных средств: подгруппы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ r_AssetH - Обновление CHILD */
/* План счетов ^ Справочник основных средств: История - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GAccID = i.GAccID
          FROM r_AssetH a, inserted i, deleted d WHERE a.GAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_AssetH a, deleted d WHERE a.GAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Справочник основных средств: История''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ r_Posts - Обновление CHILD */
/* План счетов ^ Справочник должностей - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CostGAccID = i.GAccID
          FROM r_Posts a, inserted i, deleted d WHERE a.CostGAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Posts a, deleted d WHERE a.CostGAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Справочник должностей''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ r_OursAC - Обновление CHILD */
/* План счетов ^ Справочник внутренних фирм - Валютные счета - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GAccID = i.GAccID
          FROM r_OursAC a, inserted i, deleted d WHERE a.GAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_OursAC a, deleted d WHERE a.GAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Справочник внутренних фирм - Валютные счета''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ r_OursCC - Обновление CHILD */
/* План счетов ^ Справочник внутренних фирм - Расчетные счета - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GAccID = i.GAccID
          FROM r_OursCC a, inserted i, deleted d WHERE a.GAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_OursCC a, deleted d WHERE a.GAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Справочник внутренних фирм - Расчетные счета''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ r_GAccFA - Обновление CHILD */
/* План счетов ^ План счетов - Формулы аналитики - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GAccID = i.GAccID
          FROM r_GAccFA a, inserted i, deleted d WHERE a.GAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GAccFA a, deleted d WHERE a.GAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''План счетов - Формулы аналитики''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_AExp - Обновление CHILD */
/* План счетов ^ Акт сдачи услуг - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_AExp a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_AExp a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Акт сдачи услуг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_AExp - Обновление CHILD */
/* План счетов ^ Акт сдачи услуг - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_AExp a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_AExp a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Акт сдачи услуг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_ARec - Обновление CHILD */
/* План счетов ^ Акт приемки услуг - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_ARec a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARec a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Акт приемки услуг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_ARec - Обновление CHILD */
/* План счетов ^ Акт приемки услуг - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_ARec a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARec a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Акт приемки услуг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_ARepADP - Обновление CHILD */
/* План счетов ^ Авансовый отчет валютный (ТМЦ) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_ARepADP a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepADP a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Авансовый отчет валютный (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_ARepADS - Обновление CHILD */
/* План счетов ^ Авансовый отчет валютный (Основные средства) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GSTAccID = i.GAccID
          FROM b_ARepADS a, inserted i, deleted d WHERE a.GSTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepADS a, deleted d WHERE a.GSTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Авансовый отчет валютный (Основные средства)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_ARepADV - Обновление CHILD */
/* План счетов ^ Авансовый отчет валютный (Общие) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GVTAccID = i.GAccID
          FROM b_ARepADV a, inserted i, deleted d WHERE a.GVTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepADV a, deleted d WHERE a.GVTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Авансовый отчет валютный (Общие)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_BankExpAC - Обновление CHILD */
/* План счетов ^ Валютный счет: Расход - Обновление CHILD */
  IF UPDATE(GAccId)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccId
          FROM b_BankExpAC a, inserted i, deleted d WHERE a.GTAccID = d.GAccId
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankExpAC a, deleted d WHERE a.GTAccID = d.GAccId)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Валютный счет: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_BankExpAC - Обновление CHILD */
/* План счетов ^ Валютный счет: Расход - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_BankExpAC a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankExpAC a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Валютный счет: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_BankExpCC - Обновление CHILD */
/* План счетов ^ Расчетный счет: Расход - Обновление CHILD */
  IF UPDATE(GAccId)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccId
          FROM b_BankExpCC a, inserted i, deleted d WHERE a.GTAccID = d.GAccId
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankExpCC a, deleted d WHERE a.GTAccID = d.GAccId)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Расчетный счет: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_BankExpCC - Обновление CHILD */
/* План счетов ^ Расчетный счет: Расход - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_BankExpCC a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankExpCC a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Расчетный счет: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_BankRecAC - Обновление CHILD */
/* План счетов ^ Валютный счет: Приход - Обновление CHILD */
  IF UPDATE(GAccId)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccId
          FROM b_BankRecAC a, inserted i, deleted d WHERE a.GTAccID = d.GAccId
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankRecAC a, deleted d WHERE a.GTAccID = d.GAccId)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Валютный счет: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_BankRecAC - Обновление CHILD */
/* План счетов ^ Валютный счет: Приход - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_BankRecAC a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankRecAC a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Валютный счет: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_BankRecCC - Обновление CHILD */
/* План счетов ^ Расчетный счет: Приход - Обновление CHILD */
  IF UPDATE(GAccId)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccId
          FROM b_BankRecCC a, inserted i, deleted d WHERE a.GTAccID = d.GAccId
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankRecCC a, deleted d WHERE a.GTAccID = d.GAccId)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Расчетный счет: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_BankRecCC - Обновление CHILD */
/* План счетов ^ Расчетный счет: Приход - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_BankRecCC a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankRecCC a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Расчетный счет: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_CExp - Обновление CHILD */
/* План счетов ^ Кассовый ордер: Расход - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_CExp a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CExp a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Кассовый ордер: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_CExp - Обновление CHILD */
/* План счетов ^ Кассовый ордер: Расход - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_CExp a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CExp a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Кассовый ордер: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_CInv - Обновление CHILD */
/* План счетов ^ ТМЦ: Расход по ГТД (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_CInv a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CInv a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''ТМЦ: Расход по ГТД (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_CInv - Обновление CHILD */
/* План счетов ^ ТМЦ: Расход по ГТД (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_CInv a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CInv a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''ТМЦ: Расход по ГТД (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_CRec - Обновление CHILD */
/* План счетов ^ Кассовый ордер: Приход - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_CRec a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRec a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Кассовый ордер: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_CRec - Обновление CHILD */
/* План счетов ^ Кассовый ордер: Приход - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_CRec a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRec a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Кассовый ордер: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_CRepADP - Обновление CHILD */
/* План счетов ^ Авансовый отчет с признаками (ТМЦ) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_CRepADP a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRepADP a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Авансовый отчет с признаками (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_CRepADS - Обновление CHILD */
/* План счетов ^ Авансовый отчет с признаками (Основные средства) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GSTAccID = i.GAccID
          FROM b_CRepADS a, inserted i, deleted d WHERE a.GSTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRepADS a, deleted d WHERE a.GSTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Авансовый отчет с признаками (Основные средства)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_CRepADV - Обновление CHILD */
/* План счетов ^ Авансовый отчет с признаками (Общие) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GVTAccID = i.GAccID
          FROM b_CRepADV a, inserted i, deleted d WHERE a.GVTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRepADV a, deleted d WHERE a.GVTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Авансовый отчет с признаками (Общие)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_CRet - Обновление CHILD */
/* План счетов ^ ТМЦ: Возврат поставщику (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_CRet a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRet a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''ТМЦ: Возврат поставщику (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_Cst - Обновление CHILD */
/* План счетов ^ ТМЦ: Приход по ГТД (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_Cst a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Cst a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''ТМЦ: Приход по ГТД (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_Cst - Обновление CHILD */
/* План счетов ^ ТМЦ: Приход по ГТД (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_Cst a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Cst a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''ТМЦ: Приход по ГТД (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_DStack - Обновление CHILD */
/* План счетов ^ ТМЦ: Суммовой учет - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_DStack a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_DStack a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''ТМЦ: Суммовой учет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_DStack - Обновление CHILD */
/* План счетов ^ ТМЦ: Суммовой учет - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_DStack a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_DStack a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''ТМЦ: Суммовой учет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_Exp - Обновление CHILD */
/* План счетов ^ ТМЦ: Внутренний расход (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_Exp a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Exp a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''ТМЦ: Внутренний расход (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_Exp - Обновление CHILD */
/* План счетов ^ ТМЦ: Внутренний расход (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_Exp a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Exp a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''ТМЦ: Внутренний расход (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_GOperDocs - Обновление CHILD */
/* План счетов ^ Проводки для документов - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_GOperDocs a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GOperDocs a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Проводки для документов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_GOperDocs - Обновление CHILD */
/* План счетов ^ Проводки для документов - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_GOperDocs a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GOperDocs a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Проводки для документов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_GOperDocs - Обновление CHILD */
/* План счетов ^ Проводки для документов - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTaxAccID = i.GAccID
          FROM b_GOperDocs a, inserted i, deleted d WHERE a.GTaxAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GOperDocs a, deleted d WHERE a.GTaxAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Проводки для документов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_GTranD - Обновление CHILD */
/* План счетов ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_GAccID = i.GAccID
          FROM b_GTranD a, inserted i, deleted d WHERE a.C_GAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.C_GAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_GTranD - Обновление CHILD */
/* План счетов ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_GAccID = i.GAccID
          FROM b_GTranD a, inserted i, deleted d WHERE a.D_GAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.D_GAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_Inv - Обновление CHILD */
/* План счетов ^ ТМЦ: Расходная накладная (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_Inv a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Inv a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''ТМЦ: Расходная накладная (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_Inv - Обновление CHILD */
/* План счетов ^ ТМЦ: Расходная накладная (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_Inv a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Inv a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''ТМЦ: Расходная накладная (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_Rec - Обновление CHILD */
/* План счетов ^ ТМЦ: Приход по накладной (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_Rec a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Rec a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''ТМЦ: Приход по накладной (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_Rec - Обновление CHILD */
/* План счетов ^ ТМЦ: Приход по накладной (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_Rec a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Rec a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''ТМЦ: Приход по накладной (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_Ret - Обновление CHILD */
/* План счетов ^ ТМЦ: Возврат от получателя (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_Ret a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Ret a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''ТМЦ: Возврат от получателя (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_Ret - Обновление CHILD */
/* План счетов ^ ТМЦ: Возврат от получателя (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_Ret a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Ret a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''ТМЦ: Возврат от получателя (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_SExp - Обновление CHILD */
/* План счетов ^ Основные средства: Списание (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_SExp a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExp a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Основные средства: Списание (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_SExp - Обновление CHILD */
/* План счетов ^ Основные средства: Списание (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_SExp a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExp a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Основные средства: Списание (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_SInv - Обновление CHILD */
/* План счетов ^ Основные средства: Продажа (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_SInv a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SInv a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Основные средства: Продажа (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_SInv - Обновление CHILD */
/* План счетов ^ Основные средства: Продажа (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_SInv a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SInv a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Основные средства: Продажа (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_SRec - Обновление CHILD */
/* План счетов ^ Основные средства: Приход (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_SRec a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRec a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Основные средства: Приход (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_SRec - Обновление CHILD */
/* План счетов ^ Основные средства: Приход (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_SRec a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRec a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Основные средства: Приход (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_SRep - Обновление CHILD */
/* План счетов ^ Основные средства: Ремонт (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_SRep a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRep a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Основные средства: Ремонт (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_SRep - Обновление CHILD */
/* План счетов ^ Основные средства: Ремонт (Заголовок) - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_SRep a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRep a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Основные средства: Ремонт (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_TExp - Обновление CHILD */
/* План счетов ^ Налоговые накладные: Исходящие - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_TExp a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TExp a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Налоговые накладные: Исходящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_TExp - Обновление CHILD */
/* План счетов ^ Налоговые накладные: Исходящие - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_TExp a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TExp a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Налоговые накладные: Исходящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_TranC - Обновление CHILD */
/* План счетов ^ Проводка по предприятию - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_TranC a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranC a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Проводка по предприятию''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_TranC - Обновление CHILD */
/* План счетов ^ Проводка по предприятию - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_TranC a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranC a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Проводка по предприятию''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_TranH - Обновление CHILD */
/* План счетов ^ Ручные проводки - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_GAccID = i.GAccID
          FROM b_TranH a, inserted i, deleted d WHERE a.C_GAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranH a, deleted d WHERE a.C_GAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Ручные проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_TranH - Обновление CHILD */
/* План счетов ^ Ручные проводки - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_GAccID = i.GAccID
          FROM b_TranH a, inserted i, deleted d WHERE a.D_GAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranH a, deleted d WHERE a.D_GAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Ручные проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_TRec - Обновление CHILD */
/* План счетов ^ Налоговые накладные: Входящие - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAccID = i.GAccID
          FROM b_TRec a, inserted i, deleted d WHERE a.GTAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TRec a, deleted d WHERE a.GTAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Налоговые накладные: Входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_TRec - Обновление CHILD */
/* План счетов ^ Налоговые накладные: Входящие - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GTAdvAccID = i.GAccID
          FROM b_TRec a, inserted i, deleted d WHERE a.GTAdvAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TRec a, deleted d WHERE a.GTAdvAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Налоговые накладные: Входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_zInH - Обновление CHILD */
/* План счетов ^ Ручные входящие - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_GAccID = i.GAccID
          FROM b_zInH a, inserted i, deleted d WHERE a.C_GAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInH a, deleted d WHERE a.C_GAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Ручные входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ b_zInH - Обновление CHILD */
/* План счетов ^ Ручные входящие - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_GAccID = i.GAccID
          FROM b_zInH a, inserted i, deleted d WHERE a.D_GAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInH a, deleted d WHERE a.D_GAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Ручные входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GAccs ^ p_CommunalTaxDD - Обновление CHILD */
/* План счетов ^ Коммунальный налог: Подробно - Обновление CHILD */
  IF UPDATE(GAccID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CostGAccID = i.GAccID
          FROM p_CommunalTaxDD a, inserted i, deleted d WHERE a.CostGAccID = d.GAccID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CommunalTaxDD a, deleted d WHERE a.CostGAccID = d.GAccID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''План счетов'' => ''Коммунальный налог: Подробно''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(GAccID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT GAccID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT GAccID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.GAccID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10707001 AND l.PKValue = 
          '[' + cast(d.GAccID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.GAccID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10707001 AND l.PKValue = 
          '[' + cast(d.GAccID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10707001, m.ChID, 
          '[' + cast(d.GAccID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_GAccs1 m ON m.GAccID1 = d.GAccID1
          DELETE FROM z_LogCreate WHERE TableCode = 10707001 AND PKValue IN (SELECT 
          '[' + cast(GAccID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10707001 AND PKValue IN (SELECT 
          '[' + cast(GAccID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10707001, m.ChID, 
          '[' + cast(i.GAccID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_GAccs1 m ON m.GAccID1 = i.GAccID1

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10707001, m.ChID, 
    '[' + cast(i.GAccID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_GAccs1 m ON m.GAccID1 = i.GAccID1


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_GAccs', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_GAccs] ON [r_GAccs]
FOR DELETE AS
/* r_GAccs - План счетов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_GAccs ^ r_AssetG - Проверка в CHILD */
/* План счетов ^ Справочник основных средств: подгруппы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_AssetG a WITH(NOLOCK), deleted d WHERE a.AssDepGAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'r_AssetG', 3
      RETURN
    END

/* r_GAccs ^ r_AssetG - Проверка в CHILD */
/* План счетов ^ Справочник основных средств: подгруппы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_AssetG a WITH(NOLOCK), deleted d WHERE a.AssGrGAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'r_AssetG', 3
      RETURN
    END

/* r_GAccs ^ r_AssetH - Проверка в CHILD */
/* План счетов ^ Справочник основных средств: История - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_AssetH a WITH(NOLOCK), deleted d WHERE a.GAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'r_AssetH', 3
      RETURN
    END

/* r_GAccs ^ r_Posts - Проверка в CHILD */
/* План счетов ^ Справочник должностей - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Posts a WITH(NOLOCK), deleted d WHERE a.CostGAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'r_Posts', 3
      RETURN
    END

/* r_GAccs ^ r_OursAC - Проверка в CHILD */
/* План счетов ^ Справочник внутренних фирм - Валютные счета - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_OursAC a WITH(NOLOCK), deleted d WHERE a.GAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'r_OursAC', 3
      RETURN
    END

/* r_GAccs ^ r_OursCC - Проверка в CHILD */
/* План счетов ^ Справочник внутренних фирм - Расчетные счета - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_OursCC a WITH(NOLOCK), deleted d WHERE a.GAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'r_OursCC', 3
      RETURN
    END

/* r_GAccs ^ r_GAccFA - Удаление в CHILD */
/* План счетов ^ План счетов - Формулы аналитики - Удаление в CHILD */
  DELETE r_GAccFA FROM r_GAccFA a, deleted d WHERE a.GAccID = d.GAccID
  IF @@ERROR > 0 RETURN

/* r_GAccs ^ b_AExp - Проверка в CHILD */
/* План счетов ^ Акт сдачи услуг - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_AExp a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_AExp', 3
      RETURN
    END

/* r_GAccs ^ b_AExp - Проверка в CHILD */
/* План счетов ^ Акт сдачи услуг - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_AExp a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_AExp', 3
      RETURN
    END

/* r_GAccs ^ b_ARec - Проверка в CHILD */
/* План счетов ^ Акт приемки услуг - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARec a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_ARec', 3
      RETURN
    END

/* r_GAccs ^ b_ARec - Проверка в CHILD */
/* План счетов ^ Акт приемки услуг - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARec a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_ARec', 3
      RETURN
    END

/* r_GAccs ^ b_ARepADP - Проверка в CHILD */
/* План счетов ^ Авансовый отчет валютный (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepADP a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_ARepADP', 3
      RETURN
    END

/* r_GAccs ^ b_ARepADS - Проверка в CHILD */
/* План счетов ^ Авансовый отчет валютный (Основные средства) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepADS a WITH(NOLOCK), deleted d WHERE a.GSTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_ARepADS', 3
      RETURN
    END

/* r_GAccs ^ b_ARepADV - Проверка в CHILD */
/* План счетов ^ Авансовый отчет валютный (Общие) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepADV a WITH(NOLOCK), deleted d WHERE a.GVTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_ARepADV', 3
      RETURN
    END

/* r_GAccs ^ b_BankExpAC - Проверка в CHILD */
/* План счетов ^ Валютный счет: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankExpAC a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccId)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_BankExpAC', 3
      RETURN
    END

/* r_GAccs ^ b_BankExpAC - Проверка в CHILD */
/* План счетов ^ Валютный счет: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankExpAC a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_BankExpAC', 3
      RETURN
    END

/* r_GAccs ^ b_BankExpCC - Проверка в CHILD */
/* План счетов ^ Расчетный счет: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankExpCC a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccId)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_BankExpCC', 3
      RETURN
    END

/* r_GAccs ^ b_BankExpCC - Проверка в CHILD */
/* План счетов ^ Расчетный счет: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankExpCC a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_BankExpCC', 3
      RETURN
    END

/* r_GAccs ^ b_BankRecAC - Проверка в CHILD */
/* План счетов ^ Валютный счет: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankRecAC a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccId)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_BankRecAC', 3
      RETURN
    END

/* r_GAccs ^ b_BankRecAC - Проверка в CHILD */
/* План счетов ^ Валютный счет: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankRecAC a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_BankRecAC', 3
      RETURN
    END

/* r_GAccs ^ b_BankRecCC - Проверка в CHILD */
/* План счетов ^ Расчетный счет: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankRecCC a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccId)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_BankRecCC', 3
      RETURN
    END

/* r_GAccs ^ b_BankRecCC - Проверка в CHILD */
/* План счетов ^ Расчетный счет: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankRecCC a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_BankRecCC', 3
      RETURN
    END

/* r_GAccs ^ b_CExp - Проверка в CHILD */
/* План счетов ^ Кассовый ордер: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CExp a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_CExp', 3
      RETURN
    END

/* r_GAccs ^ b_CExp - Проверка в CHILD */
/* План счетов ^ Кассовый ордер: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CExp a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_CExp', 3
      RETURN
    END

/* r_GAccs ^ b_CInv - Проверка в CHILD */
/* План счетов ^ ТМЦ: Расход по ГТД (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CInv a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_CInv', 3
      RETURN
    END

/* r_GAccs ^ b_CInv - Проверка в CHILD */
/* План счетов ^ ТМЦ: Расход по ГТД (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CInv a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_CInv', 3
      RETURN
    END

/* r_GAccs ^ b_CRec - Проверка в CHILD */
/* План счетов ^ Кассовый ордер: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRec a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_CRec', 3
      RETURN
    END

/* r_GAccs ^ b_CRec - Проверка в CHILD */
/* План счетов ^ Кассовый ордер: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRec a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_CRec', 3
      RETURN
    END

/* r_GAccs ^ b_CRepADP - Проверка в CHILD */
/* План счетов ^ Авансовый отчет с признаками (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRepADP a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_CRepADP', 3
      RETURN
    END

/* r_GAccs ^ b_CRepADS - Проверка в CHILD */
/* План счетов ^ Авансовый отчет с признаками (Основные средства) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRepADS a WITH(NOLOCK), deleted d WHERE a.GSTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_CRepADS', 3
      RETURN
    END

/* r_GAccs ^ b_CRepADV - Проверка в CHILD */
/* План счетов ^ Авансовый отчет с признаками (Общие) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRepADV a WITH(NOLOCK), deleted d WHERE a.GVTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_CRepADV', 3
      RETURN
    END

/* r_GAccs ^ b_CRet - Проверка в CHILD */
/* План счетов ^ ТМЦ: Возврат поставщику (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRet a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_CRet', 3
      RETURN
    END

/* r_GAccs ^ b_Cst - Проверка в CHILD */
/* План счетов ^ ТМЦ: Приход по ГТД (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Cst a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_Cst', 3
      RETURN
    END

/* r_GAccs ^ b_Cst - Проверка в CHILD */
/* План счетов ^ ТМЦ: Приход по ГТД (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Cst a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_Cst', 3
      RETURN
    END

/* r_GAccs ^ b_DStack - Проверка в CHILD */
/* План счетов ^ ТМЦ: Суммовой учет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_DStack a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_DStack', 3
      RETURN
    END

/* r_GAccs ^ b_DStack - Проверка в CHILD */
/* План счетов ^ ТМЦ: Суммовой учет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_DStack a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_DStack', 3
      RETURN
    END

/* r_GAccs ^ b_Exp - Проверка в CHILD */
/* План счетов ^ ТМЦ: Внутренний расход (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Exp a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_Exp', 3
      RETURN
    END

/* r_GAccs ^ b_Exp - Проверка в CHILD */
/* План счетов ^ ТМЦ: Внутренний расход (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Exp a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_Exp', 3
      RETURN
    END

/* r_GAccs ^ b_GOperDocs - Проверка в CHILD */
/* План счетов ^ Проводки для документов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GOperDocs a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_GOperDocs', 3
      RETURN
    END

/* r_GAccs ^ b_GOperDocs - Проверка в CHILD */
/* План счетов ^ Проводки для документов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GOperDocs a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_GOperDocs', 3
      RETURN
    END

/* r_GAccs ^ b_GOperDocs - Проверка в CHILD */
/* План счетов ^ Проводки для документов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GOperDocs a WITH(NOLOCK), deleted d WHERE a.GTaxAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_GOperDocs', 3
      RETURN
    END

/* r_GAccs ^ b_GTranD - Удаление в CHILD */
/* План счетов ^ Таблица проводок (Проводки) - Удаление в CHILD */
  DELETE b_GTranD FROM b_GTranD a, deleted d WHERE a.C_GAccID = d.GAccID
  IF @@ERROR > 0 RETURN

/* r_GAccs ^ b_GTranD - Удаление в CHILD */
/* План счетов ^ Таблица проводок (Проводки) - Удаление в CHILD */
  DELETE b_GTranD FROM b_GTranD a, deleted d WHERE a.D_GAccID = d.GAccID
  IF @@ERROR > 0 RETURN

/* r_GAccs ^ b_Inv - Проверка в CHILD */
/* План счетов ^ ТМЦ: Расходная накладная (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Inv a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_Inv', 3
      RETURN
    END

/* r_GAccs ^ b_Inv - Проверка в CHILD */
/* План счетов ^ ТМЦ: Расходная накладная (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Inv a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_Inv', 3
      RETURN
    END

/* r_GAccs ^ b_Rec - Проверка в CHILD */
/* План счетов ^ ТМЦ: Приход по накладной (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Rec a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_Rec', 3
      RETURN
    END

/* r_GAccs ^ b_Rec - Проверка в CHILD */
/* План счетов ^ ТМЦ: Приход по накладной (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Rec a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_Rec', 3
      RETURN
    END

/* r_GAccs ^ b_Ret - Проверка в CHILD */
/* План счетов ^ ТМЦ: Возврат от получателя (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Ret a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_Ret', 3
      RETURN
    END

/* r_GAccs ^ b_Ret - Проверка в CHILD */
/* План счетов ^ ТМЦ: Возврат от получателя (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Ret a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_Ret', 3
      RETURN
    END

/* r_GAccs ^ b_SExp - Проверка в CHILD */
/* План счетов ^ Основные средства: Списание (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExp a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_SExp', 3
      RETURN
    END

/* r_GAccs ^ b_SExp - Проверка в CHILD */
/* План счетов ^ Основные средства: Списание (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExp a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_SExp', 3
      RETURN
    END

/* r_GAccs ^ b_SInv - Проверка в CHILD */
/* План счетов ^ Основные средства: Продажа (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SInv a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_SInv', 3
      RETURN
    END

/* r_GAccs ^ b_SInv - Проверка в CHILD */
/* План счетов ^ Основные средства: Продажа (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SInv a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_SInv', 3
      RETURN
    END

/* r_GAccs ^ b_SRec - Проверка в CHILD */
/* План счетов ^ Основные средства: Приход (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRec a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_SRec', 3
      RETURN
    END

/* r_GAccs ^ b_SRec - Проверка в CHILD */
/* План счетов ^ Основные средства: Приход (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRec a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_SRec', 3
      RETURN
    END

/* r_GAccs ^ b_SRep - Проверка в CHILD */
/* План счетов ^ Основные средства: Ремонт (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRep a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_SRep', 3
      RETURN
    END

/* r_GAccs ^ b_SRep - Проверка в CHILD */
/* План счетов ^ Основные средства: Ремонт (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRep a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_SRep', 3
      RETURN
    END

/* r_GAccs ^ b_TExp - Проверка в CHILD */
/* План счетов ^ Налоговые накладные: Исходящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TExp a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_TExp', 3
      RETURN
    END

/* r_GAccs ^ b_TExp - Проверка в CHILD */
/* План счетов ^ Налоговые накладные: Исходящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TExp a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_TExp', 3
      RETURN
    END

/* r_GAccs ^ b_TranC - Проверка в CHILD */
/* План счетов ^ Проводка по предприятию - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranC a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_TranC', 3
      RETURN
    END

/* r_GAccs ^ b_TranC - Проверка в CHILD */
/* План счетов ^ Проводка по предприятию - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranC a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_TranC', 3
      RETURN
    END

/* r_GAccs ^ b_TranH - Проверка в CHILD */
/* План счетов ^ Ручные проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranH a WITH(NOLOCK), deleted d WHERE a.C_GAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_TranH', 3
      RETURN
    END

/* r_GAccs ^ b_TranH - Проверка в CHILD */
/* План счетов ^ Ручные проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranH a WITH(NOLOCK), deleted d WHERE a.D_GAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_TranH', 3
      RETURN
    END

/* r_GAccs ^ b_TRec - Проверка в CHILD */
/* План счетов ^ Налоговые накладные: Входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TRec a WITH(NOLOCK), deleted d WHERE a.GTAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_TRec', 3
      RETURN
    END

/* r_GAccs ^ b_TRec - Проверка в CHILD */
/* План счетов ^ Налоговые накладные: Входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TRec a WITH(NOLOCK), deleted d WHERE a.GTAdvAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_TRec', 3
      RETURN
    END

/* r_GAccs ^ b_zInH - Проверка в CHILD */
/* План счетов ^ Ручные входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInH a WITH(NOLOCK), deleted d WHERE a.C_GAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_zInH', 3
      RETURN
    END

/* r_GAccs ^ b_zInH - Проверка в CHILD */
/* План счетов ^ Ручные входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInH a WITH(NOLOCK), deleted d WHERE a.D_GAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_zInH', 3
      RETURN
    END

/* r_GAccs ^ p_CommunalTaxDD - Проверка в CHILD */
/* План счетов ^ Коммунальный налог: Подробно - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CommunalTaxDD a WITH(NOLOCK), deleted d WHERE a.CostGAccID = d.GAccID)
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'p_CommunalTaxDD', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10707001 AND m.PKValue = 
    '[' + cast(i.GAccID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10707001 AND m.PKValue = 
    '[' + cast(i.GAccID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10707001, m.ChID, 
    '[' + cast(d.GAccID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_GAccs1 m ON m.GAccID1 = d.GAccID1

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_GAccs', N'Last', N'DELETE'
GO