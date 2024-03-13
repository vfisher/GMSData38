SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
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

  SET @DocCode = JSON_VALUE(@ParamsIn, '$.DocCode')
  SET @ChID = JSON_VALUE(@ParamsIn, '$.ChID')

  If @DocCode = 11035
    BEGIN
	     SELECT 
		     @UseProdNotes = c.UseProdNotes, 
		     @GroupProds = c.GroupProds, 
		     @TaxPayer = dbo.zf_GetTaxPayerByDate(m.OurID, m.DocTime) 
	     FROM t_Sale m WITH(NOLOCK), r_CRs c WITH(NOLOCK), r_Ours o WITH(NOLOCK)  
	     WHERE m.ChID = @ChID AND c.CRID = m.CRID AND m.OurID = o.OurID 

	     SET @ParamsOut = (
	     SELECT 
		     Doc = ISNULL((SELECT m.* FROM t_Sale m WITH(NOLOCK) WHERE m.CHID = @ChID FOR JSON PATH), '{}'),
            DocD = ISNULL((SELECT m.*, p.ProdName, p.CstProdCode,
		                      CASE WHEN @TaxPayer = 1 THEN m.TaxTypeID ELSE 1 END TaxTypeIDWithCheckTax
		                    FROM t_SaleD m WITH(NOLOCK), r_Prods p WITH(NOLOCK) WHERE m.ProdID = p.ProdID AND m.CHID = @ChID FOR JSON PATH),'{}'),
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
