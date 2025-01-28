SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetInetChequeExtraInfo] @ParamsIn VARCHAR(MAX)
/* ПРРО: Возвращает дополнительную информацию (для формирования возвратных чеков, в период перехода с РРО на ПРРО) 
* InetChequeNum: фискальный номер чек продажи по ПРРО
* Comment: комментарий с номером DocID реального чека продажи
* SaleChID: СhID чека продажи соответствующего InetChequeNum
*/
AS
BEGIN
  DECLARE @DocCode INT, @ChID BIGINT, @OurID INT, @CRID INT 
  DECLARE @InetChequeNum VARCHAR(50), @Comment VARCHAR(250), @SaleChID BIGINT, @ExtraInfo VARCHAR(MAX), @DocID BIGINT, @CashType INT
  DECLARE @SaleFinID VARCHAR(50), @SaleDocTime DATETIME

  DROP TABLE IF EXISTS #SaleCashRegInetCheques
  DROP TABLE IF EXISTS #Sale
  DROP TABLE IF EXISTS #CRRetCashRegInetCheques

  SET @DocCode = JSON_VALUE(@ParamsIn, '$.DocCode')
  SET @ChID = JSON_VALUE(@ParamsIn, '$.ChID')
  SET @OurID = JSON_VALUE(@ParamsIn, '$.OurID')
  SET @CRID = JSON_VALUE(@ParamsIn, '$.CRID')

  IF @DocCode = 11004
    BEGIN
      /* ChID, DocID, InetChequeNum из t_Sale */
      SELECT TOP 1 @SaleChID = m.ChID, @DocID = m.DocID,
      @CashType = (SELECT TOP 1 CashType FROM r_CRs WHERE CRID = m.CRID)
	     FROM t_Sale m WITH(NOLOCK)
	     WHERE m.DocID IN (SELECT TOP 1 SrcDocID FROM t_CRRet WITH(NOLOCK) WHERE ChID = @ChID)

	     SELECT TOP 1 @InetChequeNum = InetChequeNum, @SaleFinID = FinID, @SaleDocTime = DocTime
      FROM t_CashRegInetCheques WITH(NOLOCK)
	     WHERE ChID = @SaleChID And DocCode = 11035

	  /* ChID, DocID, InetChequeNum из t_SaleShadow */
	  /* Расскоментировать при наличии таблицы t_SaleShadow */
	  /* IF ISNULL(@SaleChID,0) = 0 */
	  /*   BEGIN */
	  /*     SELECT TOP 1 @SaleChID = m.ChID, @DocID = m.DocID, */
      /*       @CashType = (SELECT TOP 1 CashType FROM r_CRs WHERE CRID = m.CRID), */
      /*       @ExtraInfo = m.ExtraInfo */
	  /*     FROM t_SaleShadow m WITH(NOLOCK) */
	  /*     WHERE m.DocID IN (SELECT TOP 1 SrcDocID FROM t_CRRet WITH(NOLOCK) WHERE ChID = @ChID) */

	  /*     IF @ExtraInfo <> '' */
	  /*       BEGIN */
	  /*         SET @InetChequeNum = ISNULL(JSON_VALUE(@ExtraInfo, '$.InetChequeNum'), '') */
	  /*         SET @SaleFinID = ISNULL(JSON_VALUE(@ExtraInfo, '$.FinID'), '') */
	  /*         SET @SaleDocTime = ISNULL(JSON_VALUE(@ExtraInfo, '$.DocTime'), '') */
	  /*       END */
	  /*   END */


    /* TOP 1 ChID, InetChequeNum */
    IF ISNULL(@CashType,0) <> 39 AND ISNULL(@InetChequeNum,'') = ''
    BEGIN
      /* Все чеки продажи по кассе @CRID */ 
      SELECT c.InetChequeNum, c.ChID, m.DocID
	     INTO #SaleCashRegInetCheques
	     FROM t_CashRegInetCheques c WITH(NOLOCK)
	     LEFT JOIN t_Sale m WITH(NOLOCK) ON m.CRID = c.CRID AND c.ChID = m.ChID 
	     WHERE c.DocCode = 11035 AND c.CRID = @CRID

	     /* Все чеки продажи по фирме @OurID, по кассе @CRID, по которым есть возвраты */
	     SELECT m.ChID AS ChIDSale, m.DocID, d.ChID AS ChIDRet
	     INTO #Sale
	     FROM t_Sale m WITH(NOLOCK)
	     INNER JOIN t_CRRet d WITH(NOLOCK) ON m.DocID = d.SrcDocID AND m.OurID = d.OurID AND m.OurID = @OurID AND m.CRID = d.CRID AND m.CRID = @CRID 

	     SELECT 
        c1.ChID, c1.InetChequeNum, 
	       JSON_VALUE(c1.ExtraInfo, '$.OrderRetNum') AS OrderRetNum
	     INTO #CRRetCashRegInetCheques
	     FROM t_CashRegInetCheques c1 WITH(NOLOCK)
	     WHERE c1.DocCode = 11004 AND JSON_VALUE(c1.ExtraInfo, '$.OrderRetNum') IS NOT NULL AND c1.CRID = @CRID 

	     SELECT TOP 1 @InetChequeNum = t.InetChequeNum, @SaleChID = t.ChID 
	     FROM (
	       SELECT m.ChID, m.InetChequeNum, d.ChIDSale, m.DocID, d.ChIDRet 
	       FROM #SaleCashRegInetCheques m
		   LEFT JOIN #Sale d ON m.ChID = d.ChIDSale) t 
		   WHERE t.InetChequeNum NOT IN (SELECT OrderRetNum FROM #CRRetCashRegInetCheques) AND t.ChIDSale IS NULL
		   ORDER BY ChID ASC

	     IF ISNULL(@InetChequeNum,'') = ''
	     SET @InetChequeNum = (SELECT TOP 1 InetChequeNum FROM t_CashRegInetCheques
	     WHERE CRID = @CRID AND DocCode = 11035 ORDER BY NextLocalNum ASC)
    END
  END

  /* Не актуально с 13.12.2024 */
  /*
  IF ISNULL(@CashType,0) = 39 AND ISNULL(@InetChequeNum,'') <> '' 
    BEGIN
	  SET @Comment = 'RNO=' + @InetChequeNum + ' FN=' + @FinID + ' TS=' + CONVERT(VARCHAR(8), @DocTime, 112)
	END
  ELSE
    BEGIN
      SET @Comment = ISNULL(@DocID,'')
      SET @Comment = CASE WHEN @Comment <> '' THEN 'Чек продажу: ' + @Comment END
    END
  */

  SET @Comment = ISNULL(@DocID,'')
  SET @Comment = CASE WHEN @Comment <> '' THEN dbo.zf_Translate('Чек продажу: ') + @Comment END

  SELECT 
    ISNULL(@InetChequeNum, '') AS InetChequeNum,
    ISNULL(@SaleChID, 0) AS SaleChID,
	ISNULL(@SaleFinID,-1) AS SaleFinID,
	ISNULL(@SaleDocTime,0) AS SaleDocTime,
    @Comment AS Comment,
	ISNULL(@ExtraInfo, '') AS ExtraInfo
END

GO
