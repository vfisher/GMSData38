CREATE TABLE [dbo].[z_Vars]
(
[VarName] [varchar] (250) NOT NULL,
[VarDesc] [varchar] (250) NOT NULL,
[VarValue] [varchar] (250) NULL,
[VarInfo] [varchar] (250) NULL,
[VarType] [int] NOT NULL DEFAULT (0),
[VarPageCode] [int] NOT NULL DEFAULT (0),
[VarGroup] [varchar] (250) NULL,
[VarPosID] [int] NOT NULL DEFAULT (0),
[LabelPos] [int] NOT NULL DEFAULT (0),
[VarExtInfo] [varchar] (2000) NULL,
[VarSelType] [int] NOT NULL DEFAULT (0),
[AppCode] [int] NOT NULL DEFAULT (0),
[ObjectDef] [text] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_Vars] ADD CONSTRAINT [_pk_z_Vars] PRIMARY KEY CLUSTERED ([VarName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_Vars] ADD CONSTRAINT [FK_z_Vars_z_Apps] FOREIGN KEY ([AppCode]) REFERENCES [dbo].[z_Apps] ([AppCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_Vars] ADD CONSTRAINT [FK_z_Vars_z_VarPages] FOREIGN KEY ([VarPageCode]) REFERENCES [dbo].[z_VarPages] ([VarPageCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
