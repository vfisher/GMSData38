CREATE TABLE [dbo].[r_Uni]
(
[RefTypeID] [int] NOT NULL,
[RefID] [int] NOT NULL,
[RefName] [varchar] (300) NOT NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Uni] ON [dbo].[r_Uni]
FOR INSERT AS
/* r_Uni - Справочник универсальный - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Uni ^ r_UniTypes - Проверка в PARENT */
/* Справочник универсальный ^ Справочник универсальный: типы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.RefTypeID NOT IN (SELECT RefTypeID FROM r_UniTypes))
    BEGIN
      EXEC z_RelationError 'r_UniTypes', 'r_Uni', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10010002, m.ChID, 
    '[' + cast(i.RefTypeID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.RefID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_UniTypes m ON m.RefTypeID = i.RefTypeID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_Uni]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Uni] ON [dbo].[r_Uni]
FOR UPDATE AS
/* r_Uni - Справочник универсальный - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Uni ^ r_UniTypes - Проверка в PARENT */
/* Справочник универсальный ^ Справочник универсальный: типы - Проверка в PARENT */
  IF UPDATE(RefTypeID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.RefTypeID NOT IN (SELECT RefTypeID FROM r_UniTypes))
      BEGIN
        EXEC z_RelationError 'r_UniTypes', 'r_Uni', 1
        RETURN
      END

/* r_Uni ^ r_CRUniInput - Обновление CHILD */
/* Справочник универсальный ^ Справочник ЭККА: единый ввод - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UniInputAction = i.RefID
          FROM r_CRUniInput a, inserted i, deleted d WHERE 10455 = d.RefTypeID AND a.UniInputAction = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CRUniInput a, deleted d WHERE 10455 = d.RefTypeID AND a.UniInputAction = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Справочник ЭККА: единый ввод''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ r_ProdImages - Обновление CHILD */
/* Справочник универсальный ^ Справочник товаров: изображения - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ImageType = i.RefID
          FROM r_ProdImages a, inserted i, deleted d WHERE 10608 = d.RefTypeID AND a.ImageType = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdImages a, deleted d WHERE 10608 = d.RefTypeID AND a.ImageType = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Справочник товаров: изображения''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ r_EmpFiles - Обновление CHILD */
/* Справочник универсальный ^ Справочник служащих: Документы - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpDocID = i.RefID
          FROM r_EmpFiles a, inserted i, deleted d WHERE 10609 = d.RefTypeID AND a.EmpDocID = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpFiles a, deleted d WHERE 10609 = d.RefTypeID AND a.EmpDocID = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Справочник служащих: Документы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ r_EmpMPst - Обновление CHILD */
/* Справочник универсальный ^ Справочник служащих - Должности и оплата труда - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PensMethod = i.RefID
          FROM r_EmpMPst a, inserted i, deleted d WHERE 10057 = d.RefTypeID AND a.PensMethod = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpMPst a, deleted d WHERE 10057 = d.RefTypeID AND a.PensMethod = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Справочник служащих - Должности и оплата труда''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ r_EmpMPst - Обновление CHILD */
/* Справочник универсальный ^ Справочник служащих - Должности и оплата труда - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PensCatID = i.RefID
          FROM r_EmpMPst a, inserted i, deleted d WHERE 10058 = d.RefTypeID AND a.PensCatID = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpMPst a, deleted d WHERE 10058 = d.RefTypeID AND a.PensCatID = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Справочник служащих - Должности и оплата труда''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ r_Emps - Обновление CHILD */
/* Справочник универсальный ^ Справочник служащих - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpSex = i.RefID
          FROM r_Emps a, inserted i, deleted d WHERE 10011 = d.RefTypeID AND a.EmpSex = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Emps a, deleted d WHERE 10011 = d.RefTypeID AND a.EmpSex = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Справочник служащих''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ r_Emps - Обновление CHILD */
