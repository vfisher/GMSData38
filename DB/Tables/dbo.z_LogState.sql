CREATE TABLE [dbo].[z_LogState]
(
[LogID] [int] NOT NULL IDENTITY(1, 1),
[LogDate] [smalldatetime] NOT NULL DEFAULT (getdate()),
[StateRuleCode] [int] NOT NULL,
[DocCode] [int] NOT NULL,
[ChID] [bigint] NOT NULL,
[OldStateCode] [int] NOT NULL,
[NewStateCode] [int] NOT NULL,
[UserCode] [smallint] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_LogState] ON [dbo].[z_LogState]
FOR INSERT AS
/* z_LogState - Регистрация действий - Статусы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_LogState ^ r_States - Проверка в PARENT */
/* Регистрация действий - Статусы ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.NewStateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'z_LogState', 0
      RETURN
    END

/* z_LogState ^ r_States - Проверка в PARENT */
/* Регистрация действий - Статусы ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OldStateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'z_LogState', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_LogState]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_LogState] ON [dbo].[z_LogState]
FOR UPDATE AS
/* z_LogState - Регистрация действий - Статусы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_LogState ^ r_States - Проверка в PARENT */
/* Регистрация действий - Статусы ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(NewStateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.NewStateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'z_LogState', 1
        RETURN
      END

/* z_LogState ^ r_States - Проверка в PARENT */
/* Регистрация действий - Статусы ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(OldStateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OldStateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'z_LogState', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_LogState]', 'last', 'update', null
GO
ALTER TABLE [dbo].[z_LogState] ADD CONSTRAINT [pk_z_LogState] PRIMARY KEY CLUSTERED ([LogID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserCode] ON [dbo].[z_LogState] ([UserCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogState] ADD CONSTRAINT [FK_z_LogState_r_Users] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[r_Users] ([UserID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_LogState] ADD CONSTRAINT [FK_z_LogState_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
