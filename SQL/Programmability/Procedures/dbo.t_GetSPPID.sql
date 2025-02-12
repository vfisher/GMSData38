SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[t_GetSPPID](@AOurID int, @AStockID int, @AProdID int, @ASecID int, @SPPID int, @PPID int OUTPUT) AS
Begin
  Declare @ADocDate DateTime, @FPPID int

  If @SPPID = 0 
    Begin
      SELECT @PPID = 0
      Return 1
    End

  If @SPPID = 1 
    Begin
      DECLARE ACursor CURSOR LOCAL FAST_FORWARD FOR
                             SELECT Min(DocDate) AS TDocDate, PPID FROM t_Rec m WITH (NOLOCK) INNER JOIN t_RecD d WITH (NOLOCK) ON d.ChID=m.ChID
                             WHERE OurID=@AOurID AND StockID=@AStockID AND SecID=@ASecID AND ProdID=@AProdID
                             GROUP BY PPID
                             UNION All
                             SELECT Min(DocDate) AS TDocDate, PPID FROM t_Cst m WITH (NOLOCK) INNER JOIN t_CstD d WITH (NOLOCK) ON d.ChID=m.ChID
                             WHERE OurID=@AOurID AND StockID=@AStockID AND SecID=@ASecID AND ProdID=@AProdID
                             GROUP BY PPID
                             UNION All
                             SELECT Min(DocDate) AS TDocDate, PPID FROM t_Ret m WITH (NOLOCK) INNER JOIN t_RetD d WITH (NOLOCK) ON d.ChID=m.ChID
                             WHERE OurID=@AOurID AND StockID=@AStockID AND SecID=@ASecID AND ProdID=@AProdID
                             GROUP BY PPID
                             UNION All
                             SELECT Min(DocDate) AS TDocDate, PPID FROM t_CRRet m WITH (NOLOCK) INNER JOIN t_CRRetD d WITH (NOLOCK) ON d.ChID=m.ChID
                             WHERE OurID=@AOurID AND StockID=@AStockID AND SecID=@ASecID AND ProdID=@AProdID
                             GROUP BY PPID
                             UNION All
                             SELECT Min(DocDate) AS TDocDate, PPID FROM t_Exc m WITH (NOLOCK) INNER JOIN t_ExcD d WITH (NOLOCK) ON d.ChID=m.ChID
                             WHERE OurID=@AOurID AND NewStockID=@AStockID AND NewSecID=@ASecID AND ProdID=@AProdID
                             GROUP BY PPID
                             UNION All
                             SELECT Min(DocDate) AS TDocDate, NewPPID AS PPID FROM t_Est m WITH (NOLOCK) INNER JOIN t_EstD d WITH (NOLOCK) ON d.ChID=m.ChID
                             WHERE OurID=@AOurID AND StockID=@AStockID AND SecID=@ASecID AND ProdID=@AProdID
                             GROUP BY NewPPID
                             UNION All
                             SELECT Min(DocDate) AS TDocDate, PPID FROM t_Ven m WITH (NOLOCK) INNER JOIN t_VenD d WITH (NOLOCK) ON d.ChID=m.ChID
                             WHERE OurID=@AOurID AND StockID=@AStockID AND SecID=@ASecID AND DetProdID=@AProdID
                             GROUP BY PPID
                             UNION All
                             SELECT Min(DocDate) AS TDocDate, PPID FROM t_SRec a WITH (NOLOCK) INNER JOIN t_SRecA b WITH (NOLOCK) ON a.ChID=b.ChID 
                             WHERE OurID=@AOurID AND StockID=@AStockID AND SecID=@ASecID AND ProdID=@AProdID
                             GROUP BY PPID
                             UNION  All
                             SELECT Min(SubDocDate) As TDocDate, SubPPID AS PPID FROM (t_SExp a WITH (NOLOCK) INNER JOIN t_SExpA t WITH (NOLOCK) ON a.ChID=t.ChID) INNER JOIN t_SExpD b WITH (NOLOCK) ON t.AChID = b.AChID
                             WHERE OurID=@AOurID AND SubStockID=@AStockID AND SubSecID=@ASecID AND SubProdID=@AProdID
                             GROUP BY SubPPID 
                             UNION  All
                             SELECT  '1/1/1990' AS TDocDate, PPID FROM t_zInP WITH (NOLOCK)
                             WHERE OurID=@AOurID AND StockID=@AStockID AND SecID=@ASecID AND ProdID=@AProdID
                             ORDER BY TDocDate ASC, PPID ASC
                              
    End
  Else
    Begin
      DECLARE ACursor CURSOR LOCAL FAST_FORWARD FOR
                             SELECT Max(DocDate) AS TDocDate, PPID FROM t_Rec m WITH (NOLOCK) INNER JOIN t_RecD d WITH (NOLOCK) ON d.ChID=m.ChID
                             WHERE OurID=@AOurID AND StockID=@AStockID AND SecID=@ASecID AND ProdID=@AProdID
                             GROUP BY PPID
                             UNION All
                             SELECT Max(DocDate) AS TDocDate, PPID FROM t_Cst m WITH (NOLOCK) INNER JOIN t_CstD d WITH (NOLOCK) ON d.ChID=m.ChID
                             WHERE OurID=@AOurID AND StockID=@AStockID AND SecID=@ASecID AND ProdID=@AProdID
                             GROUP BY PPID
                             UNION All
                             SELECT Max(DocDate) AS TDocDate, PPID FROM t_Ret m WITH (NOLOCK) INNER JOIN t_RetD d WITH (NOLOCK) ON d.ChID=m.ChID
                             WHERE OurID=@AOurID AND StockID=@AStockID AND SecID=@ASecID AND ProdID=@AProdID
                             GROUP BY PPID
                             UNION All
                             SELECT Max(DocDate) AS TDocDate, PPID FROM t_CRRet m WITH (NOLOCK) INNER JOIN t_CRRetD d WITH (NOLOCK) ON d.ChID=m.ChID
                             WHERE OurID=@AOurID AND StockID=@AStockID AND SecID=@ASecID AND ProdID=@AProdID
                             GROUP BY PPID
                             UNION All
                             SELECT Max(DocDate) AS TDocDate, PPID FROM t_Exc m WITH (NOLOCK) INNER JOIN t_ExcD d WITH (NOLOCK) ON d.ChID=m.ChID
                             WHERE OurID=@AOurID AND NewStockID=@AStockID AND NewSecID=@ASecID AND ProdID=@AProdID
                             GROUP BY PPID
                             UNION All
                             SELECT Max(DocDate) AS TDocDate, NewPPID AS PPID FROM t_Est m WITH (NOLOCK) INNER JOIN t_EstD d WITH (NOLOCK) ON d.ChID=m.ChID
                             WHERE OurID=@AOurID AND StockID=@AStockID AND SecID=@ASecID AND ProdID=@AProdID
                             GROUP BY NewPPID
                             UNION All
                             SELECT Max(DocDate) AS TDocDate, PPID FROM t_Ven m WITH (NOLOCK) INNER JOIN t_VenD d WITH (NOLOCK) ON d.ChID=m.ChID
                             WHERE OurID=@AOurID AND StockID=@AStockID AND SecID=@ASecID AND DetProdID=@AProdID
                             GROUP BY PPID
                             UNION All
                             SELECT Max(DocDate) AS TDocDate, PPID FROM t_SRec a WITH (NOLOCK) INNER JOIN t_SRecA b WITH (NOLOCK) ON a.ChID=b.ChID 
                             WHERE OurID=@AOurID AND StockID=@AStockID AND SecID=@ASecID AND ProdID=@AProdID
                             GROUP BY PPID
                             UNION All
                             SELECT Max(SubDocDate) As TDocDate, SubPPID AS PPID FROM (t_SExp a WITH (NOLOCK) INNER JOIN t_SExpA t WITH (NOLOCK) ON a.ChID=t.ChID) INNER JOIN t_SExpD b WITH (NOLOCK) ON t.AChID = b.AChID
                             WHERE OurID=@AOurID AND SubStockID=@AStockID AND SubSecID=@ASecID AND SubProdID=@AProdID
                             GROUP BY SubPPID 
                             UNION All
                             SELECT '1/1/1990' AS TDocDate, PPID FROM t_zInP WITH (NOLOCK)
                             WHERE OurID=@AOurID AND StockID=@AStockID AND SecID=@ASecID AND ProdID=@AProdID
                             ORDER BY TDocDate DESC, PPID DESC 
                              
    End

  OPEN ACursor
  If @@error <> 0 Goto Error1

  FETCH NEXT FROM ACursor INTO
  @ADocDate, @FPPID

  SELECT @PPID=ISNULL(@FPPID, 0)

  CLOSE ACursor
  DEALLOCATE ACursor
  Return 1
Error1:
  CLOSE ACursor
  DEALLOCATE ACursor
  Return 0      
End
GO