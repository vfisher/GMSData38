CREATE TABLE [dbo].[r_GAccFA]
(
[GAccID] [int] NOT NULL,
[A_CompExpE] [varchar] (255) NULL,
[A_CompExpR] [varchar] (255) NULL,
[A_EmpExpE] [varchar] (255) NULL,
[A_EmpExpR] [varchar] (255) NULL,
[A_Code1ExpE] [varchar] (255) NULL,
[A_Code1ExpR] [varchar] (255) NULL,
[A_Code2ExpE] [varchar] (255) NULL,
[A_Code2ExpR] [varchar] (255) NULL,
[A_Code3ExpE] [varchar] (255) NULL,
[A_Code3ExpR] [varchar] (255) NULL,
[A_Code4ExpE] [varchar] (255) NULL,
[A_Code4ExpR] [varchar] (255) NULL,
[A_Code5ExpE] [varchar] (255) NULL,
[A_Code5ExpR] [varchar] (255) NULL,
[A_StockExpE] [varchar] (255) NULL,
[A_StockExpR] [varchar] (255) NULL,
[A_ProdExpE] [varchar] (255) NULL,
[A_ProdExpR] [varchar] (255) NULL,
[A_AssExpE] [varchar] (255) NULL,
[A_AssExpR] [varchar] (255) NULL,
[A_VolExpE] [varchar] (255) NULL,
[A_VolExpR] [varchar] (255) NULL,
[A_Vol1ExpE] [varchar] (255) NULL,
[A_Vol1ExpR] [varchar] (255) NULL,
[A_Vol2ExpE] [varchar] (255) NULL,
[A_Vol2ExpR] [varchar] (255) NULL,
[A_Vol3ExpE] [varchar] (255) NULL,
[A_Vol3ExpR] [varchar] (255) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_GAccFA] ON [dbo].[r_GAccFA]
FOR INSERT AS
/* r_GAccFA - План счетов - Формулы аналитики - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_GAccFA ^ r_GAccs - Проверка в PARENT */
/* План счетов - Формулы аналитики ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'r_GAccFA', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10707004, 0, 
    '[' + cast(i.GAccID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_GAccFA]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_GAccFA] ON [dbo].[r_GAccFA]
FOR UPDATE AS
/* r_GAccFA - План счетов - Формулы аналитики - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_GAccFA ^ r_GAccs - Проверка в PARENT */
/* План счетов - Формулы аналитики ^ План счетов - Проверка в PARENT */
  IF UPDATE(GAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'r_GAccFA', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(GAccID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT GAccID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT GAccID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.GAccID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10707004 AND l.PKValue = 
          '[' + cast(d.GAccID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.GAccID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10707004 AND l.PKValue = 
          '[' + cast(d.GAccID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10707004, 0, 
          '[' + cast(d.GAccID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10707004 AND PKValue IN (SELECT 
          '[' + cast(GAccID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10707004 AND PKValue IN (SELECT 
          '[' + cast(GAccID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10707004, 0, 
          '[' + cast(i.GAccID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10707004, 0, 
    '[' + cast(i.GAccID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_GAccFA]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_GAccFA] ON [dbo].[r_GAccFA]FOR DELETE AS/* r_GAccFA - План счетов - Формулы аналитики - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* Удаление регистрации создания записи */  DELETE z_LogCreate FROM z_LogCreate m, deleted i  WHERE m.TableCode = 10707004 AND m.PKValue =     '[' + cast(i.GAccID as varchar(200)) + ']'/* Удаление регистрации изменения записи */  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i  WHERE m.TableCode = 10707004 AND m.PKValue =     '[' + cast(i.GAccID as varchar(200)) + ']'/* Регистрация удаления записи */  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)  SELECT 10707004, 0,     '[' + cast(d.GAccID as varchar(200)) + ']'          , dbo.zf_GetUserCode() FROM deleted dEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_GAccFA]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_GAccFA] ADD CONSTRAINT [_pk_r_GAccFA] PRIMARY KEY CLUSTERED ([GAccID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccFA].[GAccID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccFA].[GAccID]'
GO
