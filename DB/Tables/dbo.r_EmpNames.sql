CREATE TABLE [dbo].[r_EmpNames]
(
[OurID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[ChDate] [smalldatetime] NOT NULL,
[EmpName] [varchar] (200) NOT NULL,
[EmpInitials] [varchar] (200) NOT NULL,
[EmpLastName] [varchar] (200) NOT NULL,
[EmpFirstName] [varchar] (200) NOT NULL,
[EmpParName] [varchar] (200) NOT NULL,
[UAEmpName] [varchar] (200) NOT NULL,
[UAEmpLastName] [varchar] (200) NOT NULL,
[UAEmpFirstName] [varchar] (200) NOT NULL,
[UAEmpParName] [varchar] (200) NOT NULL,
[UAEmpInitials] [varchar] (200) NOT NULL,
[PassSer] [varchar] (250) NULL,
[PassNo] [varchar] (250) NULL,
[PassDate] [smalldatetime] NULL,
[PassDept] [varchar] (250) NULL,
[TaxCode] [varchar] (250) NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_EmpNames] ON [dbo].[r_EmpNames]FOR INSERT AS/* r_EmpNames - Справочник служащих: Изменение ФИО - INSERT TRIGGER */BEGIN  DECLARE @RCount Int  SELECT @RCount = @@RowCount  IF @RCount = 0 RETURN  SET NOCOUNT ON/* r_EmpNames ^ r_EmpMO - Проверка в PARENT *//* Справочник служащих: Изменение ФИО ^ Справочник служащих - Внутренние фирмы - Проверка в PARENT */  IF (SELECT COUNT(*) FROM r_EmpMO m WITH(NOLOCK), inserted i WHERE i.EmpID = m.EmpID AND i.OurID = m.OurID) <> @RCount    BEGIN      EXEC z_RelationError 'r_EmpMO', 'r_EmpNames', 0      RETURN    ENDEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_EmpNames]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_EmpNames] ON [dbo].[r_EmpNames]FOR UPDATE AS/* r_EmpNames - Справочник служащих: Изменение ФИО - UPDATE TRIGGER */BEGIN  DECLARE @RCount Int  SELECT @RCount = @@RowCount  IF @RCount = 0 RETURN  SET NOCOUNT ON/* r_EmpNames ^ r_EmpMO - Проверка в PARENT *//* Справочник служащих: Изменение ФИО ^ Справочник служащих - Внутренние фирмы - Проверка в PARENT */  IF UPDATE(EmpID) OR UPDATE(OurID)    IF (SELECT COUNT(*) FROM r_EmpMO m WITH(NOLOCK), inserted i WHERE i.EmpID = m.EmpID AND i.OurID = m.OurID) <> @RCount      BEGIN        EXEC z_RelationError 'r_EmpMO', 'r_EmpNames', 1        RETURN      ENDEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_EmpNames]', 'last', 'update', null
GO
ALTER TABLE [dbo].[r_EmpNames] ADD CONSTRAINT [pk_r_EmpNames] PRIMARY KEY CLUSTERED ([EmpID], [OurID], [ChDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Notes] ON [dbo].[r_EmpNames] ([Notes]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TaxCode] ON [dbo].[r_EmpNames] ([TaxCode]) ON [PRIMARY]
GO
