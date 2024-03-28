CREATE TABLE [dbo].[r_ServiceCompatibility]
(
[SrvcID] [int] NOT NULL,
[CompatibleServiceID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ServiceCompatibility] ADD CONSTRAINT [pk_r_ServiceCompatibility] PRIMARY KEY CLUSTERED ([SrvcID], [CompatibleServiceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompatibleServiceID] ON [dbo].[r_ServiceCompatibility] ([CompatibleServiceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrvcID] ON [dbo].[r_ServiceCompatibility] ([SrvcID]) ON [PRIMARY]
GO
