CREATE TABLE [dbo].[r_Menu] (
  [ChID] [bigint] NOT NULL,
  [MenuID] [int] NOT NULL,
  [MenuName] [varchar](200) NOT NULL,
  [Notes] [varchar](250) NULL,
  [Picture] [image] NULL,
  [BgColor] [int] NULL DEFAULT (0),
  CONSTRAINT [pk_r_Menu] PRIMARY KEY CLUSTERED ([MenuID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Menu] ([ChID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Menu] ON [r_Menu]
FOR UPDATE AS
/* r_Menu - Справочник меню - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Menu ^ r_WPRoles - Обновление CHILD */
/* Справочник меню ^ Справочник рабочих мест: роли - Обновление CHILD */
  IF UPDATE(MenuID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.MenuID = i.MenuID
          FROM r_WPRoles a, inserted i, deleted d WHERE a.MenuID = d.MenuID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_WPRoles a, deleted d WHERE a.MenuID = d.MenuID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник меню'' => ''Справочник рабочих мест: роли''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Menu ^ r_MenuM - Обновление CHILD */
/* Справочник меню ^ Справочник меню - подменю - Обновление CHILD */
  IF UPDATE(MenuID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.MenuID = i.MenuID
          FROM r_MenuM a, inserted i, deleted d WHERE a.MenuID = d.MenuID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_MenuM a, deleted d WHERE a.MenuID = d.MenuID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник меню'' => ''Справочник меню - подменю''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Menu ^ r_MenuM - Проверка в CHILD */
/* Справочник меню ^ Справочник меню - подменю - Проверка в CHILD */
  IF UPDATE(MenuID) IF EXISTS (SELECT * FROM r_MenuM a WITH(NOLOCK), deleted d WHERE a.SubmenuID = d.MenuID)
    BEGIN
      EXEC z_RelationError 'r_Menu', 'r_MenuM', 2
      RETURN
    END

/* r_Menu ^ r_MenuP - Обновление CHILD */
/* Справочник меню ^ Справочник меню - товары - Обновление CHILD */
  IF UPDATE(MenuID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.MenuID = i.MenuID
          FROM r_MenuP a, inserted i, deleted d WHERE a.MenuID = d.MenuID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_MenuP a, deleted d WHERE a.MenuID = d.MenuID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник меню'' => ''Справочник меню - товары''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Menu', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Menu] ON [r_Menu]
FOR DELETE AS
/* r_Menu - Справочник меню - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Menu ^ r_WPRoles - Проверка в CHILD */
/* Справочник меню ^ Справочник рабочих мест: роли - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_WPRoles a WITH(NOLOCK), deleted d WHERE a.MenuID = d.MenuID)
    BEGIN
      EXEC z_RelationError 'r_Menu', 'r_WPRoles', 3
      RETURN
    END

/* r_Menu ^ r_MenuM - Удаление в CHILD */
/* Справочник меню ^ Справочник меню - подменю - Удаление в CHILD */
  DELETE r_MenuM FROM r_MenuM a, deleted d WHERE a.MenuID = d.MenuID
  IF @@ERROR > 0 RETURN

/* r_Menu ^ r_MenuM - Проверка в CHILD */
/* Справочник меню ^ Справочник меню - подменю - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_MenuM a WITH(NOLOCK), deleted d WHERE a.SubmenuID = d.MenuID)
    BEGIN
      EXEC z_RelationError 'r_Menu', 'r_MenuM', 3
      RETURN
    END

/* r_Menu ^ r_MenuP - Удаление в CHILD */
/* Справочник меню ^ Справочник меню - товары - Удаление в CHILD */
  DELETE r_MenuP FROM r_MenuP a, deleted d WHERE a.MenuID = d.MenuID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10610 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Menu', N'Last', N'DELETE'
GO