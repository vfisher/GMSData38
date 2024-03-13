CREATE TABLE [dbo].[t_LogDiscExpP]
(
[LogID] [int] NOT NULL,
[DBiID] [int] NOT NULL,
[ChID] [bigint] NOT NULL,
[DocCode] [int] NOT NULL,
[SrcPosID] [int] NULL,
[DiscCode] [int] NOT NULL,
[SumBonus] [numeric] (21, 9) NULL,
[LogDate] [smalldatetime] NOT NULL,
[DCardChID] [bigint] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_LogDiscExpP] ON [dbo].[t_LogDiscExpP]
FOR INSERT AS
/* t_LogDiscExpP - Временные данные продаж - Скидки: Суммы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_LogDiscExpP ^ z_DocDC - Проверка в PARENT */
/* Временные данные продаж - Скидки: Суммы ^ Документы - Дисконтные карты - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM z_DocDC m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.DocCode = m.DocCode AND i.DCardChID = m.DCardChID) <> @RCount
    BEGIN
      EXEC z_RelationError 'z_DocDC', 't_LogDiscExpP', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_t_LogDiscExpP]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_LogDiscExpP] ON [dbo].[t_LogDiscExpP]
FOR UPDATE AS
/* t_LogDiscExpP - Временные данные продаж - Скидки: Суммы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_LogDiscExpP ^ z_DocDC - Проверка в PARENT */
/* Временные данные продаж - Скидки: Суммы ^ Документы - Дисконтные карты - Проверка в PARENT */
  IF UPDATE(ChID) OR UPDATE(DocCode) OR UPDATE(DCardChID)
    IF (SELECT COUNT(*) FROM z_DocDC m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.DocCode = m.DocCode AND i.DCardChID = m.DCardChID) <> @RCount
      BEGIN
        EXEC z_RelationError 'z_DocDC', 't_LogDiscExpP', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_t_LogDiscExpP]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_LogDiscExpP] ON [dbo].[t_LogDiscExpP]
FOR DELETE AS
/* t_LogDiscExpP - Временные данные продаж - Скидки: Суммы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 1011 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_t_LogDiscExpP]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[t_LogDiscExpP] ADD CONSTRAINT [pk_t_LogDiscExpP] PRIMARY KEY CLUSTERED ([LogID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DiscCode] ON [dbo].[t_LogDiscExpP] ([DiscCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_LogDiscExpP] ADD CONSTRAINT [FK_t_LogDiscExpP_r_DCards] FOREIGN KEY ([DCardChID]) REFERENCES [dbo].[r_DCards] ([ChID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[t_LogDiscExpP] ADD CONSTRAINT [FK_t_LogDiscExpP_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode]) ON UPDATE CASCADE
GO
