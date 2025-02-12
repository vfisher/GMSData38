SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[t_GetRet](@appOurID int,@appStockID int,@appSecID int,@APPID int,@ProdID int,@ABlockDate DateTime,
                          @FirstLink int,@Result numeric(21,13) OUTPUT) AS
Begin
  Declare @AQty numeric(21,13)
  Declare @Date VarChar(255)
  SELECT @Date=CONVERT(varchar, @ABlockDate, 101)
If @FirstLink = 1 
  Begin
    Declare appRecCursor CURSOR FOR
    SELECT Sum(Qty) AS TQty
    FROM t_Rec a INNER JOIN t_RecD b ON a.ChID=b.ChID
    WHERE OurID=@appOurID AND StockID=@appStockID AND SecID=@appSecID AND ProdID=@ProdID AND PPID=@APPID AND DocDate<=@Date
    UNION All
    SELECT Sum(Qty) AS TQty
    FROM t_Cst a INNER JOIN t_CstD b ON a.ChID=b.ChID
    WHERE OurID=@appOurID AND StockID=@appStockID AND SecID=@appSecID AND ProdID=@ProdID AND PPID=@APPID AND DocDate<=@Date
    UNION All
    SELECT Sum(Qty) AS TQty
    FROM t_Ret a INNER JOIN t_RetD b ON a.ChID=b.ChID
    WHERE OurID=@appOurID AND StockID=@appStockID AND SecID=@appSecID AND ProdID=@ProdID AND PPID=@APPID AND DocDate<=@Date
    UNION All
    SELECT Sum(Qty) AS TQty
    FROM t_CRRet a INNER JOIN t_CRRetD b ON a.ChID=b.ChID
    WHERE OurID=@appOurID AND StockID=@appStockID AND SecID=@appSecID AND ProdID=@ProdID AND PPID=@APPID AND DocDate<=@Date
    UNION All
    SELECT Sum(Qty) AS TQty
    FROM t_Exc a INNER JOIN t_ExcD b ON a.ChID=b.ChID
    WHERE  OurID=@appOurID AND NewStockID=@appStockID AND NewSecID=@appSecID AND ProdID=@ProdID AND PPID=@APPID AND DocDate<=@Date
    UNION All
    SELECT Sum(Qty) AS TQty
    FROM t_Est a INNER JOIN t_EstD b ON a.ChID=b.ChID
    WHERE  OurID=@appOurID AND StockID=@appStockID AND SecID=@appSecID AND ProdID=@ProdID AND NewPPID=@APPID AND DocDate<=@Date
    UNION All
    SELECT Sum(NewQty) AS TQty
    FROM t_Ven a INNER JOIN t_VenD b ON a.ChID=b.ChID
    WHERE  OurID=@appOurID AND StockID=@appStockID AND SecID=@appSecID AND DetProdID=@ProdID AND PPID=@APPID AND DocDate<=@Date
    UNION All
    SELECT Sum(Qty) AS TQty
    FROM t_SRec a INNER JOIN t_SRecA b ON a.ChID=b.ChID 
    WHERE OurID=@appOurID AND StockID=@appStockID AND SecID=@appSecID AND ProdID=@ProdID AND PPID=@APPID AND DocDate<=@Date
    UNION All
    SELECT Sum(SubQty) AS TQty
    FROM (t_SExp a INNER JOIN t_SExpA t ON a.ChID=t.ChID) INNER JOIN t_SExpD b ON t.AChID=b.AChID 
    WHERE OurID=@appOurID AND SubStockID=@appStockID AND SubSecID=@appSecID AND SubProdID=@ProdID AND SubPPID=@APPID AND SubDocDate<=@Date
    UNION All
    SELECT Sum(Qty) AS TQty
    FROM t_zInP
    WHERE  OurID=@appOurID AND StockID=@appStockID AND SecID=@appSecID AND ProdID=@ProdID AND PPID=@APPID
  End
