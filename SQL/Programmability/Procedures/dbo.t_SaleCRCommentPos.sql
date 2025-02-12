SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleCRCommentPos](@ChID bigint, @WPID int) 
/* Возвращает комментарии к позициям чека */ 
AS 
BEGIN 
  IF NOT EXISTS(SELECT TOP 1 1 FROM r_WPs w WITH(NOLOCK), r_WPRoles r WITH(NOLOCK) WHERE w.WPID = @WPID AND r.WPRoleID = w.WPRoleID AND r.PrintDiscs = 1) 
    BEGIN 
      SELECT TOP 0 0 SrcPosID, '' Col1, '' Col2, '' Col3, '' Barcode 
      RETURN 
    END 
 
  DECLARE @ProcessingDiscCode int 
  SELECT @ProcessingDiscCode = DiscCode 
  FROM z_DocDC c, r_DCards r, r_DCTypes t, r_DCTypeG g, r_DiscDC dc 
  WHERE r.DCTypeCode = t.DCTypeCode AND t.DCTypeGCode = g.DCTypeGCode AND r.ChID = c.DCardChID AND 
        dc.DCTypeCode = r.DCTypeCode AND ProcessingID > 0 AND c.DocCode = 1011 AND c.ChID = @ChID 
 
  DECLARE @out table(SrcPosID int, Col1 varchar(250), Col2 varchar(250), Col3 varchar(250), Barcode varchar(250)) 
  INSERT INTO @Out(SrcPosID, Col1, Col2, Col3, Barcode) 
  SELECT DISTINCT ( 
      SELECT MIN(s.SrcPosID) AS SrcPosID 
      FROM t_SaleTempD s WITH(NOLOCK) 
      WHERE s.ChID = @ChID AND s.ProdID = s1.ProdID AND s.PLID = s1.PLID AND s.BarCode = s1.BarCode AND 
        s.TaxTypeID = s1.TaxTypeID AND s.RealQty = s1.RealQty AND s.PriceCC_wt = s1.PriceCC_wt 
      GROUP BY s.ProdID 
      HAVING SUM(s.Qty) <> 0) SrcPosID, 
      dbo.zf_Translate('Полная стоимость ') + (CAST(CAST(( 
      SELECT SUM(s.PurPriceCC_wt*s.Qty)  
      FROM t_SaleTempD s WITH(NOLOCK) 
      WHERE s.ChID = @ChID AND s.ProdID = s1.ProdID AND s.PLID = s1.PLID AND s.BarCode = s1.BarCode AND 
        s.TaxTypeID = s1.TaxTypeID AND s.RealQty = s1.RealQty AND s.PriceCC_wt = s1.PriceCC_wt 
      GROUP BY s.ProdID 
      HAVING SUM(s.Qty) <> 0) AS numeric(21, 2)) AS varchar(20)))  + dbo.zf_Translate(' грн.') AS Col1, 
    '' Col2, 
    '' Col3, 
    '' Barcode 
  FROM t_LogDiscExp l WITH(NOLOCK), r_Discs d WITH(NOLOCK), t_SaleTempD s1 WITH(NOLOCK) 
  WHERE s1.ChID = @ChID AND l.DiscCode = d.DiscCode AND l.DiscCode <> 0 AND l.DocCode = 1011 AND l.ChID = s1.ChID AND l.SrcPosID = s1.SrcPosID AND 
        ((d.DiscCode <> @ProcessingDiscCode) OR (@ProcessingDiscCode IS NULL)) 
 
  /* Если есть чековая скидка */ 
  IF EXISTS(SELECT TOP 1 1 FROM t_LogDiscExp l WITH(NOLOCK) WHERE ChID = @ChID AND DocCode = 1011 AND SrcPosID IS NULL) 
    BEGIN 
   INSERT INTO @Out(SrcPosID, Col1, Col2, Col3, Barcode) 
   SELECT DISTINCT ( 
     SELECT MIN(s.SrcPosID) AS SrcPosID 
     FROM t_SaleTempD s WITH(NOLOCK) 
     WHERE s.ChID = @ChID AND s.ProdID = s1.ProdID AND s.PLID = s1.PLID AND s.BarCode = s1.BarCode AND 
     s.TaxTypeID = s1.TaxTypeID AND s.RealQty = s1.RealQty AND s.PriceCC_wt = s1.PriceCC_wt 
     GROUP BY s.ProdID 
     HAVING SUM(s.Qty) <> 0) SrcPosID, 
     dbo.zf_Translate('Полная стоимость ') + (CAST(CAST(( 
     SELECT SUM(s.PurPriceCC_wt*s.Qty)  
     FROM t_SaleTempD s WITH(NOLOCK) 
     WHERE s.ChID = @ChID AND s.ProdID = s1.ProdID AND s.PLID = s1.PLID AND s.BarCode = s1.BarCode AND 
     s.TaxTypeID = s1.TaxTypeID AND s.RealQty = s1.RealQty AND s.PriceCC_wt = s1.PriceCC_wt 
     GROUP BY s.ProdID 
     HAVING SUM(s.Qty) <> 0) AS numeric(21, 2)) AS varchar(20)))  + dbo.zf_Translate(' грн.') AS Col1, 
   '' Col2, 
   '' Col3, 
   '' Barcode 
   FROM t_SaleTempD s1 WITH(NOLOCK) 
   WHERE s1.ChID = @ChID AND s1.SrcPosID NOT IN (SELECT SrcPosID FROM @Out) 
    END 
 
  INSERT INTO @Out(SrcPosID, Col1, Col2, Col3, Barcode) 
  SELECT DISTINCT( 
      SELECT MIN(s.SrcPosID) AS SrcPosID 
      FROM t_SaleTempD s WITH(NOLOCK) 
      WHERE s.ChID = @ChID AND s.ProdID = s1.ProdID AND s.PLID = s1.PLID AND s.BarCode = s1.BarCode AND 
        s.TaxTypeID = s1.TaxTypeID AND s.RealQty = s1.RealQty AND s.PriceCC_wt = s1.PriceCC_wt 
      GROUP BY s.ProdID 
      HAVING SUM(s.Qty) <> 0) SrcPosID, 
    d.DiscName + ' ' + CASE WHEN l.Discount <> 0 THEN (CAST(CAST(l.Discount AS int) AS varchar(20))) + '%' ELSE (CAST(CAST(l.SumBonus AS numeric(21, 2)) AS varchar(20))) + dbo.zf_Translate(' грн.') END Col1, 
    '' Col2, 
    '' Col3, 
    '' Barcode 
  FROM t_LogDiscExp l WITH(NOLOCK), r_Discs d WITH(NOLOCK), t_SaleTempD s1 WITH(NOLOCK) 
  WHERE s1.ChID = @ChID AND l.DiscCode = d.DiscCode AND l.DiscCode <> 0 AND l.DocCode = 1011 AND l.ChID = s1.ChID AND l.SrcPosID = s1.SrcPosID AND d.PrintInCheque = 1 AND ((d.DiscCode <> @ProcessingDiscCode) OR (@ProcessingDiscCode IS NULL))  
 
/*Маркировка товара*/ 
/*SELECT CSrcPosID, 1, SrcPosID, 
                        'Код товара '+ CASE n.IsMarked WHEN 1 THEN SUBSTRING(n.DataMatrix,3, 14) + ' ' + SUBSTRING(n.DataMatrix,19, 13)  ELSE Article3 END  + ' ' AS Col1, 
                         '' AS Col2, 
                         '' Col3, '' As DiscCode 
            FROM 
                (SELECT SrcPosID, b.ProdID, pm.DataMatrix, b.IsMarked, b.Article3 
                FROM t_SaleTempD a 
                JOIN r_Prods b ON a.prodid = b.prodid 
                LEFT JOIN r_ProdMarks pm ON pm.MarkCode=a.MarkCode 
                WHERE a.ChID = @CHID 
                GROUP BY  srcposid,b.ProdID, pm.DataMatrix, b.IsMarked, b.Article3)n */ 
                 
  SELECT SrcPosID, Col1, Col2, Col3, Barcode FROM @Out 
END
GO