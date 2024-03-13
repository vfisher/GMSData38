CREATE TABLE [dbo].[r_LevyRates]
(
[LevyID] [int] NOT NULL,
[ChDate] [smalldatetime] NOT NULL,
[LevyPercent] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_LevyRates] ADD CONSTRAINT [pk_r_LevyRates] PRIMARY KEY CLUSTERED ([LevyID], [ChDate]) ON [PRIMARY]
GO
