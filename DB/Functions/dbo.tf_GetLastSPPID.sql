SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetLastSPPID](@OurID int, @StockID int, @DocDate smalldatetime, @ProdID int)
/* Возвращает партию последнего прихода для товара */
RETURNS int 
BEGIN
  DECLARE @PPID int

  SELECT TOP 1 @PPID = PPID
  FROM
  (
    SELECT 
      m.PPID, CAST('19000101' AS smalldatetime) DocDate
    FROM t_zInP m WITH (NOLOCK)
    WHERE 
      m.OurID = ISNULL(@OurID, m.OurID) 
      AND m.StockID = ISNULL(@StockID, m.StockID)  
      AND m.ProdID = @ProdID
    UNION ALL
    SELECT 
      d.PPID, m.DocDate
    FROM t_Rec m WITH (NOLOCK)
    INNER JOIN t_RecD d WITH (NOLOCK)
    ON m.ChID = d.ChID
    WHERE 
      m.OurID = ISNULL(@OurID, m.OurID) 
      AND m.StockID = ISNULL(@StockID, m.StockID)
      AND m.DocDate <= @DocDate
      AND d.ProdID = @ProdID
    UNION ALL
    SELECT 
      d.PPID, m.DocDate
    FROM t_Ven m WITH (NOLOCK)
    INNER JOIN t_VenD d WITH (NOLOCK)
    ON m.ChID = d.ChID 
    INNER JOIN t_PInP pp WITH (NOLOCK)
    ON d.DetProdID = pp.ProdID AND d.PPID = pp.PPID
    WHERE 
      d.NewQty > d.Qty AND m.DocDate = pp.ProdDate
      AND pp.PPDesc = dbo.zf_Translate('Инвентаризация')
      AND m.OurID = ISNULL(@OurID, m.OurID) 
      AND m.StockID = ISNULL(@StockID, m.StockID)
      AND m.DocDate <= @DocDate
      AND d.DetProdID = @ProdID 
    UNION ALL
    SELECT 
      d.PPID, m.DocDate
    FROM t_SRec m WITH (NOLOCK)
    INNER JOIN t_SRecA d WITH (NOLOCK)
    ON m.ChID = d.ChID
    WHERE 
      m.OurID = ISNULL(@OurID, m.OurID) 
      AND m.StockID = ISNULL(@StockID, m.StockID) 
      AND m.DocDate <= @DocDate 
      AND d.ProdID = @ProdID 
    UNION ALL
    SELECT 
      d.PPID, m.DocDate
    FROM t_Exc m WITH (NOLOCK)
    INNER JOIN t_ExcD d WITH (NOLOCK)
    ON m.ChID = d.ChID
    WHERE 
      m.OurID = ISNULL(@OurID, m.OurID) 
      AND m.NewStockID = ISNULL(@StockID, m.NewStockID) 
      AND m.DocDate <= @DocDate 
      AND d.ProdID = @ProdID
    UNION ALL
    SELECT 
      d.SubPPID, m.DocDate
    FROM t_SExp m WITH (NOLOCK)
    INNER JOIN t_SExpA a WITH (NOLOCK)
    ON m.ChID = a.ChID
    INNER JOIN t_SExpD d WITH (NOLOCK)
    ON a.AChID = d.AChID
    WHERE 
      m.OurID = ISNULL(@OurID, m.OurID) 
      AND m.SubStockID = ISNULL(@StockID, m.SubStockID) 
      AND m.DocDate <= @DocDate 
      AND d.SubProdID = @ProdID
  ) spp    
    ORDER BY 
      DocDate DESC, PPID DESC
  RETURN ISNULL(@PPID, 0)
END

GO
