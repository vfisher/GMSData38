SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleMoneyGetCodes](@WPRoleID int, @CRID int, @IsRec bit)
/* Возвращает виды служебных операций */
AS
BEGIN
  DECLARE @FirstMonIntRec NUMERIC(21,9), @LastMonIntExp NUMERIC(21,9),
          @LastZRepDateTime DATETIME, @LastDocDateTime DATETIME, @Time DATETIME,
          @SaleSumCash NUMERIC(21,9), @SumRetCash NUMERIC(21,9), @MRec NUMERIC(21,9), @MExp NUMERIC(21,9), @SumCash NUMERIC(21,9)   
  DECLARE @StateCode TABLE(StateCode INT)

  INSERT INTO @StateCode (StateCode)
  SELECT AValue FROM dbo.zf_FilterToTable('22,23')

  SET @Time = GetDate()
  SET @LastZRepDateTime = ISNULL((SELECT dbo.tf_LastZRep(@CRID)),'19000101')
  SET @LastDocDateTime = ISNULL((SELECT dbo.tf_GetLastCRTime(@CRID,0)),'19000101')

  SET @LastMonIntExp  = ISNULL((SELECT TOP 1 SumCC FROM t_MonIntExp WHERE CRID = @CRID AND StateCode IN (SELECT StateCode FROM @StateCode) AND DocTime < @LastZRepDateTime ORDER BY DocTime DESC),0)
  SET @FirstMonIntRec = ISNULL((SELECT TOP 1 SumCC FROM t_MonIntRec WHERE CRID = @CRID AND StateCode IN (SELECT StateCode FROM @StateCode) AND DocTime > @LastZRepDateTime ORDER BY DocTime ASC),0)

  SELECT @SaleSumCash = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) FROM t_Sale m WITH(NOLOCK), t_SalePays d WITH(NOLOCK) WHERE m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRepDateTime AND @Time AND m.CRID = @CRID AND d.PayFormCode = 1 AND m.StateCode IN (SELECT StateCode FROM @StateCode)      	      
  SELECT @SumRetCash  = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) FROM t_CRRet m WITH(NOLOCK), t_CRRetPays d WITH(NOLOCK) WHERE m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRepDateTime AND @Time AND m.CRID = @CRID AND d.PayFormCode = 1 AND m.StateCode IN (SELECT StateCode FROM @StateCode)    
  SELECT @MRec = ISNULL(Sum(SumCC), 0) FROM t_MonIntRec WITH(NOLOCK) WHERE DocTime BETWEEN @LastZRepDateTime AND @Time AND CRID = @CRID AND StateCode IN (SELECT StateCode FROM @StateCode)  
  SELECT @MExp = ISNULL(Sum(SumCC), 0) FROM t_MonIntExp WITH(NOLOCK) WHERE DocTime BETWEEN @LastZRepDateTime AND @Time AND CRID = @CRID AND StateCode IN (SELECT StateCode FROM @StateCode)

  SELECT @SaleSumCash = @SaleSumCash - @SumRetCash
  SELECT @SumCash = @SaleSumCash + @MRec - @MExp

SELECT m.MPayDesc, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.SumCC, CASE WHEN m.SumCC <> 0 THEN 1 ELSE 0 END AS IsReadOnly
FROM (
SELECT MPayDesc, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5,
  CASE WHEN @IsRec = 1 AND MPayDesc = dbo.zf_Translate('Служебный внос') AND @LastMonIntExp - @FirstMonIntRec > 0 THEN @LastMonIntExp ELSE 
    CASE WHEN @IsRec = 0 AND MPayDesc = dbo.zf_Translate('Служебный вынос') THEN @SumCash ELSE 0 END END AS SumCC
FROM r_CRMM 
WHERE WPRoleID = @WPRoleID AND IsRec = @IsRec 
/*WHERE CRID = @CRID AND IsRec = @IsRec */
) m	
END

GO
