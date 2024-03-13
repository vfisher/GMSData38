CREATE TABLE [dbo].[z_Files]
(
[FileID] [uniqueidentifier] NOT NULL,
[FileName] [varchar] (200) NOT NULL,
[ExtFileID] [int] NOT NULL,
[FileDate] [datetime] NOT NULL,
[FileData] [image] NOT NULL,
[DocCode] [int] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_Files] ADD CONSTRAINT [pk_z_Files] PRIMARY KEY CLUSTERED ([FileID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCode] ON [dbo].[z_Files] ([DocCode]) ON [PRIMARY]
GO
