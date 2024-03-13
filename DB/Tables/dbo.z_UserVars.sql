CREATE TABLE [dbo].[z_UserVars]
(
[UserCode] [smallint] NOT NULL,
[VarName] [varchar] (250) NOT NULL,
[VarDesc] [varchar] (250) NOT NULL,
[VarValue] [varchar] (250) NULL,
[VarInfo] [varchar] (250) NULL,
[VarType] [int] NOT NULL DEFAULT (0),
[VarSelType] [int] NOT NULL DEFAULT (0),
[VarGroup] [varchar] (250) NULL,
[VarPosID] [int] NOT NULL DEFAULT (0),
[LabelPos] [int] NOT NULL DEFAULT (0),
[VarExtInfo] [varchar] (250) NULL,
[VarVisible] [bit] NOT NULL DEFAULT (1),
[ObjectDef] [text] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_UserVars] ON [dbo].[z_UserVars]
FOR INSERT AS
/* z_UserVars - Пользователи - Переменные - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserVars ^ r_Ours - Проверка в PARENT */
/* Пользователи - Переменные ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'b_OurID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_UserVars', 0
      RETURN
    END

/* z_UserVars ^ r_Ours - Проверка в PARENT */
/* Пользователи - Переменные ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'c_OurID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_UserVars', 0
      RETURN
    END

/* z_UserVars ^ r_Ours - Проверка в PARENT */
/* Пользователи - Переменные ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 't_OurID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_UserVars', 0
      RETURN
    END

/* z_UserVars ^ r_Secs - Проверка в PARENT */
/* Пользователи - Переменные ^ Справочник секций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 't_SecID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT SecID FROM r_Secs))
    BEGIN
      EXEC z_RelationError 'r_Secs', 'z_UserVars', 0
      RETURN
    END

/* z_UserVars ^ r_Stocks - Проверка в PARENT */
/* Пользователи - Переменные ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'b_StockID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'z_UserVars', 0
      RETURN
    END

/* z_UserVars ^ r_Stocks - Проверка в PARENT */
/* Пользователи - Переменные ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'c_StockID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'z_UserVars', 0
      RETURN
    END

/* z_UserVars ^ r_Stocks - Проверка в PARENT */
/* Пользователи - Переменные ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 't_StockID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'z_UserVars', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_UserVars]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_UserVars] ON [dbo].[z_UserVars]
FOR UPDATE AS
/* z_UserVars - Пользователи - Переменные - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserVars ^ r_Ours - Проверка в PARENT */
/* Пользователи - Переменные ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'b_OurID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'z_UserVars', 1
        RETURN
      END

/* z_UserVars ^ r_Ours - Проверка в PARENT */
/* Пользователи - Переменные ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'c_OurID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'z_UserVars', 1
        RETURN
      END

/* z_UserVars ^ r_Ours - Проверка в PARENT */
/* Пользователи - Переменные ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 't_OurID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'z_UserVars', 1
        RETURN
      END

/* z_UserVars ^ r_Secs - Проверка в PARENT */
/* Пользователи - Переменные ^ Справочник секций - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 't_SecID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT SecID FROM r_Secs))
      BEGIN
        EXEC z_RelationError 'r_Secs', 'z_UserVars', 1
        RETURN
      END

/* z_UserVars ^ r_Stocks - Проверка в PARENT */
/* Пользователи - Переменные ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'b_StockID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'z_UserVars', 1
        RETURN
      END

/* z_UserVars ^ r_Stocks - Проверка в PARENT */
/* Пользователи - Переменные ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 'c_StockID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'z_UserVars', 1
        RETURN
      END

/* z_UserVars ^ r_Stocks - Проверка в PARENT */
/* Пользователи - Переменные ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(VarValue)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VarName = 't_StockID' AND i.VarValue IS NOT NULL AND i.VarValue NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'z_UserVars', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_UserVars]', 'last', 'update', null
GO
ALTER TABLE [dbo].[z_UserVars] ADD CONSTRAINT [pk_z_UserVars] PRIMARY KEY CLUSTERED ([UserCode], [VarName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserCode] ON [dbo].[z_UserVars] ([UserCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VarPosID] ON [dbo].[z_UserVars] ([UserCode], [VarPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VarName] ON [dbo].[z_UserVars] ([VarName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_UserVars] ADD CONSTRAINT [FK_z_UserVars_r_Users] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[r_Users] ([UserID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