/* Справочник универсальный ^ Справочник служащих - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.Education = i.RefID
          FROM r_Emps a, inserted i, deleted d WHERE 10061 = d.RefTypeID AND a.Education = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Emps a, deleted d WHERE 10061 = d.RefTypeID AND a.Education = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Справочник служащих''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ r_Emps - Обновление CHILD */
/* Справочник универсальный ^ Справочник служащих - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.FamilyStatus = i.RefID
          FROM r_Emps a, inserted i, deleted d WHERE 10062 = d.RefTypeID AND a.FamilyStatus = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Emps a, deleted d WHERE 10062 = d.RefTypeID AND a.FamilyStatus = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Справочник служащих''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ r_Emps - Обновление CHILD */
/* Справочник универсальный ^ Справочник служащих - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.MilStatus = i.RefID
          FROM r_Emps a, inserted i, deleted d WHERE 10063 = d.RefTypeID AND a.MilStatus = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Emps a, deleted d WHERE 10063 = d.RefTypeID AND a.MilStatus = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Справочник служащих''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ r_Emps - Обновление CHILD */
/* Справочник универсальный ^ Справочник служащих - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.MilFitness = i.RefID
          FROM r_Emps a, inserted i, deleted d WHERE 10064 = d.RefTypeID AND a.MilFitness = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Emps a, deleted d WHERE 10064 = d.RefTypeID AND a.MilFitness = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Справочник служащих''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ r_Emps - Обновление CHILD */
/* Справочник универсальный ^ Справочник служащих - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ShiftPostID = i.RefID
          FROM r_Emps a, inserted i, deleted d WHERE 10606 = d.RefTypeID AND a.ShiftPostID = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Emps a, deleted d WHERE 10606 = d.RefTypeID AND a.ShiftPostID = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Справочник служащих''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ r_Persons - Обновление CHILD */
/* Справочник универсальный ^ Справочник персон - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.Sex = i.RefID
          FROM r_Persons a, inserted i, deleted d WHERE 10011 = d.RefTypeID AND a.Sex = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Persons a, deleted d WHERE 10011 = d.RefTypeID AND a.Sex = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Справочник персон''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ r_Persons - Обновление CHILD */
/* Справочник универсальный ^ Справочник персон - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.State = i.RefID
          FROM r_Persons a, inserted i, deleted d WHERE 10701 = d.RefTypeID AND a.State = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Persons a, deleted d WHERE 10701 = d.RefTypeID AND a.State = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Справочник персон''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ r_CandidateFiles - Обновление CHILD */
/* Справочник универсальный ^ Справочник кандидатов: Документы - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpDocID = i.RefID
          FROM r_CandidateFiles a, inserted i, deleted d WHERE 10609 = d.RefTypeID AND a.EmpDocID = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CandidateFiles a, deleted d WHERE 10609 = d.RefTypeID AND a.EmpDocID = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Справочник кандидатов: Документы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ r_Candidates - Обновление CHILD */
/* Справочник универсальный ^ Справочник кандидатов - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CandidateID = i.RefID
          FROM r_Candidates a, inserted i, deleted d WHERE 10611 = d.RefTypeID AND a.CandidateID = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Candidates a, deleted d WHERE 10611 = d.RefTypeID AND a.CandidateID = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Справочник кандидатов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ r_Candidates - Обновление CHILD */
/* Справочник универсальный ^ Справочник кандидатов - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ResultCheckAO = i.RefID
          FROM r_Candidates a, inserted i, deleted d WHERE 10612 = d.RefTypeID AND a.ResultCheckAO = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Candidates a, deleted d WHERE 10612 = d.RefTypeID AND a.ResultCheckAO = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Справочник кандидатов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ r_Posts - Обновление CHILD */
/* Справочник универсальный ^ Справочник должностей - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PostTypeID = i.RefID
          FROM r_Posts a, inserted i, deleted d WHERE 10050 = d.RefTypeID AND a.PostTypeID = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Posts a, deleted d WHERE 10050 = d.RefTypeID AND a.PostTypeID = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Справочник должностей''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ b_TExp - Обновление CHILD */
