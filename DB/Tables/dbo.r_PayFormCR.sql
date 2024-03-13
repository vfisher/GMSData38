CREATE TABLE [dbo].[r_PayFormCR]
(
[PayFormCode] [int] NOT NULL,
[CashType] [smallint] NOT NULL,
[CRPayFormCode] [smallint] NOT NULL,
[SendTransactionInfo] [bit] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_PayFormCR] ON [dbo].[r_PayFormCR]
FOR INSERT AS
/* r_PayFormCR - Справочник форм оплаты - Параметры РРО - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PayFormCR ^ r_DeviceTypes - Проверка в PARENT */
/* Справочник форм оплаты - Параметры РРО ^ Справочник типов устройств - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CashType NOT IN (SELECT DeviceType FROM r_DeviceTypes))
    BEGIN
      EXEC z_RelationError 'r_DeviceTypes', 'r_PayFormCR', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_PayFormCR]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_PayFormCR] ON [dbo].[r_PayFormCR]
FOR UPDATE AS
/* r_PayFormCR - Справочник форм оплаты - Параметры РРО - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PayFormCR ^ r_DeviceTypes - Проверка в PARENT */
/* Справочник форм оплаты - Параметры РРО ^ Справочник типов устройств - Проверка в PARENT */
  IF UPDATE(CashType)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CashType NOT IN (SELECT DeviceType FROM r_DeviceTypes))
      BEGIN
        EXEC z_RelationError 'r_DeviceTypes', 'r_PayFormCR', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_PayFormCR]', 'last', 'update', null
GO
ALTER TABLE [dbo].[r_PayFormCR] ADD CONSTRAINT [pk_r_PayFormCR] PRIMARY KEY CLUSTERED ([PayFormCode], [CashType], [CRPayFormCode]) ON [PRIMARY]
GO
