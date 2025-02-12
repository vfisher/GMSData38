SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGetProcessingProdBonuses](@DocCode int, @DocChID bigint)
/* Формирует список сумм бонусов для каждого товара в чеке */
AS
BEGIN
  If @DocCode = 1011
    BEGIN
      SELECT ep.DiscCode, sd.CSrcPosID, sd.ProdID, SUM(ep.SumBonus) SumBonus 
      FROM r_DCards r 
        JOIN r_DCTypes t ON r.DCTypeCode = t.DCTypeCode
        JOIN r_DCTypeG g ON t.DCTypeGCode = g.DCTypeGCode
        JOIN z_DocDC c ON r.ChID = c.DCardChID
        JOIN r_DiscDC dc ON dc.DCTypeCode = r.DCTypeCode      
        JOIN t_SaleTempD sd ON c.ChID = sd.ChID
        JOIN t_LogDiscExpP ep ON dc.DiscCode = ep.DiscCode AND sd.ChID = ep.ChID AND sd.SrcPosID = ep.SrcPosID AND c.DocCode = ep.DocCode
      WHERE g.ProcessingID > 0 AND c.DocCode = @DocCode AND c.ChID = @DocChID
      GROUP BY ep.DiscCode, sd.CSrcPosID, sd.ProdID
      ORDER BY sd.ProdID
    END
  ELSE IF @DocCode = 11035
    BEGIN
      SELECT ep.DiscCode, sd.ProdID, SUM(ep.SumBonus) SumBonus 
      FROM r_DCards r 
        JOIN r_DCTypes t ON r.DCTypeCode = t.DCTypeCode
        JOIN r_DCTypeG g ON t.DCTypeGCode = g.DCTypeGCode
        JOIN z_DocDC c ON r.ChID = c.DCardChID
        JOIN r_DiscDC dc ON dc.DCTypeCode = r.DCTypeCode
        JOIN t_SaleD sd ON c.ChID = sd.ChID
        JOIN z_LogDiscExpP ep ON dc.DiscCode = ep.DiscCode AND sd.ChID = ep.ChID AND sd.SrcPosID = ep.SrcPosID AND c.DocCode = ep.DocCode
      WHERE g.ProcessingID > 0 AND c.DocCode = @DocCode AND c.ChID = @DocChID
      GROUP BY ep.DiscCode, sd.ProdID
      ORDER BY sd.ProdID
    END
END
GO