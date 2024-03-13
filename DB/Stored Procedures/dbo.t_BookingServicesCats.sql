SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_BookingServicesCats](@StockID int, @ExecutorID int, @SrvcNameFilter varchar(200), @PGrID3Filter varchar(200), @DCtypeCode int)
/* Формирует список категорий услуг для приложения GMS Услуги */
AS
BEGIN
  DECLARE @PLID int
  DECLARE @FilterListSeparator varchar(10)
  SELECT @FilterListSeparator = dbo.zf_Var('z_FilterListSeparator')
  SELECT @PLID = PLID FROM r_Stocks WHERE StockID = @StockID

  IF ISNULL(@ExecutorID, '') = ''
    BEGIN      
      IF @DCtypeCode IS NULL

      SELECT c.PCatID, c.PCatName
      FROM r_ProdC c WITH (NOLOCK)
        JOIN r_Prods p WITH (NOLOCK) ON c.PCatID = p.PCatID
        JOIN r_ProdMQ q WITH (NOLOCK) ON p.ProdID = q.ProdID
        JOIN r_ProdMP mp WITH (NOLOCK) ON p.ProdID = mp.ProdID
        JOIN r_Services s WITH (NOLOCK) ON s.ProdID = p.ProdID 
      WHERE s.SrvcID > 0 AND s.StockID = @StockID AND 
        mp.PLID = @PLID AND
        mp.PriceMC > 0 AND
        q.Qty <> 0 AND
        ((ISNULL(@SrvcNameFilter, '') = '' AND 1 = 1) OR (p.ProdName LIKE '%' + @SrvcNameFilter + '%')) AND
        dbo.zf_MatchFilterInt(p.PGrID3, @PGrID3Filter, @FilterListSeparator) = 1
      GROUP BY c.PCatID, c.PCatName
      HAVING COUNT(p.ProdID) > 0
      ORDER BY c.PCatName
      ELSE 
      SELECT c.PCatID, c.PCatName
      FROM r_ProdC c WITH (NOLOCK)
        JOIN r_Prods p WITH (NOLOCK) ON c.PCatID = p.PCatID
        JOIN r_ProdMQ q WITH (NOLOCK) ON p.ProdID = q.ProdID
        JOIN r_ProdMP mp WITH (NOLOCK) ON p.ProdID = mp.ProdID
        JOIN r_Services s WITH (NOLOCK) ON s.ProdID = p.ProdID 
        JOIN r_DCTypeP tp WITH (NOLOCK) ON tp.ProdID = p.ProdID AND tp.DCTypeCode = @DCtypeCode 
      WHERE s.SrvcID > 0 AND s.StockID = @StockID AND 
        mp.PLID = @PLID AND
        mp.PriceMC > 0 AND
        q.Qty <> 0 AND
        ((ISNULL(@SrvcNameFilter, '') = '' AND 1 = 1) OR (p.ProdName LIKE '%' + @SrvcNameFilter + '%')) AND
        dbo.zf_MatchFilterInt(p.PGrID3, @PGrID3Filter, @FilterListSeparator) = 1
      GROUP BY c.PCatID, c.PCatName
      HAVING COUNT(p.ProdID) > 0
      ORDER BY c.PCatName      

    END
  ELSE
    BEGIN
      SELECT c.PCatID, c.PCatName
      FROM r_ProdC c WITH (NOLOCK)
        JOIN r_Prods p WITH (NOLOCK) ON c.PCatID = p.PCatID
        JOIN r_ProdMQ q WITH (NOLOCK) ON p.ProdID = q.ProdID
        JOIN r_ProdMP mp WITH (NOLOCK) ON p.ProdID = mp.ProdID
        JOIN r_Services s WITH (NOLOCK) ON s.ProdID = p.ProdID 
        JOIN r_ExecutorServices e WITH(NOLOCK) ON s.SrvcID = e.SrvcID
        JOIN r_ExecutorShifts es WITH(NOLOCK) ON e.ExecutorID = es.ExecutorID
      WHERE es.ExecutorID = @ExecutorID AND
        s.SrvcID > 0 AND s.StockID = @StockID AND es.StockID = @StockID AND
        mp.PLID = @PLID AND
        mp.PriceMC > 0 AND
        q.Qty <> 0 AND
        ((ISNULL(@SrvcNameFilter, '') = '' AND 1 = 1) OR (p.ProdName LIKE '%' + @SrvcNameFilter + '%')) AND
        dbo.zf_MatchFilterInt(p.PGrID3, @PGrID3Filter, @FilterListSeparator) = 1
      GROUP BY c.PCatID, c.PCatName
      HAVING COUNT(p.ProdID) > 0
      ORDER BY c.PCatName
    END
END
GO
