CREATE TABLE [dbo].[r_MenuM]
(
[MenuID] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[SubmenuID] [int] NOT NULL DEFAULT ((0)),
[OrderID] [int] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_MenuM] ON [dbo].[r_MenuM]
FOR INSERT AS
/* r_MenuM - Справочник меню - подменю - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_MenuM ^ r_Menu - Проверка в PARENT */
/* Справочник меню - подменю ^ Справочник меню - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.MenuID NOT IN (SELECT MenuID FROM r_Menu))
    BEGIN
      EXEC z_RelationError 'r_Menu', 'r_MenuM', 0
      RETURN
    END

/* r_MenuM ^ r_Menu - Проверка в PARENT */
/* Справочник меню - подменю ^ Справочник меню - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SubmenuID NOT IN (SELECT MenuID FROM r_Menu))
    BEGIN
      EXEC z_RelationError 'r_Menu', 'r_MenuM', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_MenuM]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_MenuM] ON [dbo].[r_MenuM]
FOR UPDATE AS
/* r_MenuM - Справочник меню - подменю - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_MenuM ^ r_Menu - Проверка в PARENT */
/* Справочник меню - подменю ^ Справочник меню - Проверка в PARENT */
  IF UPDATE(MenuID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.MenuID NOT IN (SELECT MenuID FROM r_Menu))
      BEGIN
        EXEC z_RelationError 'r_Menu', 'r_MenuM', 1
        RETURN
      END

/* r_MenuM ^ r_Menu - Проверка в PARENT */
/* Справочник меню - подменю ^ Справочник меню - Проверка в PARENT */
  IF UPDATE(SubmenuID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SubmenuID NOT IN (SELECT MenuID FROM r_Menu))
      BEGIN
        EXEC z_RelationError 'r_Menu', 'r_MenuM', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_MenuM]', 'last', 'update', null
GO
ALTER TABLE [dbo].[r_MenuM] ADD CONSTRAINT [pk_r_MenuM] PRIMARY KEY CLUSTERED ([MenuID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubmenuID] ON [dbo].[r_MenuM] ([SubmenuID]) ON [PRIMARY]
GO
