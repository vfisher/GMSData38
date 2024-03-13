CREATE TABLE [dbo].[r_LevyCR]
(
[LevyID] [int] NOT NULL,
[CashType] [smallint] NOT NULL,
[TaxID] [tinyint] NOT NULL,
[CRTaxPercent] [numeric] (21, 9) NOT NULL,
[Override] [bit] NOT NULL,
[TaxTypeID] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_LevyCR] ON [dbo].[r_LevyCR]
FOR INSERT AS
/* r_LevyCR - Справочник сборов - Параметры РРО - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_LevyCR ^ r_DeviceTypes - Проверка в PARENT */
/* Справочник сборов - Параметры РРО ^ Справочник типов устройств - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CashType NOT IN (SELECT DeviceType FROM r_DeviceTypes))
    BEGIN
      EXEC z_RelationError 'r_DeviceTypes', 'r_LevyCR', 0
      RETURN
    END

/* r_LevyCR ^ r_Taxes - Проверка в PARENT */
/* Справочник сборов - Параметры РРО ^ Справочник НДС - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TaxTypeID NOT IN (SELECT TaxTypeID FROM r_Taxes))
    BEGIN
      EXEC z_RelationError 'r_Taxes', 'r_LevyCR', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_LevyCR]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_LevyCR] ON [dbo].[r_LevyCR]
FOR UPDATE AS
/* r_LevyCR - Справочник сборов - Параметры РРО - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_LevyCR ^ r_DeviceTypes - Проверка в PARENT */
/* Справочник сборов - Параметры РРО ^ Справочник типов устройств - Проверка в PARENT */
  IF UPDATE(CashType)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CashType NOT IN (SELECT DeviceType FROM r_DeviceTypes))
      BEGIN
        EXEC z_RelationError 'r_DeviceTypes', 'r_LevyCR', 1
        RETURN
      END

/* r_LevyCR ^ r_Taxes - Проверка в PARENT */
/* Справочник сборов - Параметры РРО ^ Справочник НДС - Проверка в PARENT */
  IF UPDATE(TaxTypeID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TaxTypeID NOT IN (SELECT TaxTypeID FROM r_Taxes))
      BEGIN
        EXEC z_RelationError 'r_Taxes', 'r_LevyCR', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_LevyCR]', 'last', 'update', null
GO
ALTER TABLE [dbo].[r_LevyCR] ADD CONSTRAINT [pk_r_LevyCR] PRIMARY KEY CLUSTERED ([LevyID], [CashType], [TaxTypeID]) ON [PRIMARY]
GO