/* Справочник универсальный ^ Налоговые накладные: Исходящие - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PosType = i.RefID
          FROM b_TExp a, inserted i, deleted d WHERE 10041 = d.RefTypeID AND a.PosType = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TExp a, deleted d WHERE 10041 = d.RefTypeID AND a.PosType = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Налоговые накладные: Исходящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ b_TExp - Обновление CHILD */
/* Справочник универсальный ^ Налоговые накладные: Исходящие - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TaxCorrType = i.RefID
          FROM b_TExp a, inserted i, deleted d WHERE 10042 = d.RefTypeID AND a.TaxCorrType = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TExp a, deleted d WHERE 10042 = d.RefTypeID AND a.TaxCorrType = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Налоговые накладные: Исходящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ b_TRec - Обновление CHILD */
/* Справочник универсальный ^ Налоговые накладные: Входящие - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PosType = i.RefID
          FROM b_TRec a, inserted i, deleted d WHERE 10041 = d.RefTypeID AND a.PosType = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TRec a, deleted d WHERE 10041 = d.RefTypeID AND a.PosType = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Налоговые накладные: Входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ b_TRec - Обновление CHILD */
/* Справочник универсальный ^ Налоговые накладные: Входящие - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TaxCorrType = i.RefID
          FROM b_TRec a, inserted i, deleted d WHERE 10042 = d.RefTypeID AND a.TaxCorrType = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TRec a, deleted d WHERE 10042 = d.RefTypeID AND a.TaxCorrType = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Налоговые накладные: Входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ p_EDis - Обновление CHILD */
/* Справочник универсальный ^ Приказ: Увольнение - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DisReason = i.RefID
          FROM p_EDis a, inserted i, deleted d WHERE 10055 = d.RefTypeID AND a.DisReason = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EDis a, deleted d WHERE 10055 = d.RefTypeID AND a.DisReason = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Приказ: Увольнение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ p_EExc - Обновление CHILD */
/* Справочник универсальный ^ Приказ: Кадровое перемещение - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PensMethod = i.RefID
          FROM p_EExc a, inserted i, deleted d WHERE 10057 = d.RefTypeID AND a.PensMethod = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EExc a, deleted d WHERE 10057 = d.RefTypeID AND a.PensMethod = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Приказ: Кадровое перемещение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ p_EExc - Обновление CHILD */
/* Справочник универсальный ^ Приказ: Кадровое перемещение - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PensCatID = i.RefID
          FROM p_EExc a, inserted i, deleted d WHERE 10058 = d.RefTypeID AND a.PensCatID = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EExc a, deleted d WHERE 10058 = d.RefTypeID AND a.PensCatID = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Приказ: Кадровое перемещение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ p_EGiv - Обновление CHILD */
/* Справочник универсальный ^ Приказ: Прием на работу - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PensMethod = i.RefID
          FROM p_EGiv a, inserted i, deleted d WHERE 10057 = d.RefTypeID AND a.PensMethod = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EGiv a, deleted d WHERE 10057 = d.RefTypeID AND a.PensMethod = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Приказ: Прием на работу''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ p_EGiv - Обновление CHILD */
/* Справочник универсальный ^ Приказ: Прием на работу - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PensCatID = i.RefID
          FROM p_EGiv a, inserted i, deleted d WHERE 10058 = d.RefTypeID AND a.PensCatID = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EGiv a, deleted d WHERE 10058 = d.RefTypeID AND a.PensCatID = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Приказ: Прием на работу''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ p_ELeavCorD - Обновление CHILD */
/* Справочник универсальный ^ Приказ: Отпуск: Корректировка (Данные) - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.LeavCorType = i.RefID
          FROM p_ELeavCorD a, inserted i, deleted d WHERE 10059 = d.RefTypeID AND a.LeavCorType = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ELeavCorD a, deleted d WHERE 10059 = d.RefTypeID AND a.LeavCorType = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Приказ: Отпуск: Корректировка (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ p_ELeavCorD - Обновление CHILD */
