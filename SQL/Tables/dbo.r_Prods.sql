CREATE TABLE [dbo].[r_Prods] (
  [ChID] [bigint] NOT NULL,
  [ProdID] [int] NOT NULL,
  [ProdName] [varchar](200) NOT NULL,
  [UM] [varchar](50) NOT NULL,
  [Country] [varchar](200) NULL,
  [Notes] [varchar](200) NULL,
  [PCatID] [int] NOT NULL,
  [PGrID] [int] NOT NULL,
  [Article1] [varchar](200) NULL,
  [Article2] [varchar](200) NULL,
  [Article3] [varchar](200) NULL,
  [Weight] [numeric](21, 9) NULL,
  [Age] [numeric](21, 9) NULL,
  [PriceWithTax] [bit] NOT NULL,
  [Note1] [varchar](200) NULL,
  [Note2] [varchar](200) NULL,
  [Note3] [varchar](200) NULL,
  [MinPriceMC] [numeric](21, 9) NOT NULL,
  [MaxPriceMC] [numeric](21, 9) NOT NULL,
  [MinRem] [numeric](21, 9) NOT NULL,
  [CstDty] [numeric](21, 9) NOT NULL,
  [CstPrc] [numeric](21, 9) NOT NULL,
  [CstExc] [numeric](21, 9) NOT NULL,
  [StdExtraR] [varchar](255) NOT NULL CONSTRAINT [StdExtraR_Def] DEFAULT (0),
  [StdExtraE] [varchar](255) NOT NULL CONSTRAINT [StdExtraE_Def] DEFAULT (0),
  [MaxExtra] [numeric](21, 9) NOT NULL,
  [MinExtra] [numeric](21, 9) NOT NULL,
  [UseAlts] [bit] NOT NULL,
  [UseCrts] [bit] NOT NULL,
  [PGrID1] [int] NOT NULL,
  [PGrID2] [int] NOT NULL,
  [PGrID3] [int] NOT NULL,
  [PGrAID] [smallint] NOT NULL,
  [PBGrID] [smallint] NOT NULL,
  [LExpSet] [varchar](255) NULL,
  [EExpSet] [varchar](255) NULL,
  [InRems] [bit] NOT NULL,
  [IsDecQty] [bit] NOT NULL,
  [File1] [varchar](200) NULL,
  [File2] [varchar](200) NULL,
  [File3] [varchar](200) NULL,
  [AutoSet] [bit] NOT NULL,
  [Extra1] [numeric](21, 9) NOT NULL,
  [Extra2] [numeric](21, 9) NOT NULL,
  [Extra3] [numeric](21, 9) NOT NULL,
  [Extra4] [numeric](21, 9) NOT NULL,
  [Extra5] [numeric](21, 9) NOT NULL,
  [Norma1] [numeric](21, 9) NOT NULL,
  [Norma2] [numeric](21, 9) NOT NULL,
  [Norma3] [numeric](21, 9) NOT NULL,
  [Norma4] [numeric](21, 9) NOT NULL,
  [Norma5] [numeric](21, 9) NOT NULL,
  [RecMinPriceCC] [numeric](21, 9) NOT NULL,
  [RecMaxPriceCC] [numeric](21, 9) NOT NULL,
  [RecStdPriceCC] [numeric](21, 9) NOT NULL,
  [RecRemQty] [numeric](21, 9) NOT NULL,
  [InStopList] [bit] NOT NULL,
  [PrepareTime] [int] NULL DEFAULT (0),
  [ScaleGrID] [int] NOT NULL DEFAULT (0),
  [ScaleStandard] [varchar](250) NULL,
  [ScaleConditions] [varchar](250) NULL,
  [ScaleComponents] [varchar](250) NULL,
  [TaxFreeReason] [varchar](250) NULL,
  [CstProdCode] [varchar](250) NULL,
  [TaxTypeID] [int] NOT NULL DEFAULT (0),
  [CstDty2] [numeric](21, 9) NOT NULL DEFAULT (0),
  [CounID] [smallint] NOT NULL DEFAULT (0),
  [IsMarked] [bit] NOT NULL DEFAULT (0),
  [ProviderProdName] [varchar](250) NULL,
  [GuaranteeMonth] [smallint] NULL DEFAULT (0),
  [RequireLevyMark] [bit] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_r_Prods] PRIMARY KEY CLUSTERED ([ProdID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Prods] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [CounID]
  ON [dbo].[r_Prods] ([CounID])
  ON [PRIMARY]
GO

CREATE INDEX [CstDty2]
  ON [dbo].[r_Prods] ([CstDty2])
  ON [PRIMARY]
GO

CREATE INDEX [PBGrID]
  ON [dbo].[r_Prods] ([PBGrID])
  ON [PRIMARY]
GO

CREATE INDEX [PCatID]
  ON [dbo].[r_Prods] ([PCatID])
  ON [PRIMARY]
GO

CREATE INDEX [PGrAID]
  ON [dbo].[r_Prods] ([PGrAID])
  ON [PRIMARY]
GO

CREATE INDEX [PGrID]
  ON [dbo].[r_Prods] ([PGrID])
  ON [PRIMARY]
GO

CREATE INDEX [PGrID1]
  ON [dbo].[r_Prods] ([PGrID1])
  ON [PRIMARY]
GO

CREATE INDEX [PGrID2]
  ON [dbo].[r_Prods] ([PGrID2])
  ON [PRIMARY]
GO

CREATE INDEX [PGrID3]
  ON [dbo].[r_Prods] ([PGrID3])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID_InRems]
  ON [dbo].[r_Prods] ([ProdID], [InRems])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ProdName]
  ON [dbo].[r_Prods] ([ProdName])
  ON [PRIMARY]
