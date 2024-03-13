CREATE TABLE [dbo].[t_SaleTempD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[UM] [varchar] (50) NULL,
[Qty] [numeric] (21, 9) NULL,
[RealQty] [numeric] (21, 9) NULL,
[PriceCC_wt] [numeric] (21, 9) NULL,
[SumCC_wt] [numeric] (21, 9) NULL,
[PurPriceCC_wt] [numeric] (21, 9) NULL,
[PurSumCC_wt] [numeric] (21, 9) NULL,
[BarCode] [varchar] (42) NULL,
[RealBarCode] [varchar] (42) NOT NULL,
[PLID] [int] NOT NULL,
[UseToBarQty] [int] NULL,
[PosStatus] [int] NOT NULL,
[ServingTime] [smalldatetime] NULL,
[CSrcPosID] [int] NOT NULL,
[ServingID] [int] NOT NULL DEFAULT (0),
[CReasonID] [int] NOT NULL DEFAULT (0),
[PrintTime] [datetime] NULL,
[CanEditQty] [bit] NOT NULL DEFAULT (1),
[EmpID] [int] NOT NULL DEFAULT (0),
[EmpName] [varchar] (250) NULL,
[CreateTime] [datetime] NOT NULL DEFAULT (getdate()),
[ModifyTime] [datetime] NOT NULL DEFAULT (getdate()),
[TaxTypeID] [int] NOT NULL DEFAULT ((0)),
[AllowZeroPrice] [bit] NOT NULL DEFAULT ((0)),
[MarkCode] [int] NULL DEFAULT ((0)),
[LevyMark] [varchar] (20) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TGMSRel2_Upd_t_SaleTempD] ON [dbo].[t_SaleTempD]
FOR UPDATE AS
/* t_SaleTempD - Временные данные продаж: Товар - UPDATE TRIGGER */
BEGIN
  SET NOCOUNT ON

  /* Временные данные продаж: Товар ^ Заявки: подробно - Обновление CHILD */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    IF EXISTS(SELECT TOP 1 1 FROM t_Booking m ,t_BookingD a, deleted d WHERE m.ChID = a.ChID AND m.DocCode = 1011 AND m.DocChID = d.ChID AND a.DetSrcPosID = d.SrcPosID)
      EXEC z_RelationError 't_SaleTempD', 't_BookingD', 2
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TGMSRel3_Del_t_SaleTempD] ON [dbo].[t_SaleTempD]
FOR DELETE AS
/* t_SaleTempD - Временные данные продаж: Товар - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

  /* t_SaleTempD ^ t_BookingD - Удаление в CHILD */
  /* Временные данные продаж: Товар ^ Заявки: подробно - Удаление в CHILD */
  DELETE t_BookingD FROM t_Booking m, t_BookingD a, deleted d 
  WHERE m.DocChID = d.ChID AND m.DocCode = 1011 AND m.ChID = a.ChID AND a.DetSrcPosID = d.SrcPosID 

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_SaleTempD] ON [dbo].[t_SaleTempD]
FOR INSERT AS
/* t_SaleTempD - Временные данные продаж: Товар - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_SaleTempD ^ r_Emps - Проверка в PARENT */
/* Временные данные продаж: Товар ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_SaleTempD', 0
      RETURN
    END

/* t_SaleTempD ^ r_ProdMarks - Проверка в PARENT */
/* Временные данные продаж: Товар ^ Справочник товаров: маркировки - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.MarkCode IS NOT NULL AND i.MarkCode NOT IN (SELECT MarkCode FROM r_ProdMarks))
    BEGIN
      EXEC z_RelationError 'r_ProdMarks', 't_SaleTempD', 0
      RETURN
    END

/* t_SaleTempD ^ r_Taxes - Проверка в PARENT */
/* Временные данные продаж: Товар ^ Справочник НДС - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TaxTypeID NOT IN (SELECT TaxTypeID FROM r_Taxes))
    BEGIN
      EXEC z_RelationError 'r_Taxes', 't_SaleTempD', 0
      RETURN
    END

/* t_SaleTempD ^ t_SaleTemp - Проверка в PARENT */
/* Временные данные продаж: Товар ^ Временные данные продаж: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_SaleTemp))
    BEGIN
      EXEC z_RelationError 't_SaleTemp', 't_SaleTempD', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_t_SaleTempD]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_SaleTempD] ON [dbo].[t_SaleTempD]
FOR UPDATE AS
/* t_SaleTempD - Временные данные продаж: Товар - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_SaleTempD ^ r_Emps - Проверка в PARENT */
/* Временные данные продаж: Товар ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 't_SaleTempD', 1
        RETURN
      END

/* t_SaleTempD ^ r_ProdMarks - Проверка в PARENT */
/* Временные данные продаж: Товар ^ Справочник товаров: маркировки - Проверка в PARENT */
  IF UPDATE(MarkCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.MarkCode IS NOT NULL AND i.MarkCode NOT IN (SELECT MarkCode FROM r_ProdMarks))
      BEGIN
        EXEC z_RelationError 'r_ProdMarks', 't_SaleTempD', 1
        RETURN
      END