/* Справочник универсальный ^ Приказ: Отпуск: Корректировка (Данные) - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.LeavCorReason = i.RefID
          FROM p_ELeavCorD a, inserted i, deleted d WHERE 10060 = d.RefTypeID AND a.LeavCorReason = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ELeavCorD a, deleted d WHERE 10060 = d.RefTypeID AND a.LeavCorReason = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Приказ: Отпуск: Корректировка (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ p_ELeavD - Обновление CHILD */
/* Справочник универсальный ^ Приказ: Отпуск (Данные) - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.LeavType = i.RefID
          FROM p_ELeavD a, inserted i, deleted d WHERE 10051 = d.RefTypeID AND a.LeavType = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ELeavD a, deleted d WHERE 10051 = d.RefTypeID AND a.LeavType = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Приказ: Отпуск (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ p_EmpInLeavs - Обновление CHILD */
/* Справочник универсальный ^ Входящие данные по служащим: Отпуска - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.LeavType = i.RefID
          FROM p_EmpInLeavs a, inserted i, deleted d WHERE 10051 = d.RefTypeID AND a.LeavType = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EmpInLeavs a, deleted d WHERE 10051 = d.RefTypeID AND a.LeavType = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Входящие данные по служащим: Отпуска''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ p_ESic - Обновление CHILD */
/* Справочник универсальный ^ Больничный лист (Заголовок) - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SickType = i.RefID
          FROM p_ESic a, inserted i, deleted d WHERE 10056 = d.RefTypeID AND a.SickType = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ESic a, deleted d WHERE 10056 = d.RefTypeID AND a.SickType = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Больничный лист (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ p_LeaveSchedD - Обновление CHILD */
/* Справочник универсальный ^ Отпуск: Лимиты по видам (Данные) - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.LeavType = i.RefID
          FROM p_LeaveSchedD a, inserted i, deleted d WHERE 10051 = d.RefTypeID AND a.LeavType = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LeaveSchedD a, deleted d WHERE 10051 = d.RefTypeID AND a.LeavType = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Отпуск: Лимиты по видам (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ p_LExcD - Обновление CHILD */
/* Справочник универсальный ^ Приказ: Кадровое перемещение списком (Данные) - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PensMethod = i.RefID
          FROM p_LExcD a, inserted i, deleted d WHERE 10057 = d.RefTypeID AND a.PensMethod = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LExcD a, deleted d WHERE 10057 = d.RefTypeID AND a.PensMethod = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Приказ: Кадровое перемещение списком (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ p_LExcD - Обновление CHILD */
/* Справочник универсальный ^ Приказ: Кадровое перемещение списком (Данные) - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PensCatID = i.RefID
          FROM p_LExcD a, inserted i, deleted d WHERE 10058 = d.RefTypeID AND a.PensCatID = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LExcD a, deleted d WHERE 10058 = d.RefTypeID AND a.PensCatID = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Приказ: Кадровое перемещение списком (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ t_CRRetD - Обновление CHILD */
/* Справочник универсальный ^ Возврат товара по чеку: Товар - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CReasonID = i.RefID
          FROM t_CRRetD a, inserted i, deleted d WHERE 10702 = d.RefTypeID AND a.CReasonID = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRRetD a, deleted d WHERE 10702 = d.RefTypeID AND a.CReasonID = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Возврат товара по чеку: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ t_RestShiftD - Обновление CHILD */
/* Справочник универсальный ^ Ресторан: Смена: Персонал - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ShiftPostID = i.RefID
          FROM t_RestShiftD a, inserted i, deleted d WHERE 10606 = d.RefTypeID AND a.ShiftPostID = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_RestShiftD a, deleted d WHERE 10606 = d.RefTypeID AND a.ShiftPostID = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Ресторан: Смена: Персонал''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ t_SaleC - Обновление CHILD */
