CREATE TABLE [dbo].[v_SourceGrs]
(
[RepID] [int] NOT NULL,
[SourceGrName] [varchar] (250) NOT NULL,
[SrcPosID] [int] NOT NULL,
[SourceGrType] [smallint] NOT NULL,
[ObjectDef] [text] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_v_SourceGrs] ON [dbo].[v_SourceGrs]
FOR UPDATE AS
/* v_SourceGrs - Анализатор - Группы источников - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldRepID int, @NewRepID int
  DECLARE @OldSourceGrName varchar(250), @NewSourceGrName varchar(250)

/* v_SourceGrs ^ v_MapSG - Обновление CHILD */
/* Анализатор - Группы источников ^ Анализатор - Источники групп - Обновление CHILD */
  IF UPDATE(RepID) OR UPDATE(SourceGrName)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.RepID = i.RepID, a.SourceGrName = i.SourceGrName
          FROM v_MapSG a, inserted i, deleted d WHERE a.RepID = d.RepID AND a.SourceGrName = d.SourceGrName
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(SourceGrName) AND (SELECT COUNT(DISTINCT RepID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT RepID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldRepID = RepID FROM deleted
          SELECT TOP 1 @NewRepID = RepID FROM inserted
          UPDATE v_MapSG SET v_MapSG.RepID = @NewRepID FROM v_MapSG, deleted d WHERE v_MapSG.RepID = @OldRepID AND v_MapSG.SourceGrName = d.SourceGrName
        END
      ELSE IF NOT UPDATE(RepID) AND (SELECT COUNT(DISTINCT SourceGrName) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT SourceGrName) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldSourceGrName = SourceGrName FROM deleted
          SELECT TOP 1 @NewSourceGrName = SourceGrName FROM inserted
          UPDATE v_MapSG SET v_MapSG.SourceGrName = @NewSourceGrName FROM v_MapSG, deleted d WHERE v_MapSG.SourceGrName = @OldSourceGrName AND v_MapSG.RepID = d.RepID
        END
      ELSE IF EXISTS (SELECT * FROM v_MapSG a, deleted d WHERE a.RepID = d.RepID AND a.SourceGrName = d.SourceGrName)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Анализатор - Группы источников'' => ''Анализатор - Источники групп''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_v_SourceGrs]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_v_SourceGrs] ON [dbo].[v_SourceGrs]FOR DELETE AS/* v_SourceGrs - Анализатор - Группы источников - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* v_SourceGrs ^ v_MapSG - Удаление в CHILD *//* Анализатор - Группы источников ^ Анализатор - Источники групп - Удаление в CHILD */  DELETE v_MapSG FROM v_MapSG a, deleted d WHERE a.RepID = d.RepID AND a.SourceGrName = d.SourceGrName  IF @@ERROR > 0 RETURNEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_v_SourceGrs]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[v_SourceGrs] ADD CONSTRAINT [_pk_v_SourceGrs] PRIMARY KEY CLUSTERED ([RepID], [SourceGrName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RepID] ON [dbo].[v_SourceGrs] ([RepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PosID] ON [dbo].[v_SourceGrs] ([SrcPosID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_SourceGrs] ADD CONSTRAINT [FK_v_SourceGrs_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_SourceGrs].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_SourceGrs].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_SourceGrs].[SourceGrType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_SourceGrs].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_SourceGrs].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_SourceGrs].[SourceGrType]'
GO
