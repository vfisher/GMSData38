CREATE TABLE [dbo].[z_DocDC] (
  [DocCode] [int] NOT NULL,
  [ChID] [bigint] NOT NULL,
  [DCardChID] [bigint] NOT NULL CONSTRAINT [DF__z_DocDC__DCardCh__26F54B27] DEFAULT (0),
  CONSTRAINT [pk_z_DocDC] PRIMARY KEY CLUSTERED ([DocCode], [ChID], [DCardChID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_DocDC] ON [z_DocDC]
FOR INSERT AS
/* z_DocDC - Документы - Дисконтные карты - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_DocDC ^ t_CRRet - Проверка в PARENT */
/* Документы - Дисконтные карты ^ Возврат товара по чеку: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11004 AND i.ChID NOT IN (SELECT ChID FROM t_CRRet))
    BEGIN
      EXEC z_RelationError 't_CRRet', 'z_DocDC', 0
      RETURN
    END

/* z_DocDC ^ t_Sale - Проверка в PARENT */
/* Документы - Дисконтные карты ^ Продажа товара оператором: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11035 AND i.ChID NOT IN (SELECT ChID FROM t_Sale))
    BEGIN
      EXEC z_RelationError 't_Sale', 'z_DocDC', 0
      RETURN
    END

/* z_DocDC ^ t_SaleTemp - Проверка в PARENT */
/* Документы - Дисконтные карты ^ Временные данные продаж: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 1011 AND i.ChID NOT IN (SELECT ChID FROM t_SaleTemp))
    BEGIN
      EXEC z_RelationError 't_SaleTemp', 'z_DocDC', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_DocDC', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_DocDC] ON [z_DocDC]
FOR UPDATE AS
/* z_DocDC - Документы - Дисконтные карты - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_DocDC ^ t_CRRet - Проверка в PARENT */
/* Документы - Дисконтные карты ^ Возврат товара по чеку: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11004 AND i.ChID NOT IN (SELECT ChID FROM t_CRRet))
      BEGIN
        EXEC z_RelationError 't_CRRet', 'z_DocDC', 1
        RETURN
      END

/* z_DocDC ^ t_Sale - Проверка в PARENT */
/* Документы - Дисконтные карты ^ Продажа товара оператором: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11035 AND i.ChID NOT IN (SELECT ChID FROM t_Sale))
      BEGIN
        EXEC z_RelationError 't_Sale', 'z_DocDC', 1
        RETURN
      END

/* z_DocDC ^ t_SaleTemp - Проверка в PARENT */
/* Документы - Дисконтные карты ^ Временные данные продаж: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 1011 AND i.ChID NOT IN (SELECT ChID FROM t_SaleTemp))
      BEGIN
        EXEC z_RelationError 't_SaleTemp', 'z_DocDC', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldChID bigint, @NewChID bigint
  DECLARE @OldDocCode int, @NewDocCode int
  DECLARE @OldDCardChID bigint, @NewDCardChID bigint

/* z_DocDC ^ t_LogDiscExp - Обновление CHILD */
/* Документы - Дисконтные карты ^ Временные данные продаж - Скидки: Списание бонусов - Обновление CHILD */
  IF UPDATE(ChID) OR UPDATE(DocCode) OR UPDATE(DCardChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.DocCode = i.DocCode, a.DCardChID = i.DCardChID
          FROM t_LogDiscExp a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.DocCode = d.DocCode AND a.DCardChID = d.DCardChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(DocCode) AND NOT UPDATE(DCardChID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE t_LogDiscExp SET t_LogDiscExp.ChID = @NewChID FROM t_LogDiscExp, deleted d WHERE t_LogDiscExp.ChID = @OldChID AND t_LogDiscExp.DocCode = d.DocCode AND t_LogDiscExp.DCardChID = d.DCardChID
        END
      ELSE IF NOT UPDATE(ChID) AND NOT UPDATE(DCardChID) AND (SELECT COUNT(DISTINCT DocCode) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT DocCode) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldDocCode = DocCode FROM deleted
          SELECT TOP 1 @NewDocCode = DocCode FROM inserted
          UPDATE t_LogDiscExp SET t_LogDiscExp.DocCode = @NewDocCode FROM t_LogDiscExp, deleted d WHERE t_LogDiscExp.DocCode = @OldDocCode AND t_LogDiscExp.ChID = d.ChID AND t_LogDiscExp.DCardChID = d.DCardChID
        END
      ELSE IF NOT UPDATE(ChID) AND NOT UPDATE(DocCode) AND (SELECT COUNT(DISTINCT DCardChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT DCardChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldDCardChID = DCardChID FROM deleted
          SELECT TOP 1 @NewDCardChID = DCardChID FROM inserted
          UPDATE t_LogDiscExp SET t_LogDiscExp.DCardChID = @NewDCardChID FROM t_LogDiscExp, deleted d WHERE t_LogDiscExp.DCardChID = @OldDCardChID AND t_LogDiscExp.ChID = d.ChID AND t_LogDiscExp.DocCode = d.DocCode
        END
      ELSE IF EXISTS (SELECT * FROM t_LogDiscExp a, deleted d WHERE a.ChID = d.ChID AND a.DocCode = d.DocCode AND a.DCardChID = d.DCardChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Документы - Дисконтные карты'' => ''Временные данные продаж - Скидки: Списание бонусов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_DocDC ^ t_LogDiscExpP - Обновление CHILD */
/* Документы - Дисконтные карты ^ Временные данные продаж - Скидки: Суммы - Обновление CHILD */
  IF UPDATE(ChID) OR UPDATE(DocCode) OR UPDATE(DCardChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.DocCode = i.DocCode, a.DCardChID = i.DCardChID
          FROM t_LogDiscExpP a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.DocCode = d.DocCode AND a.DCardChID = d.DCardChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(DocCode) AND NOT UPDATE(DCardChID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE t_LogDiscExpP SET t_LogDiscExpP.ChID = @NewChID FROM t_LogDiscExpP, deleted d WHERE t_LogDiscExpP.ChID = @OldChID AND t_LogDiscExpP.DocCode = d.DocCode AND t_LogDiscExpP.DCardChID = d.DCardChID
        END
      ELSE IF NOT UPDATE(ChID) AND NOT UPDATE(DCardChID) AND (SELECT COUNT(DISTINCT DocCode) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT DocCode) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldDocCode = DocCode FROM deleted
          SELECT TOP 1 @NewDocCode = DocCode FROM inserted
          UPDATE t_LogDiscExpP SET t_LogDiscExpP.DocCode = @NewDocCode FROM t_LogDiscExpP, deleted d WHERE t_LogDiscExpP.DocCode = @OldDocCode AND t_LogDiscExpP.ChID = d.ChID AND t_LogDiscExpP.DCardChID = d.DCardChID
        END
      ELSE IF NOT UPDATE(ChID) AND NOT UPDATE(DocCode) AND (SELECT COUNT(DISTINCT DCardChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT DCardChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldDCardChID = DCardChID FROM deleted
          SELECT TOP 1 @NewDCardChID = DCardChID FROM inserted
          UPDATE t_LogDiscExpP SET t_LogDiscExpP.DCardChID = @NewDCardChID FROM t_LogDiscExpP, deleted d WHERE t_LogDiscExpP.DCardChID = @OldDCardChID AND t_LogDiscExpP.ChID = d.ChID AND t_LogDiscExpP.DocCode = d.DocCode
        END
      ELSE IF EXISTS (SELECT * FROM t_LogDiscExpP a, deleted d WHERE a.ChID = d.ChID AND a.DocCode = d.DocCode AND a.DCardChID = d.DCardChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Документы - Дисконтные карты'' => ''Временные данные продаж - Скидки: Суммы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_DocDC ^ t_LogDiscRec - Обновление CHILD */
/* Документы - Дисконтные карты ^ Временные данные продаж - Скидки: Начисления бонусов - Обновление CHILD */
  IF UPDATE(ChID) OR UPDATE(DocCode) OR UPDATE(DCardChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.DocCode = i.DocCode, a.DCardChID = i.DCardChID
          FROM t_LogDiscRec a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.DocCode = d.DocCode AND a.DCardChID = d.DCardChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(DocCode) AND NOT UPDATE(DCardChID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE t_LogDiscRec SET t_LogDiscRec.ChID = @NewChID FROM t_LogDiscRec, deleted d WHERE t_LogDiscRec.ChID = @OldChID AND t_LogDiscRec.DocCode = d.DocCode AND t_LogDiscRec.DCardChID = d.DCardChID
        END
      ELSE IF NOT UPDATE(ChID) AND NOT UPDATE(DCardChID) AND (SELECT COUNT(DISTINCT DocCode) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT DocCode) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldDocCode = DocCode FROM deleted
          SELECT TOP 1 @NewDocCode = DocCode FROM inserted
          UPDATE t_LogDiscRec SET t_LogDiscRec.DocCode = @NewDocCode FROM t_LogDiscRec, deleted d WHERE t_LogDiscRec.DocCode = @OldDocCode AND t_LogDiscRec.ChID = d.ChID AND t_LogDiscRec.DCardChID = d.DCardChID
        END
      ELSE IF NOT UPDATE(ChID) AND NOT UPDATE(DocCode) AND (SELECT COUNT(DISTINCT DCardChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT DCardChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldDCardChID = DCardChID FROM deleted
          SELECT TOP 1 @NewDCardChID = DCardChID FROM inserted
          UPDATE t_LogDiscRec SET t_LogDiscRec.DCardChID = @NewDCardChID FROM t_LogDiscRec, deleted d WHERE t_LogDiscRec.DCardChID = @OldDCardChID AND t_LogDiscRec.ChID = d.ChID AND t_LogDiscRec.DocCode = d.DocCode
        END
      ELSE IF EXISTS (SELECT * FROM t_LogDiscRec a, deleted d WHERE a.ChID = d.ChID AND a.DocCode = d.DocCode AND a.DCardChID = d.DCardChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Документы - Дисконтные карты'' => ''Временные данные продаж - Скидки: Начисления бонусов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_DocDC ^ z_LogDiscExp - Обновление CHILD */
/* Документы - Дисконтные карты ^ Регистрация действий - Списание бонусов - Обновление CHILD */
  IF UPDATE(ChID) OR UPDATE(DocCode) OR UPDATE(DCardChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.DocCode = i.DocCode, a.DCardChID = i.DCardChID
          FROM z_LogDiscExp a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.DocCode = d.DocCode AND a.DCardChID = d.DCardChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(DocCode) AND NOT UPDATE(DCardChID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE z_LogDiscExp SET z_LogDiscExp.ChID = @NewChID FROM z_LogDiscExp, deleted d WHERE z_LogDiscExp.ChID = @OldChID AND z_LogDiscExp.DocCode = d.DocCode AND z_LogDiscExp.DCardChID = d.DCardChID
        END
      ELSE IF NOT UPDATE(ChID) AND NOT UPDATE(DCardChID) AND (SELECT COUNT(DISTINCT DocCode) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT DocCode) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldDocCode = DocCode FROM deleted
          SELECT TOP 1 @NewDocCode = DocCode FROM inserted
          UPDATE z_LogDiscExp SET z_LogDiscExp.DocCode = @NewDocCode FROM z_LogDiscExp, deleted d WHERE z_LogDiscExp.DocCode = @OldDocCode AND z_LogDiscExp.ChID = d.ChID AND z_LogDiscExp.DCardChID = d.DCardChID
        END
      ELSE IF NOT UPDATE(ChID) AND NOT UPDATE(DocCode) AND (SELECT COUNT(DISTINCT DCardChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT DCardChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldDCardChID = DCardChID FROM deleted
          SELECT TOP 1 @NewDCardChID = DCardChID FROM inserted
          UPDATE z_LogDiscExp SET z_LogDiscExp.DCardChID = @NewDCardChID FROM z_LogDiscExp, deleted d WHERE z_LogDiscExp.DCardChID = @OldDCardChID AND z_LogDiscExp.ChID = d.ChID AND z_LogDiscExp.DocCode = d.DocCode
        END
      ELSE IF EXISTS (SELECT * FROM z_LogDiscExp a, deleted d WHERE a.ChID = d.ChID AND a.DocCode = d.DocCode AND a.DCardChID = d.DCardChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Документы - Дисконтные карты'' => ''Регистрация действий - Списание бонусов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_DocDC ^ z_LogDiscExpP - Обновление CHILD */
/* Документы - Дисконтные карты ^ Регистрация действий - Скидки - Обновление CHILD */
  IF UPDATE(ChID) OR UPDATE(DocCode) OR UPDATE(DCardChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.DocCode = i.DocCode, a.DCardChID = i.DCardChID
          FROM z_LogDiscExpP a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.DocCode = d.DocCode AND a.DCardChID = d.DCardChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(DocCode) AND NOT UPDATE(DCardChID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE z_LogDiscExpP SET z_LogDiscExpP.ChID = @NewChID FROM z_LogDiscExpP, deleted d WHERE z_LogDiscExpP.ChID = @OldChID AND z_LogDiscExpP.DocCode = d.DocCode AND z_LogDiscExpP.DCardChID = d.DCardChID
        END
      ELSE IF NOT UPDATE(ChID) AND NOT UPDATE(DCardChID) AND (SELECT COUNT(DISTINCT DocCode) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT DocCode) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldDocCode = DocCode FROM deleted
          SELECT TOP 1 @NewDocCode = DocCode FROM inserted
          UPDATE z_LogDiscExpP SET z_LogDiscExpP.DocCode = @NewDocCode FROM z_LogDiscExpP, deleted d WHERE z_LogDiscExpP.DocCode = @OldDocCode AND z_LogDiscExpP.ChID = d.ChID AND z_LogDiscExpP.DCardChID = d.DCardChID
        END
      ELSE IF NOT UPDATE(ChID) AND NOT UPDATE(DocCode) AND (SELECT COUNT(DISTINCT DCardChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT DCardChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldDCardChID = DCardChID FROM deleted
          SELECT TOP 1 @NewDCardChID = DCardChID FROM inserted
          UPDATE z_LogDiscExpP SET z_LogDiscExpP.DCardChID = @NewDCardChID FROM z_LogDiscExpP, deleted d WHERE z_LogDiscExpP.DCardChID = @OldDCardChID AND z_LogDiscExpP.ChID = d.ChID AND z_LogDiscExpP.DocCode = d.DocCode
        END
      ELSE IF EXISTS (SELECT * FROM z_LogDiscExpP a, deleted d WHERE a.ChID = d.ChID AND a.DocCode = d.DocCode AND a.DCardChID = d.DCardChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Документы - Дисконтные карты'' => ''Регистрация действий - Скидки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_DocDC ^ z_LogDiscRec - Обновление CHILD */
/* Документы - Дисконтные карты ^ Регистрация действий - Начисление бонусов - Обновление CHILD */
  IF UPDATE(ChID) OR UPDATE(DocCode) OR UPDATE(DCardChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.DocCode = i.DocCode, a.DCardChID = i.DCardChID
          FROM z_LogDiscRec a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.DocCode = d.DocCode AND a.DCardChID = d.DCardChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(DocCode) AND NOT UPDATE(DCardChID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE z_LogDiscRec SET z_LogDiscRec.ChID = @NewChID FROM z_LogDiscRec, deleted d WHERE z_LogDiscRec.ChID = @OldChID AND z_LogDiscRec.DocCode = d.DocCode AND z_LogDiscRec.DCardChID = d.DCardChID
        END
      ELSE IF NOT UPDATE(ChID) AND NOT UPDATE(DCardChID) AND (SELECT COUNT(DISTINCT DocCode) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT DocCode) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldDocCode = DocCode FROM deleted
          SELECT TOP 1 @NewDocCode = DocCode FROM inserted
          UPDATE z_LogDiscRec SET z_LogDiscRec.DocCode = @NewDocCode FROM z_LogDiscRec, deleted d WHERE z_LogDiscRec.DocCode = @OldDocCode AND z_LogDiscRec.ChID = d.ChID AND z_LogDiscRec.DCardChID = d.DCardChID
        END
      ELSE IF NOT UPDATE(ChID) AND NOT UPDATE(DocCode) AND (SELECT COUNT(DISTINCT DCardChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT DCardChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldDCardChID = DCardChID FROM deleted
          SELECT TOP 1 @NewDCardChID = DCardChID FROM inserted
          UPDATE z_LogDiscRec SET z_LogDiscRec.DCardChID = @NewDCardChID FROM z_LogDiscRec, deleted d WHERE z_LogDiscRec.DCardChID = @OldDCardChID AND z_LogDiscRec.ChID = d.ChID AND z_LogDiscRec.DocCode = d.DocCode
        END
      ELSE IF EXISTS (SELECT * FROM z_LogDiscRec a, deleted d WHERE a.ChID = d.ChID AND a.DocCode = d.DocCode AND a.DCardChID = d.DCardChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Документы - Дисконтные карты'' => ''Регистрация действий - Начисление бонусов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_DocDC', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_DocDC] ON [z_DocDC]
FOR DELETE AS
/* z_DocDC - Документы - Дисконтные карты - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* z_DocDC ^ t_LogDiscExp - Удаление в CHILD */
/* Документы - Дисконтные карты ^ Временные данные продаж - Скидки: Списание бонусов - Удаление в CHILD */
  DELETE t_LogDiscExp FROM t_LogDiscExp a, deleted d WHERE a.ChID = d.ChID AND a.DocCode = d.DocCode AND a.DCardChID = d.DCardChID
  IF @@ERROR > 0 RETURN

/* z_DocDC ^ t_LogDiscExpP - Удаление в CHILD */
/* Документы - Дисконтные карты ^ Временные данные продаж - Скидки: Суммы - Удаление в CHILD */
  DELETE t_LogDiscExpP FROM t_LogDiscExpP a, deleted d WHERE a.ChID = d.ChID AND a.DocCode = d.DocCode AND a.DCardChID = d.DCardChID
  IF @@ERROR > 0 RETURN

/* z_DocDC ^ t_LogDiscRec - Удаление в CHILD */
/* Документы - Дисконтные карты ^ Временные данные продаж - Скидки: Начисления бонусов - Удаление в CHILD */
  DELETE t_LogDiscRec FROM t_LogDiscRec a, deleted d WHERE a.ChID = d.ChID AND a.DocCode = d.DocCode AND a.DCardChID = d.DCardChID
  IF @@ERROR > 0 RETURN

/* z_DocDC ^ z_LogDiscExp - Удаление в CHILD */
/* Документы - Дисконтные карты ^ Регистрация действий - Списание бонусов - Удаление в CHILD */
  DELETE z_LogDiscExp FROM z_LogDiscExp a, deleted d WHERE a.ChID = d.ChID AND a.DocCode = d.DocCode AND a.DCardChID = d.DCardChID
  IF @@ERROR > 0 RETURN

/* z_DocDC ^ z_LogDiscExpP - Удаление в CHILD */
/* Документы - Дисконтные карты ^ Регистрация действий - Скидки - Удаление в CHILD */
  DELETE z_LogDiscExpP FROM z_LogDiscExpP a, deleted d WHERE a.ChID = d.ChID AND a.DocCode = d.DocCode AND a.DCardChID = d.DCardChID
  IF @@ERROR > 0 RETURN

/* z_DocDC ^ z_LogDiscRec - Удаление в CHILD */
/* Документы - Дисконтные карты ^ Регистрация действий - Начисление бонусов - Удаление в CHILD */
  DELETE z_LogDiscRec FROM z_LogDiscRec a, deleted d WHERE a.ChID = d.ChID AND a.DocCode = d.DocCode AND a.DCardChID = d.DCardChID
  IF @@ERROR > 0 RETURN

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_z_DocDC', N'Last', N'DELETE'
GO

ALTER TABLE [dbo].[z_DocDC]
  ADD CONSTRAINT [FK_z_DocDC_r_DCards] FOREIGN KEY ([DCardChID]) REFERENCES [dbo].[r_DCards] ([ChID]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[z_DocDC]
  ADD CONSTRAINT [FK_z_DocDC_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode])
GO