/* Справочник универсальный ^ Продажа товара оператором: Отмены продаж - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CReasonID = i.RefID
          FROM t_SaleC a, inserted i, deleted d WHERE 10607 = d.RefTypeID AND a.CReasonID = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleC a, deleted d WHERE 10607 = d.RefTypeID AND a.CReasonID = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Продажа товара оператором: Отмены продаж''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ t_VenI - Обновление CHILD */
/* Справочник универсальный ^ Инвентаризация товара: Первичные данные - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.InputTypeID = i.RefID
          FROM t_VenI a, inserted i, deleted d WHERE 10800 = d.RefTypeID AND a.InputTypeID = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_VenI a, deleted d WHERE 10800 = d.RefTypeID AND a.InputTypeID = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Инвентаризация товара: Первичные данные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Uni ^ z_Contracts - Обновление CHILD */
/* Справочник универсальный ^ Договор - Обновление CHILD */
  IF UPDATE(RefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CivilContractType = i.RefID
          FROM z_Contracts a, inserted i, deleted d WHERE 10020 = d.RefTypeID AND a.CivilContractType = d.RefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Contracts a, deleted d WHERE 10020 = d.RefTypeID AND a.CivilContractType = d.RefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный'' => ''Договор''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(RefTypeID) OR UPDATE(RefID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT RefTypeID, RefID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT RefTypeID, RefID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.RefTypeID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.RefID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10010002 AND l.PKValue = 
          '[' + cast(d.RefTypeID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.RefID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.RefTypeID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.RefID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10010002 AND l.PKValue = 
          '[' + cast(d.RefTypeID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.RefID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10010002, m.ChID, 
          '[' + cast(d.RefTypeID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.RefID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_UniTypes m ON m.RefTypeID = d.RefTypeID
          DELETE FROM z_LogCreate WHERE TableCode = 10010002 AND PKValue IN (SELECT 
          '[' + cast(RefTypeID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(RefID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10010002 AND PKValue IN (SELECT 
          '[' + cast(RefTypeID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(RefID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10010002, m.ChID, 
          '[' + cast(i.RefTypeID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.RefID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_UniTypes m ON m.RefTypeID = i.RefTypeID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10010002, m.ChID, 
    '[' + cast(i.RefTypeID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.RefID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_UniTypes m ON m.RefTypeID = i.RefTypeID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_Uni]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Uni] ON [dbo].[r_Uni]
FOR DELETE AS
/* r_Uni - Справочник универсальный - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Uni ^ r_CRUniInput - Проверка в CHILD */
/* Справочник универсальный ^ Справочник ЭККА: единый ввод - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_CRUniInput a WITH(NOLOCK), deleted d WHERE 10455 = d.RefTypeID AND a.UniInputAction = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'r_CRUniInput', 10455, 3
      RETURN
    END

/* r_Uni ^ r_ProdImages - Проверка в CHILD */
/* Справочник универсальный ^ Справочник товаров: изображения - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ProdImages a WITH(NOLOCK), deleted d WHERE 10608 = d.RefTypeID AND a.ImageType = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'r_ProdImages', 10608, 3
      RETURN
    END

/* r_Uni ^ r_EmpFiles - Проверка в CHILD */
/* Справочник универсальный ^ Справочник служащих: Документы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_EmpFiles a WITH(NOLOCK), deleted d WHERE 10609 = d.RefTypeID AND a.EmpDocID = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'r_EmpFiles', 10609, 3
      RETURN
    END

/* r_Uni ^ r_EmpMPst - Проверка в CHILD */
/* Справочник универсальный ^ Справочник служащих - Должности и оплата труда - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_EmpMPst a WITH(NOLOCK), deleted d WHERE 10057 = d.RefTypeID AND a.PensMethod = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'r_EmpMPst', 10057, 3
      RETURN
    END

/* r_Uni ^ r_EmpMPst - Проверка в CHILD */
/* Справочник универсальный ^ Справочник служащих - Должности и оплата труда - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_EmpMPst a WITH(NOLOCK), deleted d WHERE 10058 = d.RefTypeID AND a.PensCatID = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'r_EmpMPst', 10058, 3
      RETURN
    END

/* r_Uni ^ r_Emps - Проверка в CHILD */
/* Справочник универсальный ^ Справочник служащих - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Emps a WITH(NOLOCK), deleted d WHERE 10011 = d.RefTypeID AND a.EmpSex = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'r_Emps', 10011, 3
      RETURN
    END

/* r_Uni ^ r_Emps - Проверка в CHILD */
/* Справочник универсальный ^ Справочник служащих - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Emps a WITH(NOLOCK), deleted d WHERE 10061 = d.RefTypeID AND a.Education = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'r_Emps', 10061, 3
      RETURN
    END

/* r_Uni ^ r_Emps - Проверка в CHILD */
/* Справочник универсальный ^ Справочник служащих - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Emps a WITH(NOLOCK), deleted d WHERE 10062 = d.RefTypeID AND a.FamilyStatus = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'r_Emps', 10062, 3
      RETURN
    END

/* r_Uni ^ r_Emps - Проверка в CHILD */
/* Справочник универсальный ^ Справочник служащих - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Emps a WITH(NOLOCK), deleted d WHERE 10063 = d.RefTypeID AND a.MilStatus = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'r_Emps', 10063, 3
      RETURN
    END

/* r_Uni ^ r_Emps - Проверка в CHILD */
/* Справочник универсальный ^ Справочник служащих - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Emps a WITH(NOLOCK), deleted d WHERE 10064 = d.RefTypeID AND a.MilFitness = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'r_Emps', 10064, 3
      RETURN
    END

/* r_Uni ^ r_Emps - Проверка в CHILD */
/* Справочник универсальный ^ Справочник служащих - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Emps a WITH(NOLOCK), deleted d WHERE 10606 = d.RefTypeID AND a.ShiftPostID = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'r_Emps', 10606, 3
      RETURN
    END

/* r_Uni ^ r_Persons - Проверка в CHILD */
/* Справочник универсальный ^ Справочник персон - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Persons a WITH(NOLOCK), deleted d WHERE 10011 = d.RefTypeID AND a.Sex = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'r_Persons', 10011, 3
      RETURN
    END

/* r_Uni ^ r_Persons - Проверка в CHILD */
/* Справочник универсальный ^ Справочник персон - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Persons a WITH(NOLOCK), deleted d WHERE 10701 = d.RefTypeID AND a.State = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'r_Persons', 10701, 3
      RETURN
    END

/* r_Uni ^ r_CandidateFiles - Проверка в CHILD */
/* Справочник универсальный ^ Справочник кандидатов: Документы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_CandidateFiles a WITH(NOLOCK), deleted d WHERE 10609 = d.RefTypeID AND a.EmpDocID = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'r_CandidateFiles', 10609, 3
      RETURN
    END

/* r_Uni ^ r_Candidates - Проверка в CHILD */
/* Справочник универсальный ^ Справочник кандидатов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Candidates a WITH(NOLOCK), deleted d WHERE 10611 = d.RefTypeID AND a.CandidateID = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'r_Candidates', 10611, 3
      RETURN
    END

/* r_Uni ^ r_Candidates - Проверка в CHILD */
/* Справочник универсальный ^ Справочник кандидатов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Candidates a WITH(NOLOCK), deleted d WHERE 10612 = d.RefTypeID AND a.ResultCheckAO = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'r_Candidates', 10612, 3
      RETURN
    END

/* r_Uni ^ r_Posts - Проверка в CHILD */
/* Справочник универсальный ^ Справочник должностей - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Posts a WITH(NOLOCK), deleted d WHERE 10050 = d.RefTypeID AND a.PostTypeID = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'r_Posts', 10050, 3
      RETURN
    END

/* r_Uni ^ b_TExp - Проверка в CHILD */
/* Справочник универсальный ^ Налоговые накладные: Исходящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TExp a WITH(NOLOCK), deleted d WHERE 10041 = d.RefTypeID AND a.PosType = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'b_TExp', 10041, 3
      RETURN
    END

/* r_Uni ^ b_TExp - Проверка в CHILD */
/* Справочник универсальный ^ Налоговые накладные: Исходящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TExp a WITH(NOLOCK), deleted d WHERE 10042 = d.RefTypeID AND a.TaxCorrType = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'b_TExp', 10042, 3
      RETURN
    END

/* r_Uni ^ b_TRec - Проверка в CHILD */
/* Справочник универсальный ^ Налоговые накладные: Входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TRec a WITH(NOLOCK), deleted d WHERE 10041 = d.RefTypeID AND a.PosType = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'b_TRec', 10041, 3
      RETURN
    END

/* r_Uni ^ b_TRec - Проверка в CHILD */
/* Справочник универсальный ^ Налоговые накладные: Входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TRec a WITH(NOLOCK), deleted d WHERE 10042 = d.RefTypeID AND a.TaxCorrType = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'b_TRec', 10042, 3
      RETURN
    END

/* r_Uni ^ p_EDis - Проверка в CHILD */
/* Справочник универсальный ^ Приказ: Увольнение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EDis a WITH(NOLOCK), deleted d WHERE 10055 = d.RefTypeID AND a.DisReason = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'p_EDis', 10055, 3
      RETURN
    END

/* r_Uni ^ p_EExc - Проверка в CHILD */
/* Справочник универсальный ^ Приказ: Кадровое перемещение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EExc a WITH(NOLOCK), deleted d WHERE 10057 = d.RefTypeID AND a.PensMethod = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'p_EExc', 10057, 3
      RETURN
    END

/* r_Uni ^ p_EExc - Проверка в CHILD */
/* Справочник универсальный ^ Приказ: Кадровое перемещение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EExc a WITH(NOLOCK), deleted d WHERE 10058 = d.RefTypeID AND a.PensCatID = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'p_EExc', 10058, 3
      RETURN
    END

/* r_Uni ^ p_EGiv - Проверка в CHILD */
/* Справочник универсальный ^ Приказ: Прием на работу - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EGiv a WITH(NOLOCK), deleted d WHERE 10057 = d.RefTypeID AND a.PensMethod = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'p_EGiv', 10057, 3
      RETURN
    END

/* r_Uni ^ p_EGiv - Проверка в CHILD */
/* Справочник универсальный ^ Приказ: Прием на работу - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EGiv a WITH(NOLOCK), deleted d WHERE 10058 = d.RefTypeID AND a.PensCatID = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'p_EGiv', 10058, 3
      RETURN
    END

/* r_Uni ^ p_ELeavCorD - Проверка в CHILD */
/* Справочник универсальный ^ Приказ: Отпуск: Корректировка (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ELeavCorD a WITH(NOLOCK), deleted d WHERE 10059 = d.RefTypeID AND a.LeavCorType = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'p_ELeavCorD', 10059, 3
      RETURN
    END

/* r_Uni ^ p_ELeavCorD - Проверка в CHILD */
/* Справочник универсальный ^ Приказ: Отпуск: Корректировка (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ELeavCorD a WITH(NOLOCK), deleted d WHERE 10060 = d.RefTypeID AND a.LeavCorReason = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'p_ELeavCorD', 10060, 3
      RETURN
    END

/* r_Uni ^ p_ELeavD - Проверка в CHILD */
/* Справочник универсальный ^ Приказ: Отпуск (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ELeavD a WITH(NOLOCK), deleted d WHERE 10051 = d.RefTypeID AND a.LeavType = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'p_ELeavD', 10051, 3
      RETURN
    END

/* r_Uni ^ p_EmpInLeavs - Проверка в CHILD */
/* Справочник универсальный ^ Входящие данные по служащим: Отпуска - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EmpInLeavs a WITH(NOLOCK), deleted d WHERE 10051 = d.RefTypeID AND a.LeavType = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'p_EmpInLeavs', 10051, 3
      RETURN
    END

/* r_Uni ^ p_ESic - Проверка в CHILD */
/* Справочник универсальный ^ Больничный лист (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ESic a WITH(NOLOCK), deleted d WHERE 10056 = d.RefTypeID AND a.SickType = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'p_ESic', 10056, 3
      RETURN
    END

/* r_Uni ^ p_LeaveSchedD - Проверка в CHILD */
/* Справочник универсальный ^ Отпуск: Лимиты по видам (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LeaveSchedD a WITH(NOLOCK), deleted d WHERE 10051 = d.RefTypeID AND a.LeavType = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'p_LeaveSchedD', 10051, 3
      RETURN
    END

/* r_Uni ^ p_LExcD - Проверка в CHILD */
/* Справочник универсальный ^ Приказ: Кадровое перемещение списком (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LExcD a WITH(NOLOCK), deleted d WHERE 10057 = d.RefTypeID AND a.PensMethod = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'p_LExcD', 10057, 3
      RETURN
    END

/* r_Uni ^ p_LExcD - Проверка в CHILD */
/* Справочник универсальный ^ Приказ: Кадровое перемещение списком (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LExcD a WITH(NOLOCK), deleted d WHERE 10058 = d.RefTypeID AND a.PensCatID = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'p_LExcD', 10058, 3
      RETURN
    END

/* r_Uni ^ t_CRRetD - Проверка в CHILD */
/* Справочник универсальный ^ Возврат товара по чеку: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRRetD a WITH(NOLOCK), deleted d WHERE 10702 = d.RefTypeID AND a.CReasonID = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 't_CRRetD', 10702, 3
      RETURN
    END

/* r_Uni ^ t_RestShiftD - Проверка в CHILD */
/* Справочник универсальный ^ Ресторан: Смена: Персонал - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_RestShiftD a WITH(NOLOCK), deleted d WHERE 10606 = d.RefTypeID AND a.ShiftPostID = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 't_RestShiftD', 10606, 3
      RETURN
    END

/* r_Uni ^ t_SaleC - Проверка в CHILD */
/* Справочник универсальный ^ Продажа товара оператором: Отмены продаж - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SaleC a WITH(NOLOCK), deleted d WHERE 10607 = d.RefTypeID AND a.CReasonID = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 't_SaleC', 10607, 3
      RETURN
    END

/* r_Uni ^ t_VenI - Проверка в CHILD */
/* Справочник универсальный ^ Инвентаризация товара: Первичные данные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_VenI a WITH(NOLOCK), deleted d WHERE 10800 = d.RefTypeID AND a.InputTypeID = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 't_VenI', 10800, 3
      RETURN
    END

/* r_Uni ^ z_Contracts - Проверка в CHILD */
/* Справочник универсальный ^ Договор - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Contracts a WITH(NOLOCK), deleted d WHERE 10020 = d.RefTypeID AND a.CivilContractType = d.RefID)
    BEGIN
      EXEC z_RelationErrorUni 'z_Contracts', 10020, 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10010002 AND m.PKValue = 
    '[' + cast(i.RefTypeID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.RefID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10010002 AND m.PKValue = 
    '[' + cast(i.RefTypeID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.RefID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10010002, m.ChID, 
    '[' + cast(d.RefTypeID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.RefID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_UniTypes m ON m.RefTypeID = d.RefTypeID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_Uni]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_Uni] ADD CONSTRAINT [pk_r_Uni] PRIMARY KEY CLUSTERED ([RefTypeID], [RefID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueName] ON [dbo].[r_Uni] ([RefTypeID], [RefName]) ON [PRIMARY]
GO
