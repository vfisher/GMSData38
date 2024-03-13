CREATE TABLE [dbo].[r_Countries]
(
[ChID] [bigint] NOT NULL,
[CounID] [smallint] NOT NULL,
[Country] [varchar] (200) NOT NULL,
[UACountry] [varchar] (200) NOT NULL,
[CountryCode2] [varchar] (2) NOT NULL,
[CountryCode3] [varchar] (3) NOT NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Countries] ADD CONSTRAINT [pk_r_Countries] PRIMARY KEY CLUSTERED ([CounID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Countries] ([ChID]) ON [PRIMARY]
GO
