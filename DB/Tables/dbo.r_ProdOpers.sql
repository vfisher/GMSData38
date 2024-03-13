CREATE TABLE [dbo].[r_ProdOpers]
(
[ProdID] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[OperDesc] [varchar] (255) NOT NULL,
[Percent1] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[Percent2] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[IsDefault] [bit] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ProdOpers] ON [dbo].[r_ProdOpers]
FOR INSERT AS
/* r_ProdOpers - Справочник товаров: Виды операций и потери - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdOpers ^ r_Prods - Проверка в PARENT */
/* Справочник товаров: Виды операций и потери ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_ProdOpers', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_ProdOpers]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ProdOpers] ON [dbo].[r_ProdOpers]
FOR UPDATE AS
/* r_ProdOpers - Справочник товаров: Виды операций и потери - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdOpers ^ r_Prods - Проверка в PARENT */
/* Справочник товаров: Виды операций и потери ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_ProdOpers', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_ProdOpers]', 'last', 'update', null
GO
ALTER TABLE [dbo].[r_ProdOpers] ADD CONSTRAINT [pk_r_ProdOpers] PRIMARY KEY CLUSTERED ([ProdID], [SrcPosID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[r_ProdOpers] ([ProdID], [OperDesc]) ON [PRIMARY]
GO