GO

CREATE INDEX [UM]
  ON [dbo].[r_Prods] ([UM])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.PCatID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.PGrID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.Weight'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.Age'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.PriceWithTax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.MinPriceMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.MaxPriceMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.MinRem'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.CstDty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.CstPrc'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.CstExc'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.MaxExtra'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.MinExtra'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.UseAlts'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.UseCrts'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.PGrID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.PGrID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.PGrID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.PGrAID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.PBGrID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.InRems'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.IsDecQty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.AutoSet'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.Extra1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.Extra2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.Extra3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.Extra4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.Extra5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.Norma1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.Norma2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.Norma3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.Norma4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.Norma5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.RecMinPriceCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.RecMaxPriceCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.RecStdPriceCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.RecRemQty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Prods.InStopList'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Prods] ON [r_Prods]
FOR DELETE AS
/* r_Prods - Справочник товаров - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Prods ^ r_CRMP - Проверка в CHILD */
/* Справочник товаров ^ Справочник ЭККА - Товары - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_CRMP a WITH(NOLOCK), deleted d WHERE a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_CRMP', 3
      RETURN
    END

/* r_Prods ^ r_Carrs - Проверка в CHILD */
/* Справочник товаров ^ Справочник транспорта - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Carrs a WITH(NOLOCK), deleted d WHERE a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_Carrs', 3
      RETURN
    END

/* r_Prods ^ r_ProdMarks - Удаление в CHILD */
/* Справочник товаров ^ Справочник товаров: маркировки - Удаление в CHILD */
  DELETE r_ProdMarks FROM r_ProdMarks a, deleted d WHERE a.ProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* r_Prods ^ b_PInP - Удаление в CHILD */
/* Справочник товаров ^ Справочник товаров - Цены прихода Бухгалтерии - Удаление в CHILD */
  DELETE b_PInP FROM b_PInP a, deleted d WHERE a.ProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* r_Prods ^ r_ProdCV - Удаление в CHILD */
/* Справочник товаров ^ Справочник товаров - Значения для периодов - Удаление в CHILD */
  DELETE r_ProdCV FROM r_ProdCV a, deleted d WHERE a.ProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* r_Prods ^ r_ProdEC - Удаление в CHILD */
/* Справочник товаров ^ Справочник товаров - Значения для предприятий - Удаление в CHILD */
  DELETE r_ProdEC FROM r_ProdEC a, deleted d WHERE a.ProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* r_Prods ^ r_ProdImages - Удаление в CHILD */
/* Справочник товаров ^ Справочник товаров: изображения - Удаление в CHILD */
  DELETE r_ProdImages FROM r_ProdImages a, deleted d WHERE a.ProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* r_Prods ^ r_ProdLV - Проверка в CHILD */
/* Справочник товаров ^ Справочник товаров - Сборы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ProdLV a WITH(NOLOCK), deleted d WHERE a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_ProdLV', 3
      RETURN
    END

/* r_Prods ^ r_ProdMA - Удаление в CHILD */
/* Справочник товаров ^ Справочник товаров - Альтернативы - Удаление в CHILD */
  DELETE r_ProdMA FROM r_ProdMA a, deleted d WHERE a.AProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* r_Prods ^ r_ProdMA - Удаление в CHILD */
/* Справочник товаров ^ Справочник товаров - Альтернативы - Удаление в CHILD */
  DELETE r_ProdMA FROM r_ProdMA a, deleted d WHERE a.ProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* r_Prods ^ r_ProdME - Проверка в CHILD */
