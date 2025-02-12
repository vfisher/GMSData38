CREATE TABLE [dbo].[t_LogDiscExp] (
  [LogID] [int] NOT NULL,
  [DBiID] [int] NOT NULL,
  [TempBonus] [bit] NOT NULL,
  [ChID] [bigint] NOT NULL,
  [DocCode] [int] NOT NULL,
  [SrcPosID] [int] NULL,
  [DiscCode] [int] NOT NULL,
  [SumBonus] [numeric](21, 9) NULL,
  [Discount] [numeric](21, 9) NULL,
  [LogDate] [smalldatetime] NOT NULL DEFAULT (getdate()),
  [BonusType] [int] NOT NULL DEFAULT (0),
  [GroupSumBonus] [numeric](21, 9) NULL,
  [GroupDiscount] [numeric](21, 9) NULL,
  [DCardChID] [bigint] NOT NULL,
  [IsManualSelDisc] [bit] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_t_LogDiscExp] PRIMARY KEY CLUSTERED ([LogID])
)
ON [PRIMARY]
GO

CREATE INDEX [DiscCode]
  ON [dbo].[t_LogDiscExp] ([DiscCode])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_LogDiscExp] ON [t_LogDiscExp]
FOR INSERT AS
/* t_LogDiscExp - Временные данные продаж - Скидки: Списание бонусов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_LogDiscExp ^ z_DocDC - Проверка в PARENT */
/* Временные данные продаж - Скидки: Списание бонусов ^ Документы - Дисконтные карты - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM z_DocDC m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.DocCode = m.DocCode AND i.DCardChID = m.DCardChID) <> @RCount
    BEGIN
      EXEC z_RelationError 'z_DocDC', 't_LogDiscExp', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_LogDiscExp', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_LogDiscExp] ON [t_LogDiscExp]
FOR UPDATE AS
/* t_LogDiscExp - Временные данные продаж - Скидки: Списание бонусов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_LogDiscExp ^ z_DocDC - Проверка в PARENT */
/* Временные данные продаж - Скидки: Списание бонусов ^ Документы - Дисконтные карты - Проверка в PARENT */
  IF UPDATE(ChID) OR UPDATE(DocCode) OR UPDATE(DCardChID)
    IF (SELECT COUNT(*) FROM z_DocDC m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.DocCode = m.DocCode AND i.DCardChID = m.DCardChID) <> @RCount
      BEGIN
        EXEC z_RelationError 'z_DocDC', 't_LogDiscExp', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_LogDiscExp', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_LogDiscExp] ON [t_LogDiscExp]
FOR DELETE AS
/* t_LogDiscExp - Временные данные продаж - Скидки: Списание бонусов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 1011 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_LogDiscExp', N'Last', N'DELETE'
GO

ALTER TABLE [dbo].[t_LogDiscExp]
  ADD CONSTRAINT [FK_t_LogDiscExp_r_DCards] FOREIGN KEY ([DCardChID]) REFERENCES [dbo].[r_DCards] ([ChID]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[t_LogDiscExp]
  ADD CONSTRAINT [FK_t_LogDiscExp_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode]) ON UPDATE CASCADE
GO