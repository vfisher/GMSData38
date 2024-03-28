CREATE TABLE [dbo].[z_UserOpenAge]
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
[ChUserID] [smallint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_UserOpenAge] ADD CONSTRAINT [pk_z_UserOpenAge] PRIMARY KEY CLUSTERED ([OurID], [UserID]) ON [PRIMARY]
GO
