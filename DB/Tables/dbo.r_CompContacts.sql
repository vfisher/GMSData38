CREATE TABLE [dbo].[r_CompContacts]
(
[CompID] [int] NOT NULL,
[Contact] [varchar] (250) NOT NULL,
[PhoneWork] [varchar] (50) NULL,
[PhoneMob] [varchar] (50) NULL,
[PhoneHome] [varchar] (50) NULL,
[eMail] [varchar] (250) NULL,
[Job] [varchar] (250) NULL,
[BirthDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CompContacts] ADD CONSTRAINT [pk_r_CompContacts] PRIMARY KEY CLUSTERED ([CompID], [Contact]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Contact] ON [dbo].[r_CompContacts] ([Contact]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CompContacts] ADD CONSTRAINT [FK_r_CompContacts_r_Comps] FOREIGN KEY ([CompID]) REFERENCES [dbo].[r_Comps] ([CompID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