/* Справочник товаров ^ Справочник товаров - Затраты на комплекты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ProdME a WITH(NOLOCK), deleted d WHERE a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_ProdME', 3
      RETURN
    END

/* r_Prods ^ r_ProdMP - Удаление в CHILD */
/* Справочник товаров ^ Справочник товаров - Цены для прайс-листов - Удаление в CHILD */
  DELETE r_ProdMP FROM r_ProdMP a, deleted d WHERE a.ProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* r_Prods ^ r_ProdMQ - Удаление в CHILD */
/* Справочник товаров ^ Справочник товаров - Виды упаковок - Удаление в CHILD */
  DELETE r_ProdMQ FROM r_ProdMQ a, deleted d WHERE a.ProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* r_Prods ^ r_ProdMS - Удаление в CHILD */
/* Справочник товаров ^ Справочник товаров - Комплектующие - Комплектация - Удаление в CHILD */
  DELETE r_ProdMS FROM r_ProdMS a, deleted d WHERE a.ProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* r_Prods ^ r_ProdMS - Проверка в CHILD */
/* Справочник товаров ^ Справочник товаров - Комплектующие - Комплектация - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ProdMS a WITH(NOLOCK), deleted d WHERE a.SProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_ProdMS', 3
      RETURN
    END

/* r_Prods ^ r_ProdMSE - Удаление в CHILD */
/* Справочник товаров ^ Справочник товаров - Комплектующие - Разукомплектация - Удаление в CHILD */
  DELETE r_ProdMSE FROM r_ProdMSE a, deleted d WHERE a.ProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* r_Prods ^ r_ProdMSE - Проверка в CHILD */
/* Справочник товаров ^ Справочник товаров - Комплектующие - Разукомплектация - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ProdMSE a WITH(NOLOCK), deleted d WHERE a.SProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_ProdMSE', 3
      RETURN
    END

/* r_Prods ^ r_ProdOpers - Проверка в CHILD */
/* Справочник товаров ^ Справочник товаров: Виды операций и потери - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ProdOpers a WITH(NOLOCK), deleted d WHERE a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_ProdOpers', 3
      RETURN
    END

/* r_Prods ^ r_ProdValues - Проверка в CHILD */
/* Справочник товаров ^ Справочник товаров - Значения - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ProdValues a WITH(NOLOCK), deleted d WHERE a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_ProdValues', 3
      RETURN
    END

/* r_Prods ^ t_PInP - Удаление в CHILD */
/* Справочник товаров ^ Справочник товаров - Цены прихода Торговли - Удаление в CHILD */
  DELETE t_PInP FROM t_PInP a, deleted d WHERE a.ProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* r_Prods ^ r_StockCRProds - Удаление в CHILD */
/* Справочник товаров ^ Справочник складов - Товары для ЭККА - Удаление в CHILD */
  DELETE r_StockCRProds FROM r_StockCRProds a, deleted d WHERE a.ProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* r_Prods ^ r_GOperD - Проверка в CHILD */
/* Справочник товаров ^ Справочник проводок - Проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GOperD a WITH(NOLOCK), deleted d WHERE a.C_ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_GOperD', 3
      RETURN
    END

/* r_Prods ^ r_GOperD - Проверка в CHILD */
/* Справочник товаров ^ Справочник проводок - Проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GOperD a WITH(NOLOCK), deleted d WHERE a.D_ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_GOperD', 3
      RETURN
    END

/* r_Prods ^ r_MenuP - Удаление в CHILD */
/* Справочник товаров ^ Справочник меню - товары - Удаление в CHILD */
  DELETE r_MenuP FROM r_MenuP a, deleted d WHERE a.ProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* r_Prods ^ r_DCTypeP - Проверка в CHILD */
/* Справочник товаров ^ Справочник дисконтных карт: Типы: Товары - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_DCTypeP a WITH(NOLOCK), deleted d WHERE a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_DCTypeP', 3
      RETURN
    END

/* r_Prods ^ r_DCTypes - Удаление в CHILD */
/* Справочник товаров ^ Справочник дисконтных карт: типы - Удаление в CHILD */
  DELETE r_DCTypes FROM r_DCTypes a, deleted d WHERE a.ProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* r_Prods ^ r_GAccs - Проверка в CHILD */
