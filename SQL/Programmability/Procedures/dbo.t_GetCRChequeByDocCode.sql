﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetCRChequeByDocCode](@ParamsIn varchar(max), @ParamsOut varchar(max) OUTPUT) 
/* Возвращает набор данных документа по коду регистрации */  
AS
BEGIN
  /* SET @ParamsIn = '{"ChID":100000004,"DocCode":11035}' */
  SET @ParamsOut = '{}'

  DECLARE @DocCode int, @ChID bigint
  DECLARE @UseProdNotes bit, @GroupProds bit, @TaxPayer bit
  DECLARE @OurID int, @SaleDocDate smalldatetime
  DECLARE @CashType int, @UseHardwareDisc bit, @SaleRoundDiscCode int

  SET @UseHardwareDisc = 0
  SET @CashType = 0
  SET @SaleRoundDiscCode = ISNULL(dbo.zf_Var('t_SaleRoundDiscCode'),-1)

  SET @DocCode = JSON_VALUE(@ParamsIn, '$.DocCode')
  SET @ChID = JSON_VALUE(@ParamsIn, '$.ChID')

  If @DocCode = 1101
    BEGIN
	     SELECT 
		     @UseProdNotes = c.UseProdNotes, 
		     @GroupProds = c.GroupProds, 
		     @TaxPayer = dbo.zf_GetTaxPayerByDate(m.OurID, m.DocTime) 
	     FROM t_SaleTemp m WITH(NOLOCK), r_CRs c WITH(NOLOCK), r_Ours o WITH(NOLOCK)  
	     WHERE m.ChID = @ChID AND c.CRID = m.CRID AND m.OurID = o.OurID 

	     SET @ParamsOut = (
	     SELECT 
		     Doc = ISNULL((SELECT m.* FROM t_SaleTemp m WITH(NOLOCK) WHERE m.CHID = @ChID FOR JSON PATH), '{}'),
            DocD = ISNULL((SELECT m.*, p.ProdName, p.CstProdCode, m.PriceCC_wt AS RealPrice,
		                      CASE WHEN @TaxPayer = 1 THEN m.TaxTypeID ELSE 1 END TaxTypeIDWithCheckTax
		                    FROM t_SaleTempD m WITH(NOLOCK), r_Prods p WITH(NOLOCK) WHERE m.ProdID = p.ProdID AND m.CHID = @ChID FOR JSON PATH),'{}'),
            /* Если форма оплаты: Картой с выдачей наличных, то нам нужно получить запись только по 2 форме оплаты */
		     DocPays = ISNULL((SELECT m.* FROM t_SaleTempPays m WITH(NOLOCK) WHERE m.CHID = @ChID AND m.Notes <> 'Видача готівки' FOR JSON PATH),'{}'),
		     DocDLV = '{}'
	     FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
    END
  ELSE
  If @DocCode = 11035
    BEGIN
	     SELECT 
		     @UseProdNotes = c.UseProdNotes, 
		     @GroupProds = c.GroupProds, 
		     @TaxPayer = dbo.zf_GetTaxPayerByDate(m.OurID, m.DocTime),
			 @CashType = c.CashType,
             @UseHardwareDisc = CASE WHEN pw.DiscountMode = 1 THEN 1 ELSE 0 END
	     FROM t_Sale m WITH(NOLOCK), r_CRs c WITH(NOLOCK), r_Ours o WITH(NOLOCK), r_WPs rw WITH(NOLOCK), r_WPRoles pw WITH(NOLOCK)   
	     WHERE m.ChID = @ChID AND c.CRID = m.CRID AND m.OurID = o.OurID AND m.WPID = rw.WPID AND rw.WPRoleID = pw.WPRoleID  
	  print @UseHardwareDisc
	     SET @ParamsOut = (
	     SELECT 
		     Doc = ISNULL((SELECT m.* FROM t_Sale m WITH(NOLOCK) WHERE m.CHID = @ChID FOR JSON PATH), '{}'),
             DocD = ISNULL((SELECT m.ChID, m.SrcPosID, m.ProdID, m.PPID, m.UM, m.Qty, m.PriceCC_nt, m.SumCC_nt, m.Tax, m.TaxSum, m.PriceCC_wt, m.SumCC_wt, m.BarCode, m.SecID, m.PurPriceCC_nt, m.PurTax, m.PurPriceCC_wt, m.PLID, m.Discount, m.EmpID, m.CreateTime, m.ModifyTime, m.TaxTypeID, 
			   CASE WHEN @UseHardwareDisc = 1 THEN CASE WHEN @CashType = 39 THEN ISNULL(m.PurPriceCC_wt,0) ELSE m.RealPrice END ELSE m.RealPrice END RealPrice,
			   CASE WHEN @UseHardwareDisc = 1 THEN CASE WHEN @CashType = 39 THEN ROUND((ISNULL(m.PurPriceCC_wt,0) * m.Qty),2) ELSE m.RealSum END ELSE m.RealSum END RealSum,
			   m.MarkCode, m.LevyMark,
			   p.ProdName, p.CstProdCode,
			   CASE WHEN @UseHardwareDisc = 1 THEN CASE WHEN @CashType = 39 THEN ISNULL(l.SumBonus,0) ELSE m.Discount END ELSE 0 END DiscountSum,
			   ISNULL(lrnd.SumBonus,0) RndSum,
		       CASE WHEN @TaxPayer = 1 THEN m.TaxTypeID ELSE 1 END TaxTypeIDWithCheckTax
		 FROM t_SaleD m WITH(NOLOCK)
		 INNER JOIN r_Prods p WITH(NOLOCK) ON m.ProdID = p.ProdID
		 LEFT JOIN (SELECT SrcPosID, SUM(ISNULL(SumBonus,0)) AS SumBonus FROM z_LogDiscExpP WITH(NOLOCK) WHERE DocCode = 11035 AND ChID = @ChID AND DiscCode <> @SaleRoundDiscCode GROUP BY SrcPosID) l ON m.SrcPosID = l.SrcPosID  
		 LEFT JOIN (SELECT SrcPosID, SUM(ISNULL(SumBonus,0)) AS SumBonus FROM z_LogDiscExpP WITH(NOLOCK) WHERE DocCode = 11035 AND ChID = @ChID AND DiscCode = @SaleRoundDiscCode GROUP BY SrcPosID) lrnd ON m.SrcPosID = lrnd.SrcPosID
		 WHERE m.CHID = @ChID FOR JSON PATH),'{}'),

            /* Если форма оплаты: Картой с выдачей наличных, то нам нужно получить запись только по 2 форме оплаты */
		     DocPays = ISNULL((SELECT m.* FROM t_SalePays m WITH(NOLOCK) WHERE m.CHID = @ChID AND m.Notes <> 'Видача готівки' FOR JSON PATH),'{}'),
		     DocDLV = ISNULL((SELECT * FROM t_SaleDLV WHERE CHID = @ChID FOR JSON PATH),'{}')
	     FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
    END
  ELSE If @DocCode = 11004
    BEGIN
	     SELECT 
		     @UseProdNotes = c.UseProdNotes, 
		     @GroupProds = c.GroupProds, 
		     @OurID = m.OurID
	     FROM t_CRRet m WITH(NOLOCK), r_CRs c WITH(NOLOCK), r_Ours o WITH(NOLOCK)  
	     WHERE m.ChID = @ChID AND c.CRID = m.CRID AND m.OurID = o.OurID 

	     SET @SaleDocDate = ISNULL((SELECT TOP 1 DocDate FROM t_Sale WITH(NOLOCK) WHERE OurID = @OurID AND DocID IN (SELECT TOP 1 SrcDocID FROM t_CRRet WITH(NOLOCK) WHERE OurID = @OurID AND ChID = @ChID)),'19000101')
        SET @TaxPayer = dbo.zf_GetTaxPayerByDate(@OurID, @SaleDocDate)

	     SET @ParamsOut = (
	     SELECT 
		     Doc = ISNULL((SELECT m.* FROM t_CRRet m WITH(NOLOCK) WHERE m.CHID = @ChID FOR JSON PATH), '{}'),
		     DocD = ISNULL((SELECT m.*, p.ProdName, p.CstProdCode,
		                      CASE WHEN @TaxPayer = 1 THEN m.TaxTypeID ELSE 1 END TaxTypeIDWithCheckTax
						    FROM t_CRRetD m WITH(NOLOCK), r_Prods p WITH(NOLOCK) WHERE m.ProdID = p.ProdID AND m.CHID = @ChID FOR JSON PATH),'{}'),
		     DocPays = ISNULL((SELECT m.* FROM t_CRRetPays m WITH(NOLOCK) WHERE m.CHID = @ChID FOR JSON PATH),'{}'),
		     DocDLV = ISNULL((SELECT * FROM t_CRRetDLV WHERE CHID = @ChID FOR JSON PATH),'{}')
	     FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
    END
  ELSE If @DocCode = 11036
    BEGIN
	     SELECT 
		     @UseProdNotes = c.UseProdNotes, 
		     @GroupProds = c.GroupProds, 
		     @TaxPayer = dbo.zf_GetTaxPayerByDate(m.OurID, m.DocTime) 
	     FROM t_CashBack m WITH(NOLOCK), r_CRs c WITH(NOLOCK), r_Ours o WITH(NOLOCK)  
	     WHERE m.ChID = @ChID AND c.CRID = m.CRID AND m.OurID = o.OurID 

	     SET @ParamsOut = (
	     SELECT 
		     Doc = ISNULL((SELECT m.* FROM t_CashBack m WITH(NOLOCK) WHERE m.CHID = @ChID FOR JSON PATH), '{}')
	     FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
    END 	
END
GO