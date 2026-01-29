SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGetEReceiptComment](@ParamsIn nvarchar(max))
AS
BEGIN
  DECLARE @CRID int, @DocCode int, @ChID bigint 
  DECLARE @TransactionInfo nvarchar(max) 
  DECLARE @BID nvarchar(max), @RID bigint, @TIN varchar(10), @BNS varchar(max), @RWR varchar(64), @BTX varchar(255) 
  /* SET @ParamsIn = '{"DocCode":11035, "ChID":100000143, "CRID":2}' */

  SET @CRID = JSON_VALUE(@ParamsIn, '$.CRID')
  SET @DocCode = JSON_VALUE(@ParamsIn, '$.DocCode')
  SET @ChID = JSON_VALUE(@ParamsIn, '$.ChID')
  SET @TransactionInfo = '{}'

  IF @DocCode = 11035 
    SELECT @TransactionInfo = TransactionInfo FROM t_SalePays WHERE ChID = @ChID
  ELSE IF @DocCode = 11004
    SELECT @TransactionInfo = TransactionInfo FROM t_CRRetPays WHERE ChID = @ChID
select @TransactionInfo
/* 
<COMMENT>ERECEIPT
BID=123e4567-e89b-12d3-a456-426614174000
RID=bar:20240101-123456789
TIN=1234567890
BNS=acpenfb
RWR=2312 балів
BTX=Замовлення №12345, дякуємо за покупку!</COMMENT>
*/

  SET @BID = JSON_VALUE(@ParamsIn, '$.adv.natr')
  SET @RID = JSON_VALUE(@ParamsIn, '$.adv.rid')
  SET @TIN = ''
  SET @BNS = ''
  SET @RWR = ''
  SET @BTX = ''
print 1
SELECT
    'ERECEIPT' + CHAR(10) +
    'BID=' + @BID + CHAR(10) +
    'RID=' + CAST(@RID AS VARCHAR(max)) + CHAR(10) +
    'TIN=' + @TIN + CHAR(10) +
    'BNS=' + @BNS + CHAR(10) +
    'RWR=' + @RWR + CHAR(10) +
    'BTX=' + @BTX 
    AS Comment
END
GO