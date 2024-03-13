CREATE TABLE [dbo].[z_OpenAge]
(
[OurID] [int] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[OpenAgeBType] [tinyint] NOT NULL,
[OpenAgeEType] [tinyint] NOT NULL,
[OpenAgeBQty] [smallint] NOT NULL,
[OpenAgeEQty] [smallint] NOT NULL,
[ChUserID] [smallint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_OpenAge] ADD CONSTRAINT [pk_z_OpenAge] PRIMARY KEY CLUSTERED ([OurID]) ON [PRIMARY]
GO
