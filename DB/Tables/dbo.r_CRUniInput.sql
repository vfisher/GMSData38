CREATE TABLE [dbo].[r_CRUniInput]
(
[ChID] [bigint] NOT NULL,
[UniInputCode] [int] NOT NULL,
[UniInputAction] [int] NOT NULL,
[UniInputMask] [varchar] (250) NULL,
[Notes] [varchar] (250) NULL,
[UniInput] [bit] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CRUniInput] ON [dbo].[r_CRUniInput]
FOR INSERT AS
/* r_CRUniInput - Справочник ЭККА: единый ввод - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CRUniInput ^ r_Uni - Проверка в PARENT */
/* Справочник ЭККА: единый ввод ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UniInputAction NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10455))
    BEGIN
      EXEC z_RelationErrorUni 'r_CRUniInput', 10455, 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_CRUniInput]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CRUniInput] ON [dbo].[r_CRUniInput]
FOR UPDATE AS
/* r_CRUniInput - Справочник ЭККА: единый ввод - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CRUniInput ^ r_Uni - Проверка в PARENT */
/* Справочник ЭККА: единый ввод ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(UniInputAction)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UniInputAction NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10455))
      BEGIN
        EXEC z_RelationErrorUni 'r_CRUniInput', 10455, 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_CRUniInput]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CRUniInput] ON [dbo].[r_CRUniInput]FOR DELETE AS/* r_CRUniInput - Справочник ЭККА: единый ввод - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* Удаление регистрации печати */  DELETE z_LogPrint FROM z_LogPrint m, deleted i  WHERE m.DocCode = 10456 AND m.ChID = i.ChIDEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_CRUniInput]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_CRUniInput] ADD CONSTRAINT [pk_r_CRUniInput] PRIMARY KEY CLUSTERED ([UniInputCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[r_CRUniInput] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UniInputCode_UniInputAction_UniInputMask] ON [dbo].[r_CRUniInput] ([UniInputCode], [UniInputAction], [UniInputMask]) ON [PRIMARY]
GO
