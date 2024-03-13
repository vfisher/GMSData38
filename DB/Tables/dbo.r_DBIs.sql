CREATE TABLE [dbo].[r_DBIs]
(
[ChID] [bigint] NOT NULL,
[DBiID] [int] NOT NULL,
[DBiName] [varchar] (250) NOT NULL,
[Notes] [varchar] (250) NULL,
[IsDefault] [bit] NOT NULL DEFAULT (0),
[RangeValue] [bigint] NOT NULL,
[ChID_Start] [bigint] NOT NULL,
[ChID_End] [bigint] NOT NULL,
[DocID_Start] [bigint] NOT NULL,
[DocID_End] [bigint] NOT NULL,
[IntDocID_Start] [bigint] NOT NULL,
[IntDocID_End] [bigint] NOT NULL,
[RefID_Start] [int] NOT NULL,
[RefID_End] [int] NOT NULL,
[PPID_Start] [int] NOT NULL,
[PPID_End] [int] NOT NULL,
[OurID] [int] NOT NULL,
[PCCode] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DBIs] ADD CONSTRAINT [pk_r_DBIs] PRIMARY KEY CLUSTERED ([DBiID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_DBIs] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID_End] ON [dbo].[r_DBIs] ([ChID_End]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID_Start] ON [dbo].[r_DBIs] ([ChID_Start]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DBiName] ON [dbo].[r_DBIs] ([DBiName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID_End] ON [dbo].[r_DBIs] ([DocID_End]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID_Start] ON [dbo].[r_DBIs] ([DocID_Start]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID_End] ON [dbo].[r_DBIs] ([IntDocID_End]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID_Start] ON [dbo].[r_DBIs] ([IntDocID_Start]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[r_DBIs] ([OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PCCode] ON [dbo].[r_DBIs] ([PCCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PPID_End] ON [dbo].[r_DBIs] ([PPID_End]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PPID_Start] ON [dbo].[r_DBIs] ([PPID_Start]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RefID_End] ON [dbo].[r_DBIs] ([RefID_End]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RefID_Start] ON [dbo].[r_DBIs] ([RefID_Start]) ON [PRIMARY]
GO
