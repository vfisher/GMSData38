SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetCRBalance](@ParamsIn varchar(max), @ParamsOut varchar(max) OUTPUT)
/* Возвращает баланс по кассе */
AS
BEGIN
  DECLARE @CRID int
  DECLARE @LastZRep datetime, @Time datetime
  DECLARE @CashType INT, @PayFormCodeCustom1 INT, @PayFormCodeCustom2 INT, @PayFormCodeCustom3 INT, @PayFormCodeCustom4 INT, @PayFormCodeCustom5 INT
  DECLARE @RoundTaxSum NUMERIC(21,9), @CountSymbolRoundTax INT
  DECLARE @TaxPayer BIT, @TaxIDNotVAT INT, @PayFormCodeCashBack INT

  DECLARE @SaleSumCash numeric(21, 9), @SaleSumCCard numeric(21, 9), @SaleSumCredit numeric(21, 9), @SaleSumCheque numeric(21, 9), @SaleSumOther numeric(21, 9)
  DECLARE @MRec numeric(21, 9), @MExp numeric(21, 9), @SumCash numeric(21, 9)
  DECLARE @SumRetCash numeric(21, 9), @SumRetCCard numeric(21, 9), @SumRetCredit numeric(21, 9), @SumRetCheque numeric(21, 9), @SumRetOther numeric(21, 9)
  /* Баланс на момент открытия смены, подсчет количества чеков продаж в режиме офлайн, подсчет количества возвратных чеков в режиме офлайн, подсчет количества чеков выдачи наличных в режиме офлайн */
  DECLARE @InitialBalance numeric(21, 9), @SaleOrdersCount INT, @RetOrdersCount INT, @CashBackOrdersCount INT
  DECLARE @SaleTaxSum_0 numeric(21, 9), @SaleTaxSum_1 numeric(21, 9), @SaleTaxSum_2 numeric(21, 9), @SaleTaxSum_3 numeric(21, 9), @SaleTaxSum_4 numeric(21, 9), @SaleTaxSum_5 numeric(21, 9)
  DECLARE @RetTaxSum_0 numeric(21, 9), @RetTaxSum_1 numeric(21, 9), @RetTaxSum_2 numeric(21, 9), @RetTaxSum_3 numeric(21, 9), @RetTaxSum_4 numeric(21, 9), @RetTaxSum_5 numeric(21, 9)
  DECLARE @SaleSum_0 numeric(21, 9), @SaleSum_1 numeric(21, 9), @SaleSum_2 numeric(21, 9), @SaleSum_3 numeric(21, 9), @SaleSum_4 numeric(21, 9), @SaleSum_5 numeric(21, 9)
  DECLARE @RetSum_0 numeric(21, 9), @RetSum_1 numeric(21, 9), @RetSum_2 numeric(21, 9), @RetSum_3 numeric(21, 9), @RetSum_4 numeric(21, 9), @RetSum_5 numeric(21, 9)
  DECLARE @SaleSumCashFact numeric(21, 9), @SaleSumCCardFact numeric(21, 9), @SaleSumCreditFact numeric(21, 9), @SaleSumChequeFact numeric(21, 9), @SaleSumOtherFact numeric(21, 9), @SaleSumCustom1Fact numeric(21, 9), @SaleSumCustom2Fact numeric(21, 9), @SaleSumCustom3Fact numeric(21, 9), @SaleSumCustom4Fact numeric(21, 9), @SaleSumCustom5Fact numeric(21, 9)
  DECLARE @SaleSumCustom1 numeric(21, 9), @SaleSumCustom2 numeric(21, 9), @SaleSumCustom3 numeric(21, 9), @SaleSumCustom4 numeric(21, 9), @SaleSumCustom5 numeric(21, 9)
  DECLARE @SumRetCustom1 numeric(21, 9), @SumRetCustom2 numeric(21, 9), @SumRetCustom3 numeric(21, 9), @SumRetCustom4 numeric(21, 9),
  @SumRetCustom5 numeric(21, 9)
  DECLARE @CashBack numeric(21, 9), @SaleSumCCardOnlyCashBack numeric(21, 9)
  DECLARE @SaleRndSum numeric(21, 9), @SaleNoRndSum numeric(21, 9), @RetRndSum numeric(21, 9), @RetNoRndSum numeric(21, 9)
  DECLARE @SaleRoundDiscCode int
  DECLARE @SaleSumType0 numeric(21, 9), @SaleSumType1 numeric(21, 9), @SaleSumType2 numeric(21, 9)
  DECLARE @RetSumType0 numeric(21, 9), @RetSumType1 numeric(21, 9), @RetSumType2 numeric(21, 9)
  DECLARE @SaleLevySum_0 numeric(21, 9), @SaleLevySum_1 numeric(21, 9), @SaleLevySum_2 numeric(21, 9), @SaleLevySum_3 numeric(21, 9), @SaleLevySum_4 numeric(21, 9), @SaleLevySum_5 numeric(21, 9)
  DECLARE @RetLevySum_0 numeric(21, 9), @RetLevySum_1 numeric(21, 9), @RetLevySum_2 numeric(21, 9), @RetLevySum_3 numeric(21, 9), @RetLevySum_4 numeric(21, 9), @RetLevySum_5 numeric(21, 9)

  /* SET @ParamsIn = '{"CRID":2}' */
  SET @ParamsOut = '{}'

  SET @CRID = JSON_VALUE(@ParamsIn, '$.CRID')
  SET @CashType = ISNULL((SELECT CashType FROM r_CRs WITH(NOLOCK) WHERE CRID = @CRID),0)
  SET @Time = GetDate()

  /* SET @RoundTaxSum = dbo.zf_Var('z_RoundTaxSum') */
  /* SELECT @CountSymbolRoundTax = ISNULL((SELECT LEN(REPLACE(STR(@RoundTaxSum, 20, 10), '0', ' ')) - 10),2) */ 
  /* ПРРО: необходимо для корректного рассчета суммы НДС и суммы акциза */
  SET @CountSymbolRoundTax = 5

  SELECT @TaxPayer = o.TaxPayer 
  FROM r_CRs c WITH(NOLOCK), r_CRSrvs s WITH(NOLOCK), r_Ours o WITH(NOLOCK) 
  WHERE c.CRID = @CRID AND c.SrvID = s.SrvID AND s.OurID = o.OurID

  SET @PayFormCodeCustom1 = ISNULL((SELECT PayFormCode from r_PayFormCR WITH(NOLOCK) WHERE CRPayFormCode = 4 AND CashType = @CashType),-1)
  SET @PayFormCodeCustom2 = ISNULL((SELECT PayFormCode from r_PayFormCR WITH(NOLOCK) WHERE CRPayFormCode = 5 AND CashType = @CashType),-1)
  SET @PayFormCodeCustom3 = ISNULL((SELECT PayFormCode from r_PayFormCR WITH(NOLOCK) WHERE CRPayFormCode = 6 AND CashType = @CashType),-1)
  SET @PayFormCodeCustom4 = ISNULL((SELECT PayFormCode from r_PayFormCR WITH(NOLOCK) WHERE CRPayFormCode = 7 AND CashType = @CashType),-1)
  SET @PayFormCodeCustom5 = ISNULL((SELECT PayFormCode from r_PayFormCR WITH(NOLOCK) WHERE CRPayFormCode = 8 AND CashType = @CashType),-1)
  SET @PayFormCodeCashBack = 11

  DROP TABLE IF EXISTS #StateCode
  DROP TABLE IF EXISTS #t_zRep
  DROP TABLE IF EXISTS #t_Sale
  DROP TABLE IF EXISTS #t_SaleD
  DROP TABLE IF EXISTS #t_SalePays
  DROP TABLE IF EXISTS #t_SaleDLV

  DROP TABLE IF EXISTS #t_CRRet
  DROP TABLE IF EXISTS #t_CRRetD
  DROP TABLE IF EXISTS #t_CRRetPays
  DROP TABLE IF EXISTS #t_CRRetDLV

  DROP TABLE IF EXISTS #t_MonIntRec
  DROP TABLE IF EXISTS #t_MonIntExp
  DROP TABLE IF EXISTS #t_CashBack

  DROP TABLE IF EXISTS #r_Taxes
  DROP TABLE IF EXISTS #r_LevyCR

  DROP TABLE IF EXISTS #r_PayForms

  SELECT AValue AS StateCode
  INTO #StateCode
  FROM dbo.zf_FilterToTable('22,23')

  SELECT TOP 1 m.*  
  INTO #t_zRep
  FROM t_zRep m WITH(NOLOCK)
  WHERE m.CRID = @CRID
  ORDER BY DocTime DESC

  SELECT @LastZRep = DocTime, @InitialBalance = SumRem FROM #t_zRep

  SET @LastZRep = ISNULL(@LastZRep,'1900-01-01 00:00:00')
  SET @InitialBalance = ISNULL(@InitialBalance,0)

  DECLARE @UseHardwareDisc BIT  
  SELECT @UseHardwareDisc = CASE WHEN pw.DiscountMode = 1 THEN 1 ELSE 0 END FROM r_WPRoles AS pw  
  JOIN r_WPs AS rw ON pw.WPRoleID = rw.WPRoleID
  JOIN r_CRs AS cr ON rw.CRID = cr.CRID
  WHERE cr.CRID = @CRID
  
  SET @SaleRoundDiscCode = ISNULL(dbo.zf_Var('t_SaleRoundDiscCode'),-1)

  /* Данные за период последней открытой смены */
  /* Все документы по продажам кассы @CRID */ 
  SELECT m.ChID, m.DocID, m.OurID, m.DocDate, TSumCC_wt, dbo.zf_GetTaxPayerByDate(m.OurID, m.DocDate) AS TaxPayerByDate  
  INTO #t_Sale
  FROM t_Sale m WITH(NOLOCK)
  WHERE m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND (@CashType <> 39 OR m.StateCode IN (SELECT StateCode FROM #StateCode)) 

  /* Все документы выдачи наличных кассы @CRID */ 
  SELECT m.DocID  
  INTO #t_CashBack
  FROM t_CashBack m WITH(NOLOCK)
  WHERE m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID 

  SELECT d.ChID, d.SrcPosID, d.TaxTypeID, 
  CASE WHEN @CashType = 39 AND @UseHardwareDisc = 1 THEN ROUND((Qty * PurTax),2) ELSE d.TaxSum END TaxSum,
  CASE WHEN @CashType = 39 AND @UseHardwareDisc = 1 THEN ROUND((Qty * PurPriceCC_wt),2) ELSE d.SumCC_wt END SumCC_wt 
  INTO #t_SaleD
  FROM #t_Sale m WITH(NOLOCK)
  INNER JOIN t_SaleD d WITH(NOLOCK) ON m.ChID = d.ChID 

  /* Все оплаты по прадажам кассы @CRID */ 
  SELECT d.ChID, d.PayFormCode, d.SumCC_wt, d.CashBack
  INTO #t_SalePays
  FROM #t_Sale m WITH(NOLOCK)
  INNER JOIN t_SalePays d WITH(NOLOCK) ON m.ChID = d.ChID 

  /* Все возвратные документы кассы @CRID */ 
  SELECT m.ChID, m.DocID, m.OurID, m.DocDate, TSumCC_wt, dbo.zf_GetTaxPayerByDate(m.OurID, m.SrcDocDate) AS TaxPayerByDate  
  INTO #t_CRRet
  FROM t_CRRet m WITH(NOLOCK)
  WHERE m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND (@CashType <> 39 OR m.StateCode IN (SELECT StateCode FROM #StateCode))

  SELECT d.ChID, d.SrcPosID, d.TaxTypeID, d.TaxSum, d.SumCC_wt
  INTO #t_CRRetD
  FROM #t_CRRet m WITH(NOLOCK)
  INNER JOIN t_CRRetD d WITH(NOLOCK) ON m.ChID = d.ChID

  /* Все оплаты по возвратам кассы @CRID */ 
  SELECT d.ChID, d.PayFormCode, d.SumCC_wt
  INTO #t_CRRetPays
  FROM #t_CRRet m WITH(NOLOCK)
  INNER JOIN t_CRRetPays d WITH(NOLOCK) ON m.ChID = d.ChID 

  SELECT m.ChID, m.SumCC  
  INTO #t_MonIntRec
  FROM t_MonIntRec m WITH(NOLOCK)
  WHERE DocTime BETWEEN @LastZRep AND @Time AND CRID = @CRID AND (@CashType <> 39 OR m.StateCode IN (SELECT StateCode FROM #StateCode)) 

  SELECT m.ChID, m.SumCC 
  INTO #t_MonIntExp
  FROM t_MonIntExp m WITH(NOLOCK)
  WHERE DocTime BETWEEN @LastZRep AND @Time AND CRID = @CRID AND (@CashType <> 39 OR m.StateCode IN (SELECT StateCode FROM #StateCode))

  SELECT DISTINCT m.TaxTypeID, m.TaxID 
  INTO #r_Taxes
  FROM r_Taxes m WITH(NOLOCK)

  SELECT DISTINCT m.LevyID, m.TaxID, m.TaxTypeID  
  INTO #r_LevyCR
  FROM r_LevyCR m WITH(NOLOCK)
  WHERE m.CashType = @CashType

  SELECT dlv.ChID, dlv.SrcPosID, dlv.LevyID, dlv.LevySum
  INTO #t_SaleDLV
  FROM #t_Sale m WITH(NOLOCK)
  INNER JOIN t_SaleD d WITH(NOLOCK) ON m.ChID = d.ChID
  INNER JOIN t_SaleDLV dlv WITH(NOLOCK) ON d.ChID = dlv.ChID AND d.SrcPosID = dlv.SrcPosID

  SELECT dlv.ChID, dlv.SrcPosID, dlv.LevyID, dlv.LevySum
  INTO #t_CRRetDLV
  FROM #t_CRRet m WITH(NOLOCK)
  INNER JOIN t_CRRetD d WITH(NOLOCK) ON m.ChID = d.ChID
  INNER JOIN t_CRRetDLV dlv WITH(NOLOCK) ON d.ChID = dlv.ChID AND d.SrcPosID = dlv.SrcPosID

  SELECT m.*
  INTO #r_PayForms
  FROM r_PayForms m WITH(NOLOCK)

  /* Неплательщик НДС */ 
  SET @TaxIDNotVAT = ISNULL((SELECT ISNULL(TaxID,1) FROM #r_Taxes WITH(NOLOCK) WHERE TaxTypeID = 1),1) 

  SELECT @SaleSumCash = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_SalePays WHERE PayFormCode = 1 

  /* Общая сумма оплат по двум формам: 2 и 11*/
  SELECT @SaleSumCCard = ROUND(ISNULL(SUM(SumCC_wt), 0), 2), @CashBack = ROUND(ISNULL(SUM(CashBack), 0), 2) FROM #t_SalePays WHERE PayFormCode IN (2, 11)

  /* Сумма исключительно только по платежной карте, форма оплаты: картой с выдачей наличных */
  SELECT @SaleSumCCardOnlyCashBack = ROUND(ISNULL(SUM(d.SumCC_wt), 0), 2) 
  FROM #t_SalePays d 
  WHERE d.PayFormCode IN (2) AND d.ChID IN (SELECT DISTINCT ChID FROM #t_SalePays WHERE PayFormCode IN (11))

  SELECT @SaleSumCredit = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_SalePays WHERE PayFormCode = 3
  SELECT @SaleSumCheque = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_SalePays WHERE PayFormCode = 4
  SELECT @SaleSumOther = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_SalePays WHERE PayFormCode NOT IN (1, 2, 11, 3, 4)
  SELECT @SaleSumCustom1 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_SalePays WHERE PayFormCode = @PayFormCodeCustom1
  SELECT @SaleSumCustom2 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_SalePays WHERE PayFormCode = @PayFormCodeCustom2
  SELECT @SaleSumCustom3 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_SalePays WHERE PayFormCode = @PayFormCodeCustom3
  SELECT @SaleSumCustom4 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_SalePays WHERE PayFormCode = @PayFormCodeCustom4
  SELECT @SaleSumCustom5 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_SalePays WHERE PayFormCode = @PayFormCodeCustom5

  SELECT @SaleSumType0 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_SalePays WHERE PayFormCode IN (SELECT PayFormCode FROM #r_PayForms WHERE CRPayTypeCode = 0)
  SET @SaleSumType0 = @SaleSumType0 + @CashBack
  SELECT @SaleSumType1 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_SalePays WHERE PayFormCode IN (SELECT PayFormCode FROM #r_PayForms WHERE CRPayTypeCode = 1)
  SET @SaleSumType1 = @SaleSumType1 - @CashBack
  SELECT @SaleSumType2 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_SalePays WHERE PayFormCode IN (SELECT PayFormCode FROM #r_PayForms WHERE CRPayTypeCode = 2)

  SELECT @SumRetCash = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_CRRetPays WHERE PayFormCode = 1
  SELECT @SumRetCCard = ROUND(ISNULL(Sum(SumCC_wt), 0), 2) FROM #t_CRRetPays WHERE PayFormCode IN (2, 11)
  SELECT @SumRetCredit = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_CRRetPays WHERE PayFormCode = 3
  SELECT @SumRetCheque = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_CRRetPays WHERE PayFormCode = 4
  SELECT @SumRetOther = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_CRRetPays WHERE PayFormCode NOT IN (1, 2, 11, 3, 4)
  SELECT @SumRetCustom1 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_CRRetPays WHERE PayFormCode = @PayFormCodeCustom1
  SELECT @SumRetCustom2 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_CRRetPays WHERE PayFormCode = @PayFormCodeCustom2
  SELECT @SumRetCustom3 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_CRRetPays WHERE PayFormCode = @PayFormCodeCustom3
  SELECT @SumRetCustom4 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_CRRetPays WHERE PayFormCode = @PayFormCodeCustom4
  SELECT @SumRetCustom5 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_CRRetPays WHERE PayFormCode = @PayFormCodeCustom5

  SELECT @RetSumType0 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_CRRetPays WHERE PayFormCode IN (SELECT PayFormCode FROM #r_PayForms WHERE CRPayTypeCode = 0)
  SELECT @RetSumType1 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_CRRetPays WHERE PayFormCode IN (SELECT PayFormCode FROM #r_PayForms WHERE CRPayTypeCode = 1)
  SELECT @RetSumType2 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_CRRetPays WHERE PayFormCode IN (SELECT PayFormCode FROM #r_PayForms WHERE CRPayTypeCode = 2)

  SELECT @SaleSumCashFact = @SaleSumCash
  SELECT @SaleSumCCardFact = @SaleSumCCard
  SELECT @SaleSumCreditFact = @SaleSumCredit
  SELECT @SaleSumChequeFact = @SaleSumCheque
  SELECT @SaleSumOtherFact = @SaleSumOther
  SELECT @SaleSumCustom1Fact = @SaleSumCustom1
  SELECT @SaleSumCustom2Fact = @SaleSumCustom2
  SELECT @SaleSumCustom3Fact = @SaleSumCustom3
  SELECT @SaleSumCustom4Fact = @SaleSumCustom4
  SELECT @SaleSumCustom5Fact = @SaleSumCustom5

  SELECT @SaleSumCash = @SaleSumCash - @SumRetCash
  SELECT @SaleSumCCard = @SaleSumCCard - @SumRetCCard
  SELECT @SaleSumCredit = @SaleSumCredit - @SumRetCredit
  SELECT @SaleSumCheque = @SaleSumCheque - @SumRetCheque
  SELECT @SaleSumOther = @SaleSumOther - @SumRetOther
  SELECT @SaleSumCustom1 = @SaleSumCustom1 - @SumRetCustom1
  SELECT @SaleSumCustom2 = @SaleSumCustom2 - @SumRetCustom2
  SELECT @SaleSumCustom3 = @SaleSumCustom3 - @SumRetCustom3
  SELECT @SaleSumCustom4 = @SaleSumCustom4 - @SumRetCustom4
  SELECT @SaleSumCustom5 = @SaleSumCustom5 - @SumRetCustom5

  SELECT @MRec = ISNULL(SUM(SumCC), 0) FROM #t_MonIntRec
  SELECT @MExp = ISNULL(SUM(SumCC), 0) FROM #t_MonIntExp

  SELECT @SaleOrdersCount = COUNT(DocID) FROM #t_Sale WHERE TSumCC_wt <> 0
  SELECT @RetOrdersCount = COUNT(DocID) FROM #t_CRRet WHERE TSumCC_wt <> 0
  SELECT @CashBackOrdersCount = COUNT(DocID) FROM #t_CashBack

  SELECT @SumCash = @SaleSumCash + @MRec - @MExp /* @SaleSumCash уже учитывает кешбек */
  IF @CashType IN (10,18) SELECT @SumCash = @SumCash + @InitialBalance

  /*SELECT @SaleSum_0 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_SaleD WHERE TaxTypeID = 0 */
  /*SELECT @SaleSum_1 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_SaleD WHERE TaxTypeID = 1 */
  /*SELECT @SaleSum_2 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_SaleD WHERE TaxTypeID = 2 */
  /*SELECT @SaleSum_3 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_SaleD WHERE TaxTypeID = 3 */
  /*SELECT @SaleSum_4 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_SaleD WHERE TaxTypeID = 4 */
  /*SELECT @SaleSum_5 = ROUND(ISNULL(SUM(SumCC_wt), 0), 2) FROM #t_SaleD WHERE TaxTypeID = 5 */

  SELECT @SaleSum_0 = ISNULL(SUM(RealSum),0) FROM (SELECT SUM(ROUND(d.SumCC_wt + ISNULL(dlv.LevySum,0),2)) AS RealSum
  FROM #t_Sale m
  INNER JOIN #t_SaleD d ON m.ChID = d.ChID
  LEFT JOIN #t_SaleDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID
  LEFT JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 0  
  WHERE (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID OR (CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) IN (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN TaxTypeID ELSE @TaxIDNotVAT END FROM #r_Taxes WHERE CASE WHEN m.TaxPayerByDate = 1 THEN TaxID ELSE @TaxIDNotVAT END = 0)
  GROUP BY m.ChID) t

  SELECT @SaleSum_1 = ISNULL(SUM(RealSum),0) FROM (SELECT SUM(ROUND(d.SumCC_wt + ISNULL(dlv.LevySum,0),2)) AS RealSum
  FROM #t_Sale m
  INNER JOIN #t_SaleD d ON m.ChID = d.ChID
  LEFT JOIN #t_SaleDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
  LEFT JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 1  
  WHERE (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID OR (CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) IN (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN TaxTypeID ELSE @TaxIDNotVAT END FROM #r_Taxes WHERE CASE WHEN m.TaxPayerByDate = 1 THEN TaxID ELSE @TaxIDNotVAT END = 1)
  GROUP BY m.ChID) t

  SELECT @SaleSum_2 = ISNULL(SUM(RealSum),0) FROM (SELECT SUM(ROUND(d.SumCC_wt + ISNULL(dlv.LevySum,0),2)) AS RealSum
  FROM #t_Sale m
  INNER JOIN #t_SaleD d ON m.ChID = d.ChID
  LEFT JOIN #t_SaleDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
  LEFT JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 2  
  WHERE (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID OR (CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) IN (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN TaxTypeID ELSE @TaxIDNotVAT END FROM #r_Taxes WHERE CASE WHEN m.TaxPayerByDate = 1 THEN TaxID ELSE @TaxIDNotVAT END = 2)
  GROUP BY m.ChID) t

  SELECT @SaleSum_3 = ISNULL(SUM(RealSum),0) FROM (SELECT SUM(ROUND(d.SumCC_wt + ISNULL(dlv.LevySum,0),2)) AS RealSum
  FROM #t_Sale m
  INNER JOIN #t_SaleD d ON m.ChID = d.ChID
  LEFT JOIN #t_SaleDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
  LEFT JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 3  
  WHERE (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID OR (CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) IN (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN TaxTypeID ELSE @TaxIDNotVAT END FROM #r_Taxes WHERE CASE WHEN m.TaxPayerByDate = 1 THEN TaxID ELSE @TaxIDNotVAT END = 3)
  GROUP BY m.ChID) t

  SELECT @SaleSum_4 = ISNULL(SUM(RealSum),0) FROM (SELECT SUM(ROUND(d.SumCC_wt + ISNULL(dlv.LevySum,0),2)) AS RealSum
  FROM #t_Sale m
  INNER JOIN #t_SaleD d ON m.ChID = d.ChID
  LEFT JOIN #t_SaleDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
  LEFT JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 4  
  WHERE (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID OR (CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) IN (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN TaxTypeID ELSE @TaxIDNotVAT END FROM #r_Taxes WHERE CASE WHEN m.TaxPayerByDate = 1 THEN TaxID ELSE @TaxIDNotVAT END = 4)
  GROUP BY m.ChID) t

  SELECT @SaleSum_5 = ISNULL(SUM(RealSum),0) FROM (SELECT SUM(ROUND(d.SumCC_wt + ISNULL(dlv.LevySum,0),2)) AS RealSum
  FROM #t_Sale m
  INNER JOIN #t_SaleD d ON m.ChID = d.ChID
  LEFT JOIN #t_SaleDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
  LEFT JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 5  
  WHERE (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID OR (CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) IN (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN TaxTypeID ELSE @TaxIDNotVAT END FROM #r_Taxes WHERE CASE WHEN m.TaxPayerByDate = 1 THEN TaxID ELSE @TaxIDNotVAT END = 5)
  GROUP BY m.ChID) t

  IF @CashType <> 39
  BEGIN
    SELECT @SaleTaxSum_0 = ISNULL(SUM(t.TaxSum), 0) FROM (SELECT ROUND(SUM(ISNULL(TaxSum, 0)), 2) AS TaxSum FROM #t_SaleD WHERE TaxTypeID = 0 GROUP BY ChID) t
    SELECT @SaleTaxSum_1 = ISNULL(SUM(t.TaxSum), 0) FROM (SELECT ROUND(SUM(ISNULL(TaxSum, 0)), 2) AS TaxSum FROM #t_SaleD WHERE TaxTypeID = 1 GROUP BY ChID) t
    SELECT @SaleTaxSum_2 = ISNULL(SUM(t.TaxSum), 0) FROM (SELECT ROUND(SUM(ISNULL(TaxSum, 0)), 2) AS TaxSum FROM #t_SaleD WHERE TaxTypeID = 2 GROUP BY ChID) t
    SELECT @SaleTaxSum_3 = ISNULL(SUM(t.TaxSum), 0) FROM (SELECT ROUND(SUM(ISNULL(TaxSum, 0)), 2) AS TaxSum FROM #t_SaleD WHERE TaxTypeID = 3 GROUP BY ChID) t
    SELECT @SaleTaxSum_4 = ISNULL(SUM(t.TaxSum), 0) FROM (SELECT ROUND(SUM(ISNULL(TaxSum, 0)), 2) AS TaxSum FROM #t_SaleD WHERE TaxTypeID = 4 GROUP BY ChID) t
    SELECT @SaleTaxSum_5 = ISNULL(SUM(t.TaxSum), 0) FROM (SELECT ROUND(SUM(ISNULL(TaxSum, 0)), 2) AS TaxSum FROM #t_SaleD WHERE TaxTypeID = 5 GROUP BY ChID) t
  END
  ELSE
  BEGIN
    SELECT @SaleTaxSum_0 = ISNULL(SUM(t.TaxSum), 0) 
	   FROM (SELECT ROUND(SUM(ISNULL(ROUND(d.TaxSum, @CountSymbolRoundTax), 0)), 2) AS TaxSum FROM #t_SaleD d WHERE d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 0) GROUP BY d.ChID) t

	   SELECT @SaleTaxSum_1 = ISNULL(SUM(t.TaxSum), 0) 
	   FROM (SELECT ROUND(SUM(ISNULL(ROUND(d.TaxSum, @CountSymbolRoundTax), 0)), 2) AS TaxSum FROM #t_SaleD d WHERE d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 1) GROUP BY d.ChID) t

	   SELECT @SaleTaxSum_2 = ISNULL(SUM(t.TaxSum), 0) 
	   FROM (SELECT ROUND(SUM(ISNULL(ROUND(d.TaxSum, @CountSymbolRoundTax), 0)), 2) AS TaxSum FROM #t_SaleD d WHERE d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 2) GROUP BY d.ChID) t

	   SELECT @SaleTaxSum_3 = ISNULL(SUM(t.TaxSum), 0) 
	   FROM (SELECT ROUND(SUM(ISNULL(ROUND(d.TaxSum, @CountSymbolRoundTax), 0)), 2) AS TaxSum FROM #t_SaleD d WHERE d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 3) GROUP BY d.ChID) t

	   SELECT @SaleTaxSum_4 = ISNULL(SUM(t.TaxSum), 0) 
	   FROM (SELECT ROUND(SUM(ISNULL(ROUND(d.TaxSum, @CountSymbolRoundTax), 0)), 2) AS TaxSum FROM #t_SaleD d WHERE d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 4) GROUP BY d.ChID) t

	   SELECT @SaleTaxSum_5 = ISNULL(SUM(t.TaxSum), 0) 
	   FROM (SELECT ROUND(SUM(ISNULL(ROUND(d.TaxSum, @CountSymbolRoundTax), 0)), 2) AS TaxSum FROM #t_SaleD d WHERE d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 5) GROUP BY d.ChID) t

	SELECT @SaleLevySum_0 = ISNULL((SELECT SUM(ROUND(LevySum,2)) 
	FROM (SELECT ISNULL(ROUND(SUM(ISNULL(dlv.LevySum,0)),4),0) AS LevySum FROM #t_Sale m 
    INNER JOIN #t_SaleD d ON d.ChID = m.ChID
    INNER JOIN #t_SaleDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
    INNER JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 0
    WHERE (d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 0) 
	OR (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID) GROUP BY m.ChID) t),0)
	SELECT @SaleTaxSum_0 = @SaleTaxSum_0 + @SaleLevySum_0
	
	SELECT @SaleLevySum_1 = ISNULL((SELECT SUM(ROUND(LevySum,2)) 
	FROM (SELECT ISNULL(ROUND(SUM(ISNULL(dlv.LevySum,0)),4),0) AS LevySum FROM #t_Sale m 
    INNER JOIN #t_SaleD d ON d.ChID = m.ChID
    LEFT JOIN #t_SaleDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
    INNER JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 1
    WHERE (d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 1) 
	OR (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID) GROUP BY m.ChID) t),0)
	SELECT @SaleTaxSum_1 = @SaleTaxSum_1 + @SaleLevySum_1

	SELECT @SaleLevySum_2 = ISNULL((SELECT SUM(ROUND(LevySum,2)) 
	FROM (SELECT ISNULL(ROUND(SUM(ISNULL(dlv.LevySum,0)),4),0) AS LevySum FROM #t_Sale m 
    INNER JOIN #t_SaleD d ON d.ChID = m.ChID
    INNER JOIN #t_SaleDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
    INNER JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 2
    WHERE (d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 2) 
	OR (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID) GROUP BY m.ChID) t),0)
	SELECT @SaleTaxSum_2 = @SaleTaxSum_2 + @SaleLevySum_2

	SELECT @SaleLevySum_3 = ISNULL((SELECT SUM(ROUND(LevySum,2)) 
	FROM (SELECT ISNULL(ROUND(SUM(ISNULL(dlv.LevySum,0)),4),0) AS LevySum FROM #t_Sale m 
    INNER JOIN #t_SaleD d ON d.ChID = m.ChID
    INNER JOIN #t_SaleDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
    INNER JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 3
	WHERE (d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 3) 
	OR (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID) GROUP BY m.ChID) t),0)
	SELECT @SaleTaxSum_3 = @SaleTaxSum_3 + @SaleLevySum_3
	
	SELECT @SaleLevySum_4 = ISNULL((SELECT SUM(ROUND(LevySum,2)) 
	FROM (SELECT ISNULL(ROUND(SUM(ISNULL(dlv.LevySum,0)),4),0) AS LevySum FROM #t_Sale m 
    INNER JOIN #t_SaleD d ON d.ChID = m.ChID
    INNER JOIN #t_SaleDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
    INNER JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 4
    WHERE (d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 4) 
	OR (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID) GROUP BY m.ChID) t),0)
	SELECT @SaleTaxSum_4 = @SaleTaxSum_4 + @SaleLevySum_4

    SELECT @SaleLevySum_5 = ISNULL((SELECT SUM(ROUND(LevySum,2)) 
	FROM (SELECT ISNULL(ROUND(SUM(ISNULL(dlv.LevySum,0)),4),0) AS LevySum FROM #t_Sale m 
    INNER JOIN #t_SaleD d ON d.ChID = m.ChID
    INNER JOIN #t_SaleDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
    INNER JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 5
    WHERE (d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 5) 
	OR (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID) GROUP BY m.ChID) t),0)
	SELECT @SaleTaxSum_5 = @SaleTaxSum_5 + @SaleLevySum_5
	
  END 

  /*SELECT @RetSum_0 = ROUND(ISNULL(SUM(d.SumCC_wt), 0), 2) FROM #t_CRRetD d WHERE d.TaxTypeID = 0 */
  /*SELECT @RetSum_1 = ROUND(ISNULL(SUM(d.SumCC_wt), 0), 2) FROM #t_CRRetD d WHERE d.TaxTypeID = 1 */
  /*SELECT @RetSum_2 = ROUND(ISNULL(SUM(d.SumCC_wt), 0), 2) FROM #t_CRRetD d WHERE d.TaxTypeID = 2 */
  /*SELECT @RetSum_3 = ROUND(ISNULL(SUM(d.SumCC_wt), 0), 2) FROM #t_CRRetD d WHERE d.TaxTypeID = 3 */
  /*SELECT @RetSum_4 = ROUND(ISNULL(SUM(d.SumCC_wt), 0), 2) FROM #t_CRRetD d WHERE d.TaxTypeID = 4 */
  /*SELECT @RetSum_5 = ROUND(ISNULL(SUM(d.SumCC_wt), 0), 2) FROM #t_CRRetD d WHERE d.TaxTypeID = 5 */

    SELECT @RetSum_0 = ISNULL(SUM(RealSum),0) FROM (SELECT SUM(ROUND(d.SumCC_wt + ISNULL(dlv.LevySum,0),2)) AS RealSum
	FROM #t_CRRet m 
    INNER JOIN #t_CRRetD d ON d.ChID = m.ChID
    LEFT JOIN #t_CRRetDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
    LEFT JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 0
    WHERE (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID 
	OR (CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) IN (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN TaxTypeID ELSE @TaxIDNotVAT END FROM #r_Taxes WHERE CASE WHEN m.TaxPayerByDate = 1 THEN TaxID ELSE @TaxIDNotVAT END = 0)
	GROUP BY m.ChID) t

    SELECT @RetSum_1 = ISNULL(SUM(RealSum),0) FROM (SELECT SUM(ROUND(d.SumCC_wt + ISNULL(dlv.LevySum,0),2)) AS RealSum
	FROM #t_CRRet m 
    INNER JOIN #t_CRRetD d ON d.ChID = m.ChID
    LEFT JOIN #t_CRRetDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
    LEFT JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 1
    WHERE (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID 
	OR (CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) IN (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN TaxTypeID ELSE @TaxIDNotVAT END FROM #r_Taxes WHERE CASE WHEN m.TaxPayerByDate = 1 THEN TaxID ELSE @TaxIDNotVAT END = 1)
	GROUP BY m.ChID) t

    SELECT @RetSum_2 = ISNULL(SUM(RealSum),0) FROM (SELECT SUM(ROUND(d.SumCC_wt + ISNULL(dlv.LevySum,0),2)) AS RealSum
	FROM #t_CRRet m 
    INNER JOIN #t_CRRetD d ON d.ChID = m.ChID
    LEFT JOIN #t_CRRetDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
    LEFT JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 2
    WHERE (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID 
	OR (CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) IN (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN TaxTypeID ELSE @TaxIDNotVAT END FROM #r_Taxes WHERE CASE WHEN m.TaxPayerByDate = 1 THEN TaxID ELSE @TaxIDNotVAT END = 2)
	GROUP BY m.ChID) t

    SELECT @RetSum_3 = ISNULL(SUM(RealSum),0) FROM (SELECT SUM(ROUND(d.SumCC_wt + ISNULL(dlv.LevySum,0),2)) AS RealSum
	FROM #t_CRRet m 
    INNER JOIN #t_CRRetD d ON d.ChID = m.ChID
    LEFT JOIN #t_CRRetDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
    LEFT JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 3
    WHERE (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID 
	OR (CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) IN (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN TaxTypeID ELSE @TaxIDNotVAT END FROM #r_Taxes WHERE CASE WHEN m.TaxPayerByDate = 1 THEN TaxID ELSE @TaxIDNotVAT END = 3)
	GROUP BY m.ChID) t

    SELECT @RetSum_4 = ISNULL(SUM(RealSum),0) FROM (SELECT SUM(ROUND(d.SumCC_wt + ISNULL(dlv.LevySum,0),2)) AS RealSum
	FROM #t_CRRet m  
    INNER JOIN #t_CRRetD d ON d.ChID = m.ChID
    LEFT JOIN #t_CRRetDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
    LEFT JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 4
    WHERE (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID 
	OR (CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) IN (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN TaxTypeID ELSE @TaxIDNotVAT END FROM #r_Taxes WHERE CASE WHEN m.TaxPayerByDate = 1 THEN TaxID ELSE @TaxIDNotVAT END = 4)
	GROUP BY m.ChID) t

    SELECT @RetSum_5 = ISNULL(SUM(RealSum),0) FROM (SELECT SUM(ROUND(d.SumCC_wt + ISNULL(dlv.LevySum,0),2)) AS RealSum
	FROM #t_CRRet m 
    INNER JOIN #t_CRRetD d ON d.ChID = m.ChID
    LEFT JOIN #t_CRRetDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
    LEFT JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 5
    WHERE (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID 
	OR (CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) IN (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN TaxTypeID ELSE @TaxIDNotVAT END FROM #r_Taxes WHERE CASE WHEN m.TaxPayerByDate = 1 THEN TaxID ELSE @TaxIDNotVAT END = 5)
	GROUP BY m.ChID) t


  IF @CashType <> 39 
  BEGIN
    SELECT @RetTaxSum_0 = ISNULL(SUM(t.TaxSum), 0) FROM (SELECT ROUND(SUM(ISNULL(TaxSum, 0)), 2) AS TaxSum FROM #t_CRRetD WHERE TaxTypeID = 0 GROUP BY ChID) t
    SELECT @RetTaxSum_1 = ISNULL(SUM(t.TaxSum), 0) FROM (SELECT ROUND(SUM(ISNULL(TaxSum, 0)), 2) AS TaxSum FROM #t_CRRetD WHERE TaxTypeID = 1 GROUP BY ChID) t
    SELECT @RetTaxSum_2 = ISNULL(SUM(t.TaxSum), 0) FROM (SELECT ROUND(SUM(ISNULL(TaxSum, 0)), 2) AS TaxSum FROM #t_CRRetD WHERE TaxTypeID = 2 GROUP BY ChID) t
    SELECT @RetTaxSum_3 = ISNULL(SUM(t.TaxSum), 0) FROM (SELECT ROUND(SUM(ISNULL(TaxSum, 0)), 2) AS TaxSum FROM #t_CRRetD WHERE TaxTypeID = 3 GROUP BY ChID) t
    SELECT @RetTaxSum_4 = ISNULL(SUM(t.TaxSum), 0) FROM (SELECT ROUND(SUM(ISNULL(TaxSum, 0)), 2) AS TaxSum FROM #t_CRRetD WHERE TaxTypeID = 4 GROUP BY ChID) t
    SELECT @RetTaxSum_5 = ISNULL(SUM(t.TaxSum), 0) FROM (SELECT ROUND(SUM(ISNULL(TaxSum, 0)), 2) AS TaxSum FROM #t_CRRetD WHERE TaxTypeID = 5 GROUP BY ChID) t
  END
  ELSE
  BEGIN
    SELECT @RetTaxSum_0 = ISNULL(SUM(t.TaxSum), 0) 
	   FROM (SELECT ROUND(SUM(ISNULL(ROUND(d.TaxSum, @CountSymbolRoundTax), 0)), 2) AS TaxSum FROM #t_CRRetD d WHERE d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 0) GROUP BY d.ChID) t

	   SELECT @RetTaxSum_1 = ISNULL(SUM(t.TaxSum), 0) 
	   FROM (SELECT ROUND(SUM(ISNULL(ROUND(d.TaxSum, @CountSymbolRoundTax), 0)), 2) AS TaxSum FROM #t_CRRetD d WHERE d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 1) GROUP BY d.ChID) t

	   SELECT @RetTaxSum_2 = ISNULL(SUM(t.TaxSum), 0) 
	   FROM (SELECT ROUND(SUM(ISNULL(ROUND(d.TaxSum, @CountSymbolRoundTax), 0)), 2) AS TaxSum FROM #t_CRRetD d WHERE d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 2) GROUP BY d.ChID) t

	   SELECT @RetTaxSum_3 = ISNULL(SUM(t.TaxSum), 0) 
	   FROM (SELECT ROUND(SUM(ISNULL(ROUND(d.TaxSum, @CountSymbolRoundTax), 0)), 2) AS TaxSum FROM #t_CRRetD d WHERE d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 3) GROUP BY d.ChID) t

	   SELECT @RetTaxSum_4 = ISNULL(SUM(t.TaxSum), 0) 
	   FROM (SELECT ROUND(SUM(ISNULL(ROUND(d.TaxSum, @CountSymbolRoundTax), 0)), 2) AS TaxSum FROM #t_CRRetD d WHERE d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 4) GROUP BY d.ChID) t

	   SELECT @RetTaxSum_5 = ISNULL(SUM(t.TaxSum), 0) 
	   FROM (SELECT ROUND(SUM(ISNULL(ROUND(d.TaxSum, @CountSymbolRoundTax), 0)), 2) AS TaxSum FROM #t_CRRetD d WHERE d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 5) GROUP BY d.ChID) t 

	   SELECT @RetLevySum_0 = ISNULL((SELECT SUM(ROUND(LevySum,2)) 
	   FROM (SELECT ISNULL(ROUND(SUM(ISNULL(dlv.LevySum,0)),4),0) AS LevySum FROM #t_CRRet m
       INNER JOIN #t_CRRetD d ON d.ChID = m.ChID
       INNER JOIN #t_CRRetDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
       INNER JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 0
       WHERE (d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 0) 
	   OR (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID) GROUP BY m.ChID) t),0)
	   SELECT @RetTaxSum_0 = @RetTaxSum_0 + @RetLevySum_0

       SELECT @RetLevySum_1 = ISNULL((SELECT SUM(ROUND(LevySum,2)) 
	   FROM (SELECT ISNULL(ROUND(SUM(ISNULL(dlv.LevySum,0)),4),0) AS LevySum FROM #t_CRRet m
       INNER JOIN #t_CRRetD d ON d.ChID = m.ChID
       LEFT JOIN #t_CRRetDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
       INNER JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 1
       WHERE (d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 1) 
	   OR (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID) GROUP BY m.ChID) t),0)
	   SELECT @RetTaxSum_1 = @RetTaxSum_1 + @RetLevySum_1

       SELECT @RetLevySum_2 = ISNULL((SELECT SUM(ROUND(LevySum,2)) 
	   FROM (SELECT ISNULL(ROUND(SUM(ISNULL(dlv.LevySum,0)),4),0) AS LevySum FROM #t_CRRet m
       INNER JOIN #t_CRRetD d ON d.ChID = m.ChID
       INNER JOIN #t_CRRetDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
       INNER JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 2
       WHERE (d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 2) 
	   OR (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID) GROUP BY m.ChID) t),0)
	   SELECT @RetTaxSum_2 = @RetTaxSum_2 + @RetLevySum_2

	   SELECT @RetLevySum_3 = ISNULL((SELECT SUM(ROUND(LevySum,2)) 
	   FROM (SELECT ISNULL(ROUND(SUM(ISNULL(dlv.LevySum,0)),4),0) AS LevySum FROM #t_CRRet m
       INNER JOIN #t_CRRetD d ON d.ChID = m.ChID
       INNER JOIN #t_CRRetDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
       INNER JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 3
       WHERE (d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 3) 
	   OR (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID) GROUP BY m.ChID) t),0)
	   SELECT @RetTaxSum_3 = @RetTaxSum_3 + @RetLevySum_3

	   SELECT @RetLevySum_4 = ISNULL((SELECT SUM(ROUND(LevySum,2)) 
	   FROM (SELECT ISNULL(ROUND(SUM(ISNULL(dlv.LevySum,0)),4),0) AS LevySum FROM #t_CRRet m
       INNER JOIN #t_CRRetD d ON d.ChID = m.ChID
       INNER JOIN #t_CRRetDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
       INNER JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 4
       WHERE (d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 4) 
	   OR (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID) GROUP BY m.ChID) t),0)
	   SELECT @RetTaxSum_4 = @RetTaxSum_4 + @RetLevySum_4

	   SELECT @RetLevySum_5 = ISNULL((SELECT SUM(ROUND(LevySum,2)) 
	   FROM (SELECT ISNULL(ROUND(SUM(ISNULL(dlv.LevySum,0)),4),0) AS LevySum FROM #t_CRRet m
       INNER JOIN #t_CRRetD d ON d.ChID = m.ChID
       INNER JOIN #t_CRRetDLV dlv ON dlv.ChID = d.ChID AND dlv.SrcPosID = d.SrcPosID 
       INNER JOIN #r_LevyCR lcr ON lcr.LevyID = dlv.LevyID AND lcr.TaxID = 5
       WHERE (d.TaxTypeID IN (SELECT TaxTypeID FROM #r_Taxes WHERE TaxID = 5) 
	   OR (SELECT CASE WHEN m.TaxPayerByDate = 1 THEN d.TaxTypeID ELSE @TaxIDNotVAT END) = lcr.TaxTypeID) GROUP BY m.ChID) t),0)
	   SELECT @RetTaxSum_5 = @RetTaxSum_5 + @RetLevySum_5 
  END

  SET @SaleRndSum = 0
  SET @SaleNoRndSum = 0
  SET @RetRndSum = 0
  SET @RetNoRndSum = 0

  IF (@UseHardwareDisc = 1) AND (@CashType = 39)
    BEGIN
	  SELECT @SaleRndSum = ISNULL(SUM(ROUND(ISNULL(lrnd.SumBonus,0),2)),0)
	  FROM #t_SaleD d WITH(NOLOCK)
      LEFT JOIN z_LogDiscExpP lrnd WITH(NOLOCK) ON d.ChID = lrnd.ChID AND lrnd.DocCode = 11035 AND d.SrcPosID = lrnd.SrcPosID AND lrnd.DiscCode = @SaleRoundDiscCode
	  print @SaleRndSum

      SELECT @RetRndSum = ISNULL(SUM(ROUND(ISNULL(lrnd.SumBonus,0),2)),0)
	  FROM #t_CRRetD d WITH(NOLOCK)
      LEFT JOIN z_LogDiscExpP lrnd WITH(NOLOCK) ON d.ChID = lrnd.ChID AND lrnd.DocCode = 11004 AND d.SrcPosID = lrnd.SrcPosID AND lrnd.DiscCode = @SaleRoundDiscCode
	
	  SET @SaleNoRndSum = @SaleSumCashFact + @SaleRndSum
      SET @RetNoRndSum = @SumRetCash + @RetRndSum
	END

  SET @ParamsOut = (
    SELECT
      @SaleSumCash AS SaleSumCash,
      @SaleSumCCard AS SaleSumCCard,
      @SaleSumCredit AS SaleSumCredit,
      @SaleSumCheque AS SaleSumCheque,
      @SaleSumOther AS SaleSumOther,
      @MRec AS MRec,
      @MExp AS MExp,
      @SumCash AS SumCash,
      @SumRetCash AS SumRetCash,
      @SumRetCCard AS SumRetCCard,
      @SumRetCredit AS SumRetCredit,
      @SumRetCheque AS SumRetCheque,
      @SumRetOther AS SumRetOther,
      @InitialBalance AS InitialBalance,
      @SaleTaxSum_0 AS SaleTaxSum_0,
      @SaleTaxSum_1 AS SaleTaxSum_1,
      @SaleTaxSum_2 AS SaleTaxSum_2,
      @SaleTaxSum_3 AS SaleTaxSum_3,
      @SaleTaxSum_4 AS SaleTaxSum_4,
      @SaleTaxSum_5 AS SaleTaxSum_5,
      @RetTaxSum_0 AS RetTaxSum_0,
      @RetTaxSum_1 AS RetTaxSum_1,
      @RetTaxSum_2 AS RetTaxSum_2,
      @RetTaxSum_3 AS RetTaxSum_3,
      @RetTaxSum_4 AS RetTaxSum_4,
      @RetTaxSum_5 AS RetTaxSum_5,
      @SaleSum_0 AS SaleSum_0,
      @SaleSum_1 AS SaleSum_1,
      @SaleSum_2 AS SaleSum_2,
      @SaleSum_3 AS SaleSum_3,
      @SaleSum_4 AS SaleSum_4,
      @SaleSum_5 AS SaleSum_5,
      @RetSum_0 AS RetSum_0,
      @RetSum_1 AS RetSum_1,
      @RetSum_2 AS RetSum_2,
      @RetSum_3 AS RetSum_3,
      @RetSum_4 AS RetSum_4,
      @RetSum_5 AS RetSum_5,
      @SaleSumCashFact AS SaleSumCashFact,
      @SaleSumCCardFact AS SaleSumCCardFact,
      @SaleSumCreditFact AS SaleSumCreditFact,
      @SaleSumChequeFact AS SaleSumChequeFact,
      @SaleSumOtherFact AS SaleSumOtherFact,
      @SaleSumCustom1Fact AS SaleSumCustom1Fact,
      @SaleSumCustom2Fact AS SaleSumCustom2Fact,
      @SaleSumCustom3Fact AS SaleSumCustom3Fact,
	  @SaleSumCustom4Fact AS SaleSumCustom4Fact,
	  @SaleSumCustom5Fact AS SaleSumCustom5Fact,
      @SaleSumCustom1 AS SaleSumCustom1,
      @SaleSumCustom2 AS SaleSumCustom2,
      @SaleSumCustom3 AS SaleSumCustom3,
	  @SaleSumCustom4 AS SaleSumCustom4,
      @SaleSumCustom5 AS SaleSumCustom5,
      @SumRetCustom1 AS SumRetCustom1,
      @SumRetCustom2 AS SumRetCustom2,
      @SumRetCustom3 AS SumRetCustom3,
	  @SumRetCustom4 AS SumRetCustom4,
      @SumRetCustom5 AS SumRetCustom5,
	  @SaleOrdersCount AS SaleOrdersCount,
	  @RetOrdersCount AS RetOrdersCount,
	  @CashBackOrdersCount AS CashBackOrdersCount,
      @CashBack AS CashBack,
      @SaleSumCCardOnlyCashBack AS SaleSumCCardOnlyCashBack,
      @SaleRndSum AS SaleRndSum,
      @SaleNoRndSum AS SaleNoRndSum,
      @RetRndSum AS RetRndSum, 
      @RetNoRndSum AS RetNoRndSum,
      @SaleSumType0 AS SaleSumType0,
	  @SaleSumType1 AS SaleSumType1,
	  @SaleSumType2 AS SaleSumType2,
	  @RetSumType0 AS RetSumType0,
	  @RetSumType1 AS RetSumType1,
	  @RetSumType2 AS RetSumType2
   FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
END
GO