/* Справочник товаров ^ План счетов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GAccs a WITH(NOLOCK), deleted d WHERE a.A_ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_GAccs', 3
      RETURN
    END

/* r_Prods ^ b_GTranD - Проверка в CHILD */
/* Справочник товаров ^ Таблица проводок (Проводки) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTranD a WITH(NOLOCK), deleted d WHERE a.C_ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'b_GTranD', 3
      RETURN
    END

/* r_Prods ^ b_GTranD - Проверка в CHILD */
/* Справочник товаров ^ Таблица проводок (Проводки) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTranD a WITH(NOLOCK), deleted d WHERE a.D_ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'b_GTranD', 3
      RETURN
    END

/* r_Prods ^ b_PCostD - Проверка в CHILD */
/* Справочник товаров ^ ТМЦ: Формирование себестоимости (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PCostD a WITH(NOLOCK), deleted d WHERE a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'b_PCostD', 3
      RETURN
    END

/* r_Prods ^ b_PVenA - Проверка в CHILD */
/* Справочник товаров ^ ТМЦ: Инвентаризация (Итоги) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PVenA a WITH(NOLOCK), deleted d WHERE a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'b_PVenA', 3
      RETURN
    END

/* r_Prods ^ b_TranH - Проверка в CHILD */
/* Справочник товаров ^ Ручные проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranH a WITH(NOLOCK), deleted d WHERE a.C_ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'b_TranH', 3
      RETURN
    END

/* r_Prods ^ b_TranH - Проверка в CHILD */
/* Справочник товаров ^ Ручные проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranH a WITH(NOLOCK), deleted d WHERE a.D_ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'b_TranH', 3
      RETURN
    END

/* r_Prods ^ b_zInH - Проверка в CHILD */
/* Справочник товаров ^ Ручные входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInH a WITH(NOLOCK), deleted d WHERE a.C_ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'b_zInH', 3
      RETURN
    END

/* r_Prods ^ b_zInH - Проверка в CHILD */
/* Справочник товаров ^ Ручные входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInH a WITH(NOLOCK), deleted d WHERE a.D_ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 'b_zInH', 3
      RETURN
    END

/* r_Prods ^ r_ProdMPCh - Удаление в CHILD */
/* Справочник товаров ^ Изменение цен продажи (Таблица) - Удаление в CHILD */
  DELETE r_ProdMPCh FROM r_ProdMPCh a, deleted d WHERE a.ProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* r_Prods ^ t_DisD - Проверка в CHILD */
/* Справочник товаров ^ Распределение товара: Данные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_DisD a WITH(NOLOCK), deleted d WHERE a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 't_DisD', 3
      RETURN
    END

/* r_Prods ^ t_EOExpD - Проверка в CHILD */
/* Справочник товаров ^ Заказ внешний: Формирование: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EOExpD a WITH(NOLOCK), deleted d WHERE a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 't_EOExpD', 3
      RETURN
    END

/* r_Prods ^ t_EOExpDD - Проверка в CHILD */
/* Справочник товаров ^ Заказ внешний: Формирование: Подробно - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EOExpDD a WITH(NOLOCK), deleted d WHERE a.DetProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 't_EOExpDD', 3
      RETURN
    END

/* r_Prods ^ t_EORecD - Проверка в CHILD */
/* Справочник товаров ^ Заказ внешний: Обработка: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EORecD a WITH(NOLOCK), deleted d WHERE a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 't_EORecD', 3
      RETURN
    END

/* r_Prods ^ t_IORecD - Проверка в CHILD */
/* Справочник товаров ^ Заказ внутренний: Формирование: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_IORecD a WITH(NOLOCK), deleted d WHERE a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 't_IORecD', 3
      RETURN
    END

/* r_Prods ^ t_PInPCh - Удаление в CHILD */
/* Справочник товаров ^ Изменение цен прихода: Бизнес - Удаление в CHILD */
  DELETE t_PInPCh FROM t_PInPCh a, deleted d WHERE a.ProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* r_Prods ^ t_SEstD - Проверка в CHILD */
/* Справочник товаров ^ Переоценка цен продажи: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SEstD a WITH(NOLOCK), deleted d WHERE a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 't_SEstD', 3
      RETURN
    END

/* r_Prods ^ t_Spec - Проверка в CHILD */
/* Справочник товаров ^ Калькуляционная карта: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Spec a WITH(NOLOCK), deleted d WHERE a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 't_Spec', 3
      RETURN
    END

/* r_Prods ^ t_SpecD - Проверка в CHILD */
/* Справочник товаров ^ Калькуляционная карта: Состав - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SpecD a WITH(NOLOCK), deleted d WHERE a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 't_SpecD', 3
      RETURN
    END

/* r_Prods ^ t_VenA - Проверка в CHILD */
/* Справочник товаров ^ Инвентаризация товара: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_VenA a WITH(NOLOCK), deleted d WHERE a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 't_VenA', 3
      RETURN
    END

/* r_Prods ^ t_VenD_UM - Удаление в CHILD */
/* Справочник товаров ^ Инвентаризация товара: Виды упаковок - Удаление в CHILD */
  DELETE t_VenD_UM FROM t_VenD_UM a, deleted d WHERE a.DetProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* r_Prods ^ t_VenI - Проверка в CHILD */
