CREATE TABLE [dbo].[z_ReplicaSubs]
(
[ReplicaSubCode] [int] NOT NULL,
[ReplicaSubName] [varchar] (200) NOT NULL,
[ReplicaPubCode] [int] NOT NULL,
[PublisherCode] [int] NOT NULL,
[Shed] [varchar] (50) NULL,
[Notes] [varchar] (200) NULL,
[ServiceName] [varchar] (250) NULL,
[UseSched] [bit] NOT NULL DEFAULT (1),
[PCCode] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_ReplicaSubs] ON [dbo].[z_ReplicaSubs]
FOR INSERT AS
/* z_ReplicaSubs - Объекты репликации: Подписки - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_ReplicaSubs ^ r_PCs - Проверка в PARENT */
/* Объекты репликации: Подписки ^ Справочник компьютеров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PublisherCode NOT IN (SELECT PCCode FROM r_PCs))
    BEGIN
      EXEC z_RelationError 'r_PCs', 'z_ReplicaSubs', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_ReplicaSubs]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_ReplicaSubs] ON [dbo].[z_ReplicaSubs]
FOR UPDATE AS
/* z_ReplicaSubs - Объекты репликации: Подписки - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_ReplicaSubs ^ r_PCs - Проверка в PARENT */
/* Объекты репликации: Подписки ^ Справочник компьютеров - Проверка в PARENT */
  IF UPDATE(PublisherCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PublisherCode NOT IN (SELECT PCCode FROM r_PCs))
      BEGIN
        EXEC z_RelationError 'r_PCs', 'z_ReplicaSubs', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_ReplicaSubs]', 'last', 'update', null
GO
ALTER TABLE [dbo].[z_ReplicaSubs] ADD CONSTRAINT [pk_z_ReplicaSubs] PRIMARY KEY CLUSTERED ([ReplicaSubCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PublisherCode] ON [dbo].[z_ReplicaSubs] ([PublisherCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ReplicaPubCode] ON [dbo].[z_ReplicaSubs] ([ReplicaPubCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[z_ReplicaSubs] ([ReplicaSubName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_ReplicaSubs] ADD CONSTRAINT [FK_z_ReplicaSubs_r_PCs] FOREIGN KEY ([PCCode]) REFERENCES [dbo].[r_PCs] ([PCCode]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_ReplicaSubs] ADD CONSTRAINT [FK_z_ReplicaSubs_z_ReplicaPubs] FOREIGN KEY ([ReplicaPubCode]) REFERENCES [dbo].[z_ReplicaPubs] ([ReplicaPubCode]) ON UPDATE CASCADE
GO
