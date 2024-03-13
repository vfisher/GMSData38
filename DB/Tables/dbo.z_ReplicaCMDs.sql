CREATE TABLE [dbo].[z_ReplicaCMDs]
(
[LogId] [int] NOT NULL IDENTITY(1, 1),
[DocTime] [datetime] NULL DEFAULT (getdate()),
[ReplicaCMD] [int] NOT NULL,
[ReplicaSubCode] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_ReplicaCMDs] ADD CONSTRAINT [pk_z_ReplicaCMDs] PRIMARY KEY CLUSTERED ([LogId]) ON [PRIMARY]
GO
