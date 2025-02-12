CREATE TABLE [dbo].[r_DiscSale] (
  [DiscCode] [int] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [LFilterExp] [varchar](max) NULL,
  [EFilterExp] [varchar](max) NULL,
  [LDiscountExp] [varchar](max) NULL,
  [EDiscountExp] [varchar](max) NULL,
  [LMaxDiscountExp] [varchar](max) NULL,
  [EMaxDiscountExp] [varchar](max) NULL,
  [LMinDiscountExp] [varchar](max) NULL,
  [EMinDiscountExp] [varchar](max) NULL,
  [LMaxSumBonusExp] [varchar](max) NULL,
  [EMaxSumBonusExp] [varchar](max) NULL,
  [LMinSumBonusExp] [varchar](max) NULL,
  [EMinSumBonusExp] [varchar](max) NULL,
  [PProdFilter] [varchar](4000) NULL,
  [PCatFilter] [varchar](4000) NULL,
  [PGrFilter] [varchar](4000) NULL,
  [PGr1Filter] [varchar](4000) NULL,
  [PGr2Filter] [varchar](4000) NULL,
  [PGr3Filter] [varchar](4000) NULL,
  [AllowZeroSumBonus] [bit] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_r_DiscSale] PRIMARY KEY CLUSTERED ([DiscCode], [SrcPosID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_DiscSale] ON [r_DiscSale]
FOR INSERT AS
/* r_DiscSale - Справочник акций: Скидка - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10470005, m.ChID, 
    '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Discs m ON m.DiscCode = i.DiscCode

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_DiscSale', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_DiscSale] ON [r_DiscSale]
FOR UPDATE AS
/* r_DiscSale - Справочник акций: Скидка - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(DiscCode) OR UPDATE(SrcPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT DiscCode, SrcPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT DiscCode, SrcPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10470005 AND l.PKValue = 
          '[' + cast(d.DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10470005 AND l.PKValue = 
          '[' + cast(d.DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10470005, m.ChID, 
          '[' + cast(d.DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Discs m ON m.DiscCode = d.DiscCode
          DELETE FROM z_LogCreate WHERE TableCode = 10470005 AND PKValue IN (SELECT 
          '[' + cast(DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10470005 AND PKValue IN (SELECT 
          '[' + cast(DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10470005, m.ChID, 
          '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Discs m ON m.DiscCode = i.DiscCode

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10470005, m.ChID, 
    '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Discs m ON m.DiscCode = i.DiscCode


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_DiscSale', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_DiscSale] ON [r_DiscSale]
FOR DELETE AS
/* r_DiscSale - Справочник акций: Скидка - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10470005 AND m.PKValue = 
    '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10470005 AND m.PKValue = 
    '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10470005, m.ChID, 
    '[' + cast(d.DiscCode as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Discs m ON m.DiscCode = d.DiscCode

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_DiscSale', N'Last', N'DELETE'
GO

ALTER TABLE [dbo].[r_DiscSale]
  ADD CONSTRAINT [FK_r_DiscSale_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO