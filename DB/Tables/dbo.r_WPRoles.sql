CREATE TABLE [dbo].[r_WPRoles]
(
[ChID] [bigint] NOT NULL,
[WPRoleID] [int] NOT NULL,
[WPRoleName] [varchar] (200) NOT NULL,
[MenuID] [int] NOT NULL DEFAULT ((0)),
[DefaultMenuID] [int] NOT NULL DEFAULT ((0)),
[Notes] [varchar] (200) NULL,
[ProcessingID] [int] NOT NULL DEFAULT ((0)),
[AllowInvalidMonExp] [bit] NOT NULL DEFAULT ((0)),
[AllowQtyReduction] [bit] NOT NULL DEFAULT ((0)),
[AlwaysShowPosEditor] [bit] NOT NULL DEFAULT ((0)),
[AskDCardsAfterOpen] [bit] NOT NULL DEFAULT ((0)),
[AskDCardsBeforeClose] [bit] NOT NULL DEFAULT ((1)),
[AskParamsAfterOpen] [bit] NOT NULL DEFAULT ((0)),
[AskParamsBeforeClose] [bit] NOT NULL DEFAULT ((1)),
[AskPWDAnull] [bit] NOT NULL,
[AskPWDBalance] [bit] NOT NULL DEFAULT ((0)),
[AskPWDCn] [bit] NOT NULL,
[AskPWDCnCheque] [bit] NOT NULL DEFAULT ((0)),
[AskPWDDCardFind] [bit] NOT NULL DEFAULT ((1)),
[AskPWDDeposit] [bit] NOT NULL DEFAULT ((0)),
[AskPWDFind] [bit] NOT NULL DEFAULT ((0)),
[AskPWDMoneyBox] [bit] NOT NULL DEFAULT ((0)),
[AskPWDPeriodRep] [bit] NOT NULL,
[AskPWDPosRePay] [bit] NOT NULL DEFAULT ((0)),
[AskPWDRet] [bit] NOT NULL DEFAULT ((0)),
[AskPWDSuspend] [bit] NOT NULL DEFAULT ((0)),
[AskPwdOnMore] [bit] NOT NULL DEFAULT ((0)),
[AskPwdOnExit] [bit] NOT NULL DEFAULT ((0)),
[AskVisitorsAfterOpen] [bit] NOT NULL,
[AsyncChequeInput] [bit] NOT NULL DEFAULT ((0)),
[AutoFillPays] [bit] NOT NULL DEFAULT ((0)),
[AutoSelDiscs] [bit] NOT NULL DEFAULT ((1)),
[CancelMDiscsWarning] [bit] NOT NULL DEFAULT ((1)),
[CanEditPrice] [bit] NOT NULL,
[CanEditProdID] [bit] NOT NULL,
[CanEditWeightQty] [bit] NOT NULL,
[CanEnterCodeID1] [bit] NOT NULL DEFAULT ((1)),
[CanEnterCodeID2] [bit] NOT NULL DEFAULT ((1)),
[CanEnterCodeID3] [bit] NOT NULL DEFAULT ((1)),
[CanEnterCodeID4] [bit] NOT NULL DEFAULT ((1)),
[CanEnterCodeID5] [bit] NOT NULL DEFAULT ((1)),
[CanEnterDCard] [bit] NOT NULL DEFAULT ((1)),
[CanEnterNotes] [bit] NOT NULL DEFAULT ((1)),
[CanEnterPosDiscount] [bit] NOT NULL,
[ChangeSumWarning] [bit] NOT NULL DEFAULT ((1)),
[CheckRetPayForms] [bit] NOT NULL DEFAULT ((0)),
[CheckRetSum] [bit] NOT NULL DEFAULT ((1)),
[ChequeEmp] [bit] NOT NULL DEFAULT ((0)),
[DecQtyFromRef] [bit] NOT NULL DEFAULT ((1)),
[LoginByAdmin] [bit] NOT NULL DEFAULT ((0)),
[MaxChange] [numeric] (21, 9) NOT NULL DEFAULT ((200)),
[MaxSuspended] [tinyint] NOT NULL DEFAULT ((3)),
[MixedPays] [bit] NOT NULL DEFAULT ((1)),
[NoManualDCardEnter] [bit] NOT NULL DEFAULT ((1)),
[OpenMoneyBoxOnDeposit] [bit] NOT NULL DEFAULT ((0)),
[PosEmpID] [int] NOT NULL DEFAULT ((0)),
[PosEmpIDType] [int] NOT NULL DEFAULT ((0)),
[PreviewReport] [bit] NOT NULL DEFAULT ((0)),
[PrintAfterSendOrder] [bit] NOT NULL DEFAULT ((1)),
[PrintCopyForCard] [bit] NOT NULL DEFAULT ((0)),
[PrintDiscs] [bit] NOT NULL DEFAULT ((0)),
[PrintInfoAnull] [bit] NOT NULL DEFAULT ((0)),
[PrintReport] [varchar] (250) NULL,
[PrintReportMonExp] [varchar] (250) NULL,
[PrintReportMonRec] [varchar] (250) NULL,
[PrintReportRet] [varchar] (250) NULL,
[PrintReportX] [varchar] (250) NULL,
[PrintReportZ] [varchar] (250) NULL,
[PrintTextAnull] [bit] NOT NULL DEFAULT ((0)),
[ShowCancels] [bit] NOT NULL DEFAULT ((1)),
[ShowChequeDisc] [bit] NOT NULL DEFAULT ((1)),
[ShowPosDisc] [bit] NOT NULL DEFAULT ((1)),
[ShowPosEditOnCancel] [bit] NOT NULL DEFAULT ((1)),
[UseBarCode] [bit] NOT NULL DEFAULT ((1)),
[UseDecQtyBarCode] [bit] NOT NULL DEFAULT ((0)),
[UseEmps] [bit] NOT NULL DEFAULT ((0)),
[ZRepAfterShift] [bit] NOT NULL DEFAULT ((0)),
[ZRepExecInTime] [bit] NOT NULL DEFAULT ((0)),
[ZRepExecTime] [smalldatetime] NULL DEFAULT ((0)),
[ZReportWarning] [bit] NOT NULL DEFAULT ((0)),
[ZRepShiftEndTime] [smalldatetime] NULL DEFAULT ((0)),
[ZRepShiftTimeCheck] [int] NOT NULL DEFAULT ((0)),
[LoadLinkedMenus] [bit] NOT NULL DEFAULT ((1)),
[LoadProdHints] [bit] NOT NULL DEFAULT ((1)),
[ResetQtyAfterProdAdd] [bit] NOT NULL DEFAULT ((1)),
[DriveMode] [bit] NOT NULL DEFAULT ((0)),
[PrintRetCopy] [bit] NOT NULL DEFAULT ((0)),
[RequireExp] [bit] NOT NULL DEFAULT ((0)),
[RequireFullExp] [bit] NOT NULL DEFAULT ((0)),
[RequireRec] [bit] NOT NULL DEFAULT ((0)),
[ExtendedChequeStates] [bit] NOT NULL DEFAULT ((0)),
[DiscountMode] [int] NOT NULL DEFAULT ((0)),
[PrintBillRequired] [bit] NOT NULL DEFAULT ((0)),
[PrintShiftCloseReport] [varchar] (250) NULL,
[PrintBillReportDraft] [varchar] (250) NULL,
[PrintBillReport] [varchar] (250) NULL,
[UseProdImages] [bit] NOT NULL DEFAULT ((0)),
[CRAdminRunShift] [bit] NOT NULL DEFAULT ((1)),
[CRAdminEditPBill] [bit] NOT NULL DEFAULT ((1)),
[OrderReports] [varchar] (2000) NULL,
[CompletedChequesCount] [int] NOT NULL,
[ShowProdNotes] [bit] NOT NULL DEFAULT ((0)),
[ShowNoChangeButton] [bit] NOT NULL DEFAULT ((0)),
[UseNewMenu] [bit] NOT NULL DEFAULT ((1)),
[AllowManualPasswordInput] [bit] NOT NULL DEFAULT ((1)),
[RecalcDiscsAfterMods] [bit] NOT NULL DEFAULT ((0)),
[ShowClosedCheques] [bit] NOT NULL DEFAULT ((1)),
[PrintClientReport] [varchar] (250) NULL,
[AllowVenEditQty] [bit] NOT NULL DEFAULT ((1)),
[PrintVenReport] [varchar] (250) NULL,
[AllowPeriodicReports] [bit] NOT NULL DEFAULT ((1)),
[UseAnullReasons] [bit] NOT NULL DEFAULT ((0)),
[BookingTimeRulerBegin] [smalldatetime] NULL,
[BookingTimeRulerEnd] [smalldatetime] NULL,
[BookingUseExtChequeParams] [bit] NOT NULL DEFAULT ((0)),
[BookingDefaultClientID] [int] NOT NULL DEFAULT ((0)),
[BookingOpenWorkHours] [int] NOT NULL DEFAULT ((0)),
[ShowMonNotes] [bit] NOT NULL DEFAULT ((0)),
[UsePrintMonitor] [bit] NOT NULL DEFAULT ((0)),
[DisplayPrintErrors] [bit] NOT NULL DEFAULT ((0)),
[PrintMonitorTimeout] [int] NOT NULL DEFAULT ((0)),
[UseSaleTouchMode] [bit] NOT NULL DEFAULT ((0)),
[ZRepShiftStartTime] [smalldatetime] NOT NULL DEFAULT ('1900-01-01 08:00:00'),
[ZRepWarningTime] [int] NOT NULL DEFAULT ((5)),
[ZRepWarningPeriod] [int] NOT NULL DEFAULT ((2)),
[ZRepBlockExit] [bit] NOT NULL DEFAULT ((0)),
[ZRepShiftBlock] [bit] NOT NULL DEFAULT ((1)),
[AutoZRepBalanceCheck] [bit] NOT NULL DEFAULT ((1)),
[ShowSuspendedChequesPanel] [bit] NOT NULL DEFAULT ((1)),
[ShowClosedChequesPanel] [bit] NOT NULL DEFAULT ((1)),
[ShowUniInput] [bit] NOT NULL DEFAULT ((0)),
[UseAutoWeightScale] [bit] NOT NULL DEFAULT ((0)),
[UseRecursiveMenu] [bit] NOT NULL DEFAULT ((0)),
[AutoZRepFullExp] [bit] NOT NULL DEFAULT ((1)),
[SetDefaultMenuAfterClose] [bit] NOT NULL DEFAULT ((1)),
[NoExpMode] [bit] NOT NULL DEFAULT ((0)),
[AskPwdOnFixError] [bit] NOT NULL DEFAULT ((1)),
[AutoRound] [bit] NOT NULL DEFAULT ((0)),
[ShowOptionalMods] [bit] NOT NULL DEFAULT ((1)),
[ShowQtyFrame] [bit] NOT NULL DEFAULT ((1)),
[ScrollButtonsWidth] [int] NOT NULL DEFAULT ((25)),
[ShowBigCloseButton] [bit] NOT NULL DEFAULT ((1)),
[ShowDCardOnUniInput] [bit] NOT NULL DEFAULT ((1)),
[AllowDCardEdit] [bit] NOT NULL DEFAULT ((1)),
[AllowVen] [bit] NOT NULL DEFAULT ((1)),
[PrintCRName] [bit] NOT NULL DEFAULT ((1)),
[CRChequeFontSize] [int] NOT NULL DEFAULT ((0)),
[CRChequeCopiesCount] [int] NOT NULL DEFAULT ((2)),
[CRUnionChequeFontSize] [int] NOT NULL DEFAULT ((1)),
[CRChequeFontSizeReport] [int] NOT NULL DEFAULT ((1)),
[FontSizeProdItems] [int] NOT NULL DEFAULT ((8)),
[FontSizeOptionalMods] [int] NOT NULL DEFAULT ((8)),
[FontSizeMenu] [int] NOT NULL DEFAULT ((8)),
[FontSizeSuspendedChequesPanel] [int] NOT NULL DEFAULT ((8)),
[FontSizeChequesPanel] [int] NOT NULL DEFAULT ((8)),
[FontSizeLinkedMenus] [int] NOT NULL DEFAULT ((8)),
[TextRowsCount] [int] NOT NULL DEFAULT ((1)),
[DCardViaBluetooth] [bit] NOT NULL DEFAULT ((0)),
[PrintPOSUnionChequeFirst] [bit] NOT NULL DEFAULT ((0)),
[SkipZRepOnEmptyDay] [bit] NOT NULL DEFAULT ((0)),
[ApiServerParams] [varchar] (4000) NULL,
[ApiServerGetRets] [bit] NOT NULL DEFAULT ((0)),
[AskPwdOnManualDisc] [bit] NOT NULL DEFAULT ((0)),
[UseRetReasons] [bit] NOT NULL DEFAULT ((0)),
[MustSelectReason] [bit] NOT NULL DEFAULT ((0)),
[CRShiftDurationTime] [int] NOT NULL DEFAULT ((1438)),
[CRChequeFontSizeReportZ] [int] NOT NULL DEFAULT ((1)),
[CloseDCardsAfterAdd] [bit] NOT NULL DEFAULT ((0)),
[CloseProdSelectAfterAdd] [bit] NOT NULL DEFAULT ((0)),
[PrintChequeNo] [bit] NOT NULL DEFAULT ((1)),
[OpenShiftWarning] [bit] NOT NULL DEFAULT ((1)),
[AskLevyMark] [bit] NOT NULL DEFAULT ((0)),
[RequireZRepForLastShift] [bit] NOT NULL DEFAULT ((0)),
[SetOldZRepDateTime] [bit] NOT NULL DEFAULT ((0)),
[POSPreviewReport] [bit] NOT NULL DEFAULT ((0)),
[SetChangeInetChequeNumForCRRet] [bit] NOT NULL DEFAULT ((0)),
[AllowNoPrinting] [bit] NOT NULL DEFAULT ((0)),
[t_SaleMinCashBack] [int] NOT NULL DEFAULT ((0)),
[t_SaleMaxCashBack] [int] NOT NULL DEFAULT ((0)),
[PrintReportDate] [varchar] (250) NULL,
[RequireProdAdd] [bit] NOT NULL DEFAULT ((0)),
[SetForcedToOfflineMode] [bit] NOT NULL DEFAULT ((0)),
[OpenShiftByZeroCheque] [bit] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_WPRoles] ON [dbo].[r_WPRoles]
FOR INSERT AS
/* r_WPRoles - Справочник рабочих мест: роли - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_WPRoles ^ r_Emps - Проверка в PARENT */
/* Справочник рабочих мест: роли ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PosEmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_WPRoles', 0
      RETURN
    END

/* r_WPRoles ^ r_Menu - Проверка в PARENT */
/* Справочник рабочих мест: роли ^ Справочник меню - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.MenuID NOT IN (SELECT MenuID FROM r_Menu))
    BEGIN
      EXEC z_RelationError 'r_Menu', 'r_WPRoles', 0
      RETURN
    END

/* r_WPRoles ^ r_Processings - Проверка в PARENT */
/* Справочник рабочих мест: роли ^ Справочник процессинговых центров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProcessingID NOT IN (SELECT ProcessingID FROM r_Processings))
    BEGIN
      EXEC z_RelationError 'r_Processings', 'r_WPRoles', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10551001, ChID, 
    '[' + cast(i.WPRoleID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_WPRoles]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_WPRoles] ON [dbo].[r_WPRoles]
FOR UPDATE AS
/* r_WPRoles - Справочник рабочих мест: роли - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_WPRoles ^ r_Emps - Проверка в PARENT */
/* Справочник рабочих мест: роли ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(PosEmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PosEmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'r_WPRoles', 1
        RETURN
      END

/* r_WPRoles ^ r_Menu - Проверка в PARENT */
/* Справочник рабочих мест: роли ^ Справочник меню - Проверка в PARENT */
  IF UPDATE(MenuID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.MenuID NOT IN (SELECT MenuID FROM r_Menu))
      BEGIN
        EXEC z_RelationError 'r_Menu', 'r_WPRoles', 1
        RETURN
      END