/* Справочник товаров ^ Инвентаризация товара: Первичные данные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_VenI a WITH(NOLOCK), deleted d WHERE a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_Prods', 't_VenI', 3
      RETURN
    END


/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10350001 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10350001 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10350001, -ChID, 
    '[' + cast(d.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10350 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Prods', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Prods] ON [r_Prods]
FOR UPDATE AS
/* r_Prods - Справочник товаров - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Prods ^ r_Countries - Проверка в PARENT */
/* Справочник товаров ^ Справочник стран - Проверка в PARENT */
  IF UPDATE(CounID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CounID NOT IN (SELECT CounID FROM r_Countries))
      BEGIN
        EXEC z_RelationError 'r_Countries', 'r_Prods', 1
        RETURN
      END

/* r_Prods ^ r_ProdA - Проверка в PARENT */
/* Справочник товаров ^ Справочник товаров: группа альтернатив - Проверка в PARENT */
  IF UPDATE(PGrAID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PGrAID NOT IN (SELECT PGrAID FROM r_ProdA))
      BEGIN
        EXEC z_RelationError 'r_ProdA', 'r_Prods', 1
        RETURN
      END

/* r_Prods ^ r_ProdBG - Проверка в PARENT */
/* Справочник товаров ^ Справочник товаров: группа бухгалтерии - Проверка в PARENT */
  IF UPDATE(PBGrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PBGrID NOT IN (SELECT PBGrID FROM r_ProdBG))
      BEGIN
        EXEC z_RelationError 'r_ProdBG', 'r_Prods', 1
        RETURN
      END

/* r_Prods ^ r_ProdC - Проверка в PARENT */
/* Справочник товаров ^ Справочник товаров: категории - Проверка в PARENT */
  IF UPDATE(PCatID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PCatID NOT IN (SELECT PCatID FROM r_ProdC))
      BEGIN
        EXEC z_RelationError 'r_ProdC', 'r_Prods', 1
        RETURN
      END

/* r_Prods ^ r_ProdG - Проверка в PARENT */
/* Справочник товаров ^ Справочник товаров: группы - Проверка в PARENT */
  IF UPDATE(PGrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PGrID NOT IN (SELECT PGrID FROM r_ProdG))
      BEGIN
        EXEC z_RelationError 'r_ProdG', 'r_Prods', 1
        RETURN
      END

/* r_Prods ^ r_ProdG1 - Проверка в PARENT */
/* Справочник товаров ^ Справочник товаров: 1 группа - Проверка в PARENT */
  IF UPDATE(PGrID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PGrID1 NOT IN (SELECT PGrID1 FROM r_ProdG1))
      BEGIN
        EXEC z_RelationError 'r_ProdG1', 'r_Prods', 1
        RETURN
      END

/* r_Prods ^ r_ProdG2 - Проверка в PARENT */
/* Справочник товаров ^ Справочник товаров: 2 группа - Проверка в PARENT */
  IF UPDATE(PGrID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PGrID2 NOT IN (SELECT PGrID2 FROM r_ProdG2))
      BEGIN
        EXEC z_RelationError 'r_ProdG2', 'r_Prods', 1
        RETURN
      END

/* r_Prods ^ r_ProdG3 - Проверка в PARENT */
/* Справочник товаров ^ Справочник товаров: 3 группа - Проверка в PARENT */
  IF UPDATE(PGrID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PGrID3 NOT IN (SELECT PGrID3 FROM r_ProdG3))
      BEGIN
        EXEC z_RelationError 'r_ProdG3', 'r_Prods', 1
        RETURN
      END

/* r_Prods ^ r_ScaleGrs - Проверка в PARENT */
/* Справочник товаров ^ Справочник весов: группы - Проверка в PARENT */
  IF UPDATE(ScaleGrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ScaleGrID NOT IN (SELECT ScaleGrID FROM r_ScaleGrs))
      BEGIN
        EXEC z_RelationError 'r_ScaleGrs', 'r_Prods', 1
        RETURN
      END

/* r_Prods ^ r_Taxes - Проверка в PARENT */
/* Справочник товаров ^ Справочник НДС - Проверка в PARENT */
  IF UPDATE(TaxTypeID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TaxTypeID NOT IN (SELECT TaxTypeID FROM r_Taxes))
      BEGIN
        EXEC z_RelationError 'r_Taxes', 'r_Prods', 1
        RETURN
      END

