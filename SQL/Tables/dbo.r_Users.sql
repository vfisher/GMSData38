CREATE TABLE [dbo].[r_Users] (
  [ChID] [bigint] NOT NULL,
  [UserID] [smallint] NOT NULL,
  [UserName] [varchar](250) NOT NULL,
  [EmpID] [int] NOT NULL,
  [Admin] [bit] NOT NULL,
  [Active] [bit] NOT NULL,
  [Emps] [bit] NULL,
  [s_PPAcc] [bit] NOT NULL,
  [s_Cost] [bit] NOT NULL,
  [s_CCPL] [bit] NOT NULL,
  [s_CCPrice] [bit] NOT NULL,
  [s_CCDiscount] [bit] NOT NULL,
  [CanCopyRems] [bit] NOT NULL,
  [BDate] [smalldatetime] NOT NULL,
  [EDate] [smalldatetime] NOT NULL,
  [UseOpenAge] [bit] NOT NULL,
  [CanInitAltsPL] [bit] NOT NULL,
  [ShowPLCange] [bit] NULL,
  [CanChangeStatus] [bit] NOT NULL,
  [CanChangeDiscount] [bit] NOT NULL,
  [CanPrintDoc] [bit] NOT NULL,
  [CanBuffDoc] [bit] NOT NULL,
  [CanChangeDocID] [bit] NOT NULL,
  [CanChangeKursMC] [bit] NOT NULL,
  [AllowRestEditDesk] [bit] NOT NULL,
  [AllowRestReserve] [bit] NOT NULL,
  [AllowRestMove] [bit] NOT NULL,
  [CanExportPrint] [bit] NOT NULL,
  [p_SalaryAcc] [bit] NOT NULL,
  [AllowRestChequeUnite] [bit] NOT NULL DEFAULT (1),
  [AllowRestChequeDel] [bit] NOT NULL DEFAULT (1),
  [OpenAgeBType] [tinyint] NOT NULL DEFAULT (0),
  [OpenAgeBQty] [smallint] NOT NULL DEFAULT (0),
  [OpenAgeEType] [tinyint] NOT NULL DEFAULT (0),
  [OpenAgeEQty] [smallint] NOT NULL DEFAULT (0),
  [AllowRestViewDesk] [bit] NOT NULL DEFAULT (1),
  CONSTRAINT [pk_r_Users] PRIMARY KEY CLUSTERED ([UserID])
)
ON [PRIMARY]
GO

CREATE INDEX [BDate]
  ON [dbo].[r_Users] ([BDate])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Users] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [EDate]
  ON [dbo].[r_Users] ([EDate])
  ON [PRIMARY]
GO

