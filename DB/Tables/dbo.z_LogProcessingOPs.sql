CREATE TABLE [dbo].[z_LogProcessingOPs]
(
[ChID] [bigint] NOT NULL,
[DocTime] [datetime] NOT NULL,
[CRID] [smallint] NOT NULL,
[Operation] [tinyint] NOT NULL,
[Note1] [varchar] (200) NULL,
[Note2] [varchar] (200) NULL,
[Note3] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogProcessingOPs] ADD CONSTRAINT [pk_z_LogProcessingOPs] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocTime_CRID] ON [dbo].[z_LogProcessingOPs] ([DocTime], [CRID]) ON [PRIMARY]
GO
