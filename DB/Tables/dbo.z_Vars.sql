CREATE TABLE [dbo].[z_Vars]
(
[VarName] [varchar] (250) NOT NULL,
[VarDesc] [varchar] (250) NOT NULL,
[VarValue] [varchar] (250) NULL,
[VarInfo] [varchar] (250) NULL,
[VarType] [int] NOT NULL DEFAULT (0),
[VarPageCode] [int] NOT NULL DEFAULT (0),
[VarGroup] [varchar] (250) NULL,
[VarPosID] [int] NOT NULL DEFAULT (0),
[LabelPos] [int] NOT NULL DEFAULT (0),
[VarExtInfo] [varchar] (2000) NULL,
[VarSelType] [int] NOT NULL DEFAULT (0),
[AppCode] [int] NOT NULL DEFAULT (0),
[ObjectDef] [text] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_Vars] ON [dbo].[z_Vars]
FOR INSERT AS
/* z_Vars - Системные переменные - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_Vars ^ r_Codes4 - Проверка в PARENT */
/* Системные переменные ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 't_ManualSRecCode' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'z_Vars', 0
      RETURN
    END

/* z_Vars ^ r_Comps - Проверка в PARENT */
/* Системные переменные ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 't_ChequeCompID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'z_Vars', 0
      RETURN
    END

/* z_Vars ^ r_Currs - Проверка в PARENT */
/* Системные переменные ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'z_CurrCC' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'z_Vars', 0
      RETURN
    END

/* z_Vars ^ r_Currs - Проверка в PARENT */
/* Системные переменные ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'z_CurrMC' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'z_Vars', 0
      RETURN
    END

/* z_Vars ^ r_DBIs - Проверка в PARENT */
/* Системные переменные ^ Справочник баз данных - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'OT_DBiID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT DBiID FROM r_DBIs))
    BEGIN
      EXEC z_RelationError 'r_DBIs', 'z_Vars', 0
      RETURN
    END

/* z_Vars ^ r_GOpers - Проверка в PARENT */
/* Системные переменные ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'b_GLInTID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'z_Vars', 0
      RETURN
    END

/* z_Vars ^ r_GOpers - Проверка в PARENT */
/* Системные переменные ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'b_GRPTID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'z_Vars', 0
      RETURN
    END

/* z_Vars ^ r_Ours - Проверка в PARENT */
/* Системные переменные ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'b_OurID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_Vars', 0
      RETURN
    END

/* z_Vars ^ r_Ours - Проверка в PARENT */
/* Системные переменные ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'c_OurID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_Vars', 0
      RETURN
    END

/* z_Vars ^ r_Ours - Проверка в PARENT */
/* Системные переменные ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'OT_MainOurID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_Vars', 0
      RETURN
    END

/* z_Vars ^ r_Ours - Проверка в PARENT */
/* Системные переменные ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 't_OurID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_Vars', 0
      RETURN
    END

/* z_Vars ^ r_PayTypes - Проверка в PARENT */
/* Системные переменные ^ Справочник выплат/удержаний - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'p_AdvancePayTypeID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT PayTypeID FROM r_PayTypes))
    BEGIN
      EXEC z_RelationError 'r_PayTypes', 'z_Vars', 0
      RETURN
    END

/* z_Vars ^ r_PayTypes - Проверка в PARENT */
/* Системные переменные ^ Справочник выплат/удержаний - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'p_IndexPayTypeID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT PayTypeID FROM r_PayTypes))
    BEGIN
      EXEC z_RelationError 'r_PayTypes', 'z_Vars', 0
      RETURN
    END

/* z_Vars ^ r_PayTypes - Проверка в PARENT */
/* Системные переменные ^ Справочник выплат/удержаний - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'p_LeavAdvPayTypeID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT PayTypeID FROM r_PayTypes))
    BEGIN
      EXEC z_RelationError 'r_PayTypes', 'z_Vars', 0
      RETURN
    END

/* z_Vars ^ r_Secs - Проверка в PARENT */
/* Системные переменные ^ Справочник секций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 't_SecID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT SecID FROM r_Secs))
    BEGIN
      EXEC z_RelationError 'r_Secs', 'z_Vars', 0
      RETURN
    END

/* z_Vars ^ r_States - Проверка в PARENT */
/* Системные переменные ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 't_ChequeStateCode' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'z_Vars', 0
      RETURN
    END

/* z_Vars ^ r_Stocks - Проверка в PARENT */
/* Системные переменные ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'b_StockID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'z_Vars', 0
      RETURN
    END

/* z_Vars ^ r_Stocks - Проверка в PARENT */
/* Системные переменные ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'c_StockID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'z_Vars', 0
      RETURN
    END

/* z_Vars ^ r_Stocks - Проверка в PARENT */
/* Системные переменные ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 't_StockID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'z_Vars', 0
      RETURN
    END

/* z_Vars ^ r_Users - Проверка в PARENT */
/* Системные переменные ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'Sync_User' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_Vars', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_Vars]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_Vars] ON [dbo].[z_Vars]
FOR UPDATE AS
/* z_Vars - Системные переменные - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_Vars ^ r_Codes4 - Проверка в PARENT */
/* Системные переменные ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 't_ManualSRecCode' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'z_Vars', 1
        RETURN
      END

/* z_Vars ^ r_Comps - Проверка в PARENT */
/* Системные переменные ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 't_ChequeCompID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'z_Vars', 1
        RETURN
      END

/* z_Vars ^ r_Currs - Проверка в PARENT */
/* Системные переменные ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'z_CurrCC' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'z_Vars', 1
        RETURN
      END

/* z_Vars ^ r_Currs - Проверка в PARENT */
/* Системные переменные ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'z_CurrMC' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'z_Vars', 1
        RETURN
      END

/* z_Vars ^ r_DBIs - Проверка в PARENT */
/* Системные переменные ^ Справочник баз данных - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'OT_DBiID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT DBiID FROM r_DBIs))
      BEGIN
        EXEC z_RelationError 'r_DBIs', 'z_Vars', 1
        RETURN
      END

/* z_Vars ^ r_GOpers - Проверка в PARENT */
/* Системные переменные ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'b_GLInTID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'z_Vars', 1
        RETURN
      END

/* z_Vars ^ r_GOpers - Проверка в PARENT */
/* Системные переменные ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'b_GRPTID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'z_Vars', 1
        RETURN
      END

/* z_Vars ^ r_Ours - Проверка в PARENT */
/* Системные переменные ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'b_OurID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'z_Vars', 1
        RETURN
      END

/* z_Vars ^ r_Ours - Проверка в PARENT */
/* Системные переменные ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'c_OurID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'z_Vars', 1
        RETURN
      END

/* z_Vars ^ r_Ours - Проверка в PARENT */
/* Системные переменные ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'OT_MainOurID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'z_Vars', 1
        RETURN
      END

/* z_Vars ^ r_Ours - Проверка в PARENT */
/* Системные переменные ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 't_OurID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'z_Vars', 1
        RETURN
      END

/* z_Vars ^ r_PayTypes - Проверка в PARENT */
/* Системные переменные ^ Справочник выплат/удержаний - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'p_AdvancePayTypeID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT PayTypeID FROM r_PayTypes))
      BEGIN
        EXEC z_RelationError 'r_PayTypes', 'z_Vars', 1
        RETURN
      END

/* z_Vars ^ r_PayTypes - Проверка в PARENT */
/* Системные переменные ^ Справочник выплат/удержаний - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'p_IndexPayTypeID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT PayTypeID FROM r_PayTypes))
      BEGIN
        EXEC z_RelationError 'r_PayTypes', 'z_Vars', 1
        RETURN
      END

/* z_Vars ^ r_PayTypes - Проверка в PARENT */
/* Системные переменные ^ Справочник выплат/удержаний - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'p_LeavAdvPayTypeID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT PayTypeID FROM r_PayTypes))
      BEGIN
        EXEC z_RelationError 'r_PayTypes', 'z_Vars', 1
        RETURN
      END

/* z_Vars ^ r_Secs - Проверка в PARENT */
/* Системные переменные ^ Справочник секций - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 't_SecID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT SecID FROM r_Secs))
      BEGIN
        EXEC z_RelationError 'r_Secs', 'z_Vars', 1
        RETURN
      END

/* z_Vars ^ r_States - Проверка в PARENT */
/* Системные переменные ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 't_ChequeStateCode' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'z_Vars', 1
        RETURN
      END

/* z_Vars ^ r_Stocks - Проверка в PARENT */
/* Системные переменные ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'b_StockID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'z_Vars', 1
        RETURN
      END

/* z_Vars ^ r_Stocks - Проверка в PARENT */
/* Системные переменные ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'c_StockID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'z_Vars', 1
        RETURN
      END

/* z_Vars ^ r_Stocks - Проверка в PARENT */
/* Системные переменные ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 't_StockID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'z_Vars', 1
        RETURN
      END

/* z_Vars ^ r_Users - Проверка в PARENT */
/* Системные переменные ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'Sync_User' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_Vars', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_Vars]', 'last', 'update', null
GO
ALTER TABLE [dbo].[z_Vars] ADD CONSTRAINT [_pk_z_Vars] PRIMARY KEY CLUSTERED ([VarName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_Vars] ADD CONSTRAINT [FK_z_Vars_z_Apps] FOREIGN KEY ([AppCode]) REFERENCES [dbo].[z_Apps] ([AppCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_Vars] ADD CONSTRAINT [FK_z_Vars_z_VarPages] FOREIGN KEY ([VarPageCode]) REFERENCES [dbo].[z_VarPages] ([VarPageCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
