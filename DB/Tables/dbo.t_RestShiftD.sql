CREATE TABLE [dbo].[t_RestShiftD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[ShiftPostID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_RestShiftD] ADD CONSTRAINT [pk_t_RestShiftD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_RestShiftD] ADD CONSTRAINT [FK_t_RestShiftD_t_RestShift] FOREIGN KEY ([ChID]) REFERENCES [dbo].[t_RestShift] ([ChID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