/* r_WPRoles ^ r_Processings - Проверка в PARENT */
/* Справочник рабочих мест: роли ^ Справочник процессинговых центров - Проверка в PARENT */
  IF UPDATE(ProcessingID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProcessingID NOT IN (SELECT ProcessingID FROM r_Processings))
      BEGIN
        EXEC z_RelationError 'r_Processings', 'r_WPRoles', 1
        RETURN
      END

/* r_WPRoles ^ r_WPs - Обновление CHILD */
/* Справочник рабочих мест: роли ^ Справочник рабочих мест - Обновление CHILD */
  IF UPDATE(WPRoleID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.WPRoleID = i.WPRoleID
          FROM r_WPs a, inserted i, deleted d WHERE a.WPRoleID = d.WPRoleID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_WPs a, deleted d WHERE a.WPRoleID = d.WPRoleID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник рабочих мест: роли'' => ''Справочник рабочих мест''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10551001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10551001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(WPRoleID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10551001 AND l.PKValue = 
        '[' + cast(i.WPRoleID as varchar(200)) + ']' AND i.WPRoleID = d.WPRoleID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10551001 AND l.PKValue = 
        '[' + cast(i.WPRoleID as varchar(200)) + ']' AND i.WPRoleID = d.WPRoleID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10551001, ChID, 
          '[' + cast(d.WPRoleID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10551001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10551001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10551001, ChID, 
          '[' + cast(i.WPRoleID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(WPRoleID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT WPRoleID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT WPRoleID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.WPRoleID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10551001 AND l.PKValue = 
          '[' + cast(d.WPRoleID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.WPRoleID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10551001 AND l.PKValue = 
          '[' + cast(d.WPRoleID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10551001, ChID, 
          '[' + cast(d.WPRoleID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10551001 AND PKValue IN (SELECT 
          '[' + cast(WPRoleID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10551001 AND PKValue IN (SELECT 
          '[' + cast(WPRoleID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10551001, ChID, 
          '[' + cast(i.WPRoleID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10551001, ChID, 
    '[' + cast(i.WPRoleID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_WPRoles]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_WPRoles] ON [dbo].[r_WPRoles]
FOR DELETE AS
/* r_WPRoles - Справочник рабочих мест: роли - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_WPRoles ^ r_WPs - Проверка в CHILD */
/* Справочник рабочих мест: роли ^ Справочник рабочих мест - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_WPs a WITH(NOLOCK), deleted d WHERE a.WPRoleID = d.WPRoleID)
    BEGIN
      EXEC z_RelationError 'r_WPRoles', 'r_WPs', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10551001 AND m.PKValue = 
    '[' + cast(i.WPRoleID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10551001 AND m.PKValue = 
    '[' + cast(i.WPRoleID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10551001, -ChID, 
    '[' + cast(d.WPRoleID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10551 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_WPRoles]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_WPRoles] ADD CONSTRAINT [pk_r_WPRoles] PRIMARY KEY CLUSTERED ([WPRoleID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_WPRoles] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MenuID] ON [dbo].[r_WPRoles] ([MenuID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProcessingID] ON [dbo].[r_WPRoles] ([ProcessingID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [WPRoleName] ON [dbo].[r_WPRoles] ([WPRoleName]) ON [PRIMARY]
GO