Else
  Begin
    Declare appRecCursor CURSOR FOR
    SELECT Sum(Qty) AS TQty
    FROM t_Rec a INNER JOIN t_RecD b ON a.ChID=b.ChID
    WHERE OurID=@appOurID AND StockID=@appStockID AND SecID=@appSecID AND ProdID=@ProdID AND PPID=@APPID
    UNION All
    SELECT Sum(Qty) AS TQty
    FROM t_Cst a INNER JOIN t_CstD b ON a.ChID=b.ChID
    WHERE OurID=@appOurID AND StockID=@appStockID AND SecID=@appSecID AND ProdID=@ProdID AND PPID=@APPID
    UNION All
    SELECT Sum(Qty) AS TQty
    FROM t_Ret a INNER JOIN t_RetD b ON a.ChID=b.ChID
    WHERE OurID=@appOurID AND StockID=@appStockID AND SecID=@appSecID AND ProdID=@ProdID AND PPID=@APPID
    UNION All
    SELECT Sum(Qty) AS TQty
    FROM t_CRRet a INNER JOIN t_CRRetD b ON a.ChID=b.ChID
    WHERE OurID=@appOurID AND StockID=@appStockID AND SecID=@appSecID AND ProdID=@ProdID AND PPID=@APPID
    UNION All
    SELECT Sum(Qty) AS TQty
    FROM t_Exc a INNER JOIN t_ExcD b ON a.ChID=b.ChID
    WHERE  OurID=@appOurID AND NewStockID=@appStockID AND NewSecID=@appSecID AND ProdID=@ProdID AND PPID=@APPID
    UNION All
    SELECT Sum(Qty) AS TQty
    FROM t_Est a INNER JOIN t_EstD b ON a.ChID=b.ChID
    WHERE  OurID=@appOurID AND StockID=@appStockID AND SecID=@appSecID AND ProdID=@ProdID AND NewPPID=@APPID
    UNION All
    SELECT Sum(NewQty) AS TQty
    FROM t_Ven a INNER JOIN t_VenD b ON a.ChID=b.ChID
    WHERE  OurID=@appOurID AND StockID=@appStockID AND SecID=@appSecID AND DetProdID=@ProdID AND PPID=@APPID
    UNION All
    SELECT Sum(Qty) AS TQty
    FROM t_SRec a INNER JOIN t_SRecA b ON a.ChID=b.ChID 
    WHERE OurID=@appOurID AND StockID=@appStockID AND SecID=@appSecID AND ProdID=@ProdID AND PPID=@APPID
    UNION All
    SELECT Sum(SubQty) AS TQty
    FROM (t_SExp a INNER JOIN t_SExpA t ON a.ChID=t.ChID) INNER JOIN t_SExpD b ON t.AChID=b.AChID
    WHERE OurID=@appOurID AND SubStockID=@appStockID AND SubSecID=@appSecID AND SubProdID=@ProdID AND SubPPID=@APPID
    UNION All
    SELECT Sum(Qty) AS TQty
    FROM t_zInP
    WHERE  OurID=@appOurID AND StockID=@appStockID AND SecID=@appSecID AND ProdID=@ProdID AND PPID=@APPID
 End
/* Начало подсчета*/

 SELECT @Result=0

 OPEN appRecCursor
 If @@error <> 0 GoTo MyError
 
 FETCH NEXT FROM appRecCursor INTO @AQty

 WHILE @@FETCH_STATUS = 0
   Begin
     SELECT @Result=@Result+ISNULL(@AQty, 0)
     FETCH NEXT FROM appRecCursor INTO @AQty
     If @@error <> 0 GoTo MyError
   End

 CLOSE appRecCursor
 DEALLOCATE appRecCursor

 Return 1
MyError:
  CLOSE appRecCursor
  DEALLOCATE appRecCursor
  Return 0
End
GO