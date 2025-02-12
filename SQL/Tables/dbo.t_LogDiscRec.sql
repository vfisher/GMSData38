CREATE TABLE [dbo].[t_LogDiscRec] (
  [LogID] [int] NOT NULL,
  [DBiID] [int] NOT NULL,
  [TempBonus] [bit] NOT NULL,
  [ChID] [bigint] NOT NULL,
  [DocCode] [int] NOT NULL,
  [SrcPosID] [int] NULL,
  [DiscCode] [int] NOT NULL,
  [SumBonus] [numeric](21, 9) NULL,
  [LogDate] [smalldatetime] NOT NULL DEFAULT (getdate()),
  [BonusType] [int] NOT NULL DEFAULT (0),
  [SaleSrcPosID] [int] NULL,
  [DCardChID] [bigint] NOT NULL,
  CONSTRAINT [pk_t_LogDiscRec] PRIMARY KEY CLUSTERED ([LogID])
)
ON [PRIMARY]
GO

CREATE INDEX [DiscCode]
  ON [dbo].[t_LogDiscRec] ([DiscCode])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_LogDiscRec] ON [t_LogDiscRec]
FOR INSERT AS
/* t_LogDiscRec - Временные данные продаж - Скидки: Начисления бонусов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_LogDiscRec ^ z_DocDC - Проверка в PARENT */
/* Временные данные продаж - Скидки: Начисления бонусов ^ Документы - Дисконтные карты - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM z_DocDC m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.DocCode = m.DocCode AND i.DCardChID = m.DCardChID) <> @RCount
    BEGIN
      EXEC z_RelationError 'z_DocDC', 't_LogDiscRec', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_LogDiscRec', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_LogDiscRec] ON [t_LogDiscRec]
FOR UPDATE AS
/* t_LogDiscRec - Временные данные продаж - Скидки: Начисления бонусов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_LogDiscRec ^ z_DocDC - Проверка в PARENT */
/* Временные данные продаж - Скидки: Начисления бонусов ^ Документы - Дисконтные карты - Проверка в PARENT */
  IF UPDATE(ChID) OR UPDATE(DocCode) OR UPDATE(DCardChID)
    IF (SELECT COUNT(*) FROM z_DocDC m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.DocCode = m.DocCode AND i.DCardChID = m.DCardChID) <> @RCount
      BEGIN
        EXEC z_RelationError 'z_DocDC', 't_LogDiscRec', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_LogDiscRec', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_LogDiscRec] ON [t_LogDiscRec]
FOR DELETE AS
/* t_LogDiscRec - Временные данные продаж - Скидки: Начисления бонусов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 1011 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_LogDiscRec', N'Last', N'DELETE'
GO

ALTER TABLE [dbo].[t_LogDiscRec]
  ADD CONSTRAINT [FK_t_LogDiscRec_r_DCards] FOREIGN KEY ([DCardChID]) REFERENCES [dbo].[r_DCards] ([ChID]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[t_LogDiscRec]
  ADD CONSTRAINT [FK_t_LogDiscRec_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode]) ON UPDATE CASCADE
GO