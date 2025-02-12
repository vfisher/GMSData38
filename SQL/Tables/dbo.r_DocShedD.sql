CREATE TABLE [dbo].[r_DocShedD] (
  [DocShedCode] [int] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [StateCode] [int] NOT NULL,
  [DateShift] [int] NOT NULL,
  [DateShiftPart] [int] NOT NULL,
  [PlanDate] [smalldatetime] NULL,
  [StateCodeFrom] [int] NOT NULL,
  [CurrID] [smallint] NOT NULL,
  [SumAC] [numeric](21, 9) NULL,
  [SumCC] [numeric](21, 9) NULL,
  [EnterDate] [bit] NOT NULL,
  [SumACPerc] [numeric](21, 9) NULL,
  [SumCCPerc] [numeric](21, 9) NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [pk_r_DocShedD] PRIMARY KEY CLUSTERED ([DocShedCode], [SrcPosID])
)
ON [PRIMARY]
GO

CREATE INDEX [DocShedCode]
  ON [dbo].[r_DocShedD] ([DocShedCode])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_DocShedD] ON [r_DocShedD]
FOR INSERT AS
/* r_DocShedD - Шаблоны процессов: Детали - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DocShedD ^ r_Currs - Проверка в PARENT */
/* Шаблоны процессов: Детали ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'r_DocShedD', 0
      RETURN
    END

/* r_DocShedD ^ r_DocShed - Проверка в PARENT */
/* Шаблоны процессов: Детали ^ Шаблоны процессов: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocShedCode NOT IN (SELECT DocShedCode FROM r_DocShed))
    BEGIN
      EXEC z_RelationError 'r_DocShed', 'r_DocShedD', 0
      RETURN
    END

/* r_DocShedD ^ r_States - Проверка в PARENT */
/* Шаблоны процессов: Детали ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'r_DocShedD', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_DocShedD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_DocShedD] ON [r_DocShedD]
FOR UPDATE AS
/* r_DocShedD - Шаблоны процессов: Детали - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DocShedD ^ r_Currs - Проверка в PARENT */
/* Шаблоны процессов: Детали ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'r_DocShedD', 1
        RETURN
      END

/* r_DocShedD ^ r_DocShed - Проверка в PARENT */
/* Шаблоны процессов: Детали ^ Шаблоны процессов: Заголовок - Проверка в PARENT */
  IF UPDATE(DocShedCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocShedCode NOT IN (SELECT DocShedCode FROM r_DocShed))
      BEGIN
        EXEC z_RelationError 'r_DocShed', 'r_DocShedD', 1
        RETURN
      END

/* r_DocShedD ^ r_States - Проверка в PARENT */
/* Шаблоны процессов: Детали ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'r_DocShedD', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_DocShedD', N'Last', N'UPDATE'
GO