/* r_Prods ^ r_CRMP - Обновление CHILD */
/* Справочник товаров ^ Справочник ЭККА - Товары - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_CRMP a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CRMP a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник ЭККА - Товары''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_Carrs - Обновление CHILD */
/* Справочник товаров ^ Справочник транспорта - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_Carrs a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Carrs a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник транспорта''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_ProdMarks - Обновление CHILD */
/* Справочник товаров ^ Справочник товаров: маркировки - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_ProdMarks a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdMarks a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник товаров: маркировки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ b_PInP - Обновление CHILD */
/* Справочник товаров ^ Справочник товаров - Цены прихода Бухгалтерии - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM b_PInP a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PInP a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник товаров - Цены прихода Бухгалтерии''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_ProdCV - Обновление CHILD */
/* Справочник товаров ^ Справочник товаров - Значения для периодов - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_ProdCV a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdCV a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник товаров - Значения для периодов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_ProdEC - Обновление CHILD */
/* Справочник товаров ^ Справочник товаров - Значения для предприятий - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_ProdEC a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdEC a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник товаров - Значения для предприятий''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_ProdImages - Обновление CHILD */
/* Справочник товаров ^ Справочник товаров: изображения - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_ProdImages a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdImages a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник товаров: изображения''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_ProdLV - Обновление CHILD */
/* Справочник товаров ^ Справочник товаров - Сборы - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_ProdLV a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdLV a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник товаров - Сборы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_ProdMA - Обновление CHILD */
/* Справочник товаров ^ Справочник товаров - Альтернативы - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AProdID = i.ProdID
          FROM r_ProdMA a, inserted i, deleted d WHERE a.AProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdMA a, deleted d WHERE a.AProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник товаров - Альтернативы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_ProdMA - Обновление CHILD */
/* Справочник товаров ^ Справочник товаров - Альтернативы - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_ProdMA a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdMA a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник товаров - Альтернативы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_ProdME - Обновление CHILD */
/* Справочник товаров ^ Справочник товаров - Затраты на комплекты - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_ProdME a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdME a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник товаров - Затраты на комплекты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_ProdMP - Обновление CHILD */
/* Справочник товаров ^ Справочник товаров - Цены для прайс-листов - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_ProdMP a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdMP a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник товаров - Цены для прайс-листов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_ProdMQ - Обновление CHILD */
/* Справочник товаров ^ Справочник товаров - Виды упаковок - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_ProdMQ a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdMQ a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник товаров - Виды упаковок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_ProdMS - Обновление CHILD */
/* Справочник товаров ^ Справочник товаров - Комплектующие - Комплектация - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_ProdMS a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdMS a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник товаров - Комплектующие - Комплектация''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_ProdMS - Обновление CHILD */
/* Справочник товаров ^ Справочник товаров - Комплектующие - Комплектация - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SProdID = i.ProdID
          FROM r_ProdMS a, inserted i, deleted d WHERE a.SProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdMS a, deleted d WHERE a.SProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник товаров - Комплектующие - Комплектация''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_ProdMSE - Обновление CHILD */
/* Справочник товаров ^ Справочник товаров - Комплектующие - Разукомплектация - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_ProdMSE a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdMSE a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник товаров - Комплектующие - Разукомплектация''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_ProdMSE - Обновление CHILD */
/* Справочник товаров ^ Справочник товаров - Комплектующие - Разукомплектация - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SProdID = i.ProdID
          FROM r_ProdMSE a, inserted i, deleted d WHERE a.SProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdMSE a, deleted d WHERE a.SProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник товаров - Комплектующие - Разукомплектация''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_ProdOpers - Обновление CHILD */
/* Справочник товаров ^ Справочник товаров: Виды операций и потери - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_ProdOpers a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdOpers a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник товаров: Виды операций и потери''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_ProdValues - Обновление CHILD */
/* Справочник товаров ^ Справочник товаров - Значения - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_ProdValues a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdValues a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник товаров - Значения''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ t_PInP - Обновление CHILD */
/* Справочник товаров ^ Справочник товаров - Цены прихода Торговли - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM t_PInP a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_PInP a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник товаров - Цены прихода Торговли''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_StockCRProds - Обновление CHILD */
/* Справочник товаров ^ Справочник складов - Товары для ЭККА - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_StockCRProds a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_StockCRProds a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник складов - Товары для ЭККА''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_GOperD - Обновление CHILD */
/* Справочник товаров ^ Справочник проводок - Проводки - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_ProdID = i.ProdID
          FROM r_GOperD a, inserted i, deleted d WHERE a.C_ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GOperD a, deleted d WHERE a.C_ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник проводок - Проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_GOperD - Обновление CHILD */
/* Справочник товаров ^ Справочник проводок - Проводки - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_ProdID = i.ProdID
          FROM r_GOperD a, inserted i, deleted d WHERE a.D_ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GOperD a, deleted d WHERE a.D_ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник проводок - Проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_MenuP - Обновление CHILD */
