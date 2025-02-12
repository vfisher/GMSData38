CREATE TABLE [dbo].[t_BookingTempD] (
  [ChID] [bigint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [SrvcID] [int] NOT NULL,
  [StockID] [int] NOT NULL,
  [ResourceID] [int] NULL,
  [ExecutorID] [int] NULL,
  [BTime] [smalldatetime] NOT NULL,
  [ETime] [smalldatetime] NOT NULL,
  CONSTRAINT [pk_t_BookingTempD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID])
)
ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[t_BookingTempD] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [ExecutorID]
  ON [dbo].[t_BookingTempD] ([ExecutorID])
  ON [PRIMARY]
GO

CREATE INDEX [ResourceID]
  ON [dbo].[t_BookingTempD] ([ResourceID])
  ON [PRIMARY]
GO

CREATE INDEX [SrcPosID]
  ON [dbo].[t_BookingTempD] ([SrcPosID])
  ON [PRIMARY]
GO

CREATE INDEX [SrvcID]
  ON [dbo].[t_BookingTempD] ([SrvcID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_BookingTempD] ON [t_BookingTempD]
FOR INSERT AS
/* t_BookingTempD - Интернет заявки - подробно - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_BookingTempD ^ r_Executors - Проверка в PARENT */
/* Интернет заявки - подробно ^ Справочник исполнителей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ExecutorID IS NOT NULL AND i.ExecutorID NOT IN (SELECT ExecutorID FROM r_Executors))
    BEGIN
      EXEC z_RelationError 'r_Executors', 't_BookingTempD', 0
      RETURN
    END

/* t_BookingTempD ^ r_Resources - Проверка в PARENT */
/* Интернет заявки - подробно ^ Справочник ресурсов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ResourceID IS NOT NULL AND i.ResourceID NOT IN (SELECT ResourceID FROM r_Resources))
    BEGIN
      EXEC z_RelationError 'r_Resources', 't_BookingTempD', 0
      RETURN
    END

/* t_BookingTempD ^ r_Services - Проверка в PARENT */
/* Интернет заявки - подробно ^ Справочник услуг - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SrvcID NOT IN (SELECT SrvcID FROM r_Services))
    BEGIN
      EXEC z_RelationError 'r_Services', 't_BookingTempD', 0
      RETURN
    END

/* t_BookingTempD ^ r_Stocks - Проверка в PARENT */
/* Интернет заявки - подробно ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_BookingTempD', 0
      RETURN
    END

/* t_BookingTempD ^ t_BookingTemp - Проверка в PARENT */
/* Интернет заявки - подробно ^ Интернет заявки - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_BookingTemp))
    BEGIN
      EXEC z_RelationError 't_BookingTemp', 't_BookingTempD', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_BookingTempD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_BookingTempD] ON [t_BookingTempD]
FOR UPDATE AS
/* t_BookingTempD - Интернет заявки - подробно - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_BookingTempD ^ r_Executors - Проверка в PARENT */
/* Интернет заявки - подробно ^ Справочник исполнителей - Проверка в PARENT */
  IF UPDATE(ExecutorID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ExecutorID IS NOT NULL AND i.ExecutorID NOT IN (SELECT ExecutorID FROM r_Executors))
      BEGIN
        EXEC z_RelationError 'r_Executors', 't_BookingTempD', 1
        RETURN
      END

/* t_BookingTempD ^ r_Resources - Проверка в PARENT */
/* Интернет заявки - подробно ^ Справочник ресурсов - Проверка в PARENT */
  IF UPDATE(ResourceID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ResourceID IS NOT NULL AND i.ResourceID NOT IN (SELECT ResourceID FROM r_Resources))
      BEGIN
        EXEC z_RelationError 'r_Resources', 't_BookingTempD', 1
        RETURN
      END

/* t_BookingTempD ^ r_Services - Проверка в PARENT */
/* Интернет заявки - подробно ^ Справочник услуг - Проверка в PARENT */
  IF UPDATE(SrvcID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SrvcID NOT IN (SELECT SrvcID FROM r_Services))
      BEGIN
        EXEC z_RelationError 'r_Services', 't_BookingTempD', 1
        RETURN
      END

/* t_BookingTempD ^ r_Stocks - Проверка в PARENT */
/* Интернет заявки - подробно ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 't_BookingTempD', 1
        RETURN
      END

/* t_BookingTempD ^ t_BookingTemp - Проверка в PARENT */
/* Интернет заявки - подробно ^ Интернет заявки - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_BookingTemp))
      BEGIN
        EXEC z_RelationError 't_BookingTemp', 't_BookingTempD', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_BookingTempD', N'Last', N'UPDATE'
GO