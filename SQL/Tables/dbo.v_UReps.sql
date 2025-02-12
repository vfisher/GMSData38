CREATE TABLE [dbo].[v_UReps] (
  [RepID] [int] NOT NULL,
  [UserID] [smallint] NOT NULL,
  [BDate] [smalldatetime] NULL,
  [EDate] [smalldatetime] NULL,
  [DataWidth] [int] NULL,
  [RowHeight] [int] NULL,
  [Processors] [tinyint] NOT NULL,
  [FromLeft] [smallint] NOT NULL,
  [FromTop] [smallint] NOT NULL,
  [Width] [int] NOT NULL,
  [Height] [smallint] NOT NULL,
  [WindowState] [tinyint] NOT NULL,
  [GrandCols] [bit] NOT NULL,
  [GrandRows] [bit] NOT NULL,
  [AlwaysPrepare] [bit] NOT NULL,
  [Optimization] [int] NULL,
  [TempTable] [bit] NOT NULL,
  [FilterOnOpen] [bit] NOT NULL,
  [FilterOnPrepare] [bit] NULL,
  [DateField] [varchar](250) NULL,
  [RepNotesOpen] [bit] NOT NULL,
  [AzPrepareTime] [varchar](250) NULL,
  [TotalTime] [varchar](250) NULL,
  [LastOpen] [varchar](250) NULL,
  [OpenCount] [int] NOT NULL,
  [SendError] [bit] NOT NULL DEFAULT (0),
  [VerID] [int] NOT NULL DEFAULT (1),
  [VerDateTime] [smalldatetime] NULL,
  [VerName] [varchar](200) NULL,
  [FixCols] [bit] NOT NULL DEFAULT (0),
  [FixRows] [bit] NOT NULL DEFAULT (1),
  [ObjectDef] [text] NULL,
  CONSTRAINT [pk_v_UReps] PRIMARY KEY CLUSTERED ([RepID], [UserID], [VerID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [RepID]
  ON [dbo].[v_UReps] ([RepID])
  ON [PRIMARY]
GO

CREATE INDEX [UserID]
  ON [dbo].[v_UReps] ([UserID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UReps.RepID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UReps.UserID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UReps.DataWidth'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UReps.RowHeight'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UReps.Processors'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UReps.FromLeft'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UReps.FromTop'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UReps.Width'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UReps.Height'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UReps.WindowState'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UReps.GrandCols'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UReps.GrandRows'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UReps.AlwaysPrepare'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UReps.Optimization'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UReps.TempTable'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UReps.FilterOnOpen'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UReps.FilterOnPrepare'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UReps.RepNotesOpen'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UReps.OpenCount'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_v_UReps] ON [v_UReps]
FOR INSERT AS
/* v_UReps - Анализатор - Отчеты пользователя - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* v_UReps ^ r_Users - Проверка в PARENT */
/* Анализатор - Отчеты пользователя ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'v_UReps', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_v_UReps', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_v_UReps] ON [v_UReps]
FOR UPDATE AS
/* v_UReps - Анализатор - Отчеты пользователя - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* v_UReps ^ r_Users - Проверка в PARENT */
/* Анализатор - Отчеты пользователя ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'v_UReps', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_v_UReps', N'Last', N'UPDATE'
GO

ALTER TABLE [dbo].[v_UReps]
  ADD CONSTRAINT [FK_v_UReps_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO