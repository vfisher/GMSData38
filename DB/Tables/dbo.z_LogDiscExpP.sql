CREATE TABLE [dbo].[z_LogDiscExpP]
(
[DBiID] [int] NOT NULL,
[LogID] [int] NOT NULL,
[DocCode] [int] NOT NULL,
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NULL,
[DiscCode] [int] NOT NULL,
[SumBonus] [numeric] (21, 9) NULL,
[LogDate] [smalldatetime] NOT NULL,
[DCardChID] [bigint] NOT NULL CONSTRAINT [DF__z_LogDisc__DCard__213C71D1] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_LogDiscExpP] ON [dbo].[z_LogDiscExpP]
FOR INSERT AS
/* z_LogDiscExpP - Регистрация действий - Скидки - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_LogDiscExpP ^ t_Sale - Проверка в PARENT */
/* Регистрация действий - Скидки ^ Продажа товара оператором: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11035 AND i.ChID NOT IN (SELECT ChID FROM t_Sale))
    BEGIN
      EXEC z_RelationError 't_Sale', 'z_LogDiscExpP', 0
      RETURN
    END

/* z_LogDiscExpP ^ t_SaleTemp - Проверка в PARENT */
/* Регистрация действий - Скидки ^ Временные данные продаж: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 1011 AND i.ChID NOT IN (SELECT ChID FROM t_SaleTemp))
    BEGIN
      EXEC z_RelationError 't_SaleTemp', 'z_LogDiscExpP', 0
      RETURN
    END

/* z_LogDiscExpP ^ z_DocDC - Проверка в PARENT */
/* Регистрация действий - Скидки ^ Документы - Дисконтные карты - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM z_DocDC m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.DocCode = m.DocCode AND i.DCardChID = m.DCardChID) <> @RCount
    BEGIN
      EXEC z_RelationError 'z_DocDC', 'z_LogDiscExpP', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_LogDiscExpP]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_LogDiscExpP] ON [dbo].[z_LogDiscExpP]
FOR UPDATE AS
/* z_LogDiscExpP - Регистрация действий - Скидки - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_LogDiscExpP ^ t_Sale - Проверка в PARENT */
/* Регистрация действий - Скидки ^ Продажа товара оператором: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11035 AND i.ChID NOT IN (SELECT ChID FROM t_Sale))
      BEGIN
        EXEC z_RelationError 't_Sale', 'z_LogDiscExpP', 1
        RETURN
      END

/* z_LogDiscExpP ^ t_SaleTemp - Проверка в PARENT */
/* Регистрация действий - Скидки ^ Временные данные продаж: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 1011 AND i.ChID NOT IN (SELECT ChID FROM t_SaleTemp))
      BEGIN
        EXEC z_RelationError 't_SaleTemp', 'z_LogDiscExpP', 1
        RETURN
      END

/* z_LogDiscExpP ^ z_DocDC - Проверка в PARENT */
/* Регистрация действий - Скидки ^ Документы - Дисконтные карты - Проверка в PARENT */
  IF UPDATE(ChID) OR UPDATE(DocCode) OR UPDATE(DCardChID)
    IF (SELECT COUNT(*) FROM z_DocDC m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.DocCode = m.DocCode AND i.DCardChID = m.DCardChID) <> @RCount
      BEGIN
        EXEC z_RelationError 'z_DocDC', 'z_LogDiscExpP', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_LogDiscExpP]', 'last', 'update', null
GO
ALTER TABLE [dbo].[z_LogDiscExpP] ADD CONSTRAINT [pk_z_LogDiscExpP] PRIMARY KEY CLUSTERED ([DBiID], [LogID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCode_ChID_SrcPosID] ON [dbo].[z_LogDiscExpP] ([DocCode], [ChID], [SrcPosID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogDiscExpP] ADD CONSTRAINT [FK_z_LogDiscExpP_r_DCards] FOREIGN KEY ([DCardChID]) REFERENCES [dbo].[r_DCards] ([ChID]) ON UPDATE CASCADE
GO
