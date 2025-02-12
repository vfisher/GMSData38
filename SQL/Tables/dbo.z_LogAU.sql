CREATE TABLE [dbo].[z_LogAU] (
  [LogID] [int] IDENTITY,
  [DocDate] [smalldatetime] NOT NULL CONSTRAINT [DF__z_LogAU__DocDate__6D6DF0FE] DEFAULT (getdate()),
  [AUGroupCode] [int] NOT NULL,
  [UserCode] [smallint] NOT NULL,
  [BDate] [smalldatetime] NULL,
  [EDate] [smalldatetime] NULL,
  CONSTRAINT [pk_z_LogAU] PRIMARY KEY CLUSTERED ([LogID])
)
ON [PRIMARY]
GO