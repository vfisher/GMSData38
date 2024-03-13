CREATE TABLE [dbo].[r_GOperD]
(
[GOperID] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[EExp] [varchar] (4000) NOT NULL,
[LExp] [varchar] (4000) NOT NULL,
[EExpQty] [varchar] (4000) NULL,
[LExpQty] [varchar] (4000) NULL,
[D_GAccRExp] [varchar] (255) NOT NULL,
[D_GAccEExp] [varchar] (255) NOT NULL,
[C_GAccRExp] [varchar] (255) NOT NULL,
[C_GAccEExp] [varchar] (255) NOT NULL,
[Notes] [varchar] (200) NULL,
[InCC] [bit] NOT NULL,
[D_IncQty] [bit] NOT NULL,
[D_AddQty] [bit] NOT NULL,
[C_IncQty] [bit] NOT NULL,
[C_AddQty] [bit] NOT NULL,
[D_CompID] [int] NOT NULL,
[D_EmpID] [int] NOT NULL,
[D_CodeID1] [smallint] NOT NULL,
[D_CodeID2] [smallint] NOT NULL,
[D_CodeID3] [smallint] NOT NULL,
[D_CodeID4] [smallint] NOT NULL,
[D_CodeID5] [smallint] NOT NULL,
[D_StockID] [int] NOT NULL,
[D_ProdID] [int] NOT NULL,
[D_AssID] [int] NOT NULL,
[D_VolID] [int] NOT NULL,
[C_CompID] [int] NOT NULL,
[C_EmpID] [int] NOT NULL,
[C_CodeID1] [smallint] NOT NULL,
[C_CodeID2] [smallint] NOT NULL,
[C_CodeID3] [smallint] NOT NULL,
[C_CodeID4] [smallint] NOT NULL,
[C_CodeID5] [smallint] NOT NULL,
[C_StockID] [int] NOT NULL,
[C_ProdID] [int] NOT NULL,
[C_AssID] [int] NOT NULL,
[C_VolID] [int] NOT NULL,
[D_CompVol] [tinyint] NOT NULL,
[D_EmpVol] [tinyint] NOT NULL,
[D_CodeVol1] [tinyint] NOT NULL,
[D_CodeVol2] [tinyint] NOT NULL,
[D_CodeVol3] [tinyint] NOT NULL,
[D_CodeVol4] [tinyint] NOT NULL,
[D_CodeVol5] [tinyint] NOT NULL,
[D_StockVol] [tinyint] NOT NULL,
[D_ProdVol] [tinyint] NOT NULL,
[D_AssVol] [tinyint] NOT NULL,
[D_VolVol] [tinyint] NOT NULL,
[C_CompVol] [tinyint] NOT NULL,
[C_EmpVol] [tinyint] NOT NULL,
[C_CodeVol1] [tinyint] NOT NULL,
[C_CodeVol2] [tinyint] NOT NULL,
[C_CodeVol3] [tinyint] NOT NULL,
[C_CodeVol4] [tinyint] NOT NULL,
[C_CodeVol5] [tinyint] NOT NULL,
[C_StockVol] [tinyint] NOT NULL,
[C_ProdVol] [tinyint] NOT NULL,
[C_AssVol] [tinyint] NOT NULL,
[C_VolVol] [tinyint] NOT NULL,
[ConductQty] [bit] NOT NULL,
[D_GrndLinkID] [int] NOT NULL DEFAULT (0),
[C_GrndLinkID] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_GOperD] ON [dbo].[r_GOperD]
FOR INSERT AS
/* r_GOperD - Справочник проводок - Проводки - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_GOperD ^ r_Assets - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник основных средств - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_AssID NOT IN (SELECT AssID FROM r_Assets))
    BEGIN
      EXEC z_RelationError 'r_Assets', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_Assets - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник основных средств - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_AssID NOT IN (SELECT AssID FROM r_Assets))
    BEGIN
      EXEC z_RelationError 'r_Assets', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_Codes1 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_Codes1 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_Codes2 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_Codes2 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_Codes3 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_Codes3 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_Codes4 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_Codes4 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_Codes5 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_Codes5 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_Comps - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_Comps - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_Emps - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_Emps - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_GOpers - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_GVols - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник проводок: виды аналитики - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_VolID NOT IN (SELECT GVolID FROM r_GVols))
    BEGIN
      EXEC z_RelationError 'r_GVols', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_GVols - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник проводок: виды аналитики - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_VolID NOT IN (SELECT GVolID FROM r_GVols))
    BEGIN
      EXEC z_RelationError 'r_GVols', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_Prods - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_Prods - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_Stocks - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'r_GOperD', 0
      RETURN
    END

/* r_GOperD ^ r_Stocks - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'r_GOperD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10708002, m.ChID, 
    '[' + cast(i.GOperID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_GOpers m ON m.GOperID = i.GOperID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_GOperD]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_GOperD] ON [dbo].[r_GOperD]
FOR UPDATE AS
/* r_GOperD - Справочник проводок - Проводки - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_GOperD ^ r_Assets - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник основных средств - Проверка в PARENT */
  IF UPDATE(C_AssID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_AssID NOT IN (SELECT AssID FROM r_Assets))
      BEGIN
        EXEC z_RelationError 'r_Assets', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_Assets - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник основных средств - Проверка в PARENT */
  IF UPDATE(D_AssID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_AssID NOT IN (SELECT AssID FROM r_Assets))
      BEGIN
        EXEC z_RelationError 'r_Assets', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_Codes1 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(C_CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_Codes1 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(D_CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_Codes2 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(C_CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_Codes2 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(D_CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_Codes3 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(C_CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_Codes3 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(D_CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_Codes4 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(C_CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_Codes4 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(D_CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_Codes5 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(C_CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_Codes5 - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(D_CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_Comps - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(C_CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_Comps - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(D_CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_Emps - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(C_EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_Emps - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(D_EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_GOpers - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_GVols - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник проводок: виды аналитики - Проверка в PARENT */
  IF UPDATE(C_VolID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_VolID NOT IN (SELECT GVolID FROM r_GVols))
      BEGIN
        EXEC z_RelationError 'r_GVols', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_GVols - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник проводок: виды аналитики - Проверка в PARENT */
  IF UPDATE(D_VolID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_VolID NOT IN (SELECT GVolID FROM r_GVols))
      BEGIN
        EXEC z_RelationError 'r_GVols', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_Prods - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(C_ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_Prods - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(D_ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_Stocks - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(C_StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'r_GOperD', 1
        RETURN
      END

/* r_GOperD ^ r_Stocks - Проверка в PARENT */
/* Справочник проводок - Проводки ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(D_StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'r_GOperD', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldGOperID int, @NewGOperID int
  DECLARE @OldSrcPosID int, @NewSrcPosID int

/* r_GOperD ^ r_GOperFC - Обновление CHILD */
/* Справочник проводок - Проводки ^ Справочник проводок - Формулы аналитики Кредит - Обновление CHILD */
  IF UPDATE(GOperID) OR UPDATE(SrcPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID, a.SrcPosID = i.SrcPosID
          FROM r_GOperFC a, inserted i, deleted d WHERE a.GOperID = d.GOperID AND a.SrcPosID = d.SrcPosID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(SrcPosID) AND (SELECT COUNT(DISTINCT GOperID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT GOperID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldGOperID = GOperID FROM deleted
          SELECT TOP 1 @NewGOperID = GOperID FROM inserted
          UPDATE r_GOperFC SET r_GOperFC.GOperID = @NewGOperID FROM r_GOperFC, deleted d WHERE r_GOperFC.GOperID = @OldGOperID AND r_GOperFC.SrcPosID = d.SrcPosID
        END
      ELSE IF NOT UPDATE(GOperID) AND (SELECT COUNT(DISTINCT SrcPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT SrcPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldSrcPosID = SrcPosID FROM deleted
          SELECT TOP 1 @NewSrcPosID = SrcPosID FROM inserted
          UPDATE r_GOperFC SET r_GOperFC.SrcPosID = @NewSrcPosID FROM r_GOperFC, deleted d WHERE r_GOperFC.SrcPosID = @OldSrcPosID AND r_GOperFC.GOperID = d.GOperID
        END
      ELSE IF EXISTS (SELECT * FROM r_GOperFC a, deleted d WHERE a.GOperID = d.GOperID AND a.SrcPosID = d.SrcPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок - Проводки'' => ''Справочник проводок - Формулы аналитики Кредит''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOperD ^ r_GOperFD - Обновление CHILD */
/* Справочник проводок - Проводки ^ Справочник проводок - Формулы аналитики Дебет - Обновление CHILD */
  IF UPDATE(GOperID) OR UPDATE(SrcPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID, a.SrcPosID = i.SrcPosID
          FROM r_GOperFD a, inserted i, deleted d WHERE a.GOperID = d.GOperID AND a.SrcPosID = d.SrcPosID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(SrcPosID) AND (SELECT COUNT(DISTINCT GOperID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT GOperID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldGOperID = GOperID FROM deleted
          SELECT TOP 1 @NewGOperID = GOperID FROM inserted
          UPDATE r_GOperFD SET r_GOperFD.GOperID = @NewGOperID FROM r_GOperFD, deleted d WHERE r_GOperFD.GOperID = @OldGOperID AND r_GOperFD.SrcPosID = d.SrcPosID
        END
      ELSE IF NOT UPDATE(GOperID) AND (SELECT COUNT(DISTINCT SrcPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT SrcPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldSrcPosID = SrcPosID FROM deleted
          SELECT TOP 1 @NewSrcPosID = SrcPosID FROM inserted
          UPDATE r_GOperFD SET r_GOperFD.SrcPosID = @NewSrcPosID FROM r_GOperFD, deleted d WHERE r_GOperFD.SrcPosID = @OldSrcPosID AND r_GOperFD.GOperID = d.GOperID
        END
      ELSE IF EXISTS (SELECT * FROM r_GOperFD a, deleted d WHERE a.GOperID = d.GOperID AND a.SrcPosID = d.SrcPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок - Проводки'' => ''Справочник проводок - Формулы аналитики Дебет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(GOperID) OR UPDATE(SrcPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT GOperID, SrcPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT GOperID, SrcPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.GOperID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10708002 AND l.PKValue = 
          '[' + cast(d.GOperID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.GOperID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10708002 AND l.PKValue = 
          '[' + cast(d.GOperID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10708002, m.ChID, 
          '[' + cast(d.GOperID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_GOpers m ON m.GOperID = d.GOperID
          DELETE FROM z_LogCreate WHERE TableCode = 10708002 AND PKValue IN (SELECT 
          '[' + cast(GOperID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10708002 AND PKValue IN (SELECT 
          '[' + cast(GOperID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10708002, m.ChID, 
          '[' + cast(i.GOperID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_GOpers m ON m.GOperID = i.GOperID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10708002, m.ChID, 
    '[' + cast(i.GOperID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_GOpers m ON m.GOperID = i.GOperID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_GOperD]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_GOperD] ON [dbo].[r_GOperD]
FOR DELETE AS
/* r_GOperD - Справочник проводок - Проводки - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_GOperD ^ r_GOperFC - Удаление в CHILD */
/* Справочник проводок - Проводки ^ Справочник проводок - Формулы аналитики Кредит - Удаление в CHILD */
  DELETE r_GOperFC FROM r_GOperFC a, deleted d WHERE a.GOperID = d.GOperID AND a.SrcPosID = d.SrcPosID
  IF @@ERROR > 0 RETURN

/* r_GOperD ^ r_GOperFD - Удаление в CHILD */
/* Справочник проводок - Проводки ^ Справочник проводок - Формулы аналитики Дебет - Удаление в CHILD */
  DELETE r_GOperFD FROM r_GOperFD a, deleted d WHERE a.GOperID = d.GOperID AND a.SrcPosID = d.SrcPosID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10708002 AND m.PKValue = 
    '[' + cast(i.GOperID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10708002 AND m.PKValue = 
    '[' + cast(i.GOperID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10708002, m.ChID, 
    '[' + cast(d.GOperID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_GOpers m ON m.GOperID = d.GOperID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_GOperD]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_GOperD] ADD CONSTRAINT [_pk_r_GOperD] PRIMARY KEY CLUSTERED ([GOperID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_AssID] ON [dbo].[r_GOperD] ([C_AssID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID1] ON [dbo].[r_GOperD] ([C_CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID2] ON [dbo].[r_GOperD] ([C_CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID3] ON [dbo].[r_GOperD] ([C_CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID4] ON [dbo].[r_GOperD] ([C_CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID5] ON [dbo].[r_GOperD] ([C_CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CompID] ON [dbo].[r_GOperD] ([C_CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_EmpID] ON [dbo].[r_GOperD] ([C_EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_GAccEExp] ON [dbo].[r_GOperD] ([C_GAccEExp]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_GAccRExp] ON [dbo].[r_GOperD] ([C_GAccRExp]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_ProdID] ON [dbo].[r_GOperD] ([C_ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_StockID] ON [dbo].[r_GOperD] ([C_StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_VolID] ON [dbo].[r_GOperD] ([C_VolID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_AssID] ON [dbo].[r_GOperD] ([D_AssID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID1] ON [dbo].[r_GOperD] ([D_CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID2] ON [dbo].[r_GOperD] ([D_CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID3] ON [dbo].[r_GOperD] ([D_CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID4] ON [dbo].[r_GOperD] ([D_CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID5] ON [dbo].[r_GOperD] ([D_CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CompID] ON [dbo].[r_GOperD] ([D_CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_EmpID] ON [dbo].[r_GOperD] ([D_EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_GAccEExp] ON [dbo].[r_GOperD] ([D_GAccEExp]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_GAccRExp] ON [dbo].[r_GOperD] ([D_GAccRExp]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_ProdID] ON [dbo].[r_GOperD] ([D_ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_StockID] ON [dbo].[r_GOperD] ([D_StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_VolID] ON [dbo].[r_GOperD] ([D_VolID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[r_GOperD] ([GOperID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[InCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_IncQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_AddQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_IncQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_AddQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_VolID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_VolID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CompVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_EmpVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeVol1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeVol2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeVol3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeVol4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeVol5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_StockVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_ProdVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_AssVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_VolVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CompVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_EmpVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeVol1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeVol2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeVol3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeVol4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeVol5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_StockVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_ProdVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_AssVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_VolVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[ConductQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[InCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_IncQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_AddQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_IncQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_AddQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_VolID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_VolID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CompVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_EmpVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeVol1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeVol2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeVol3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeVol4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeVol5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_StockVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_ProdVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_AssVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_VolVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CompVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_EmpVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeVol1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeVol2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeVol3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeVol4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeVol5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_StockVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_ProdVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_AssVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_VolVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[ConductQty]'
GO
