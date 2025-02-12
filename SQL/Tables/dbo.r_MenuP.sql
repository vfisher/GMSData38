CREATE TABLE [dbo].[r_MenuP] (
  [MenuID] [int] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [ProdID] [int] NOT NULL,
  [Color] [int] NULL DEFAULT (0),
  [OrderID] [int] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_r_MenuP] PRIMARY KEY CLUSTERED ([MenuID], [SrcPosID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_MenuP] ON [r_MenuP]
FOR INSERT AS
/* r_MenuP - Справочник меню - товары - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_MenuP ^ r_Menu - Проверка в PARENT */
/* Справочник меню - товары ^ Справочник меню - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.MenuID NOT IN (SELECT MenuID FROM r_Menu))
    BEGIN
      EXEC z_RelationError 'r_Menu', 'r_MenuP', 0
      RETURN
    END

/* r_MenuP ^ r_Prods - Проверка в PARENT */
/* Справочник меню - товары ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_MenuP', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_MenuP', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_MenuP] ON [r_MenuP]
FOR UPDATE AS
/* r_MenuP - Справочник меню - товары - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_MenuP ^ r_Menu - Проверка в PARENT */
/* Справочник меню - товары ^ Справочник меню - Проверка в PARENT */
  IF UPDATE(MenuID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.MenuID NOT IN (SELECT MenuID FROM r_Menu))
      BEGIN
        EXEC z_RelationError 'r_Menu', 'r_MenuP', 1
        RETURN
      END

/* r_MenuP ^ r_Prods - Проверка в PARENT */
/* Справочник меню - товары ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_MenuP', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_MenuP', N'Last', N'UPDATE'
GO