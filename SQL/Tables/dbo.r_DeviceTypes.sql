CREATE TABLE [dbo].[r_DeviceTypes] (
  [SrcPosID] [int] NOT NULL,
  [DeviceType] [int] NOT NULL,
  [DeviceTypeName] [varchar](250) NOT NULL,
  [AllowChooseCashType] [bit] NOT NULL DEFAULT (1),
  CONSTRAINT [pk_r_DeviceTypes] PRIMARY KEY CLUSTERED ([DeviceType])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TGMSRel1_Ins_r_DeviceTypes] ON [r_DeviceTypes]
FOR INSERT AS
/* r_DeviceTypes - Справочник типов устройств - INSERT TRIGGER */
BEGIN
  SET NOCOUNT ON

  RAISERROR ('Изменение системного справочника запрещено', 18, 1)
  ROLLBACK TRAN

END
GO

EXEC sp_settriggerorder N'dbo.TGMSRel1_Ins_r_DeviceTypes', N'First', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TGMSRel2_Upd_r_DeviceTypes] ON [r_DeviceTypes]
FOR UPDATE AS
/* r_DeviceTypes - Справочник типов устройств - UPDATE TRIGGER */
BEGIN
  SET NOCOUNT ON

  RAISERROR ('Изменение системного справочника запрещено', 18, 1)
  ROLLBACK TRAN

END
GO

EXEC sp_settriggerorder N'dbo.TGMSRel2_Upd_r_DeviceTypes', N'First', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TGMSRel3_Del_r_DeviceTypes] ON [r_DeviceTypes]
FOR DELETE AS
/* r_DeviceTypes - Справочник типов устройств - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON
  ROLLBACK TRAN
  RAISERROR ('Изменение системного справочника запрещено', 18, 1)

END
GO

EXEC sp_settriggerorder N'dbo.TGMSRel3_Del_r_DeviceTypes', N'First', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_DeviceTypes] ON [r_DeviceTypes]
FOR UPDATE AS
/* r_DeviceTypes - Справочник типов устройств - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DeviceTypes ^ r_PayFormCR - Обновление CHILD */
/* Справочник типов устройств ^ Справочник форм оплаты - Параметры РРО - Обновление CHILD */
  IF UPDATE(DeviceType)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CashType = i.DeviceType
          FROM r_PayFormCR a, inserted i, deleted d WHERE a.CashType = d.DeviceType
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_PayFormCR a, deleted d WHERE a.CashType = d.DeviceType)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник типов устройств'' => ''Справочник форм оплаты - Параметры РРО''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_DeviceTypes ^ r_LevyCR - Обновление CHILD */
/* Справочник типов устройств ^ Справочник сборов - Параметры РРО - Обновление CHILD */
  IF UPDATE(DeviceType)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CashType = i.DeviceType
          FROM r_LevyCR a, inserted i, deleted d WHERE a.CashType = d.DeviceType
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_LevyCR a, deleted d WHERE a.CashType = d.DeviceType)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник типов устройств'' => ''Справочник сборов - Параметры РРО''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_DeviceTypes', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_DeviceTypes] ON [r_DeviceTypes]
FOR DELETE AS
/* r_DeviceTypes - Справочник типов устройств - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_DeviceTypes ^ r_PayFormCR - Удаление в CHILD */
/* Справочник типов устройств ^ Справочник форм оплаты - Параметры РРО - Удаление в CHILD */
  DELETE r_PayFormCR FROM r_PayFormCR a, deleted d WHERE a.CashType = d.DeviceType
  IF @@ERROR > 0 RETURN

/* r_DeviceTypes ^ r_LevyCR - Удаление в CHILD */
/* Справочник типов устройств ^ Справочник сборов - Параметры РРО - Удаление в CHILD */
  DELETE r_LevyCR FROM r_LevyCR a, deleted d WHERE a.CashType = d.DeviceType
  IF @@ERROR > 0 RETURN

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_DeviceTypes', N'Last', N'DELETE'
GO