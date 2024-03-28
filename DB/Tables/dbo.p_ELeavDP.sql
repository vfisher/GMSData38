CREATE TABLE [dbo].[p_ELeavDP]
(
[AChID] [bigint] NOT NULL,
[SrcDate] [smalldatetime] NOT NULL,
[LeavDays] [smallint] NOT NULL,
[PLeavSumCC] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_ELeavDP] ADD CONSTRAINT [pk_p_ELeavDP] PRIMARY KEY CLUSTERED ([AChID], [SrcDate]) ON [PRIMARY]
GO
