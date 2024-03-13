SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
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
    SET @TransactionTypeName = 'Оплата' 
  IF @TransactionType = 2
    SET @TransactionTypeName = 'Повернення'	  

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
    'Екв.: ' + @BankName + @mcr + 
    'Терминал: ' + @TerminalID + @mcr +
    @TransactionTypeName + @mcr + 
    'ЕПЗ ' + @PAN + @mcr + 
    'ПЛАТІЖНА СИСТЕМА ' + @Issuer + @mcr +
    'КОД ТРАНЗ. ' + @RRN + @mcr + 
    'КОД АВТ. ' + @ApprovalCode + @mcr

    /*  
    'N.посилання: ' + @RRN + @mcr + 
    'N.чека: ' + CAST(@PosChequeNumber AS varchar(200)) + @mcr+ 
    'Дата: ' + CONVERT(VARCHAR(10), @DateTimeTransaction, 103) + ' ' + CONVERT(VARCHAR(8), @DateTimeTransaction, 108) + @mcr +
    'Сума: ' + CAST(@Amount AS varchar(15))  + @mcr + 
    'Iнша інф.:' + @ContractNo  + @mcr 
    */
  IF @NeedSignVerif = 1 
    SELECT @Msg = @Msg + @mcr + 
      'КАСИР ________________' + @mcr + 
      'ДЕРЖАТЕЛЬ ЕПЗ ________' + @mcr
  ELSE 
    SELECT @Msg = @Msg + @mcr +
      'Касир підпис не потрібен' + @mcr
  SELECT @Msg 
END
GO
