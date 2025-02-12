CREATE TABLE [dbo].[t_SaleTempM] (
  [ChID] [bigint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [ModCode] [int] NOT NULL,
  [ModQty] [int] NOT NULL,
  [IsProd] [bit] NOT NULL DEFAULT (0),
  [SaleSrcPosID] [int] NULL,
  CONSTRAINT [pk_t_SaleTempM] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID], [ModCode])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_SaleTempM] ON [t_SaleTempM]
FOR INSERT AS
/* t_SaleTempM - Временные данные продаж: Модификаторы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_SaleTempM ^ r_Mods - Проверка в PARENT */
/* Временные данные продаж: Модификаторы ^ Справочник ресторана: модификаторы блюд - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ModCode NOT IN (SELECT ModCode FROM r_Mods))
    BEGIN
      EXEC z_RelationError 'r_Mods', 't_SaleTempM', 0
      RETURN
    END

/* t_SaleTempM ^ t_SaleTempD - Проверка в PARENT */
/* Временные данные продаж: Модификаторы ^ Временные данные продаж: Товар - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM t_SaleTempD m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.SrcPosID = m.SrcPosID) <> @RCount
    BEGIN
      EXEC z_RelationError 't_SaleTempD', 't_SaleTempM', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_SaleTempM', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_SaleTempM] ON [t_SaleTempM]
FOR UPDATE AS
/* t_SaleTempM - Временные данные продаж: Модификаторы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_SaleTempM ^ r_Mods - Проверка в PARENT */
/* Временные данные продаж: Модификаторы ^ Справочник ресторана: модификаторы блюд - Проверка в PARENT */
  IF UPDATE(ModCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ModCode NOT IN (SELECT ModCode FROM r_Mods))
      BEGIN
        EXEC z_RelationError 'r_Mods', 't_SaleTempM', 1
        RETURN
      END

/* t_SaleTempM ^ t_SaleTempD - Проверка в PARENT */
/* Временные данные продаж: Модификаторы ^ Временные данные продаж: Товар - Проверка в PARENT */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    IF (SELECT COUNT(*) FROM t_SaleTempD m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.SrcPosID = m.SrcPosID) <> @RCount
      BEGIN
        EXEC z_RelationError 't_SaleTempD', 't_SaleTempM', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_SaleTempM', N'Last', N'UPDATE'
GO