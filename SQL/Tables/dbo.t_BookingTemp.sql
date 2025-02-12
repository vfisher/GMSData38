CREATE TABLE [dbo].[t_BookingTemp] (
  [ChID] [bigint] NOT NULL,
  [DocID] [bigint] NOT NULL,
  [OrderID] [int] NULL,
  [DocCreateTime] [datetime] NOT NULL,
  [PersonName] [varchar](250) NULL,
  [Phone] [varchar](20) NULL,
  [Email] [varchar](200) NULL,
  CONSTRAINT [pk_t_BookingTemp] PRIMARY KEY CLUSTERED ([DocID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[t_BookingTemp] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [DocCreateTime]
  ON [dbo].[t_BookingTemp] ([DocCreateTime])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_BookingTemp] ON [t_BookingTemp]
FOR UPDATE AS
/* t_BookingTemp - Интернет заявки - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_BookingTemp ^ t_BookingTempD - Обновление CHILD */
/* Интернет заявки ^ Интернет заявки - подробно - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM t_BookingTempD a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_BookingTempD a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Интернет заявки'' => ''Интернет заявки - подробно''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_BookingTemp', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_BookingTemp] ON [t_BookingTemp]
FOR DELETE AS
/* t_BookingTemp - Интернет заявки - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* t_BookingTemp ^ t_BookingTempD - Удаление в CHILD */
/* Интернет заявки ^ Интернет заявки - подробно - Удаление в CHILD */
  DELETE t_BookingTempD FROM t_BookingTempD a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 11120 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_BookingTemp', N'Last', N'DELETE'
GO