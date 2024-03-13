CREATE TABLE [dbo].[r_DeviceTypes]
(
[SrcPosID] [int] NOT NULL,
[DeviceType] [int] NOT NULL,
[DeviceTypeName] [varchar] (250) NOT NULL,
[AllowChooseCashType] [bit] NOT NULL DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DeviceTypes] ADD CONSTRAINT [pk_r_DeviceTypes] PRIMARY KEY CLUSTERED ([DeviceType]) ON [PRIMARY]
GO
