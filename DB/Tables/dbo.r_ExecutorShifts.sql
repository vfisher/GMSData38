CREATE TABLE [dbo].[r_ExecutorShifts]
(
[ExecutorID] [int] NOT NULL,
[StockID] [int] NOT NULL,
[BTime] [smalldatetime] NOT NULL,
[ETime] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ExecutorShifts] ADD CONSTRAINT [pk_r_ExecutorShifts] PRIMARY KEY CLUSTERED ([ExecutorID], [StockID], [BTime], [ETime]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ExecutorID] ON [dbo].[r_ExecutorShifts] ([ExecutorID]) ON [PRIMARY]
GO
