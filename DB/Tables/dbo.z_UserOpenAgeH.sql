CREATE TABLE [dbo].[z_UserOpenAgeH]
(
[OurID] [int] NOT NULL,
[UserID] [smallint] NOT NULL,
[UseOpenAge] [bit] NOT NULL,
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
ALTER TABLE [dbo].[z_UserOpenAgeH] ADD CONSTRAINT [pk_z_UserOpenAgeH] PRIMARY KEY CLUSTERED ([OurID], [UserID], [ChDate]) ON [PRIMARY]
GO
