SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSavePays](@DocCode int, @ChID bigint, @SrcPosID int, @PayFormCode int, @SumCC_wt numeric(21, 9), @POSPayID int, @SrcPayPosID int,
                               @POSPayDocID int, @POSPayRRN varchar(250), @Notes varchar(200), @POSPayChequeText varchar(8000), @BServID int, @PayPartsQty int,
                               @ContractNo varchar(200), @PosPayText varchar(8000), @TransactionInfo varchar(8000), @CashBack numeric(21, 9))
/* Сохраняет платеж для указанного типа документа */
AS
BEGIN
  /* Маппинг в РРО и длина полей:
  POSPayBankAcquirer // Екв: EquirerInfo 24
  POSPayTerminalID // Терминал: TerminalInfo 24
  POSPayPAN  //ЕПЗ: ElectronPayType 24
  POSPayCardHolder // ПЛАТИЖНА СИСТЕМА PaySystem 24
  POSPayApprovalCode // Код авт: AuthCode 16
  POSPayRRN // Код транз.: TransactionCode 10
  POSPayOperationName // OperationName 16 - наименование операции
  POSPayNeedSignVerif // SignRequired bit - признак, печтать ли поля для подписи кассира

  $.AdditionalText - дополнительный текст для печати ниже ФО карты
  */

  declare @cashtype int

  if @DocCode = 1011
    select @cashtype = cashtype
    from t_SaleTemp t
    join r_CRs c on c.CRID = t.CRID
    where t.ChID = @ChID
  else
    select @cashtype = cashtype
    from t_CRRET t
    join r_CRs c on c.CRID = t.CRID
    where t.ChID = @ChID

  IF @TransactionInfo IS NOT NULL AND @TransactionInfo <> ''
  BEGIN
    SET @TransactionInfo = REPLACE(@TransactionInfo, CHAR(13),' ')
    SET @TransactionInfo = REPLACE(@TransactionInfo, CHAR(10),'')
    SET @TransactionInfo = REPLACE(@TransactionInfo, CHAR(9),' ')
    SET @TransactionInfo = REPLACE(@TransactionInfo, CHAR(28),' ')
    SET @TransactionInfo = REPLACE(@TransactionInfo, CHAR(12),'')  	

    if ISNULL(LTRIM(RTRIM(JSON_VALUE(@TransactionInfo, '$.POSPayOperationName'))), '') = ''
      begin
        if @DocCode = 1011
          set @TransactionInfo = JSON_MODIFY(@TransactionInfo, '$.POSPayOperationName', 'Оплата')
        else
          set @TransactionInfo = JSON_MODIFY(@TransactionInfo, '$.POSPayOperationName', 'Повернення')
      end

    if ISNULL(LTRIM(RTRIM(JSON_VALUE(@TransactionInfo, '$.POSPayBankAcquirer'))), '') = ''
      select @TransactionInfo = JSON_MODIFY(@TransactionInfo, '$.POSPayBankAcquirer', (SELECT PoSPAYNAME FROM R_POSPAYS WHERE POSPAYID=@PospayID))

    if @cashtype not in (11, 15, 29, 39) /* семейство exellio, kbm само дописывает имена */
      if not (CHARINDEX(ISNULL(JSON_VALUE(@TransactionInfo, '$.POSPayBankAcquirer'), ''), 'Екв') > 0)
        select @TransactionInfo = JSON_MODIFY(@TransactionInfo, '$.POSPayBankAcquirer', 'Екв: ' + JSON_VALUE(@TransactionInfo, '$.POSPayBankAcquirer'))

    if @cashtype not in (11, 15, 29, 39) /* семейство exellio, kbm само дописывает имена */
      if not (CHARINDEX(ISNULL(JSON_VALUE(@TransactionInfo, '$.POSPayTerminalID'), ''), 'Термінал') > 0)
        select @TransactionInfo = JSON_MODIFY(@TransactionInfo, '$.POSPayTerminalID', 'Термінал: ' + JSON_VALUE(@TransactionInfo, '$.POSPayTerminalID'))

    declare @issuer varchar(200)
    select @issuer = ISNULL(JSON_VALUE(@TransactionInfo, '$.POSPayIssuerName'), '')
    if @issuer <> ''
      begin
        if not (CHARINDEX(ISNULL(JSON_VALUE(@TransactionInfo, '$.POSPayCardHolder'), ''), @issuer) > 0)
        select @TransactionInfo = JSON_MODIFY(@TransactionInfo, '$.POSPayCardHolder', @issuer + ' ' + JSON_VALUE(@TransactionInfo, '$.POSPayCardHolder'))
      end

    /* Доп. текст. Поддерживается многострочность */
    if CAST(ISNULL(JSON_VALUE(@TransactionInfo, '$.POSPayNeedSignVerif'), 0) as bit) = 0
      begin
        select @TransactionInfo = JSON_MODIFY(@TransactionInfo, '$.AdditionalText', 'Касир підпис не потрібен')
      end
    END
  ELSE
    SET @TransactionInfo = NULL

    IF @DocCode = 1011
      INSERT INTO t_SaleTempPays (ChID, SrcPosID, PayFormCode, SumCC_wt, Notes, POSPayID, POSPayDocID, POSPayRRN, PrintState, ChequeText, BServID, PayPartsQty, ContractNo, POSPayText, TransactionInfo, CashBack)
      VALUES (@ChID, @SrcPosID, @PayFormCode, @SumCC_wt, @Notes, @POSPayID, @POSPayDocID, @POSPayRRN, 0, @PosPayChequeText, @BServID, @PayPartsQty, @ContractNo, @PosPayText, @TransactionInfo, @CashBack)
    ELSE IF @DocCode = 11004
      INSERT INTO t_CRRetPays (ChID, SrcPosID, PayFormCode, SumCC_wt, Notes, POSPayID, SrcPayPosID, POSPayDocID, POSPayRRN, PrintState, ChequeText, BServID, POSPayText, TransactionInfo)
      VALUES (@ChID, @SrcPosID, @PayFormCode, @SumCC_wt, @Notes, @POSPayID, @SrcPayPosID, @POSPayDocID, @POSPayRRN, 0, @PosPayChequeText, @BServID, @PosPayText, @TransactionInfo)
    ELSE
      RAISERROR ('t_SaleSavePays: Некорректный код документа!', 18, 1)
  END
GO
