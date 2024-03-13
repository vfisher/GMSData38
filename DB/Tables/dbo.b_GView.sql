CREATE TABLE [dbo].[b_GView]
(
[DocCode] [int] NOT NULL,
[ViewID] [int] NOT NULL,
[ViewName] [varchar] (200) NOT NULL,
[DTrans] [bit] NOT NULL,
[CTrans] [bit] NOT NULL,
[Standard] [bit] NOT NULL,
[CBoxState1] [bit] NOT NULL,
[CBoxState2] [bit] NOT NULL,
[CBoxState3] [bit] NOT NULL,
[CBoxState4] [bit] NOT NULL,
[CBoxState5] [bit] NOT NULL,
[CBoxState6] [bit] NOT NULL,
[CBoxState7] [bit] NOT NULL,
[ABoxState1] [tinyint] NOT NULL,
[ABoxState2] [tinyint] NOT NULL,
[ABoxState3] [tinyint] NOT NULL,
[OurList] [varchar] (200) NULL,
[D_GAccs] [varchar] (200) NULL,
[C_GAccs] [varchar] (200) NULL,
[D_GAccUse] [bit] NOT NULL,
[C_GAccUse] [bit] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_GView] ON [dbo].[b_GView]
FOR UPDATE AS
/* b_GView - Бухгалтерия: Виды отчетов (Заголовок) - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_GView ^ b_GViewD - Обновление CHILD */
/* Бухгалтерия: Виды отчетов (Заголовок) ^ Бухгалтерия: Виды отчетов (Данные) - Обновление CHILD */
  IF UPDATE(ViewID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ViewID = i.ViewID
          FROM b_GViewD a, inserted i, deleted d WHERE a.ViewID = d.ViewID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GViewD a, deleted d WHERE a.ViewID = d.ViewID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Бухгалтерия: Виды отчетов (Заголовок)'' => ''Бухгалтерия: Виды отчетов (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_GView ^ b_GViewU - Обновление CHILD */
/* Бухгалтерия: Виды отчетов (Заголовок) ^ Бухгалтерия: Виды отчетов (Настройки пользователя) - Обновление CHILD */
  IF UPDATE(ViewID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ViewID = i.ViewID
          FROM b_GViewU a, inserted i, deleted d WHERE a.ViewID = d.ViewID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GViewU a, deleted d WHERE a.ViewID = d.ViewID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Бухгалтерия: Виды отчетов (Заголовок)'' => ''Бухгалтерия: Виды отчетов (Настройки пользователя)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_b_GView]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_GView] ON [dbo].[b_GView]FOR DELETE AS/* b_GView - Бухгалтерия: Виды отчетов (Заголовок) - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* b_GView ^ b_GViewD - Удаление в CHILD *//* Бухгалтерия: Виды отчетов (Заголовок) ^ Бухгалтерия: Виды отчетов (Данные) - Удаление в CHILD */  DELETE b_GViewD FROM b_GViewD a, deleted d WHERE a.ViewID = d.ViewID  IF @@ERROR > 0 RETURN/* b_GView ^ b_GViewU - Удаление в CHILD *//* Бухгалтерия: Виды отчетов (Заголовок) ^ Бухгалтерия: Виды отчетов (Настройки пользователя) - Удаление в CHILD */  DELETE b_GViewU FROM b_GViewU a, deleted d WHERE a.ViewID = d.ViewID  IF @@ERROR > 0 RETURNEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_b_GView]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[b_GView] ADD CONSTRAINT [_pk_b_GView] PRIMARY KEY CLUSTERED ([ViewID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocType] ON [dbo].[b_GView] ([DocCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ViewName] ON [dbo].[b_GView] ([ViewName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[DocCode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[ViewID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[DTrans]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CTrans]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[Standard]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState6]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState7]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[ABoxState1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[ABoxState2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[ABoxState3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[D_GAccUse]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[C_GAccUse]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[DocCode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[ViewID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[DTrans]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CTrans]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[Standard]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState6]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState7]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[ABoxState1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[ABoxState2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[ABoxState3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[D_GAccUse]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[C_GAccUse]'
GO