/* Справочник товаров ^ Справочник меню - товары - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_MenuP a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_MenuP a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник меню - товары''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_DCTypeP - Обновление CHILD */
/* Справочник товаров ^ Справочник дисконтных карт: Типы: Товары - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_DCTypeP a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DCTypeP a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник дисконтных карт: Типы: Товары''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_DCTypes - Обновление CHILD */
/* Справочник товаров ^ Справочник дисконтных карт: типы - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_DCTypes a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DCTypes a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Справочник дисконтных карт: типы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_GAccs - Обновление CHILD */
/* Справочник товаров ^ План счетов - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.A_ProdID = i.ProdID
          FROM r_GAccs a, inserted i, deleted d WHERE a.A_ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GAccs a, deleted d WHERE a.A_ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''План счетов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ b_GTranD - Обновление CHILD */
/* Справочник товаров ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_ProdID = i.ProdID
          FROM b_GTranD a, inserted i, deleted d WHERE a.C_ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.C_ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ b_GTranD - Обновление CHILD */
/* Справочник товаров ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_ProdID = i.ProdID
          FROM b_GTranD a, inserted i, deleted d WHERE a.D_ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.D_ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ b_PCostD - Обновление CHILD */
/* Справочник товаров ^ ТМЦ: Формирование себестоимости (ТМЦ) - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM b_PCostD a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PCostD a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''ТМЦ: Формирование себестоимости (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ b_PVenA - Обновление CHILD */
/* Справочник товаров ^ ТМЦ: Инвентаризация (Итоги) - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM b_PVenA a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PVenA a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''ТМЦ: Инвентаризация (Итоги)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ b_TranH - Обновление CHILD */
/* Справочник товаров ^ Ручные проводки - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_ProdID = i.ProdID
          FROM b_TranH a, inserted i, deleted d WHERE a.C_ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranH a, deleted d WHERE a.C_ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Ручные проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ b_TranH - Обновление CHILD */
/* Справочник товаров ^ Ручные проводки - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_ProdID = i.ProdID
          FROM b_TranH a, inserted i, deleted d WHERE a.D_ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranH a, deleted d WHERE a.D_ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Ручные проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ b_zInH - Обновление CHILD */
/* Справочник товаров ^ Ручные входящие - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_ProdID = i.ProdID
          FROM b_zInH a, inserted i, deleted d WHERE a.C_ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInH a, deleted d WHERE a.C_ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Ручные входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ b_zInH - Обновление CHILD */
/* Справочник товаров ^ Ручные входящие - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_ProdID = i.ProdID
          FROM b_zInH a, inserted i, deleted d WHERE a.D_ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInH a, deleted d WHERE a.D_ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Ручные входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ r_ProdMPCh - Обновление CHILD */
/* Справочник товаров ^ Изменение цен продажи (Таблица) - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM r_ProdMPCh a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdMPCh a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Изменение цен продажи (Таблица)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ t_DisD - Обновление CHILD */
/* Справочник товаров ^ Распределение товара: Данные - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM t_DisD a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_DisD a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Распределение товара: Данные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ t_EOExpD - Обновление CHILD */
/* Справочник товаров ^ Заказ внешний: Формирование: Товар - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM t_EOExpD a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EOExpD a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Заказ внешний: Формирование: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ t_EOExpDD - Обновление CHILD */
/* Справочник товаров ^ Заказ внешний: Формирование: Подробно - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DetProdID = i.ProdID
          FROM t_EOExpDD a, inserted i, deleted d WHERE a.DetProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EOExpDD a, deleted d WHERE a.DetProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Заказ внешний: Формирование: Подробно''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ t_EORecD - Обновление CHILD */
/* Справочник товаров ^ Заказ внешний: Обработка: Товар - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM t_EORecD a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EORecD a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Заказ внешний: Обработка: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ t_IORecD - Обновление CHILD */
/* Справочник товаров ^ Заказ внутренний: Формирование: Товар - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM t_IORecD a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_IORecD a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Заказ внутренний: Формирование: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ t_PInPCh - Обновление CHILD */
/* Справочник товаров ^ Изменение цен прихода: Бизнес - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM t_PInPCh a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_PInPCh a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Изменение цен прихода: Бизнес''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ t_SEstD - Обновление CHILD */
/* Справочник товаров ^ Переоценка цен продажи: Товар - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM t_SEstD a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SEstD a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Переоценка цен продажи: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ t_Spec - Обновление CHILD */
/* Справочник товаров ^ Калькуляционная карта: Заголовок - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM t_Spec a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Spec a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Калькуляционная карта: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ t_SpecD - Обновление CHILD */
/* Справочник товаров ^ Калькуляционная карта: Состав - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM t_SpecD a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SpecD a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Калькуляционная карта: Состав''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ t_VenA - Обновление CHILD */
/* Справочник товаров ^ Инвентаризация товара: Товар - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM t_VenA a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_VenA a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Инвентаризация товара: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ t_VenD_UM - Обновление CHILD */
/* Справочник товаров ^ Инвентаризация товара: Виды упаковок - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DetProdID = i.ProdID
          FROM t_VenD_UM a, inserted i, deleted d WHERE a.DetProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_VenD_UM a, deleted d WHERE a.DetProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Инвентаризация товара: Виды упаковок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Prods ^ t_VenI - Обновление CHILD */
