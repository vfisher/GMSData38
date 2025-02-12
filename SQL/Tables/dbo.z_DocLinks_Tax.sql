CREATE TABLE [dbo].[z_DocLinks_Tax] (
  [LinkID] [int] NOT NULL,
  [SumCC_nt_20] [numeric](21, 9) NOT NULL,
  [TaxSum_20] [numeric](21, 9) NOT NULL,
  [SumCC_nt_0] [numeric](21, 9) NOT NULL,
  [TaxSum_0] [numeric](21, 9) NOT NULL,
  [SumCC_nt_Free] [numeric](21, 9) NOT NULL,
  [TaxSum_Free] [numeric](21, 9) NOT NULL,
  [SumCC_nt_No] [numeric](21, 9) NOT NULL,
  [TaxSum_No] [numeric](21, 9) NOT NULL,
  CONSTRAINT [pk_z_DocLinks_Tax] PRIMARY KEY CLUSTERED ([LinkID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_DocLinks_Tax] ON [z_DocLinks_Tax]
FOR INSERT AS
/* z_DocLinks_Tax - Документы - Взаимосвязи: Информация о налоговых накладных - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_DocLinks_Tax ^ z_DocLinks - Проверка в PARENT */
/* Документы - Взаимосвязи: Информация о налоговых накладных ^ Документы - Взаимосвязи - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.LinkID NOT IN (SELECT LinkID FROM z_DocLinks))
    BEGIN
      EXEC z_RelationError 'z_DocLinks', 'z_DocLinks_Tax', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_DocLinks_Tax', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_DocLinks_Tax] ON [z_DocLinks_Tax]
FOR UPDATE AS
/* z_DocLinks_Tax - Документы - Взаимосвязи: Информация о налоговых накладных - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_DocLinks_Tax ^ z_DocLinks - Проверка в PARENT */
/* Документы - Взаимосвязи: Информация о налоговых накладных ^ Документы - Взаимосвязи - Проверка в PARENT */
  IF UPDATE(LinkID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.LinkID NOT IN (SELECT LinkID FROM z_DocLinks))
      BEGIN
        EXEC z_RelationError 'z_DocLinks', 'z_DocLinks_Tax', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_DocLinks_Tax', N'Last', N'UPDATE'
GO