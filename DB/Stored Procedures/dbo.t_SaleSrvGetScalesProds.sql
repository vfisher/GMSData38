SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSrvGetScalesProds](@ScaleID int)
 /* Формирует список товаров для выгрузки в весы */
 AS
 BEGIN
   SELECT
     m.ProdID, m.ProdName, q.BarCode, q.UM, 0 ProdType, 1 ProdDep, CAST(w.WPref AS int) ProdGroup,
     dbo.zf_RoundPriceSale(dbo.zf_GetProdPrice_wt(p.PriceMC, m.ProdID, dbo.zf_GetDate(GetDate()))) PriceCC_wt, 0 PriceSpecCC_wt, CAST(0 AS bit) FixedPrice,
     0 ProdOrigin, NULL ProdDate, 0 PackedBy, 0 PackedByTime, m.Age SellBy, 0 SellByTime, CAST(0 AS numeric(21, 9)) FixedWeight,
     m.ScaleStandard, m.ScaleConditions, m.ScaleComponents, km.ScaleKey, m.PriceWithTax, dbo.zf_GetTaxPercent(m.TaxTypeID),
     SUBSTRING(q.BarCode, 2, 1) + SUBSTRING(q.BarCode, CASE WHEN wp.BarQtyCount > 5 THEN 3 ELSE 9 - wp.BarQtyCount END, CASE WHEN wp.BarQtyCount > 6 THEN 10 - wp.BarQtyCount ELSE 4 END) AS PLU
   FROM
     r_Prods m WITH(NOLOCK)
   INNER JOIN
     r_ProdMP p WITH(NOLOCK) ON m.ProdID = p.ProdID
   INNER JOIN
     r_ProdMQ q WITH(NOLOCK) ON m.ProdID = q.ProdID
   INNER JOIN
     r_ScaleGrMW w WITH(NOLOCK) ON w.WPref = SUBSTRING(q.BarCode, 1, 2)
   INNER JOIN
     r_WPrefs wp WITH(NOLOCK) ON wp.WPref = w.WPref
   INNER JOIN
     r_ScaleGrs g WITH(NOLOCK) ON g.ScaleGrID = w.ScaleGrID
   INNER JOIN
     r_Scales s WITH(NOLOCK) ON s.ScaleGrID = g.ScaleGrID
   INNER JOIN
     r_Stocks st WITH(NOLOCK) ON st.StockID = s.StockID
   LEFT OUTER JOIN
     r_ScaleDefs k WITH(NOLOCK) ON k.ScaleDefID = s.ScaleDefID
   LEFT OUTER JOIN
     r_ScaleDefKeys km WITH(NOLOCK) ON km.ScaleDefID = k.ScaleDefID AND km.Barcode = q.Barcode
   WHERE
     s.ScaleID = @ScaleID AND p.PriceMC <> 0 AND q.Qty <> 0 AND st.PLID = p.PLID
   ORDER BY
     PLU
 END
GO
