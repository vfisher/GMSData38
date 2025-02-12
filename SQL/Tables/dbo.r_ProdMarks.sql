CREATE TABLE [dbo].[r_ProdMarks] (
  [MarkCode] [int] NOT NULL,
  [ProdID] [int] NOT NULL,
  [DataMatrix] [varchar](150) NOT NULL,
  [InUse] [bit] NOT NULL DEFAULT (1),
  [DateChange] [datetime] NULL,
  [RowVer] [timestamp],
  CONSTRAINT [pk_r_ProdMarks] PRIMARY KEY CLUSTERED ([MarkCode]),
  UNIQUE ([DataMatrix])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ProdMarksMarkCode_DataMatrix]
  ON [dbo].[r_ProdMarks] ([MarkCode], [DataMatrix])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[r_ProdMarks] ([ProdID], [MarkCode])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_Upd_r_ProdMarks] ON [dbo].[r_ProdMarks] 
FOR UPDATE
AS 
BEGIN 
  IF UPDATE(MarkCode) 
    BEGIN 
      RAISERROR ('Изменение номера маркировки невозможно ''Справочник товаров: маркировки''.', 18, 1) 
      ROLLBACK TRAN
    END 
     
END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ProdMarks] ON [r_ProdMarks]
FOR INSERT AS
/* r_ProdMarks - Справочник товаров: маркировки - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdMarks ^ r_Prods - Проверка в PARENT */
/* Справочник товаров: маркировки ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_ProdMarks', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_ProdMarks', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ProdMarks] ON [r_ProdMarks]
FOR UPDATE AS
/* r_ProdMarks - Справочник товаров: маркировки - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdMarks ^ r_Prods - Проверка в PARENT */
/* Справочник товаров: маркировки ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_ProdMarks', 1
        RETURN
      END

/* r_ProdMarks ^ t_CRRetD - Обновление CHILD */
/* Справочник товаров: маркировки ^ Возврат товара по чеку: Товар - Обновление CHILD */
  IF UPDATE(MarkCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.MarkCode = i.MarkCode
          FROM t_CRRetD a, inserted i, deleted d WHERE a.MarkCode = d.MarkCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRRetD a, deleted d WHERE a.MarkCode = d.MarkCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров: маркировки'' => ''Возврат товара по чеку: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_ProdMarks ^ t_SaleD - Обновление CHILD */
/* Справочник товаров: маркировки ^ Продажа товара оператором: Продажи товара - Обновление CHILD */
  IF UPDATE(MarkCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.MarkCode = i.MarkCode
          FROM t_SaleD a, inserted i, deleted d WHERE a.MarkCode = d.MarkCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleD a, deleted d WHERE a.MarkCode = d.MarkCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров: маркировки'' => ''Продажа товара оператором: Продажи товара''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_ProdMarks ^ t_SaleTempD - Обновление CHILD */
/* Справочник товаров: маркировки ^ Временные данные продаж: Товар - Обновление CHILD */
  IF UPDATE(MarkCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.MarkCode = i.MarkCode
          FROM t_SaleTempD a, inserted i, deleted d WHERE a.MarkCode = d.MarkCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleTempD a, deleted d WHERE a.MarkCode = d.MarkCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров: маркировки'' => ''Временные данные продаж: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_ProdMarks', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ProdMarks] ON [r_ProdMarks]
FOR DELETE AS
/* r_ProdMarks - Справочник товаров: маркировки - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_ProdMarks ^ t_CRRetD - Проверка в CHILD */
/* Справочник товаров: маркировки ^ Возврат товара по чеку: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRRetD a WITH(NOLOCK), deleted d WHERE a.MarkCode = d.MarkCode)
    BEGIN
      EXEC z_RelationError 'r_ProdMarks', 't_CRRetD', 3
      RETURN
    END

/* r_ProdMarks ^ t_SaleD - Проверка в CHILD */
/* Справочник товаров: маркировки ^ Продажа товара оператором: Продажи товара - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SaleD a WITH(NOLOCK), deleted d WHERE a.MarkCode = d.MarkCode)
    BEGIN
      EXEC z_RelationError 'r_ProdMarks', 't_SaleD', 3
      RETURN
    END

/* r_ProdMarks ^ t_SaleTempD - Проверка в CHILD */
/* Справочник товаров: маркировки ^ Временные данные продаж: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SaleTempD a WITH(NOLOCK), deleted d WHERE a.MarkCode = d.MarkCode)
    BEGIN
      EXEC z_RelationError 'r_ProdMarks', 't_SaleTempD', 3
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_ProdMarks', N'Last', N'DELETE'
GO