/* Справочник товаров ^ Инвентаризация товара: Первичные данные - Обновление CHILD */
  IF UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID
          FROM t_VenI a, inserted i, deleted d WHERE a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_VenI a, deleted d WHERE a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров'' => ''Инвентаризация товара: Первичные данные''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10350001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10350001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ProdID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10350001 AND l.PKValue = 
        '[' + cast(i.ProdID as varchar(200)) + ']' AND i.ProdID = d.ProdID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10350001 AND l.PKValue = 
        '[' + cast(i.ProdID as varchar(200)) + ']' AND i.ProdID = d.ProdID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10350001, ChID, 
          '[' + cast(d.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10350001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10350001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10350001, ChID, 
          '[' + cast(i.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ProdID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ProdID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ProdID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ProdID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10350001 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ProdID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10350001 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10350001, ChID, 
          '[' + cast(d.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10350001 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10350001 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10350001, ChID, 
          '[' + cast(i.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350001, ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Prods', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Prods] ON [r_Prods]
FOR INSERT AS
/* r_Prods - Справочник товаров - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Prods ^ r_Countries - Проверка в PARENT */
/* Справочник товаров ^ Справочник стран - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CounID NOT IN (SELECT CounID FROM r_Countries))
    BEGIN
      EXEC z_RelationError 'r_Countries', 'r_Prods', 0
      RETURN
    END

/* r_Prods ^ r_ProdA - Проверка в PARENT */
/* Справочник товаров ^ Справочник товаров: группа альтернатив - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PGrAID NOT IN (SELECT PGrAID FROM r_ProdA))
    BEGIN
      EXEC z_RelationError 'r_ProdA', 'r_Prods', 0
      RETURN
    END

/* r_Prods ^ r_ProdBG - Проверка в PARENT */
/* Справочник товаров ^ Справочник товаров: группа бухгалтерии - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PBGrID NOT IN (SELECT PBGrID FROM r_ProdBG))
    BEGIN
      EXEC z_RelationError 'r_ProdBG', 'r_Prods', 0
      RETURN
    END

/* r_Prods ^ r_ProdC - Проверка в PARENT */
/* Справочник товаров ^ Справочник товаров: категории - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PCatID NOT IN (SELECT PCatID FROM r_ProdC))
    BEGIN
      EXEC z_RelationError 'r_ProdC', 'r_Prods', 0
      RETURN
    END

/* r_Prods ^ r_ProdG - Проверка в PARENT */
/* Справочник товаров ^ Справочник товаров: группы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PGrID NOT IN (SELECT PGrID FROM r_ProdG))
    BEGIN
      EXEC z_RelationError 'r_ProdG', 'r_Prods', 0
      RETURN
    END

/* r_Prods ^ r_ProdG1 - Проверка в PARENT */
/* Справочник товаров ^ Справочник товаров: 1 группа - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PGrID1 NOT IN (SELECT PGrID1 FROM r_ProdG1))
    BEGIN
      EXEC z_RelationError 'r_ProdG1', 'r_Prods', 0
      RETURN
    END

/* r_Prods ^ r_ProdG2 - Проверка в PARENT */
/* Справочник товаров ^ Справочник товаров: 2 группа - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PGrID2 NOT IN (SELECT PGrID2 FROM r_ProdG2))
    BEGIN
      EXEC z_RelationError 'r_ProdG2', 'r_Prods', 0
      RETURN
    END

/* r_Prods ^ r_ProdG3 - Проверка в PARENT */
/* Справочник товаров ^ Справочник товаров: 3 группа - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PGrID3 NOT IN (SELECT PGrID3 FROM r_ProdG3))
    BEGIN
      EXEC z_RelationError 'r_ProdG3', 'r_Prods', 0
      RETURN
    END

/* r_Prods ^ r_ScaleGrs - Проверка в PARENT */
/* Справочник товаров ^ Справочник весов: группы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ScaleGrID NOT IN (SELECT ScaleGrID FROM r_ScaleGrs))
    BEGIN
      EXEC z_RelationError 'r_ScaleGrs', 'r_Prods', 0
      RETURN
    END

/* r_Prods ^ r_Taxes - Проверка в PARENT */
/* Справочник товаров ^ Справочник НДС - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TaxTypeID NOT IN (SELECT TaxTypeID FROM r_Taxes))
    BEGIN
      EXEC z_RelationError 'r_Taxes', 'r_Prods', 0
      RETURN
    END


/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350001, ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_Prods', N'Last', N'INSERT'
GO











































































































SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO