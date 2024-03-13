CREATE TABLE [dbo].[r_ProdLV]
(
[ProdID] [int] NOT NULL,
[LevyID] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ProdLV] ON [dbo].[r_ProdLV]
FOR INSERT AS
/* r_ProdLV - Справочник товаров - Сборы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdLV ^ r_Levies - Проверка в PARENT */
/* Справочник товаров - Сборы ^ Справочник сборов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.LevyID NOT IN (SELECT LevyID FROM r_Levies))
    BEGIN
      EXEC z_RelationError 'r_Levies', 'r_ProdLV', 0
      RETURN
    END

/* r_ProdLV ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Сборы ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_ProdLV', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_ProdLV]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ProdLV] ON [dbo].[r_ProdLV]
FOR UPDATE AS
/* r_ProdLV - Справочник товаров - Сборы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdLV ^ r_Levies - Проверка в PARENT */
/* Справочник товаров - Сборы ^ Справочник сборов - Проверка в PARENT */
  IF UPDATE(LevyID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.LevyID NOT IN (SELECT LevyID FROM r_Levies))
      BEGIN
        EXEC z_RelationError 'r_Levies', 'r_ProdLV', 1
        RETURN
      END

/* r_ProdLV ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Сборы ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_ProdLV', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_ProdLV]', 'last', 'update', null
GO
ALTER TABLE [dbo].[r_ProdLV] ADD CONSTRAINT [pk_r_ProdLV] PRIMARY KEY CLUSTERED ([ProdID], [LevyID]) ON [PRIMARY]
GO
