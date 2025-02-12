CREATE TABLE [dbo].[z_DatasetLinks] (
  [DSCode] [int] NOT NULL,
  [LinkDSCode] [int] NOT NULL,
  [RefreshType] [int] NOT NULL,
  CONSTRAINT [pk_z_DatasetLinks] PRIMARY KEY CLUSTERED ([DSCode], [LinkDSCode])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_DatasetLinks] ON [z_DatasetLinks]
FOR INSERT AS
/* z_DatasetLinks - Источники данных - Связи - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_DatasetLinks ^ z_DataSets - Проверка в PARENT */
/* Источники данных - Связи ^ Источники данных - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DSCode NOT IN (SELECT DSCode FROM z_DataSets))
    BEGIN
      EXEC z_RelationError 'z_DataSets', 'z_DatasetLinks', 0
      RETURN
    END

/* z_DatasetLinks ^ z_DataSets - Проверка в PARENT */
/* Источники данных - Связи ^ Источники данных - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.LinkDSCode NOT IN (SELECT DSCode FROM z_DataSets))
    BEGIN
      EXEC z_RelationError 'z_DataSets', 'z_DatasetLinks', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_DatasetLinks', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_DatasetLinks] ON [z_DatasetLinks]
FOR UPDATE AS
/* z_DatasetLinks - Источники данных - Связи - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_DatasetLinks ^ z_DataSets - Проверка в PARENT */
/* Источники данных - Связи ^ Источники данных - Проверка в PARENT */
  IF UPDATE(DSCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DSCode NOT IN (SELECT DSCode FROM z_DataSets))
      BEGIN
        EXEC z_RelationError 'z_DataSets', 'z_DatasetLinks', 1
        RETURN
      END

/* z_DatasetLinks ^ z_DataSets - Проверка в PARENT */
/* Источники данных - Связи ^ Источники данных - Проверка в PARENT */
  IF UPDATE(LinkDSCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.LinkDSCode NOT IN (SELECT DSCode FROM z_DataSets))
      BEGIN
        EXEC z_RelationError 'z_DataSets', 'z_DatasetLinks', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_DatasetLinks', N'Last', N'UPDATE'
GO