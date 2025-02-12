CREATE TABLE [dbo].[r_GOperFC] (
  [GOperID] [int] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [C_CompExpE] [varchar](255) NULL,
  [C_CompExpR] [varchar](255) NULL,
  [C_EmpExpE] [varchar](255) NULL,
  [C_EmpExpR] [varchar](255) NULL,
  [C_Code1ExpE] [varchar](255) NULL,
  [C_Code1ExpR] [varchar](255) NULL,
  [C_Code2ExpE] [varchar](255) NULL,
  [C_Code2ExpR] [varchar](255) NULL,
  [C_Code3ExpE] [varchar](255) NULL,
  [C_Code3ExpR] [varchar](255) NULL,
  [C_Code4ExpE] [varchar](255) NULL,
  [C_Code4ExpR] [varchar](255) NULL,
  [C_Code5ExpE] [varchar](255) NULL,
  [C_Code5ExpR] [varchar](255) NULL,
  [C_StockExpE] [varchar](255) NULL,
  [C_StockExpR] [varchar](255) NULL,
  [C_ProdExpE] [varchar](255) NULL,
  [C_ProdExpR] [varchar](255) NULL,
  [C_AssExpE] [varchar](255) NULL,
  [C_AssExpR] [varchar](255) NULL,
  [C_VolExpE] [varchar](255) NULL,
  [C_VolExpR] [varchar](255) NULL,
  [C_Vol1ExpE] [varchar](255) NULL,
  [C_Vol1ExpR] [varchar](255) NULL,
  [C_Vol2ExpE] [varchar](255) NULL,
  [C_Vol2ExpR] [varchar](255) NULL,
  [C_Vol3ExpE] [varchar](255) NULL,
  [C_Vol3ExpR] [varchar](255) NULL,
  CONSTRAINT [_pk_r_GOperFC] PRIMARY KEY CLUSTERED ([GOperID], [SrcPosID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GOperFC.GOperID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GOperFC.SrcPosID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_GOperFC] ON [r_GOperFC]
FOR INSERT AS
/* r_GOperFC - Справочник проводок - Формулы аналитики Кредит - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_GOperFC ^ r_GOperD - Проверка в PARENT */
/* Справочник проводок - Формулы аналитики Кредит ^ Справочник проводок - Проводки - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_GOperD m WITH(NOLOCK), inserted i WHERE i.GOperID = m.GOperID AND i.SrcPosID = m.SrcPosID) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_GOperD', 'r_GOperFC', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10708004, m.ChID, 
    '[' + cast(i.GOperID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_GOpers m ON m.GOperID = i.GOperID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_GOperFC', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_GOperFC] ON [r_GOperFC]
FOR UPDATE AS
/* r_GOperFC - Справочник проводок - Формулы аналитики Кредит - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_GOperFC ^ r_GOperD - Проверка в PARENT */
/* Справочник проводок - Формулы аналитики Кредит ^ Справочник проводок - Проводки - Проверка в PARENT */
  IF UPDATE(GOperID) OR UPDATE(SrcPosID)
    IF (SELECT COUNT(*) FROM r_GOperD m WITH(NOLOCK), inserted i WHERE i.GOperID = m.GOperID AND i.SrcPosID = m.SrcPosID) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_GOperD', 'r_GOperFC', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(GOperID) OR UPDATE(SrcPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT GOperID, SrcPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT GOperID, SrcPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.GOperID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10708004 AND l.PKValue = 
          '[' + cast(d.GOperID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.GOperID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10708004 AND l.PKValue = 
          '[' + cast(d.GOperID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10708004, m.ChID, 
          '[' + cast(d.GOperID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_GOpers m ON m.GOperID = d.GOperID
          DELETE FROM z_LogCreate WHERE TableCode = 10708004 AND PKValue IN (SELECT 
          '[' + cast(GOperID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10708004 AND PKValue IN (SELECT 
          '[' + cast(GOperID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10708004, m.ChID, 
          '[' + cast(i.GOperID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_GOpers m ON m.GOperID = i.GOperID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10708004, m.ChID, 
    '[' + cast(i.GOperID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_GOpers m ON m.GOperID = i.GOperID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_GOperFC', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_GOperFC] ON [r_GOperFC]
FOR DELETE AS
/* r_GOperFC - Справочник проводок - Формулы аналитики Кредит - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10708004 AND m.PKValue = 
    '[' + cast(i.GOperID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10708004 AND m.PKValue = 
    '[' + cast(i.GOperID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10708004, m.ChID, 
    '[' + cast(d.GOperID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_GOpers m ON m.GOperID = d.GOperID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_GOperFC', N'Last', N'DELETE'
GO