/* t_SaleTempD ^ r_Taxes - Проверка в PARENT */
/* Временные данные продаж: Товар ^ Справочник НДС - Проверка в PARENT */
  IF UPDATE(TaxTypeID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TaxTypeID NOT IN (SELECT TaxTypeID FROM r_Taxes))
      BEGIN
        EXEC z_RelationError 'r_Taxes', 't_SaleTempD', 1
        RETURN
      END

/* t_SaleTempD ^ t_SaleTemp - Проверка в PARENT */
/* Временные данные продаж: Товар ^ Временные данные продаж: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_SaleTemp))
      BEGIN
        EXEC z_RelationError 't_SaleTemp', 't_SaleTempD', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldChID bigint, @NewChID bigint
  DECLARE @OldSrcPosID int, @NewSrcPosID int

/* t_SaleTempD ^ t_SaleTempM - Обновление CHILD */
/* Временные данные продаж: Товар ^ Временные данные продаж: Модификаторы - Обновление CHILD */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.SrcPosID = i.SrcPosID
          FROM t_SaleTempM a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(SrcPosID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE t_SaleTempM SET t_SaleTempM.ChID = @NewChID FROM t_SaleTempM, deleted d WHERE t_SaleTempM.ChID = @OldChID AND t_SaleTempM.SrcPosID = d.SrcPosID
        END
      ELSE IF NOT UPDATE(ChID) AND (SELECT COUNT(DISTINCT SrcPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT SrcPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldSrcPosID = SrcPosID FROM deleted
          SELECT TOP 1 @NewSrcPosID = SrcPosID FROM inserted
          UPDATE t_SaleTempM SET t_SaleTempM.SrcPosID = @NewSrcPosID FROM t_SaleTempM, deleted d WHERE t_SaleTempM.SrcPosID = @OldSrcPosID AND t_SaleTempM.ChID = d.ChID
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleTempM a, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Временные данные продаж: Товар'' => ''Временные данные продаж: Модификаторы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_t_SaleTempD]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_SaleTempD] ON [dbo].[t_SaleTempD]FOR DELETE AS/* t_SaleTempD - Временные данные продаж: Товар - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* t_SaleTempD ^ t_SaleTempM - Удаление в CHILD *//* Временные данные продаж: Товар ^ Временные данные продаж: Модификаторы - Удаление в CHILD */  DELETE t_SaleTempM FROM t_SaleTempM a, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID  IF @@ERROR > 0 RETURNEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_t_SaleTempD]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[t_SaleTempD] ADD CONSTRAINT [pk_t_SaleTempD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID_SrcPosID_SumCC_wt] ON [dbo].[t_SaleTempD] ([ChID], [SrcPosID], [SumCC_wt]) ON [PRIMARY]
GO
