CREATE TABLE [dbo].[z_OpenAgeH]
(
[OurID] [int] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[OpenAgeBType] [tinyint] NOT NULL,
[OpenAgeEType] [tinyint] NOT NULL,
[OpenAgeBQty] [smallint] NOT NULL,
[OpenAgeEQty] [smallint] NOT NULL,
[ChUserID] [smallint] NOT NULL,
[ChDate] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_OpenAgeH] ADD CONSTRAINT [pk_z_OpenAgeH] PRIMARY KEY CLUSTERED ([OurID], [ChDate]) ON [PRIMARY]
GO
