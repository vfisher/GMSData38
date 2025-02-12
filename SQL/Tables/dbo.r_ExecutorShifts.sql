CREATE TABLE [dbo].[r_ExecutorShifts] (
  [ExecutorID] [int] NOT NULL,
  [StockID] [int] NOT NULL,
  [BTime] [smalldatetime] NOT NULL,
  [ETime] [smalldatetime] NOT NULL,
  CONSTRAINT [pk_r_ExecutorShifts] PRIMARY KEY CLUSTERED ([ExecutorID], [StockID], [BTime], [ETime])
)
ON [PRIMARY]
GO

CREATE INDEX [ExecutorID]
  ON [dbo].[r_ExecutorShifts] ([ExecutorID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ExecutorShifts] ON [r_ExecutorShifts]
FOR INSERT AS
/* r_ExecutorShifts - Справочник исполнителей - смены - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ExecutorShifts ^ r_Executors - Проверка в PARENT */
/* Справочник исполнителей - смены ^ Справочник исполнителей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ExecutorID NOT IN (SELECT ExecutorID FROM r_Executors))
    BEGIN
      EXEC z_RelationError 'r_Executors', 'r_ExecutorShifts', 0
      RETURN
    END

/* r_ExecutorShifts ^ r_Stocks - Проверка в PARENT */
/* Справочник исполнителей - смены ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'r_ExecutorShifts', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_ExecutorShifts', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ExecutorShifts] ON [r_ExecutorShifts]
FOR UPDATE AS
/* r_ExecutorShifts - Справочник исполнителей - смены - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ExecutorShifts ^ r_Executors - Проверка в PARENT */
/* Справочник исполнителей - смены ^ Справочник исполнителей - Проверка в PARENT */
  IF UPDATE(ExecutorID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ExecutorID NOT IN (SELECT ExecutorID FROM r_Executors))
      BEGIN
        EXEC z_RelationError 'r_Executors', 'r_ExecutorShifts', 1
        RETURN
      END

/* r_ExecutorShifts ^ r_Stocks - Проверка в PARENT */
/* Справочник исполнителей - смены ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'r_ExecutorShifts', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_ExecutorShifts', N'Last', N'UPDATE'
GO