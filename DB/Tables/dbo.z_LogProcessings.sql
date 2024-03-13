CREATE TABLE [dbo].[z_LogProcessings]
(
[ChID] [bigint] NOT NULL,
[DocCode] [int] NOT NULL,
[CardInfo] [varchar] (8000) NOT NULL,
[RRN] [varchar] (250) NULL,
[Status] [int] NOT NULL,
[Msg] [varchar] (250) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_LogProcessings] ON [dbo].[z_LogProcessings]
FOR INSERT AS
/* z_LogProcessings - Регистрация действий – Процессинг - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_LogProcessings ^ t_CRRet - Проверка в PARENT */
/* Регистрация действий – Процессинг ^ Возврат товара по чеку: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11004 AND i.ChID NOT IN (SELECT ChID FROM t_CRRet))
    BEGIN
      EXEC z_RelationError 't_CRRet', 'z_LogProcessings', 0
      RETURN
    END

/* z_LogProcessings ^ t_Sale - Проверка в PARENT */
/* Регистрация действий – Процессинг ^ Продажа товара оператором: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11035 AND i.ChID NOT IN (SELECT ChID FROM t_Sale))
    BEGIN
      EXEC z_RelationError 't_Sale', 'z_LogProcessings', 0
      RETURN
    END

/* z_LogProcessings ^ t_SaleTemp - Проверка в PARENT */
/* Регистрация действий – Процессинг ^ Временные данные продаж: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 1011 AND i.ChID NOT IN (SELECT ChID FROM t_SaleTemp))
    BEGIN
      EXEC z_RelationError 't_SaleTemp', 'z_LogProcessings', 0
      RETURN
    END

/* z_LogProcessings ^ z_LogProcessingOPs - Проверка в PARENT */
/* Регистрация действий – Процессинг ^ Обмен с процессингом - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 1030 AND i.ChID NOT IN (SELECT ChID FROM z_LogProcessingOPs))
    BEGIN
      EXEC z_RelationError 'z_LogProcessingOPs', 'z_LogProcessings', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_LogProcessings]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_LogProcessings] ON [dbo].[z_LogProcessings]
FOR UPDATE AS
/* z_LogProcessings - Регистрация действий – Процессинг - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_LogProcessings ^ t_CRRet - Проверка в PARENT */
/* Регистрация действий – Процессинг ^ Возврат товара по чеку: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11004 AND i.ChID NOT IN (SELECT ChID FROM t_CRRet))
      BEGIN
        EXEC z_RelationError 't_CRRet', 'z_LogProcessings', 1
        RETURN
      END

/* z_LogProcessings ^ t_Sale - Проверка в PARENT */
/* Регистрация действий – Процессинг ^ Продажа товара оператором: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11035 AND i.ChID NOT IN (SELECT ChID FROM t_Sale))
      BEGIN
        EXEC z_RelationError 't_Sale', 'z_LogProcessings', 1
        RETURN
      END

/* z_LogProcessings ^ t_SaleTemp - Проверка в PARENT */
/* Регистрация действий – Процессинг ^ Временные данные продаж: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 1011 AND i.ChID NOT IN (SELECT ChID FROM t_SaleTemp))
      BEGIN
        EXEC z_RelationError 't_SaleTemp', 'z_LogProcessings', 1
        RETURN
      END

/* z_LogProcessings ^ z_LogProcessingOPs - Проверка в PARENT */
/* Регистрация действий – Процессинг ^ Обмен с процессингом - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 1030 AND i.ChID NOT IN (SELECT ChID FROM z_LogProcessingOPs))
      BEGIN
        EXEC z_RelationError 'z_LogProcessingOPs', 'z_LogProcessings', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_LogProcessings]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_LogProcessings] ON [dbo].[z_LogProcessings]FOR DELETE AS/* z_LogProcessings - Регистрация действий – Процессинг - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* Удаление регистрации печати */  DELETE z_LogPrint FROM z_LogPrint m, deleted i  WHERE m.DocCode = 1001 AND m.ChID = i.ChIDEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_z_LogProcessings]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[z_LogProcessings] ADD CONSTRAINT [pk_z_LogProcessings] PRIMARY KEY CLUSTERED ([DocCode], [ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Status] ON [dbo].[z_LogProcessings] ([Status]) ON [PRIMARY]
GO
