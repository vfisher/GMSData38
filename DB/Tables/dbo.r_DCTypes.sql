CREATE TABLE [dbo].[r_DCTypes]
(
[ChID] [bigint] NOT NULL,
[DCTypeCode] [int] NOT NULL,
[DCTypeName] [varchar] (200) NOT NULL,
[Value1] [numeric] (21, 9) NOT NULL,
[Value2] [numeric] (21, 9) NOT NULL,
[Value3] [numeric] (21, 9) NOT NULL,
[InitSum] [numeric] (21, 9) NOT NULL,
[ProdID] [int] NOT NULL,
[Notes] [varchar] (200) NULL,
[MaxQty] [int] NOT NULL DEFAULT (1),
[DCTypeGCode] [int] NOT NULL,
[DeactivateAfterUse] [bit] NOT NULL,
[NoManualDCardEnter] [bit] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DCTypes] ADD CONSTRAINT [pk_r_DCTypes] PRIMARY KEY CLUSTERED ([DCTypeCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_DCTypes] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DCTypeName] ON [dbo].[r_DCTypes] ([DCTypeName]) ON [PRIMARY]
GO