CREATE INDEX [EmpID]
  ON [dbo].[r_Users] ([EmpID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UserName]
  ON [dbo].[r_Users] ([UserName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.UserID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.EmpID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.Admin'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.Active'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.Emps'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.s_PPAcc'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.s_Cost'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.s_CCPL'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.s_CCPrice'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.s_CCDiscount'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.CanCopyRems'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.UseOpenAge'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.CanInitAltsPL'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.ShowPLCange'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.CanChangeStatus'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.CanChangeDiscount'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.CanPrintDoc'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.CanBuffDoc'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.CanChangeDocID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Users.CanChangeKursMC'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Users] ON [r_Users]
FOR INSERT AS
/* r_Users - Справочник пользователей - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Users ^ r_Emps - Проверка в PARENT */
/* Справочник пользователей ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_Users', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10125001, ChID, 
    '[' + cast(i.UserID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_Users', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Users] ON [r_Users]
FOR UPDATE AS
/* r_Users - Справочник пользователей - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Users ^ r_Emps - Проверка в PARENT */
/* Справочник пользователей ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'r_Users', 1
        RETURN
      END

/* r_Users ^ r_StateDocsChange - Обновление CHILD */
/* Справочник пользователей ^ Справочник статусов: изменение документов - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserCode = i.UserID
          FROM r_StateDocsChange a, inserted i, deleted d WHERE a.UserCode = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_StateDocsChange a, deleted d WHERE a.UserCode = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Справочник статусов: изменение документов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ b_GViewU - Обновление CHILD */
/* Справочник пользователей ^ Бухгалтерия: Виды отчетов (Настройки пользователя) - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM b_GViewU a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GViewU a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Бухгалтерия: Виды отчетов (Настройки пользователя)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ r_ProdMPCh - Обновление CHILD */
/* Справочник пользователей ^ Изменение цен продажи (Таблица) - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM r_ProdMPCh a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdMPCh a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Изменение цен продажи (Таблица)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ t_PInPCh - Обновление CHILD */
/* Справочник пользователей ^ Изменение цен прихода: Бизнес - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM t_PInPCh a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_PInPCh a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Изменение цен прихода: Бизнес''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ t_VenI - Обновление CHILD */
/* Справочник пользователей ^ Инвентаризация товара: Первичные данные - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM t_VenI a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_VenI a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Инвентаризация товара: Первичные данные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ v_RepUsers - Обновление CHILD */
/* Справочник пользователей ^ Анализатор - Доступ к отчету - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM v_RepUsers a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM v_RepUsers a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Анализатор - Доступ к отчету''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ v_UFields - Обновление CHILD */
/* Справочник пользователей ^ Анализатор - Поля пользователя - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM v_UFields a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM v_UFields a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Анализатор - Поля пользователя''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ v_UParams - Обновление CHILD */
/* Справочник пользователей ^ Анализатор - Параметры пользователя - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM v_UParams a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM v_UParams a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Анализатор - Параметры пользователя''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ v_UReps - Обновление CHILD */
/* Справочник пользователей ^ Анализатор - Отчеты пользователя - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM v_UReps a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM v_UReps a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Анализатор - Отчеты пользователя''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_OpenAge - Обновление CHILD */
/* Справочник пользователей ^ Открытый период: Фирмы - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChUserID = i.UserID
          FROM z_OpenAge a, inserted i, deleted d WHERE a.ChUserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_OpenAge a, deleted d WHERE a.ChUserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Открытый период: Фирмы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_OpenAgeH - Обновление CHILD */
/* Справочник пользователей ^ Открытый период: Фирмы: История - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChUserID = i.UserID
          FROM z_OpenAgeH a, inserted i, deleted d WHERE a.ChUserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_OpenAgeH a, deleted d WHERE a.ChUserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Открытый период: Фирмы: История''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_UserCodes1 - Обновление CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник признаков 1 - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM z_UserCodes1 a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserCodes1 a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Доступные значения - Справочник признаков 1''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_UserCodes2 - Обновление CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник признаков 2 - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM z_UserCodes2 a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserCodes2 a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Доступные значения - Справочник признаков 2''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_UserCodes3 - Обновление CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник признаков 3 - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM z_UserCodes3 a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserCodes3 a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Доступные значения - Справочник признаков 3''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_UserCodes4 - Обновление CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник признаков 4 - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM z_UserCodes4 a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserCodes4 a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Доступные значения - Справочник признаков 4''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_UserCodes5 - Обновление CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник признаков 5 - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM z_UserCodes5 a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserCodes5 a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Доступные значения - Справочник признаков 5''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_UserCompG - Обновление CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник предприятий: группы - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM z_UserCompG a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserCompG a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Доступные значения - Справочник предприятий: группы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_UserComps - Обновление CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник предприятий - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM z_UserComps a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserComps a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Доступные значения - Справочник предприятий''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_UserOpenAge - Обновление CHILD */
/* Справочник пользователей ^ Открытый период: Пользователи - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChUserID = i.UserID
          FROM z_UserOpenAge a, inserted i, deleted d WHERE a.ChUserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserOpenAge a, deleted d WHERE a.ChUserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Открытый период: Пользователи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_UserOpenAge - Обновление CHILD */
/* Справочник пользователей ^ Открытый период: Пользователи - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM z_UserOpenAge a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserOpenAge a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Открытый период: Пользователи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_UserOpenAgeH - Обновление CHILD */
/* Справочник пользователей ^ Открытый период: Пользователи: История - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChUserID = i.UserID
          FROM z_UserOpenAgeH a, inserted i, deleted d WHERE a.ChUserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserOpenAgeH a, deleted d WHERE a.ChUserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Открытый период: Пользователи: История''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_UserOpenAgeH - Обновление CHILD */
/* Справочник пользователей ^ Открытый период: Пользователи: История - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM z_UserOpenAgeH a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserOpenAgeH a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Открытый период: Пользователи: История''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_UserOurs - Обновление CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник внутренних фирм - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM z_UserOurs a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserOurs a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Доступные значения - Справочник внутренних фирм''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_UserPLs - Обновление CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник прайс-листов - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM z_UserPLs a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserPLs a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Доступные значения - Справочник прайс-листов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_UserProdC - Обновление CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник товаров: 1 группа - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM z_UserProdC a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserProdC a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Доступные значения - Справочник товаров: 1 группа''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_UserProdG - Обновление CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник товаров: 2 группа - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM z_UserProdG a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserProdG a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Доступные значения - Справочник товаров: 2 группа''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_UserProdG1 - Обновление CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник товаров: 3 группа - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM z_UserProdG1 a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserProdG1 a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Доступные значения - Справочник товаров: 3 группа''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_UserStockGs - Обновление CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник складов: группы - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM z_UserStockGs a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserStockGs a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Доступные значения - Справочник складов: группы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_UserStocks - Обновление CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник складов - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM z_UserStocks a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserStocks a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Доступные значения - Справочник складов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_Vars - Обновление CHILD */
/* Справочник пользователей ^ Системные переменные - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 'Sync_User', a.VarValue = i.UserID
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 'Sync_User' AND a.VarValue = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 'Sync_User' AND a.VarValue = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Системные переменные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_WCopyFUF - Обновление CHILD */
/* Справочник пользователей ^ Мастер Копирования - Фильтры пользователя - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM z_WCopyFUF a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopyFUF a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Мастер Копирования - Фильтры пользователя''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_WCopyFVUF - Обновление CHILD */
/* Справочник пользователей ^ Мастер Копирования - Фильтры пользователя для вариантов - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM z_WCopyFVUF a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopyFVUF a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Мастер Копирования - Фильтры пользователя для вариантов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Users ^ z_WCopyU - Обновление CHILD */
/* Справочник пользователей ^ Мастер Копирования - Параметры пользователя - Обновление CHILD */
  IF UPDATE(UserID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UserID = i.UserID
          FROM z_WCopyU a, inserted i, deleted d WHERE a.UserID = d.UserID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopyU a, deleted d WHERE a.UserID = d.UserID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник пользователей'' => ''Мастер Копирования - Параметры пользователя''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10125001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10125001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(UserID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10125001 AND l.PKValue = 
        '[' + cast(i.UserID as varchar(200)) + ']' AND i.UserID = d.UserID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10125001 AND l.PKValue = 
        '[' + cast(i.UserID as varchar(200)) + ']' AND i.UserID = d.UserID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10125001, ChID, 
          '[' + cast(d.UserID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10125001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10125001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10125001, ChID, 
          '[' + cast(i.UserID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(UserID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT UserID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT UserID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.UserID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10125001 AND l.PKValue = 
          '[' + cast(d.UserID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.UserID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10125001 AND l.PKValue = 
          '[' + cast(d.UserID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10125001, ChID, 
          '[' + cast(d.UserID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10125001 AND PKValue IN (SELECT 
          '[' + cast(UserID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10125001 AND PKValue IN (SELECT 
          '[' + cast(UserID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10125001, ChID, 
          '[' + cast(i.UserID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10125001, ChID, 
    '[' + cast(i.UserID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Users', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Users] ON [r_Users]
FOR DELETE AS
/* r_Users - Справочник пользователей - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Users ^ r_StateDocsChange - Удаление в CHILD */
/* Справочник пользователей ^ Справочник статусов: изменение документов - Удаление в CHILD */
  DELETE r_StateDocsChange FROM r_StateDocsChange a, deleted d WHERE a.UserCode = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ b_GViewU - Удаление в CHILD */
/* Справочник пользователей ^ Бухгалтерия: Виды отчетов (Настройки пользователя) - Удаление в CHILD */
  DELETE b_GViewU FROM b_GViewU a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ r_ProdMPCh - Проверка в CHILD */
/* Справочник пользователей ^ Изменение цен продажи (Таблица) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ProdMPCh a WITH(NOLOCK), deleted d WHERE a.UserID = d.UserID)
    BEGIN
      EXEC z_RelationError 'r_Users', 'r_ProdMPCh', 3
      RETURN
    END

/* r_Users ^ t_PInPCh - Проверка в CHILD */
/* Справочник пользователей ^ Изменение цен прихода: Бизнес - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_PInPCh a WITH(NOLOCK), deleted d WHERE a.UserID = d.UserID)
    BEGIN
      EXEC z_RelationError 'r_Users', 't_PInPCh', 3
      RETURN
    END

/* r_Users ^ t_VenI - Проверка в CHILD */
/* Справочник пользователей ^ Инвентаризация товара: Первичные данные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_VenI a WITH(NOLOCK), deleted d WHERE a.UserID = d.UserID)
    BEGIN
      EXEC z_RelationError 'r_Users', 't_VenI', 3
      RETURN
    END

/* r_Users ^ v_RepUsers - Удаление в CHILD */
/* Справочник пользователей ^ Анализатор - Доступ к отчету - Удаление в CHILD */
  DELETE v_RepUsers FROM v_RepUsers a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ v_UFields - Удаление в CHILD */
/* Справочник пользователей ^ Анализатор - Поля пользователя - Удаление в CHILD */
  DELETE v_UFields FROM v_UFields a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ v_UParams - Удаление в CHILD */
/* Справочник пользователей ^ Анализатор - Параметры пользователя - Удаление в CHILD */
  DELETE v_UParams FROM v_UParams a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ v_UReps - Удаление в CHILD */
/* Справочник пользователей ^ Анализатор - Отчеты пользователя - Удаление в CHILD */
  DELETE v_UReps FROM v_UReps a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ z_OpenAge - Проверка в CHILD */
/* Справочник пользователей ^ Открытый период: Фирмы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_OpenAge a WITH(NOLOCK), deleted d WHERE a.ChUserID = d.UserID)
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_OpenAge', 3
      RETURN
    END

/* r_Users ^ z_OpenAgeH - Проверка в CHILD */
/* Справочник пользователей ^ Открытый период: Фирмы: История - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_OpenAgeH a WITH(NOLOCK), deleted d WHERE a.ChUserID = d.UserID)
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_OpenAgeH', 3
      RETURN
    END

/* r_Users ^ z_UserCodes1 - Удаление в CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник признаков 1 - Удаление в CHILD */
  DELETE z_UserCodes1 FROM z_UserCodes1 a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ z_UserCodes2 - Удаление в CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник признаков 2 - Удаление в CHILD */
  DELETE z_UserCodes2 FROM z_UserCodes2 a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ z_UserCodes3 - Удаление в CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник признаков 3 - Удаление в CHILD */
  DELETE z_UserCodes3 FROM z_UserCodes3 a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ z_UserCodes4 - Удаление в CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник признаков 4 - Удаление в CHILD */
  DELETE z_UserCodes4 FROM z_UserCodes4 a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ z_UserCodes5 - Удаление в CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник признаков 5 - Удаление в CHILD */
  DELETE z_UserCodes5 FROM z_UserCodes5 a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ z_UserCompG - Удаление в CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник предприятий: группы - Удаление в CHILD */
  DELETE z_UserCompG FROM z_UserCompG a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ z_UserComps - Удаление в CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник предприятий - Удаление в CHILD */
  DELETE z_UserComps FROM z_UserComps a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ z_UserOpenAge - Проверка в CHILD */
/* Справочник пользователей ^ Открытый период: Пользователи - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_UserOpenAge a WITH(NOLOCK), deleted d WHERE a.ChUserID = d.UserID)
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserOpenAge', 3
      RETURN
    END

/* r_Users ^ z_UserOpenAge - Проверка в CHILD */
/* Справочник пользователей ^ Открытый период: Пользователи - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_UserOpenAge a WITH(NOLOCK), deleted d WHERE a.UserID = d.UserID)
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserOpenAge', 3
      RETURN
    END

/* r_Users ^ z_UserOpenAgeH - Проверка в CHILD */
/* Справочник пользователей ^ Открытый период: Пользователи: История - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_UserOpenAgeH a WITH(NOLOCK), deleted d WHERE a.ChUserID = d.UserID)
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserOpenAgeH', 3
      RETURN
    END

/* r_Users ^ z_UserOpenAgeH - Проверка в CHILD */
/* Справочник пользователей ^ Открытый период: Пользователи: История - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_UserOpenAgeH a WITH(NOLOCK), deleted d WHERE a.UserID = d.UserID)
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserOpenAgeH', 3
      RETURN
    END

/* r_Users ^ z_UserOurs - Удаление в CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник внутренних фирм - Удаление в CHILD */
  DELETE z_UserOurs FROM z_UserOurs a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ z_UserPLs - Удаление в CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник прайс-листов - Удаление в CHILD */
  DELETE z_UserPLs FROM z_UserPLs a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ z_UserProdC - Удаление в CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник товаров: 1 группа - Удаление в CHILD */
  DELETE z_UserProdC FROM z_UserProdC a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ z_UserProdG - Удаление в CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник товаров: 2 группа - Удаление в CHILD */
  DELETE z_UserProdG FROM z_UserProdG a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ z_UserProdG1 - Удаление в CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник товаров: 3 группа - Удаление в CHILD */
  DELETE z_UserProdG1 FROM z_UserProdG1 a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ z_UserStockGs - Удаление в CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник складов: группы - Удаление в CHILD */
  DELETE z_UserStockGs FROM z_UserStockGs a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ z_UserStocks - Удаление в CHILD */
/* Справочник пользователей ^ Доступные значения - Справочник складов - Удаление в CHILD */
  DELETE z_UserStocks FROM z_UserStocks a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ z_Vars - Проверка в CHILD */
/* Справочник пользователей ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 'Sync_User' AND a.VarValue = d.UserID)
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_Vars', 3
      RETURN
    END

/* r_Users ^ z_WCopyFUF - Удаление в CHILD */
/* Справочник пользователей ^ Мастер Копирования - Фильтры пользователя - Удаление в CHILD */
  DELETE z_WCopyFUF FROM z_WCopyFUF a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ z_WCopyFVUF - Удаление в CHILD */
/* Справочник пользователей ^ Мастер Копирования - Фильтры пользователя для вариантов - Удаление в CHILD */
  DELETE z_WCopyFVUF FROM z_WCopyFVUF a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* r_Users ^ z_WCopyU - Удаление в CHILD */
/* Справочник пользователей ^ Мастер Копирования - Параметры пользователя - Удаление в CHILD */
  DELETE z_WCopyU FROM z_WCopyU a, deleted d WHERE a.UserID = d.UserID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10125001 AND m.PKValue = 
    '[' + cast(i.UserID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10125001 AND m.PKValue = 
    '[' + cast(i.UserID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10125001, -ChID, 
    '[' + cast(d.UserID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10125 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Users', N'Last', N'DELETE'
GO