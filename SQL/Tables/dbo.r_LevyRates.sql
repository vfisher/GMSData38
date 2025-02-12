CREATE TABLE [dbo].[r_LevyRates] (
  [LevyID] [int] NOT NULL,
  [ChDate] [smalldatetime] NOT NULL,
  [LevyPercent] [numeric](21, 9) NOT NULL,
  CONSTRAINT [pk_r_LevyRates] PRIMARY KEY CLUSTERED ([LevyID], [ChDate])
)
ON [PRIMARY]
GO