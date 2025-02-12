CREATE TABLE [dbo].[r_BankGrs] (
  [ChID] [bigint] NOT NULL,
  [BankGrID] [int] NOT NULL,
  [BankGrName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [pk_r_BankGrs] PRIMARY KEY CLUSTERED ([BankGrID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [BankGrName]
  ON [dbo].[r_BankGrs] ([BankGrName])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_BankGrs] ON [r_BankGrs]
FOR UPDATE AS
/* r_BankGrs - Справочник банков - группы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_BankGrs ^ r_BServs - Обновление CHILD */
/* Справочник банков - группы ^ Справочник банковских услуг - Обновление CHILD */
  IF UPDATE(BankGrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.BankGrID = i.BankGrID
          FROM r_BServs a, inserted i, deleted d WHERE a.BankGrID = d.BankGrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_BServs a, deleted d WHERE a.BankGrID = d.BankGrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник банков - группы'' => ''Справочник банковских услуг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_BankGrs ^ r_Banks - Обновление CHILD */
/* Справочник банков - группы ^ Справочник банков - Обновление CHILD */
  IF UPDATE(BankGrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.BankGrID = i.BankGrID
          FROM r_Banks a, inserted i, deleted d WHERE a.BankGrID = d.BankGrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Banks a, deleted d WHERE a.BankGrID = d.BankGrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник банков - группы'' => ''Справочник банков''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_BankGrs', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_BankGrs] ON [r_BankGrs]
FOR DELETE AS
/* r_BankGrs - Справочник банков - группы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_BankGrs ^ r_BServs - Проверка в CHILD */
/* Справочник банков - группы ^ Справочник банковских услуг - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_BServs a WITH(NOLOCK), deleted d WHERE a.BankGrID = d.BankGrID)
    BEGIN
      EXEC z_RelationError 'r_BankGrs', 'r_BServs', 3
      RETURN
    END

/* r_BankGrs ^ r_Banks - Проверка в CHILD */
/* Справочник банков - группы ^ Справочник банков - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Banks a WITH(NOLOCK), deleted d WHERE a.BankGrID = d.BankGrID)
    BEGIN
      EXEC z_RelationError 'r_BankGrs', 'r_Banks', 3
      RETURN
    END

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10102 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_BankGrs', N'Last', N'DELETE'
GO