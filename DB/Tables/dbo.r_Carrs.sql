CREATE TABLE [dbo].[r_Carrs]
(
[ChID] [bigint] NOT NULL,
[CarrID] [smallint] NOT NULL,
[CarrName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[AssID] [int] NOT NULL,
[StateRegNo] [varchar] (42) NOT NULL,
[GarageNo] [varchar] (42) NULL,
[CarMark] [varchar] (42) NOT NULL,
[CarModel] [varchar] (42) NOT NULL,
[ProdID] [int] NOT NULL,
[ExpNorm] [numeric] (21, 9) NOT NULL,
[CarrCID] [smallint] NOT NULL,
[MotorNo] [varchar] (42) NULL,
[BodyNo] [varchar] (42) NOT NULL,
[TechnNo] [varchar] (42) NOT NULL,
[TechnMass] [numeric] (21, 9) NOT NULL,
[Tonnage] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Carrs] ADD CONSTRAINT [pk_r_Carrs] PRIMARY KEY CLUSTERED ([CarrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AssID] ON [dbo].[r_Carrs] ([AssID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CarrCID] ON [dbo].[r_Carrs] ([CarrCID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CarrName] ON [dbo].[r_Carrs] ([CarrName]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Carrs] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[r_Carrs] ([ProdID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[CarrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[ExpNorm]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[CarrCID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[TechnMass]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[Tonnage]'
GO
