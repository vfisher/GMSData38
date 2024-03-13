CREATE TABLE [dbo].[p_CPIs]
(
[YearID] [smallint] NOT NULL,
[MonthID] [smallint] NOT NULL,
[CPI] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_CPIs] ADD CONSTRAINT [pk_p_CPIs] PRIMARY KEY CLUSTERED ([YearID], [MonthID]) ON [PRIMARY]
GO
