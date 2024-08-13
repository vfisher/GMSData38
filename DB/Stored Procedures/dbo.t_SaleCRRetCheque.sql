SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleCRRetCheque](@ChID bigint)  
/*  
  Возвращает набор данных, по которому печатается возвратный чек. Обязательные поля  
  SrcPosID    - позиция  
  ProdID      - код товара  
  TaxTypeID   - налоговая группа  
  TPriceCC_wt - цена с НДС  
  TQty        - количество  
  ProdName    - наименование товара  
  ProdParam1  - для оккупированных территорий
  CstProdCode - Код УКТВЭД
  LevyMark    - Акцизная марка
  BarCode     - Штрихкод
*/  
AS  
BEGIN  
  DECLARE @UseProdNotes bit  
  DECLARE @TaxPayer bit
  DECLARE @CashType int, @OurID int
  DECLARE @SaleDocDate smalldatetime

  SELECT @UseProdNotes = UseProdNotes, @TaxPayer = o.TaxPayer, @CashType = c.CashType, @OurID = o.OurID
  FROM t_CRRet m WITH(NOLOCK), r_CRs c WITH(NOLOCK), r_Ours o  WITH(NOLOCK)
  WHERE m.CRID = c.CRID AND m.ChID = @ChID AND m.OurID = o.OurID

  SET @SaleDocDate = ISNULL((SELECT TOP 1 DocDate FROM t_Sale WITH(NOLOCK) WHERE OurID = @OurID AND DocID IN (SELECT TOP 1 SrcDocID FROM t_CRRet WITH(NOLOCK) WHERE OurID = @OurID AND ChID = @ChID)),'19000101')
  SET @TaxPayer = dbo.zf_GetTaxPayerByDate(@OurID, @SaleDocDate)

  SELECT 
    MIN(d.SrcPosID) AS SrcPosID,
    d.ProdID,
    CASE WHEN @TaxPayer = 1 THEN d.TaxTypeID ELSE 1 END TaxTypeID,
    RealPrice AS TPriceCC_wt, SUM(d.Qty) AS TQty, (CASE @UseProdNotes WHEN 0 THEN p.ProdName ELSE p.Notes END) AS ProdName,
    CASE p.IsMarked WHEN 1 THEN pm.DataMatrix ELSE p.Article3 END  + ' ' AS ProdParam1,
    p.CstProdCode, /*Код УКТВЭД*/  
    d.LevyMark,
	d.BarCode
  FROM t_CRRetD d WITH(NOLOCK)
  LEFT JOIN r_ProdMarks pm WITH(NOLOCK) ON pm.MarkCode=d.MarkCode
  JOIN r_Prods p WITH(NOLOCK) ON d.ProdID = p.ProdID
  WHERE d.Qty <> 0 AND d.ChID = @ChID
  GROUP BY d.SaleSrcPosID, d.ProdID, p.ProdName, p.Notes, d.BarCode, d.TaxTypeID, d.RealPrice,
           p.IsMarked, pm.DataMatrix, p.Article3, p.CstProdCode, d.LevyMark, d.BarCode 
END
GO
