CREATE TABLE [dbo].[z_FieldsRep]
(
[FieldsRepGrpCode] [int] NOT NULL DEFAULT (0),
[FieldName] [varchar] (250) NOT NULL,
[FieldDesc] [varchar] (250) NOT NULL,
[FieldNick] [varchar] (250) NULL,
[FieldInfo] [varchar] (250) NULL,
[DataType] [tinyint] NOT NULL,
[DataSize] [int] NOT NULL,
[SQLType] [int] NOT NULL DEFAULT (0),
[SQLPrec] [int] NULL DEFAULT (0),
[SQLScale] [int] NULL DEFAULT (0),
[FieldCount] [smallint] NOT NULL DEFAULT (0),
[Required] [bit] NOT NULL DEFAULT (0),
[ReadOnly] [bit] NOT NULL DEFAULT (0),
[Visible] [bit] NOT NULL DEFAULT (1),
[DisplayFormat] [varchar] (250) NULL,
[Width] [int] NOT NULL DEFAULT (50),
[AutoNewType] [int] NOT NULL DEFAULT (0),
[AutoNewValue] [varchar] (4000) NULL,
[Calc] [bit] NOT NULL DEFAULT (0),
[Lookup] [bit] NOT NULL DEFAULT (0),
[LookupKey] [varchar] (250) NULL,
[LookupSource] [varchar] (250) NULL,
[LookupSourceKey] [varchar] (250) NULL,
[LookupSourceResult] [varchar] (250) NULL,
[PickListType] [int] NOT NULL DEFAULT (0),
[PickList] [varchar] (2000) NULL,
[EditMask] [varchar] (250) NULL,
[EditFormat] [varchar] (250) NULL,
[MinValue] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__z_FieldsR__MinVa__21229F2E] DEFAULT (0),
[MaxValue] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__z_FieldsR__MaxVa__2216C367] DEFAULT (0),
[CustomConstraint] [varchar] (250) NULL,
[ErrorMessage] [varchar] (250) NULL,
[DBDefault] [varchar] (250) NULL,
[Separator] [bit] NOT NULL DEFAULT (0),
[HideZeros] [bit] NOT NULL DEFAULT (0),
[DecimalCount] [tinyint] NOT NULL DEFAULT (0),
[FixedCount] [tinyint] NOT NULL DEFAULT (0),
[Currency] [bit] NOT NULL DEFAULT (0),
[Alignment] [tinyint] NOT NULL DEFAULT (0),
[InitBeforePost] [bit] NOT NULL,
[IsHidden] [bit] NOT NULL DEFAULT (0),
[TotalsKind] [int] NOT NULL DEFAULT ((0)),
[FieldID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_FieldsRep] ADD CONSTRAINT [pk_z_FieldsRep] PRIMARY KEY CLUSTERED ([FieldName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DataType] ON [dbo].[z_FieldsRep] ([DataType]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [FieldDesc] ON [dbo].[z_FieldsRep] ([FieldDesc]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [FieldID] ON [dbo].[z_FieldsRep] ([FieldID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FieldsRepGrpCode] ON [dbo].[z_FieldsRep] ([FieldsRepGrpCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_FieldsRep] ADD CONSTRAINT [FK_z_FieldsRep_z_FieldsRepGrps] FOREIGN KEY ([FieldsRepGrpCode]) REFERENCES [dbo].[z_FieldsRepGrps] ([FieldsRepGrpCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
