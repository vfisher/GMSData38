CREATE TABLE [dbo].[r_AssetH]
(
[AssID] [int] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[AGrID] [int] NOT NULL,
[ACatID] [int] NOT NULL,
[Age] [numeric] (21, 9) NULL,
[PriceCC_nt] [numeric] (21, 9) NOT NULL,
[SupPriceCC_nt] [numeric] (21, 9) NOT NULL,
[WerSumCC_nt] [numeric] (21, 9) NOT NULL,
[DepSumCC_nt] [numeric] (21, 9) NOT NULL,
[RepSumCC_nt] [numeric] (21, 9) NOT NULL,
[ChargeType] [tinyint] NOT NULL,
[ChargeTypeDep] [tinyint] NOT NULL,
[LiqPriceCC_nt] [numeric] (21, 9) NOT NULL,
[GenQty] [numeric] (21, 9) NOT NULL,
[EmpID] [int] NOT NULL,
[GAccID] [int] NOT NULL,
[IsProdAss] [bit] NOT NULL,
[DepID] [smallint] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_AssetH] ON [dbo].[r_AssetH]
FOR INSERT AS
/* r_AssetH - Справочник основных средств: История - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_AssetH ^ r_AssetC - Проверка в PARENT */
/* Справочник основных средств: История ^ Справочник основных средств: категории - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ACatID NOT IN (SELECT ACatID FROM r_AssetC))
    BEGIN
      EXEC z_RelationError 'r_AssetC', 'r_AssetH', 0
      RETURN
    END

/* r_AssetH ^ r_AssetG - Проверка в PARENT */
/* Справочник основных средств: История ^ Справочник основных средств: подгруппы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AGrID NOT IN (SELECT AGrID FROM r_AssetG))
    BEGIN
      EXEC z_RelationError 'r_AssetG', 'r_AssetH', 0
      RETURN
    END

/* r_AssetH ^ r_Assets - Проверка в PARENT */
/* Справочник основных средств: История ^ Справочник основных средств - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AssID NOT IN (SELECT AssID FROM r_Assets))
    BEGIN
      EXEC z_RelationError 'r_Assets', 'r_AssetH', 0
      RETURN
    END

/* r_AssetH ^ r_Deps - Проверка в PARENT */
/* Справочник основных средств: История ^ Справочник отделов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
    BEGIN
      EXEC z_RelationError 'r_Deps', 'r_AssetH', 0
      RETURN
    END

/* r_AssetH ^ r_Emps - Проверка в PARENT */
/* Справочник основных средств: История ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_AssetH', 0
      RETURN
    END

/* r_AssetH ^ r_GAccs - Проверка в PARENT */
/* Справочник основных средств: История ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'r_AssetH', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_AssetH]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_AssetH] ON [dbo].[r_AssetH]
FOR UPDATE AS
/* r_AssetH - Справочник основных средств: История - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_AssetH ^ r_AssetC - Проверка в PARENT */
/* Справочник основных средств: История ^ Справочник основных средств: категории - Проверка в PARENT */
  IF UPDATE(ACatID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ACatID NOT IN (SELECT ACatID FROM r_AssetC))
      BEGIN
        EXEC z_RelationError 'r_AssetC', 'r_AssetH', 1
        RETURN
      END

/* r_AssetH ^ r_AssetG - Проверка в PARENT */
/* Справочник основных средств: История ^ Справочник основных средств: подгруппы - Проверка в PARENT */
  IF UPDATE(AGrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AGrID NOT IN (SELECT AGrID FROM r_AssetG))
      BEGIN
        EXEC z_RelationError 'r_AssetG', 'r_AssetH', 1
        RETURN
      END

/* r_AssetH ^ r_Assets - Проверка в PARENT */
/* Справочник основных средств: История ^ Справочник основных средств - Проверка в PARENT */
  IF UPDATE(AssID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AssID NOT IN (SELECT AssID FROM r_Assets))
      BEGIN
        EXEC z_RelationError 'r_Assets', 'r_AssetH', 1
        RETURN
      END

/* r_AssetH ^ r_Deps - Проверка в PARENT */
/* Справочник основных средств: История ^ Справочник отделов - Проверка в PARENT */
  IF UPDATE(DepID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
      BEGIN
        EXEC z_RelationError 'r_Deps', 'r_AssetH', 1
        RETURN
      END

/* r_AssetH ^ r_Emps - Проверка в PARENT */
/* Справочник основных средств: История ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'r_AssetH', 1
        RETURN
      END

/* r_AssetH ^ r_GAccs - Проверка в PARENT */
/* Справочник основных средств: История ^ План счетов - Проверка в PARENT */
  IF UPDATE(GAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'r_AssetH', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_AssetH]', 'last', 'update', null
GO
ALTER TABLE [dbo].[r_AssetH] ADD CONSTRAINT [pk_r_AssetH] PRIMARY KEY CLUSTERED ([AssID], [BDate]) ON [PRIMARY]
GO
