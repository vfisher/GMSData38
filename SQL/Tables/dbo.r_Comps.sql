CREATE TABLE [dbo].[r_Comps] (
  [ChID] [bigint] NOT NULL,
  [CompID] [int] NOT NULL,
  [CompName] [varchar](200) NOT NULL,
  [CompShort] [varchar](200) NULL,
  [Address] [varchar](200) NULL,
  [PostIndex] [varchar](10) NULL,
  [City] [varchar](200) NOT NULL,
  [Region] [varchar](200) NULL,
  [Code] [varchar](20) NOT NULL,
  [TaxRegNo] [varchar](50) NOT NULL,
  [TaxCode] [varchar](20) NOT NULL,
  [TaxPayer] [bit] NOT NULL,
  [CompDesc] [varchar](200) NULL,
  [Contact] [varchar](200) NULL,
  [Phone1] [varchar](50) NULL,
  [Phone2] [varchar](50) NULL,
  [Phone3] [varchar](50) NULL,
  [Fax] [varchar](20) NULL,
  [EMail] [varchar](200) NULL,
  [HTTP] [varchar](200) NULL,
  [Notes] [varchar](200) NULL,
  [CodeID1] [smallint] NOT NULL,
  [CodeID2] [smallint] NOT NULL,
  [CodeID3] [smallint] NOT NULL,
  [CodeID4] [smallint] NOT NULL,
  [CodeID5] [smallint] NOT NULL,
  [UseCodes] [bit] NULL,
  [PLID] [int] NOT NULL,
  [UsePL] [bit] NULL,
  [Discount] [numeric](21, 9) NOT NULL,
  [UseDiscount] [bit] NULL,
  [PayDelay] [smallint] NOT NULL,
  [UsePayDelay] [bit] NULL,
  [MaxCredit] [numeric](21, 9) NULL,
  [CalcMaxCredit] [bit] NULL,
  [EmpID] [int] NOT NULL,
  [Contract1] [varchar](200) NULL,
  [Contract2] [varchar](200) NULL,
  [Contract3] [varchar](200) NULL,
  [License1] [varchar](200) NULL,
  [License2] [varchar](200) NULL,
  [License3] [varchar](200) NULL,
  [Job1] [varchar](200) NULL,
  [Job2] [varchar](200) NULL,
  [Job3] [varchar](200) NULL,
  [TranPrc] [numeric](21, 9) NOT NULL,
  [MorePrc] [numeric](21, 9) NOT NULL,
  [FirstEventMode] [tinyint] NOT NULL,
  [CompType] [smallint] NOT NULL,
  [SysTaxType] [smallint] NOT NULL,
  [FixTaxPercent] [numeric](21, 9) NOT NULL,
  [InStopList] [bit] NOT NULL,
  [Value1] [numeric](21, 9) NULL,
  [Value2] [numeric](21, 9) NULL,
  [Value3] [numeric](21, 9) NULL,
  [PassNo] [varchar](50) NULL,
  [PassSer] [varchar](50) NULL,
  [PassDate] [smalldatetime] NULL,
  [PassDept] [varchar](200) NULL,
  [CompGrID1] [int] NOT NULL DEFAULT (0),
  [CompGrID2] [int] NOT NULL DEFAULT (0),
  [CompGrID3] [int] NOT NULL DEFAULT (0),
  [CompGrID4] [int] NOT NULL DEFAULT (0),
  [CompGrID5] [int] NOT NULL DEFAULT (0),
  [CompNameFull] [varchar](250) NOT NULL,
  [IsResident] [bit] NULL DEFAULT (1),
  [ReasonRegCode] [varchar](12) NULL,
  CONSTRAINT [pk_r_Comps] PRIMARY KEY CLUSTERED ([CompID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Comps] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [Code]
  ON [dbo].[r_Comps] ([Code])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID1]
  ON [dbo].[r_Comps] ([CodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID2]
  ON [dbo].[r_Comps] ([CodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID3]
  ON [dbo].[r_Comps] ([CodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID4]
  ON [dbo].[r_Comps] ([CodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID5]
  ON [dbo].[r_Comps] ([CodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [CompName]
  ON [dbo].[r_Comps] ([CompName])
  ON [PRIMARY]
GO

CREATE INDEX [EmpID]
  ON [dbo].[r_Comps] ([EmpID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [NoDuplicates]
  ON [dbo].[r_Comps] ([CompName], [Code])
  ON [PRIMARY]
GO

CREATE INDEX [PLID]
  ON [dbo].[r_Comps] ([PLID])
  ON [PRIMARY]
GO

CREATE INDEX [ReportPerf]
  ON [dbo].[r_Comps] ([CompID], [CompName])
  ON [PRIMARY]
GO

CREATE INDEX [TaxCode]
  ON [dbo].[r_Comps] ([TaxCode])
  ON [PRIMARY]
GO

CREATE INDEX [TaxRegNo]
  ON [dbo].[r_Comps] ([TaxRegNo])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.CompID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.CodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.CodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.CodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.CodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.CodeID5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.UseCodes'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.PLID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.UsePL'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.Discount'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.UseDiscount'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.PayDelay'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.UsePayDelay'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.MaxCredit'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.CalcMaxCredit'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.EmpID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.TranPrc'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.MorePrc'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.FirstEventMode'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.CompType'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.SysTaxType'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.FixTaxPercent'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.InStopList'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.Value1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.Value2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Comps.Value3'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Comps] ON [r_Comps]
FOR INSERT AS
/* r_Comps - Справочник предприятий - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Comps ^ r_Codes1 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'r_Comps', 0
      RETURN
    END

/* r_Comps ^ r_Codes2 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'r_Comps', 0
      RETURN
    END

/* r_Comps ^ r_Codes3 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'r_Comps', 0
      RETURN
    END

/* r_Comps ^ r_Codes4 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'r_Comps', 0
      RETURN
    END

/* r_Comps ^ r_Codes5 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'r_Comps', 0
      RETURN
    END

/* r_Comps ^ r_CompGrs1 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник предприятий: 1 группа - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompGrID1 NOT IN (SELECT CompGrID1 FROM r_CompGrs1))
    BEGIN
      EXEC z_RelationError 'r_CompGrs1', 'r_Comps', 0
      RETURN
    END

/* r_Comps ^ r_CompGrs2 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник предприятий: 2 группа - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompGrID2 NOT IN (SELECT CompGrID2 FROM r_CompGrs2))
    BEGIN
      EXEC z_RelationError 'r_CompGrs2', 'r_Comps', 0
      RETURN
    END

/* r_Comps ^ r_CompGrs3 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник предприятий: 3 группа - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompGrID3 NOT IN (SELECT CompGrID3 FROM r_CompGrs3))
    BEGIN
      EXEC z_RelationError 'r_CompGrs3', 'r_Comps', 0
      RETURN
    END

/* r_Comps ^ r_CompGrs4 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник предприятий: 4 группа - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompGrID4 NOT IN (SELECT CompGrID4 FROM r_CompGrs4))
    BEGIN
      EXEC z_RelationError 'r_CompGrs4', 'r_Comps', 0
      RETURN
    END

/* r_Comps ^ r_CompGrs5 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник предприятий: 5 группа - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompGrID5 NOT IN (SELECT CompGrID5 FROM r_CompGrs5))
    BEGIN
      EXEC z_RelationError 'r_CompGrs5', 'r_Comps', 0
      RETURN
    END

/* r_Comps ^ r_Emps - Проверка в PARENT */
/* Справочник предприятий ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_Comps', 0
      RETURN
    END

/* r_Comps ^ r_PLs - Проверка в PARENT */
/* Справочник предприятий ^ Справочник прайс-листов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PLID NOT IN (SELECT PLID FROM r_PLs))
    BEGIN
      EXEC z_RelationError 'r_PLs', 'r_Comps', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10250001, ChID, 
    '[' + cast(i.CompID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_Comps', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Comps] ON [r_Comps]
FOR UPDATE AS
/* r_Comps - Справочник предприятий - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Comps ^ r_Codes1 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'r_Comps', 1
        RETURN
      END

/* r_Comps ^ r_Codes2 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'r_Comps', 1
        RETURN
      END

/* r_Comps ^ r_Codes3 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'r_Comps', 1
        RETURN
      END

/* r_Comps ^ r_Codes4 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'r_Comps', 1
        RETURN
      END

/* r_Comps ^ r_Codes5 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'r_Comps', 1
        RETURN
      END

/* r_Comps ^ r_CompGrs1 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник предприятий: 1 группа - Проверка в PARENT */
  IF UPDATE(CompGrID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompGrID1 NOT IN (SELECT CompGrID1 FROM r_CompGrs1))
      BEGIN
        EXEC z_RelationError 'r_CompGrs1', 'r_Comps', 1
        RETURN
      END

/* r_Comps ^ r_CompGrs2 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник предприятий: 2 группа - Проверка в PARENT */
  IF UPDATE(CompGrID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompGrID2 NOT IN (SELECT CompGrID2 FROM r_CompGrs2))
      BEGIN
        EXEC z_RelationError 'r_CompGrs2', 'r_Comps', 1
        RETURN
      END

/* r_Comps ^ r_CompGrs3 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник предприятий: 3 группа - Проверка в PARENT */
  IF UPDATE(CompGrID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompGrID3 NOT IN (SELECT CompGrID3 FROM r_CompGrs3))
      BEGIN
        EXEC z_RelationError 'r_CompGrs3', 'r_Comps', 1
        RETURN
      END

/* r_Comps ^ r_CompGrs4 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник предприятий: 4 группа - Проверка в PARENT */
  IF UPDATE(CompGrID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompGrID4 NOT IN (SELECT CompGrID4 FROM r_CompGrs4))
      BEGIN
        EXEC z_RelationError 'r_CompGrs4', 'r_Comps', 1
        RETURN
      END

/* r_Comps ^ r_CompGrs5 - Проверка в PARENT */
/* Справочник предприятий ^ Справочник предприятий: 5 группа - Проверка в PARENT */
  IF UPDATE(CompGrID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompGrID5 NOT IN (SELECT CompGrID5 FROM r_CompGrs5))
      BEGIN
        EXEC z_RelationError 'r_CompGrs5', 'r_Comps', 1
        RETURN
      END

/* r_Comps ^ r_Emps - Проверка в PARENT */
/* Справочник предприятий ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'r_Comps', 1
        RETURN
      END

/* r_Comps ^ r_PLs - Проверка в PARENT */
/* Справочник предприятий ^ Справочник прайс-листов - Проверка в PARENT */
  IF UPDATE(PLID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PLID NOT IN (SELECT PLID FROM r_PLs))
      BEGIN
        EXEC z_RelationError 'r_PLs', 'r_Comps', 1
        RETURN
      END

/* r_Comps ^ b_PInP - Обновление CHILD */
/* Справочник предприятий ^ Справочник товаров - Цены прихода Бухгалтерии - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_PInP a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PInP a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Справочник товаров - Цены прихода Бухгалтерии''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ r_ProdCV - Обновление CHILD */
/* Справочник предприятий ^ Справочник товаров - Значения для периодов - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM r_ProdCV a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdCV a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Справочник товаров - Значения для периодов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ r_ProdEC - Обновление CHILD */
/* Справочник предприятий ^ Справочник товаров - Значения для предприятий - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM r_ProdEC a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdEC a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Справочник товаров - Значения для предприятий''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_PInP - Обновление CHILD */
/* Справочник предприятий ^ Справочник товаров - Цены прихода Торговли - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_PInP a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_PInP a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Справочник товаров - Цены прихода Торговли''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ r_GOperD - Обновление CHILD */
/* Справочник предприятий ^ Справочник проводок - Проводки - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_CompID = i.CompID
          FROM r_GOperD a, inserted i, deleted d WHERE a.C_CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GOperD a, deleted d WHERE a.C_CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Справочник проводок - Проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ r_GOperD - Обновление CHILD */
/* Справочник предприятий ^ Справочник проводок - Проводки - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_CompID = i.CompID
          FROM r_GOperD a, inserted i, deleted d WHERE a.D_CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GOperD a, deleted d WHERE a.D_CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Справочник проводок - Проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ r_CompMG - Обновление CHILD */
/* Справочник предприятий ^ Справочник предприятий - Участие в группах - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM r_CompMG a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CompMG a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Справочник предприятий - Участие в группах''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ r_CompsAC - Обновление CHILD */
/* Справочник предприятий ^ Справочник предприятий - Валютные счета - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM r_CompsAC a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CompsAC a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Справочник предприятий - Валютные счета''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ r_CompsAdd - Обновление CHILD */
/* Справочник предприятий ^ Справочник предприятий - Адреса - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM r_CompsAdd a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CompsAdd a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Справочник предприятий - Адреса''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ r_CompsCC - Обновление CHILD */
/* Справочник предприятий ^ Справочник предприятий - Расчетные счета - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM r_CompsCC a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CompsCC a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Справочник предприятий - Расчетные счета''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ r_DCards - Обновление CHILD */
/* Справочник предприятий ^ Справочник дисконтных карт - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM r_DCards a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DCards a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Справочник дисконтных карт''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ r_GAccs - Обновление CHILD */
/* Справочник предприятий ^ План счетов - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.A_CompID = i.CompID
          FROM r_GAccs a, inserted i, deleted d WHERE a.A_CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GAccs a, deleted d WHERE a.A_CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''План счетов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_Acc - Обновление CHILD */
/* Справочник предприятий ^ Счет на оплату (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_Acc a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Acc a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Счет на оплату (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_AExp - Обновление CHILD */
/* Справочник предприятий ^ Акт сдачи услуг - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_AExp a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_AExp a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Акт сдачи услуг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_ARec - Обновление CHILD */
/* Справочник предприятий ^ Акт приемки услуг - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_ARec a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARec a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Акт приемки услуг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_ARepA - Обновление CHILD */
/* Справочник предприятий ^ Авансовый отчет валютный (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_ARepA a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepA a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Авансовый отчет валютный (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_CExp - Обновление CHILD */
/* Справочник предприятий ^ Кассовый ордер: Расход - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_CExp a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CExp a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Кассовый ордер: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_CInv - Обновление CHILD */
/* Справочник предприятий ^ ТМЦ: Расход по ГТД (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_CInv a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CInv a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''ТМЦ: Расход по ГТД (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_CRec - Обновление CHILD */
/* Справочник предприятий ^ Кассовый ордер: Приход - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_CRec a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRec a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Кассовый ордер: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_CRepA - Обновление CHILD */
/* Справочник предприятий ^ Авансовый отчет с признаками (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_CRepA a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRepA a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Авансовый отчет с признаками (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_CRet - Обновление CHILD */
/* Справочник предприятий ^ ТМЦ: Возврат поставщику (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_CRet a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRet a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''ТМЦ: Возврат поставщику (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_Cst - Обновление CHILD */
/* Справочник предприятий ^ ТМЦ: Приход по ГТД (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_Cst a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Cst a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''ТМЦ: Приход по ГТД (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_Cst - Обновление CHILD */
/* Справочник предприятий ^ ТМЦ: Приход по ГТД (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CstCompID = i.CompID
          FROM b_Cst a, inserted i, deleted d WHERE a.CstCompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Cst a, deleted d WHERE a.CstCompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''ТМЦ: Приход по ГТД (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_DStack - Обновление CHILD */
/* Справочник предприятий ^ ТМЦ: Суммовой учет - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_DStack a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_DStack a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''ТМЦ: Суммовой учет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_Exp - Обновление CHILD */
/* Справочник предприятий ^ ТМЦ: Внутренний расход (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_Exp a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Exp a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''ТМЦ: Внутренний расход (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_GTranD - Обновление CHILD */
/* Справочник предприятий ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_CompID = i.CompID
          FROM b_GTranD a, inserted i, deleted d WHERE a.C_CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.C_CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_GTranD - Обновление CHILD */
/* Справочник предприятий ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_CompID = i.CompID
          FROM b_GTranD a, inserted i, deleted d WHERE a.D_CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.D_CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_Inv - Обновление CHILD */
/* Справочник предприятий ^ ТМЦ: Расходная накладная (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_Inv a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Inv a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''ТМЦ: Расходная накладная (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_PAcc - Обновление CHILD */
/* Справочник предприятий ^ ТМЦ: Счет на оплату (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_PAcc a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PAcc a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''ТМЦ: Счет на оплату (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_PCost - Обновление CHILD */
/* Справочник предприятий ^ ТМЦ: Формирование себестоимости (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_PCost a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PCost a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''ТМЦ: Формирование себестоимости (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_PExc - Обновление CHILD */
/* Справочник предприятий ^ ТМЦ: Перемещение (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_PExc a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PExc a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''ТМЦ: Перемещение (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_PVen - Обновление CHILD */
/* Справочник предприятий ^ ТМЦ: Инвентаризация (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_PVen a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PVen a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''ТМЦ: Инвентаризация (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_Rec - Обновление CHILD */
/* Справочник предприятий ^ ТМЦ: Приход по накладной (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_Rec a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Rec a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''ТМЦ: Приход по накладной (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_RepA - Обновление CHILD */
/* Справочник предприятий ^ Авансовый отчет (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_RepA a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_RepA a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Авансовый отчет (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_Ret - Обновление CHILD */
/* Справочник предприятий ^ ТМЦ: Возврат от получателя (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_Ret a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Ret a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''ТМЦ: Возврат от получателя (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_SExp - Обновление CHILD */
/* Справочник предприятий ^ Основные средства: Списание (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_SExp a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExp a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Основные средства: Списание (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_SInv - Обновление CHILD */
/* Справочник предприятий ^ Основные средства: Продажа (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_SInv a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SInv a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Основные средства: Продажа (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_SPut - Обновление CHILD */
/* Справочник предприятий ^ Основные средства: Ввод в эксплуатацию (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_SPut a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SPut a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Основные средства: Ввод в эксплуатацию (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_SRec - Обновление CHILD */
/* Справочник предприятий ^ Основные средства: Приход (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_SRec a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRec a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Основные средства: Приход (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_SRep - Обновление CHILD */
/* Справочник предприятий ^ Основные средства: Ремонт (Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_SRep a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRep a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Основные средства: Ремонт (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_TExp - Обновление CHILD */
/* Справочник предприятий ^ Налоговые накладные: Исходящие - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_TExp a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TExp a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Налоговые накладные: Исходящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_TranC - Обновление CHILD */
/* Справочник предприятий ^ Проводка по предприятию - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_TranC a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranC a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Проводка по предприятию''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_TranH - Обновление CHILD */
/* Справочник предприятий ^ Ручные проводки - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_CompID = i.CompID
          FROM b_TranH a, inserted i, deleted d WHERE a.C_CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranH a, deleted d WHERE a.C_CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Ручные проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_TranH - Обновление CHILD */
/* Справочник предприятий ^ Ручные проводки - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_CompID = i.CompID
          FROM b_TranH a, inserted i, deleted d WHERE a.D_CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranH a, deleted d WHERE a.D_CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Ручные проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_TRec - Обновление CHILD */
/* Справочник предприятий ^ Налоговые накладные: Входящие - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_TRec a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TRec a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Налоговые накладные: Входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_zInC - Обновление CHILD */
/* Справочник предприятий ^ Входящий баланс: Предприятия - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM b_zInC a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInC a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Входящий баланс: Предприятия''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_zInH - Обновление CHILD */
/* Справочник предприятий ^ Ручные входящие - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_CompID = i.CompID
          FROM b_zInH a, inserted i, deleted d WHERE a.C_CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInH a, deleted d WHERE a.C_CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Ручные входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ b_zInH - Обновление CHILD */
/* Справочник предприятий ^ Ручные входящие - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_CompID = i.CompID
          FROM b_zInH a, inserted i, deleted d WHERE a.D_CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInH a, deleted d WHERE a.D_CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Ручные входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ p_ETrp - Обновление CHILD */
/* Справочник предприятий ^ Приказ: Командировка - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM p_ETrp a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ETrp a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Приказ: Командировка''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ p_EWri - Обновление CHILD */
/* Справочник предприятий ^ Исполнительный лист - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AddrCompID = i.CompID
          FROM p_EWri a, inserted i, deleted d WHERE a.AddrCompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EWri a, deleted d WHERE a.AddrCompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Исполнительный лист''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_Acc - Обновление CHILD */
/* Справочник предприятий ^ Счет на оплату товара: Заголовок - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_Acc a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Acc a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Счет на оплату товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_Cos - Обновление CHILD */
/* Справочник предприятий ^ Формирование себестоимости: Заголовок - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_Cos a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cos a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Формирование себестоимости: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_CRet - Обновление CHILD */
/* Справочник предприятий ^ Возврат товара поставщику: Заголовок - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_CRet a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRet a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Возврат товара поставщику: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_CRRet - Обновление CHILD */
/* Справочник предприятий ^ Возврат товара по чеку: Заголовок - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_CRRet a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRRet a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Возврат товара по чеку: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_Cst - Обновление CHILD */
/* Справочник предприятий ^ Приход товара по ГТД: Заголовок - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_Cst a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cst a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Приход товара по ГТД: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_Cst2 - Обновление CHILD */
/* Справочник предприятий ^ Приход товара по ГТД (новый)(Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_Cst2 a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cst2 a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Приход товара по ГТД (новый)(Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_Cst2 - Обновление CHILD */
/* Справочник предприятий ^ Приход товара по ГТД (новый)(Заголовок) - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CstCompID = i.CompID
          FROM t_Cst2 a, inserted i, deleted d WHERE a.CstCompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cst2 a, deleted d WHERE a.CstCompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Приход товара по ГТД (новый)(Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_DeskRes - Обновление CHILD */
/* Справочник предприятий ^ Ресторан: Резервирование столиков - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_DeskRes a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_DeskRes a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Ресторан: Резервирование столиков''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_Dis - Обновление CHILD */
/* Справочник предприятий ^ Распределение товара: Заголовок - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_Dis a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Dis a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Распределение товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_EOExp - Обновление CHILD */
/* Справочник предприятий ^ Заказ внешний: Формирование: Заголовок - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_EOExp a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EOExp a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Заказ внешний: Формирование: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_EORec - Обновление CHILD */
/* Справочник предприятий ^ Заказ внешний: Обработка: Заголовок - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_EORec a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EORec a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Заказ внешний: Обработка: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_Epp - Обновление CHILD */
/* Справочник предприятий ^ Расходный документ в ценах прихода: Заголовок - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_Epp a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Epp a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Расходный документ в ценах прихода: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_Est - Обновление CHILD */
/* Справочник предприятий ^ Переоценка цен прихода: Заголовок - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_Est a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Est a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Переоценка цен прихода: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_Exc - Обновление CHILD */
/* Справочник предприятий ^ Перемещение товара: Заголовок - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_Exc a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Exc a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Перемещение товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_Exp - Обновление CHILD */
/* Справочник предприятий ^ Расходный документ: Заголовок - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_Exp a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Exp a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Расходный документ: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_Inv - Обновление CHILD */
/* Справочник предприятий ^ Расходная накладная: Заголовок - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_Inv a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Inv a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Расходная накладная: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_IOExp - Обновление CHILD */
/* Справочник предприятий ^ Заказ внутренний: Обработка: Заголовок - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_IOExp a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_IOExp a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Заказ внутренний: Обработка: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_IORec - Обновление CHILD */
/* Справочник предприятий ^ Заказ внутренний: Формирование: Заголовок - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_IORec a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_IORec a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Заказ внутренний: Формирование: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_MonRec - Обновление CHILD */
/* Справочник предприятий ^ Прием наличных денег на склад - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_MonRec a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_MonRec a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Прием наличных денег на склад''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_Rec - Обновление CHILD */
/* Справочник предприятий ^ Приход товара: Заголовок - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_Rec a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Rec a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Приход товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_Ret - Обновление CHILD */
/* Справочник предприятий ^ Возврат товара от получателя: Заголовок - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_Ret a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Ret a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Возврат товара от получателя: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_Sale - Обновление CHILD */
/* Справочник предприятий ^ Продажа товара оператором: Заголовок - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_Sale a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Sale a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Продажа товара оператором: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ t_Ven - Обновление CHILD */
/* Справочник предприятий ^ Инвентаризация товара: Заголовок - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM t_Ven a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Ven a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Инвентаризация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ z_Contracts - Обновление CHILD */
/* Справочник предприятий ^ Договор - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM z_Contracts a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Contracts a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Договор''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ z_InAcc - Обновление CHILD */
/* Справочник предприятий ^ Входящий счет на оплату - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM z_InAcc a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_InAcc a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Входящий счет на оплату''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ z_UserComps - Обновление CHILD */
/* Справочник предприятий ^ Доступные значения - Справочник предприятий - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID
          FROM z_UserComps a, inserted i, deleted d WHERE a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserComps a, deleted d WHERE a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Доступные значения - Справочник предприятий''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Comps ^ z_Vars - Обновление CHILD */
/* Справочник предприятий ^ Системные переменные - Обновление CHILD */
  IF UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 't_ChequeCompID', a.VarValue = i.CompID
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 't_ChequeCompID' AND a.VarValue = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 't_ChequeCompID' AND a.VarValue = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий'' => ''Системные переменные''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10250001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10250001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(CompID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10250001 AND l.PKValue = 
        '[' + cast(i.CompID as varchar(200)) + ']' AND i.CompID = d.CompID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10250001 AND l.PKValue = 
        '[' + cast(i.CompID as varchar(200)) + ']' AND i.CompID = d.CompID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10250001, ChID, 
          '[' + cast(d.CompID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10250001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10250001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10250001, ChID, 
          '[' + cast(i.CompID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(CompID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CompID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CompID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CompID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10250001 AND l.PKValue = 
          '[' + cast(d.CompID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CompID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10250001 AND l.PKValue = 
          '[' + cast(d.CompID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10250001, ChID, 
          '[' + cast(d.CompID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10250001 AND PKValue IN (SELECT 
          '[' + cast(CompID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10250001 AND PKValue IN (SELECT 
          '[' + cast(CompID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10250001, ChID, 
          '[' + cast(i.CompID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10250001, ChID, 
    '[' + cast(i.CompID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Comps', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Comps] ON [r_Comps]
FOR DELETE AS
/* r_Comps - Справочник предприятий - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Comps ^ b_PInP - Проверка в CHILD */
/* Справочник предприятий ^ Справочник товаров - Цены прихода Бухгалтерии - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PInP a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_PInP', 3
      RETURN
    END

/* r_Comps ^ r_ProdCV - Проверка в CHILD */
/* Справочник предприятий ^ Справочник товаров - Значения для периодов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ProdCV a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'r_ProdCV', 3
      RETURN
    END

/* r_Comps ^ r_ProdEC - Проверка в CHILD */
/* Справочник предприятий ^ Справочник товаров - Значения для предприятий - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ProdEC a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'r_ProdEC', 3
      RETURN
    END

/* r_Comps ^ t_PInP - Проверка в CHILD */
/* Справочник предприятий ^ Справочник товаров - Цены прихода Торговли - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_PInP a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_PInP', 3
      RETURN
    END

/* r_Comps ^ r_GOperD - Проверка в CHILD */
/* Справочник предприятий ^ Справочник проводок - Проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GOperD a WITH(NOLOCK), deleted d WHERE a.C_CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'r_GOperD', 3
      RETURN
    END

/* r_Comps ^ r_GOperD - Проверка в CHILD */
/* Справочник предприятий ^ Справочник проводок - Проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GOperD a WITH(NOLOCK), deleted d WHERE a.D_CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'r_GOperD', 3
      RETURN
    END

/* r_Comps ^ r_CompMG - Удаление в CHILD */
/* Справочник предприятий ^ Справочник предприятий - Участие в группах - Удаление в CHILD */
  DELETE r_CompMG FROM r_CompMG a, deleted d WHERE a.CompID = d.CompID
  IF @@ERROR > 0 RETURN

/* r_Comps ^ r_CompsAC - Удаление в CHILD */
/* Справочник предприятий ^ Справочник предприятий - Валютные счета - Удаление в CHILD */
  DELETE r_CompsAC FROM r_CompsAC a, deleted d WHERE a.CompID = d.CompID
  IF @@ERROR > 0 RETURN

/* r_Comps ^ r_CompsAdd - Удаление в CHILD */
/* Справочник предприятий ^ Справочник предприятий - Адреса - Удаление в CHILD */
  DELETE r_CompsAdd FROM r_CompsAdd a, deleted d WHERE a.CompID = d.CompID
  IF @@ERROR > 0 RETURN

/* r_Comps ^ r_CompsCC - Удаление в CHILD */
/* Справочник предприятий ^ Справочник предприятий - Расчетные счета - Удаление в CHILD */
  DELETE r_CompsCC FROM r_CompsCC a, deleted d WHERE a.CompID = d.CompID
  IF @@ERROR > 0 RETURN

/* r_Comps ^ r_DCards - Проверка в CHILD */
/* Справочник предприятий ^ Справочник дисконтных карт - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_DCards a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'r_DCards', 3
      RETURN
    END

/* r_Comps ^ r_GAccs - Проверка в CHILD */
/* Справочник предприятий ^ План счетов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GAccs a WITH(NOLOCK), deleted d WHERE a.A_CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'r_GAccs', 3
      RETURN
    END

/* r_Comps ^ b_Acc - Проверка в CHILD */
/* Справочник предприятий ^ Счет на оплату (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Acc a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_Acc', 3
      RETURN
    END

/* r_Comps ^ b_AExp - Проверка в CHILD */
/* Справочник предприятий ^ Акт сдачи услуг - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_AExp a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_AExp', 3
      RETURN
    END

/* r_Comps ^ b_ARec - Проверка в CHILD */
/* Справочник предприятий ^ Акт приемки услуг - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARec a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_ARec', 3
      RETURN
    END

/* r_Comps ^ b_ARepA - Проверка в CHILD */
/* Справочник предприятий ^ Авансовый отчет валютный (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepA a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_ARepA', 3
      RETURN
    END

/* r_Comps ^ b_CExp - Проверка в CHILD */
/* Справочник предприятий ^ Кассовый ордер: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CExp a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_CExp', 3
      RETURN
    END

/* r_Comps ^ b_CInv - Проверка в CHILD */
/* Справочник предприятий ^ ТМЦ: Расход по ГТД (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CInv a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_CInv', 3
      RETURN
    END

/* r_Comps ^ b_CRec - Проверка в CHILD */
/* Справочник предприятий ^ Кассовый ордер: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRec a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_CRec', 3
      RETURN
    END

/* r_Comps ^ b_CRepA - Проверка в CHILD */
/* Справочник предприятий ^ Авансовый отчет с признаками (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRepA a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_CRepA', 3
      RETURN
    END

/* r_Comps ^ b_CRet - Проверка в CHILD */
/* Справочник предприятий ^ ТМЦ: Возврат поставщику (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRet a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_CRet', 3
      RETURN
    END

/* r_Comps ^ b_Cst - Проверка в CHILD */
/* Справочник предприятий ^ ТМЦ: Приход по ГТД (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Cst a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_Cst', 3
      RETURN
    END

/* r_Comps ^ b_Cst - Проверка в CHILD */
/* Справочник предприятий ^ ТМЦ: Приход по ГТД (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Cst a WITH(NOLOCK), deleted d WHERE a.CstCompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_Cst', 3
      RETURN
    END

/* r_Comps ^ b_DStack - Проверка в CHILD */
/* Справочник предприятий ^ ТМЦ: Суммовой учет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_DStack a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_DStack', 3
      RETURN
    END

/* r_Comps ^ b_Exp - Проверка в CHILD */
/* Справочник предприятий ^ ТМЦ: Внутренний расход (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Exp a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_Exp', 3
      RETURN
    END

/* r_Comps ^ b_GTranD - Проверка в CHILD */
/* Справочник предприятий ^ Таблица проводок (Проводки) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTranD a WITH(NOLOCK), deleted d WHERE a.C_CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_GTranD', 3
      RETURN
    END

/* r_Comps ^ b_GTranD - Проверка в CHILD */
/* Справочник предприятий ^ Таблица проводок (Проводки) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTranD a WITH(NOLOCK), deleted d WHERE a.D_CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_GTranD', 3
      RETURN
    END

/* r_Comps ^ b_Inv - Проверка в CHILD */
/* Справочник предприятий ^ ТМЦ: Расходная накладная (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Inv a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_Inv', 3
      RETURN
    END

/* r_Comps ^ b_PAcc - Проверка в CHILD */
/* Справочник предприятий ^ ТМЦ: Счет на оплату (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PAcc a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_PAcc', 3
      RETURN
    END

/* r_Comps ^ b_PCost - Проверка в CHILD */
/* Справочник предприятий ^ ТМЦ: Формирование себестоимости (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PCost a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_PCost', 3
      RETURN
    END

/* r_Comps ^ b_PExc - Проверка в CHILD */
/* Справочник предприятий ^ ТМЦ: Перемещение (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PExc a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_PExc', 3
      RETURN
    END

/* r_Comps ^ b_PVen - Проверка в CHILD */
/* Справочник предприятий ^ ТМЦ: Инвентаризация (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PVen a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_PVen', 3
      RETURN
    END

/* r_Comps ^ b_Rec - Проверка в CHILD */
/* Справочник предприятий ^ ТМЦ: Приход по накладной (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Rec a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_Rec', 3
      RETURN
    END

/* r_Comps ^ b_RepA - Проверка в CHILD */
/* Справочник предприятий ^ Авансовый отчет (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_RepA a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_RepA', 3
      RETURN
    END

/* r_Comps ^ b_Ret - Проверка в CHILD */
/* Справочник предприятий ^ ТМЦ: Возврат от получателя (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Ret a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_Ret', 3
      RETURN
    END

/* r_Comps ^ b_SExp - Проверка в CHILD */
/* Справочник предприятий ^ Основные средства: Списание (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExp a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_SExp', 3
      RETURN
    END

/* r_Comps ^ b_SInv - Проверка в CHILD */
/* Справочник предприятий ^ Основные средства: Продажа (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SInv a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_SInv', 3
      RETURN
    END

/* r_Comps ^ b_SPut - Проверка в CHILD */
/* Справочник предприятий ^ Основные средства: Ввод в эксплуатацию (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SPut a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_SPut', 3
      RETURN
    END

/* r_Comps ^ b_SRec - Проверка в CHILD */
/* Справочник предприятий ^ Основные средства: Приход (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRec a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_SRec', 3
      RETURN
    END

/* r_Comps ^ b_SRep - Проверка в CHILD */
/* Справочник предприятий ^ Основные средства: Ремонт (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRep a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_SRep', 3
      RETURN
    END

/* r_Comps ^ b_TExp - Проверка в CHILD */
/* Справочник предприятий ^ Налоговые накладные: Исходящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TExp a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_TExp', 3
      RETURN
    END

/* r_Comps ^ b_TranC - Проверка в CHILD */
/* Справочник предприятий ^ Проводка по предприятию - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranC a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_TranC', 3
      RETURN
    END

/* r_Comps ^ b_TranH - Проверка в CHILD */
/* Справочник предприятий ^ Ручные проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranH a WITH(NOLOCK), deleted d WHERE a.C_CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_TranH', 3
      RETURN
    END

/* r_Comps ^ b_TranH - Проверка в CHILD */
/* Справочник предприятий ^ Ручные проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranH a WITH(NOLOCK), deleted d WHERE a.D_CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_TranH', 3
      RETURN
    END

/* r_Comps ^ b_TRec - Проверка в CHILD */
/* Справочник предприятий ^ Налоговые накладные: Входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TRec a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_TRec', 3
      RETURN
    END

/* r_Comps ^ b_zInC - Проверка в CHILD */
/* Справочник предприятий ^ Входящий баланс: Предприятия - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInC a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_zInC', 3
      RETURN
    END

/* r_Comps ^ b_zInH - Проверка в CHILD */
/* Справочник предприятий ^ Ручные входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInH a WITH(NOLOCK), deleted d WHERE a.C_CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_zInH', 3
      RETURN
    END

/* r_Comps ^ b_zInH - Проверка в CHILD */
/* Справочник предприятий ^ Ручные входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInH a WITH(NOLOCK), deleted d WHERE a.D_CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_zInH', 3
      RETURN
    END

/* r_Comps ^ p_ETrp - Проверка в CHILD */
/* Справочник предприятий ^ Приказ: Командировка - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ETrp a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'p_ETrp', 3
      RETURN
    END

/* r_Comps ^ p_EWri - Проверка в CHILD */
/* Справочник предприятий ^ Исполнительный лист - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EWri a WITH(NOLOCK), deleted d WHERE a.AddrCompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'p_EWri', 3
      RETURN
    END

/* r_Comps ^ t_Acc - Проверка в CHILD */
/* Справочник предприятий ^ Счет на оплату товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Acc a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Acc', 3
      RETURN
    END

/* r_Comps ^ t_Cos - Проверка в CHILD */
/* Справочник предприятий ^ Формирование себестоимости: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cos a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Cos', 3
      RETURN
    END

/* r_Comps ^ t_CRet - Проверка в CHILD */
/* Справочник предприятий ^ Возврат товара поставщику: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRet a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_CRet', 3
      RETURN
    END

/* r_Comps ^ t_CRRet - Проверка в CHILD */
/* Справочник предприятий ^ Возврат товара по чеку: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRRet a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_CRRet', 3
      RETURN
    END

/* r_Comps ^ t_Cst - Проверка в CHILD */
/* Справочник предприятий ^ Приход товара по ГТД: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cst a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Cst', 3
      RETURN
    END

/* r_Comps ^ t_Cst2 - Проверка в CHILD */
/* Справочник предприятий ^ Приход товара по ГТД (новый)(Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cst2 a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Cst2', 3
      RETURN
    END

/* r_Comps ^ t_Cst2 - Проверка в CHILD */
/* Справочник предприятий ^ Приход товара по ГТД (новый)(Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cst2 a WITH(NOLOCK), deleted d WHERE a.CstCompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Cst2', 3
      RETURN
    END

/* r_Comps ^ t_DeskRes - Проверка в CHILD */
/* Справочник предприятий ^ Ресторан: Резервирование столиков - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_DeskRes a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_DeskRes', 3
      RETURN
    END

/* r_Comps ^ t_Dis - Проверка в CHILD */
/* Справочник предприятий ^ Распределение товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Dis a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Dis', 3
      RETURN
    END

/* r_Comps ^ t_EOExp - Проверка в CHILD */
/* Справочник предприятий ^ Заказ внешний: Формирование: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EOExp a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_EOExp', 3
      RETURN
    END

/* r_Comps ^ t_EORec - Проверка в CHILD */
/* Справочник предприятий ^ Заказ внешний: Обработка: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EORec a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_EORec', 3
      RETURN
    END

/* r_Comps ^ t_Epp - Проверка в CHILD */
/* Справочник предприятий ^ Расходный документ в ценах прихода: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Epp a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Epp', 3
      RETURN
    END

/* r_Comps ^ t_Est - Проверка в CHILD */
/* Справочник предприятий ^ Переоценка цен прихода: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Est a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Est', 3
      RETURN
    END

/* r_Comps ^ t_Exc - Проверка в CHILD */
/* Справочник предприятий ^ Перемещение товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Exc a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Exc', 3
      RETURN
    END

/* r_Comps ^ t_Exp - Проверка в CHILD */
/* Справочник предприятий ^ Расходный документ: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Exp a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Exp', 3
      RETURN
    END

/* r_Comps ^ t_Inv - Проверка в CHILD */
/* Справочник предприятий ^ Расходная накладная: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Inv a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Inv', 3
      RETURN
    END

/* r_Comps ^ t_IOExp - Проверка в CHILD */
/* Справочник предприятий ^ Заказ внутренний: Обработка: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_IOExp a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_IOExp', 3
      RETURN
    END

/* r_Comps ^ t_IORec - Проверка в CHILD */
/* Справочник предприятий ^ Заказ внутренний: Формирование: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_IORec a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_IORec', 3
      RETURN
    END

/* r_Comps ^ t_MonRec - Проверка в CHILD */
/* Справочник предприятий ^ Прием наличных денег на склад - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_MonRec a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_MonRec', 3
      RETURN
    END

/* r_Comps ^ t_Rec - Проверка в CHILD */
/* Справочник предприятий ^ Приход товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Rec a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Rec', 3
      RETURN
    END

/* r_Comps ^ t_Ret - Проверка в CHILD */
/* Справочник предприятий ^ Возврат товара от получателя: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Ret a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Ret', 3
      RETURN
    END

/* r_Comps ^ t_Sale - Проверка в CHILD */
/* Справочник предприятий ^ Продажа товара оператором: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Sale a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Sale', 3
      RETURN
    END

/* r_Comps ^ t_Ven - Проверка в CHILD */
/* Справочник предприятий ^ Инвентаризация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Ven a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Ven', 3
      RETURN
    END

/* r_Comps ^ z_Contracts - Проверка в CHILD */
/* Справочник предприятий ^ Договор - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Contracts a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'z_Contracts', 3
      RETURN
    END

/* r_Comps ^ z_InAcc - Проверка в CHILD */
/* Справочник предприятий ^ Входящий счет на оплату - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_InAcc a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'z_InAcc', 3
      RETURN
    END

/* r_Comps ^ z_UserComps - Удаление в CHILD */
/* Справочник предприятий ^ Доступные значения - Справочник предприятий - Удаление в CHILD */
  DELETE z_UserComps FROM z_UserComps a, deleted d WHERE a.CompID = d.CompID
  IF @@ERROR > 0 RETURN

/* r_Comps ^ z_Vars - Проверка в CHILD */
/* Справочник предприятий ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 't_ChequeCompID' AND a.VarValue = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_Comps', 'z_Vars', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10250001 AND m.PKValue = 
    '[' + cast(i.CompID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10250001 AND m.PKValue = 
    '[' + cast(i.CompID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10250001, -ChID, 
    '[' + cast(d.CompID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10250 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Comps', N'Last', N'DELETE'
GO