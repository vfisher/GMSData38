CREATE TABLE [dbo].[z_Licenses]
(
[ChID] [bigint] NOT NULL,
[LicType] [int] NOT NULL,
[BlobValue] [image] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_Licenses] ADD CONSTRAINT [PK__z_Licens__AF02F0B8346454DE] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
