CREATE TABLE [dbo].[r_DiscMessages] (
  [DiscCode] [int] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [LFilterExp] [varchar](max) NULL,
  [EFilterExp] [varchar](max) NULL,
  [PProdFilter] [varchar](4000) NULL,
  [PCatFilter] [varchar](4000) NULL,
  [PGrFilter] [varchar](4000) NULL,
  [PGr1Filter] [varchar](4000) NULL,
  [PGr2Filter] [varchar](4000) NULL,
  [PGr3Filter] [varchar](4000) NULL,
  [Action] [int] NOT NULL,
  [Msg] [varchar](2000) NOT NULL,
  [BeforeAction] [bit] NOT NULL,
  [ContinueRun] [bit] NOT NULL,
  CONSTRAINT [pk_r_DiscMessages] PRIMARY KEY CLUSTERED ([DiscCode], [SrcPosID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_DiscMessages] ON [r_DiscMessages]
FOR INSERT AS
/* r_DiscMessages - Справочник акций: Сообщения - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DiscMessages ^ r_Discs - Проверка в PARENT */
/* Справочник акций: Сообщения ^ Справочник акций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DiscCode NOT IN (SELECT DiscCode FROM r_Discs))
    BEGIN
      EXEC z_RelationError 'r_Discs', 'r_DiscMessages', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_DiscMessages', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_DiscMessages] ON [r_DiscMessages]
FOR UPDATE AS
/* r_DiscMessages - Справочник акций: Сообщения - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DiscMessages ^ r_Discs - Проверка в PARENT */
/* Справочник акций: Сообщения ^ Справочник акций - Проверка в PARENT */
  IF UPDATE(DiscCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DiscCode NOT IN (SELECT DiscCode FROM r_Discs))
      BEGIN
        EXEC z_RelationError 'r_Discs', 'r_DiscMessages', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_DiscMessages', N'Last', N'UPDATE'
GO