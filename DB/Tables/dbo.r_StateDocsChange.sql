CREATE TABLE [dbo].[r_StateDocsChange]
(
[UserCode] [smallint] NOT NULL,
[StateCode] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_StateDocsChange] ON [dbo].[r_StateDocsChange]
FOR INSERT AS
/* r_StateDocsChange - Справочник статусов: изменение документов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_StateDocsChange ^ r_States - Проверка в PARENT */
/* Справочник статусов: изменение документов ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'r_StateDocsChange', 0
      RETURN
    END

/* r_StateDocsChange ^ r_Users - Проверка в PARENT */
/* Справочник статусов: изменение документов ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserCode NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'r_StateDocsChange', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_StateDocsChange]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_StateDocsChange] ON [dbo].[r_StateDocsChange]
FOR UPDATE AS
/* r_StateDocsChange - Справочник статусов: изменение документов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_StateDocsChange ^ r_States - Проверка в PARENT */
/* Справочник статусов: изменение документов ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'r_StateDocsChange', 1
        RETURN
      END

/* r_StateDocsChange ^ r_Users - Проверка в PARENT */
/* Справочник статусов: изменение документов ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserCode NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'r_StateDocsChange', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_StateDocsChange]', 'last', 'update', null
GO
ALTER TABLE [dbo].[r_StateDocsChange] ADD CONSTRAINT [pk_r_StateDocsChange] PRIMARY KEY CLUSTERED ([UserCode], [StateCode]) ON [PRIMARY]
GO
