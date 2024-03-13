CREATE TABLE [dbo].[z_LogTools]
(
[DocDate] [smalldatetime] NOT NULL DEFAULT (getdate()),
[RepToolCode] [int] NOT NULL,
[Note1] [varchar] (200) NULL,
[Note2] [varchar] (200) NULL,
[Note3] [varchar] (200) NULL,
[UserCode] [smallint] NOT NULL DEFAULT ([dbo].[zf_GetUserCode]()),
[ExtraInfo] [varchar] (8000) NULL,
[ChID] [bigint] NOT NULL DEFAULT ((0)),
[WPID] [int] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogTools] ADD CONSTRAINT [pk_z_LogTools] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogTools] ADD CONSTRAINT [FK_z_LogTools_z_ToolRep] FOREIGN KEY ([RepToolCode]) REFERENCES [dbo].[z_ToolRep] ([RepToolCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
