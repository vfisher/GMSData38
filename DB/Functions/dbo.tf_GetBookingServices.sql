SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetBookingServices](@StockID int, @ExecutorID int, @CatFilter varchar(200), @PGrID3Filter varchar(200), @DCtypeCode int)
/* Возвращает список доступных для выбора услуг */
RETURNS @out TABLE(SrvcID int, ProdID int, PCatID int, SrvcName varchar(200), TimeNorm int, PriceCC numeric(21, 9), ExecutorID int, Notes varchar(200))  
BEGIN
  DECLARE @FilterListSeparator varchar(10)
  DECLARE @PLID int
  DECLARE @OnlyExecutorServices bit

  IF ISNULL(@ExecutorID, '') = ''
    SELECT @OnlyExecutorServices = 0
  ELSE
    SELECT @OnlyExecutorServices = 1

  SELECT @FilterListSeparator = dbo.zf_Var('z_FilterListSeparator')
  SELECT @PLID = PLID FROM r_Stocks WITH(NOLOCK) WHERE StockID = @StockID


  IF @DCtypeCode IS NULL
    INSERT INTO @Out(SrvcID, ProdID, PCatID, SrvcName, TimeNorm, PriceCC, ExecutorID, Notes)  
      SELECT DISTINCT
      m.SrvcID, d.ProdID, d.PCatID, d.ProdName, m.TimeNorm, 
      (p.PriceMC * c.KursCC) * q.Qty AS PriceCC, 
      CASE @OnlyExecutorServices
        WHEN 1 THEN ISNULL(es.ExecutorID, 0)
        ELSE 0 
      END,
        m.Notes
      FROM 
        r_Services m WITH (NOLOCK),
        r_ExecutorServices es WITH (NOLOCK),
        r_Prods d WITH (NOLOCK),
        r_ProdMQ q WITH (NOLOCK), 
        r_ProdMP p WITH (NOLOCK),  
        r_Currs c WITH (NOLOCK)
      WHERE
        m.ProdID = d.ProdID AND
        m.ProdID = q.ProdID AND
        m.ProdID = p.ProdID AND
        p.CurrID = c.CurrID AND
	       ((@OnlyExecutorServices = 1 AND es.ExecutorID = @ExecutorID AND m.SrvcID = es.SrvcID) OR (@OnlyExecutorServices = 0)) AND
        m.StockID = @StockID AND
        p.PLID = @PLID AND
        p.PriceMC > 0 AND
        q.Qty <> 0 AND
        dbo.zf_MatchFilterInt(d.PCatID, @CatFilter, @FilterListSeparator) = 1 AND
        dbo.zf_MatchFilterInt(d.PGrID3, @PGrID3Filter, @FilterListSeparator) = 1
      ORDER BY
        d.ProdName
  ELSE     
    INSERT INTO @Out(SrvcID, ProdID, PCatID, SrvcName, TimeNorm, PriceCC, ExecutorID, Notes)  
    SELECT DISTINCT
      m.SrvcID, d.ProdID, d.PCatID, d.ProdName, m.TimeNorm, 
     (p.PriceMC * c.KursCC) * q.Qty AS PriceCC, 
     CASE @OnlyExecutorServices
       WHEN 1 THEN ISNULL(es.ExecutorID, 0)
       ELSE 0 
     END,
       m.Notes
     FROM 
       r_Services m WITH (NOLOCK),
       r_ExecutorServices es WITH (NOLOCK),
       r_Prods d WITH (NOLOCK),
       r_ProdMQ q WITH (NOLOCK), 
       r_ProdMP p WITH (NOLOCK),  
       r_Currs c WITH (NOLOCK),
       r_DCTypeP tp WITH (NOLOCK)
     WHERE
       m.ProdID = d.ProdID AND
       m.ProdID = q.ProdID AND
       m.ProdID = p.ProdID AND
       p.CurrID = c.CurrID AND
       tp.ProdID = p.ProdID AND
       tp.DCTypeCode = @DCtypeCode AND
	      ((@OnlyExecutorServices = 1 AND es.ExecutorID = @ExecutorID AND m.SrvcID = es.SrvcID) OR (@OnlyExecutorServices = 0)) AND
       m.StockID = @StockID AND
       p.PLID = @PLID AND
       p.PriceMC > 0 AND
       q.Qty <> 0 AND
       dbo.zf_MatchFilterInt(d.PCatID, @CatFilter, @FilterListSeparator) = 1 AND
       dbo.zf_MatchFilterInt(d.PGrID3, @PGrID3Filter, @FilterListSeparator) = 1
     ORDER BY
       d.ProdName    
  RETURN
END
GO
