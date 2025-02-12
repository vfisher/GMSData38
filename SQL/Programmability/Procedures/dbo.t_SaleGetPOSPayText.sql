SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGetPOSPayText](@DocCode int, @ChID bigint,  
  @BankName varchar(200), @TerminalID varchar(200), @Issuer varchar(200), @PAN varchar(200), @CardHolder varchar(200), @ApprovalCode varchar(200), @RRN varchar(20), 
  @PosChequeNumber int, @NeedSignVerif BIT, @ContractNo varchar(200), @DateTimeTransaction datetime, @Amount FLOAT, @TransactionType INT, @CardType INT, @emvAID varchar(32) 
) 
/* Возвращает информацию об оплате картой для печати в подвале чека РРО */ 
AS 
BEGIN 
  DECLARE @Msg varchar(8000), @mcr varchar(2), @TransactionTypeName VARCHAR(250) 
  SET @mcr = CHAR(13) + CHAR(10) 

  SET @TransactionTypeName = ''
  IF @TransactionType = 1
    SET @TransactionTypeName = dbo.zf_Translate('Оплата') 
  IF @TransactionType = 2
    SET @TransactionTypeName = dbo.zf_Translate('Повернення')	  

  IF ISNULL(@BankName,'') = ''
    BEGIN 
      IF @DocCode IN (1011)
        SET @BankName = (SELECT TOP 1 POSPayName FROM r_POSPays WHERE  POSPayID IN (SELECT POSPayID FROM t_SaleTempPays WHERE ChID = @ChID))
      IF @DocCode IN (11035)
        SET @BankName = (SELECT TOP 1 POSPayName FROM r_POSPays WHERE  POSPayID IN (SELECT POSPayID FROM t_SalePays WHERE ChID = @ChID))
      IF @DocCode IN (11004) 
        SET @BankName = (SELECT TOP 1 POSPayName FROM r_POSPays WHERE  POSPayID IN (SELECT POSPayID FROM t_CRRetPays WHERE ChID = @ChID))
    END
  SELECT @Msg = 
    dbo.zf_Translate('Екв.: ') + @BankName + @mcr + 
    dbo.zf_Translate('Терминал: ') + @TerminalID + @mcr +
    @TransactionTypeName + @mcr + 
    dbo.zf_Translate('ЕПЗ ') + @PAN + @mcr + 
    dbo.zf_Translate('ПЛАТІЖНА СИСТЕМА ') + @Issuer + @mcr +
    dbo.zf_Translate('КОД ТРАНЗ. ') + @RRN + @mcr + 
    dbo.zf_Translate('КОД АВТ. ') + @ApprovalCode + @mcr

    /*  
    'N.посилання: ' + @RRN + @mcr + 
    'N.чека: ' + CAST(@PosChequeNumber AS varchar(200)) + @mcr+ 
    'Дата: ' + CONVERT(VARCHAR(10), @DateTimeTransaction, 103) + ' ' + CONVERT(VARCHAR(8), @DateTimeTransaction, 108) + @mcr +
    'Сума: ' + CAST(@Amount AS varchar(15))  + @mcr + 
    'Iнша інф.:' + @ContractNo  + @mcr 
    */
  IF @NeedSignVerif = 1 
    SELECT @Msg = @Msg + @mcr + 
      dbo.zf_Translate('КАСИР ________________') + @mcr + 
      dbo.zf_Translate('ДЕРЖАТЕЛЬ ЕПЗ ________') + @mcr
  ELSE 
    SELECT @Msg = @Msg + @mcr +
      dbo.zf_Translate('Касир підпис не потрібен') + @mcr
  SELECT @Msg 
END
GO