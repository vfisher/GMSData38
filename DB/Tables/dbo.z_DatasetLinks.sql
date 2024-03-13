CREATE TABLE [dbo].[z_DatasetLinks]
(
[DSCode] [int] NOT NULL,
[LinkDSCode] [int] NOT NULL,
[RefreshType] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_DatasetLinks] ADD CONSTRAINT [pk_z_DatasetLinks] PRIMARY KEY CLUSTERED ([DSCode], [LinkDSCode]) ON [PRIMARY]
GO
