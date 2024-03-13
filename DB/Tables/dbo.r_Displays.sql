CREATE TABLE [dbo].[r_Displays]
(
[WPID] [int] NOT NULL,
[DisplayID] [int] NOT NULL,
[DisplayName] [varchar] (100) NOT NULL,
[DisplayModel] [tinyint] NOT NULL,
[Port] [tinyint] NOT NULL,
[Baudrate] [smallint] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Displays] ON [dbo].[r_Displays]
FOR INSERT AS
/* r_Displays - Рабочие места: внешние дисплеи - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Displays ^ r_WPs - Проверка в PARENT */
/* Рабочие места: внешние дисплеи ^ Справочник рабочих мест - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.WPID NOT IN (SELECT WPID FROM r_WPs))
    BEGIN
      EXEC z_RelationError 'r_WPs', 'r_Displays', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_Displays]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Displays] ON [dbo].[r_Displays]
FOR UPDATE AS
/* r_Displays - Рабочие места: внешние дисплеи - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Displays ^ r_WPs - Проверка в PARENT */
/* Рабочие места: внешние дисплеи ^ Справочник рабочих мест - Проверка в PARENT */
  IF UPDATE(WPID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.WPID NOT IN (SELECT WPID FROM r_WPs))
      BEGIN
        EXEC z_RelationError 'r_WPs', 'r_Displays', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_Displays]', 'last', 'update', null
GO
ALTER TABLE [dbo].[r_Displays] ADD CONSTRAINT [pk_r_Displays] PRIMARY KEY CLUSTERED ([DisplayID], [WPID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[r_Displays] ([WPID], [Port]) ON [PRIMARY]
GO
