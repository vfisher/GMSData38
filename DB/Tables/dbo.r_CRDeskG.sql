CREATE TABLE [dbo].[r_CRDeskG]
(
[DeskGCode] [int] NOT NULL,
[WPID] [int] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CRDeskG] ON [dbo].[r_CRDeskG]
FOR INSERT AS
/* r_CRDeskG - Справочник ЭККА - Столики: группы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CRDeskG ^ r_WPs - Проверка в PARENT */
/* Справочник ЭККА - Столики: группы ^ Справочник рабочих мест - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.WPID NOT IN (SELECT WPID FROM r_WPs))
    BEGIN
      EXEC z_RelationError 'r_WPs', 'r_CRDeskG', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_CRDeskG]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CRDeskG] ON [dbo].[r_CRDeskG]
FOR UPDATE AS
/* r_CRDeskG - Справочник ЭККА - Столики: группы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CRDeskG ^ r_WPs - Проверка в PARENT */
/* Справочник ЭККА - Столики: группы ^ Справочник рабочих мест - Проверка в PARENT */
  IF UPDATE(WPID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.WPID NOT IN (SELECT WPID FROM r_WPs))
      BEGIN
        EXEC z_RelationError 'r_WPs', 'r_CRDeskG', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_CRDeskG]', 'last', 'update', null
GO
ALTER TABLE [dbo].[r_CRDeskG] ADD CONSTRAINT [pk_r_CRDeskG] PRIMARY KEY CLUSTERED ([WPID], [DeskGCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CRDeskG] ADD CONSTRAINT [FK_r_CRDeskG_r_DeskG] FOREIGN KEY ([DeskGCode]) REFERENCES [dbo].[r_DeskG] ([DeskGCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
