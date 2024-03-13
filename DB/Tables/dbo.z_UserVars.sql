CREATE TABLE [dbo].[z_UserVars]
(
[UserCode] [smallint] NOT NULL,
[VarName] [varchar] (250) NOT NULL,
[VarDesc] [varchar] (250) NOT NULL,
[VarValue] [varchar] (250) NULL,
[VarInfo] [varchar] (250) NULL,
[VarType] [int] NOT NULL DEFAULT (0),
[VarSelType] [int] NOT NULL DEFAULT (0),
[VarGroup] [varchar] (250) NULL,
[VarPosID] [int] NOT NULL DEFAULT (0),
[LabelPos] [int] NOT NULL DEFAULT (0),
[VarExtInfo] [varchar] (250) NULL,
[VarVisible] [bit] NOT NULL DEFAULT (1),
[ObjectDef] [text] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_UserVars] ADD CONSTRAINT [pk_z_UserVars] PRIMARY KEY CLUSTERED ([UserCode], [VarName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserCode] ON [dbo].[z_UserVars] ([UserCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VarPosID] ON [dbo].[z_UserVars] ([UserCode], [VarPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VarName] ON [dbo].[z_UserVars] ([VarName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_UserVars] ADD CONSTRAINT [FK_z_UserVars_r_Users] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[r_Users] ([UserID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
