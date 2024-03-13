CREATE TABLE [dbo].[b_GViewU]
(
[ViewID] [int] NOT NULL,
[UserID] [smallint] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_GViewU] ON [dbo].[b_GViewU]
FOR INSERT AS
/* b_GViewU - Бухгалтерия: Виды отчетов (Настройки пользователя) - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_GViewU ^ b_GView - Проверка в PARENT */
/* Бухгалтерия: Виды отчетов (Настройки пользователя) ^ Бухгалтерия: Виды отчетов (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ViewID NOT IN (SELECT ViewID FROM b_GView))
    BEGIN
      EXEC z_RelationError 'b_GView', 'b_GViewU', 0
      RETURN
    END

/* b_GViewU ^ r_Users - Проверка в PARENT */
/* Бухгалтерия: Виды отчетов (Настройки пользователя) ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'b_GViewU', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_b_GViewU]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_GViewU] ON [dbo].[b_GViewU]
FOR UPDATE AS
/* b_GViewU - Бухгалтерия: Виды отчетов (Настройки пользователя) - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_GViewU ^ b_GView - Проверка в PARENT */
/* Бухгалтерия: Виды отчетов (Настройки пользователя) ^ Бухгалтерия: Виды отчетов (Заголовок) - Проверка в PARENT */
  IF UPDATE(ViewID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ViewID NOT IN (SELECT ViewID FROM b_GView))
      BEGIN
        EXEC z_RelationError 'b_GView', 'b_GViewU', 1
        RETURN
      END

/* b_GViewU ^ r_Users - Проверка в PARENT */
/* Бухгалтерия: Виды отчетов (Настройки пользователя) ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'b_GViewU', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_b_GViewU]', 'last', 'update', null
GO
ALTER TABLE [dbo].[b_GViewU] ADD CONSTRAINT [_pk_b_GViewU] PRIMARY KEY CLUSTERED ([ViewID], [UserID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[b_GViewU] ([UserID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ViewID] ON [dbo].[b_GViewU] ([ViewID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewU].[ViewID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewU].[UserID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewU].[ViewID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewU].[UserID]'
GO
