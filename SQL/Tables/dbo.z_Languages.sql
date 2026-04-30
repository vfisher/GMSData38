CREATE TABLE [dbo].[z_Languages] (
  [LanguageID] [int] NOT NULL,
  [LanguageCode] [varchar](10) NOT NULL,
  [LanguageName] [nvarchar](100) NOT NULL,
  PRIMARY KEY CLUSTERED ([LanguageID]),
  UNIQUE ([LanguageCode])
)
ON [PRIMARY]
GO