CREATE TABLE [dbo].[r_ProdCV]
(
[ProdID] [int] NOT NULL,
[CompID] [int] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[Value1] [numeric] (21, 9) NOT NULL,
[Note1] [varchar] (200) NULL,
[Value2] [numeric] (21, 9) NOT NULL,
[Note2] [varchar] (200) NULL,
[Value3] [numeric] (21, 9) NOT NULL,
[Note3] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ProdCV] ON [dbo].[r_ProdCV]
FOR INSERT AS
/* r_ProdCV - Справочник товаров - Значения для периодов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdCV ^ r_Comps - Проверка в PARENT */
/* Справочник товаров - Значения для периодов ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'r_ProdCV', 0
      RETURN
    END

/* r_ProdCV ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Значения для периодов ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_ProdCV', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350011, m.ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_ProdCV]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ProdCV] ON [dbo].[r_ProdCV]
FOR UPDATE AS
/* r_ProdCV - Справочник товаров - Значения для периодов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdCV ^ r_Comps - Проверка в PARENT */
/* Справочник товаров - Значения для периодов ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'r_ProdCV', 1
        RETURN
      END

/* r_ProdCV ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Значения для периодов ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_ProdCV', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(ProdID) OR UPDATE(CompID) OR UPDATE(BDate)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ProdID, CompID, BDate FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ProdID, CompID, BDate FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.BDate as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10350011 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.BDate as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.BDate as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10350011 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.BDate as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10350011, m.ChID, 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.BDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Prods m ON m.ProdID = d.ProdID
          DELETE FROM z_LogCreate WHERE TableCode = 10350011 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(BDate as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10350011 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(BDate as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10350011, m.ChID, 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.BDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350011, m.ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_ProdCV]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ProdCV] ON [dbo].[r_ProdCV]
FOR DELETE AS
/* r_ProdCV - Справочник товаров - Значения для периодов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10350011 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10350011 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10350011, m.ChID, 
    '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.BDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Prods m ON m.ProdID = d.ProdID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_ProdCV]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_ProdCV] ADD CONSTRAINT [_pk_r_ProdCV] PRIMARY KEY CLUSTERED ([ProdID], [CompID], [BDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[r_ProdCV] ([CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[r_ProdCV] ([ProdID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdCV].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdCV].[CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdCV].[Value1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdCV].[Value2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdCV].[Value3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdCV].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdCV].[CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdCV].[Value1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdCV].[Value2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdCV].[Value3]'
GO
