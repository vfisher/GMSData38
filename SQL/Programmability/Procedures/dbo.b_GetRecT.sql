SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[b_GetRecT](@AOurID int, @AStockID int, @AProdID int, @APPID int, @ADate DateTime, @AUseDate int, @AResultQty numeric(21,13) OUTPUT) AS
Begin
  Declare @AQty numeric(21,13)

  If @AUseDate = 1 
    Declare appRecQuery CURSOR LOCAL FAST_FORWARD FOR
          SELECT Sum(Qty) AS TQty
          FROM b_Rec a WITH(NOLOCK) INNER JOIN b_RecD b WITH(NOLOCK) ON a.ChID=b.ChID 
          WHERE OurID=@AOurID AND StockID=@AStockID AND ProdID=@AProdID AND PPID=@APPID AND DocDate<=@ADate  
          UNION All
          SELECT Sum(Qty) AS TQty 
          FROM b_Ret a WITH(NOLOCK) INNER JOIN b_RetD b WITH(NOLOCK) ON a.ChID=b.ChID
          WHERE OurID=@AOurID AND StockID=@AStockID AND ProdID=@AProdID AND PPID=@APPID AND DocDate<=@ADate 
          UNION All
          SELECT Sum(Qty) AS TQty
          FROM b_PExc a WITH(NOLOCK) INNER JOIN b_PExcD b WITH(NOLOCK) ON a.ChID=b.ChID 
          WHERE OurID=@AOurID AND NewStockID=@AStockID AND ProdID=@AProdID AND PPID=@APPID AND DocDate<=@ADate 
          UNION All
          SELECT Sum(NewQty) AS TQty 
          FROM b_PVen a WITH(NOLOCK) INNER JOIN b_PVenD b WITH(NOLOCK) ON a.ChID=b.ChID 
          WHERE OurID=@AOurID AND StockID=@AStockID AND DetProdID=@AProdID AND PPID=@APPID AND DocDate<=@ADate  
          UNION All
          SELECT Sum(Qty) AS TQty 
          FROM b_PEst a WITH(NOLOCK) INNER JOIN b_PEstD b WITH(NOLOCK) ON a.ChID=b.ChID 
          WHERE OurID=@AOurID AND StockID=@AStockID AND ProdID=@AProdID AND NewPPID=@APPID AND DocDate<=@ADate  
          UNION All
          SELECT Sum(Qty) AS TQty 
          FROM b_Cst a WITH(NOLOCK) INNER JOIN b_CstD b WITH(NOLOCK) ON a.ChID=b.ChID
          WHERE  OurID=@AOurID AND StockID=@AStockID AND ProdID=@AProdID AND PPID=@APPID AND DocDate<=@ADate  
          UNION All
          SELECT Sum(Qty) AS TQty 
          FROM b_RepA a WITH(NOLOCK) INNER JOIN b_RepADP b WITH(NOLOCK) ON a.ChID=b.ChID
          WHERE  OurID=@AOurID AND StockID=@AStockID AND ProdID=@AProdID AND PPID=@APPID AND DocDate<=@ADate  
          UNION All
          SELECT Sum(Qty) AS TQty 
          FROM b_CRepA a WITH(NOLOCK) INNER JOIN b_CRepADP b WITH(NOLOCK) ON a.ChID=b.ChID
          WHERE  OurID=@AOurID AND StockID=@AStockID AND ProdID=@AProdID AND PPID=@APPID AND DocDate<=@ADate  
          UNION All
          SELECT Sum(Qty) AS TQty 
          FROM b_ARepA a WITH(NOLOCK) INNER JOIN b_ARepADP b WITH(NOLOCK) ON a.ChID=b.ChID
          WHERE  OurID=@AOurID AND StockID=@AStockID AND ProdID=@AProdID AND PPID=@APPID AND DocDate<=@ADate  
          UNION All
          SELECT Sum(Qty) AS TQty 
          FROM b_zInP WITH(NOLOCK)
          WHERE OurID=@AOurID AND StockID=@AStockID AND ProdID=@AProdID AND PPID=@APPID
  Else
    Declare appRecQuery CURSOR LOCAL FAST_FORWARD FOR
          SELECT Sum(Qty) AS TQty
          FROM b_Rec a WITH(NOLOCK) INNER JOIN b_RecD b WITH(NOLOCK) ON a.ChID=b.ChID 
          WHERE OurID=@AOurID AND StockID=@AStockID AND ProdID=@AProdID AND PPID=@APPID 
          UNION All
          SELECT Sum(Qty) AS TQty 
          FROM b_Ret a WITH(NOLOCK) INNER JOIN b_RetD b WITH(NOLOCK) ON a.ChID=b.ChID
          WHERE OurID=@AOurID AND StockID=@AStockID AND ProdID=@AProdID AND PPID=@APPID 
          UNION All
          SELECT Sum(Qty) AS TQty
          FROM b_PExc a WITH(NOLOCK) INNER JOIN b_PExcD b WITH(NOLOCK) ON a.ChID=b.ChID 
          WHERE OurID=@AOurID AND NewStockID=@AStockID AND ProdID=@AProdID AND PPID=@APPID 
          UNION All
          SELECT Sum(NewQty) AS TQty 
          FROM b_PVen a WITH(NOLOCK) INNER JOIN b_PVenD b WITH(NOLOCK) ON a.ChID=b.ChID 
          WHERE OurID=@AOurID AND StockID=@AStockID AND DetProdID=@AProdID AND PPID=@APPID 
          UNION All
          SELECT Sum(Qty) AS TQty 
          FROM b_PEst a WITH(NOLOCK) INNER JOIN b_PEstD b WITH(NOLOCK) ON a.ChID=b.ChID 
          WHERE OurID=@AOurID AND StockID=@AStockID AND ProdID=@AProdID AND NewPPID=@APPID 
          UNION All
          SELECT Sum(Qty) AS TQty 
          FROM b_Cst a WITH(NOLOCK) INNER JOIN b_CstD b WITH(NOLOCK) ON a.ChID=b.ChID
          WHERE  OurID=@AOurID AND StockID=@AStockID AND ProdID=@AProdID AND PPID=@APPID 
          UNION All
          SELECT Sum(Qty) AS TQty 
          FROM b_RepA a WITH(NOLOCK) INNER JOIN b_RepADP b WITH(NOLOCK) ON a.ChID=b.ChID
          WHERE  OurID=@AOurID AND StockID=@AStockID AND ProdID=@AProdID AND PPID=@APPID 
          UNION All
          SELECT Sum(Qty) AS TQty 
          FROM b_CRepA a WITH(NOLOCK) INNER JOIN b_CRepADP b WITH(NOLOCK) ON a.ChID=b.ChID
          WHERE  OurID=@AOurID AND StockID=@AStockID AND ProdID=@AProdID AND PPID=@APPID 
          UNION All
          SELECT Sum(Qty) AS TQty 
          FROM b_ARepA a WITH(NOLOCK) INNER JOIN b_ARepADP b WITH(NOLOCK) ON a.ChID=b.ChID
          WHERE  OurID=@AOurID AND StockID=@AStockID AND ProdID=@AProdID AND PPID=@APPID 
          UNION All
          SELECT Sum(Qty) AS TQty 
          FROM b_zInP WITH(NOLOCK)
          WHERE OurID=@AOurID AND StockID=@AStockID AND ProdID=@AProdID AND PPID=@APPID

 OPEN appRecQuery
 If @@error <> 0 GoTo MyError
 
 SELECT @AResultQty=0
 FETCH NEXT FROM appRecQuery INTO @AQty


 WHILE @@FETCH_STATUS = 0
   Begin
     SELECT @AResultQty=@AResultQty+ISNULL(@AQty, 0)
     FETCH NEXT FROM appRecQuery INTO @AQty
   End


 CLOSE appRecQuery
 DEALLOCATE appRecQuery

 Return 1

MyError:
  CLOSE appRecQuery
  DEALLOCATE appRecQuery
End
GO