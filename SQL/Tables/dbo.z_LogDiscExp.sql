CREATE TABLE [dbo].[z_LogDiscExp] (
  [LogID] [int] NOT NULL,
  [TempBonus] [bit] NOT NULL,
  [DocCode] [int] NOT NULL,
  [ChID] [bigint] NOT NULL,
  [SrcPosID] [int] NULL,
  [DiscCode] [int] NOT NULL,
  [SumBonus] [numeric](21, 9) NULL,
  [Discount] [numeric](21, 9) NULL,
  [LogDate] [smalldatetime] NOT NULL CONSTRAINT [df_z_LogDiscExp_LogDate] DEFAULT (getdate()),
  [BonusType] [int] NOT NULL DEFAULT (0),
  [GroupSumBonus] [numeric](21, 9) NULL,
  [GroupDiscount] [numeric](21, 9) NULL,
  [DBiID] [int] NOT NULL,
  [DCardChID] [bigint] NOT NULL CONSTRAINT [DF__z_LogDisc__DCard__250D02B5] DEFAULT (0),
  CONSTRAINT [pk_z_LogDiscExp] PRIMARY KEY CLUSTERED ([DBiID], [LogID])
)
ON [PRIMARY]
GO

CREATE INDEX [DCardChID_LogID]
  ON [dbo].[z_LogDiscExp] ([DCardChID], [LogID])
  ON [PRIMARY]
GO

CREATE INDEX [DocCode_ChID_SrcPosID_DiscCode]
  ON [dbo].[z_LogDiscExp] ([DocCode], [ChID], [SrcPosID], [DiscCode])
  ON [PRIMARY]
GO

CREATE INDEX [DocCode_ChID_SrcPosID_DiscCode_BonusType]
  ON [dbo].[z_LogDiscExp] ([DocCode], [ChID], [SrcPosID], [DiscCode], [BonusType])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_LogDiscExp] ON [z_LogDiscExp]
FOR INSERT AS
/* z_LogDiscExp - Регистрация действий - Списание бонусов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_LogDiscExp ^ r_DBIs - Проверка в PARENT */
/* Регистрация действий - Списание бонусов ^ Справочник баз данных - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DBiID NOT IN (SELECT DBiID FROM r_DBIs))
    BEGIN
      EXEC z_RelationError 'r_DBIs', 'z_LogDiscExp', 0
      RETURN
    END

/* z_LogDiscExp ^ z_DocDC - Проверка в PARENT */
/* Регистрация действий - Списание бонусов ^ Документы - Дисконтные карты - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM z_DocDC m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.DocCode = m.DocCode AND i.DCardChID = m.DCardChID) <> @RCount
    BEGIN
      EXEC z_RelationError 'z_DocDC', 'z_LogDiscExp', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_LogDiscExp', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_LogDiscExp] ON [z_LogDiscExp]
FOR UPDATE AS
/* z_LogDiscExp - Регистрация действий - Списание бонусов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_LogDiscExp ^ r_DBIs - Проверка в PARENT */
/* Регистрация действий - Списание бонусов ^ Справочник баз данных - Проверка в PARENT */
  IF UPDATE(DBiID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DBiID NOT IN (SELECT DBiID FROM r_DBIs))
      BEGIN
        EXEC z_RelationError 'r_DBIs', 'z_LogDiscExp', 1
        RETURN
      END

/* z_LogDiscExp ^ z_DocDC - Проверка в PARENT */
/* Регистрация действий - Списание бонусов ^ Документы - Дисконтные карты - Проверка в PARENT */
  IF UPDATE(ChID) OR UPDATE(DocCode) OR UPDATE(DCardChID)
    IF (SELECT COUNT(*) FROM z_DocDC m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.DocCode = m.DocCode AND i.DCardChID = m.DCardChID) <> @RCount
      BEGIN
        EXEC z_RelationError 'z_DocDC', 'z_LogDiscExp', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_LogDiscExp', N'Last', N'UPDATE'
GO

ALTER TABLE [dbo].[z_LogDiscExp]
  ADD CONSTRAINT [FK_z_LogDiscExp_r_DCards] FOREIGN KEY ([DCardChID]) REFERENCES [dbo].[r_DCards] ([ChID]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[z_LogDiscExp]
  ADD CONSTRAINT [FK_z_LogDiscExp_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode])
GO