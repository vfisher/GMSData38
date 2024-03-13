SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[b_GetPriorityPPID] (@AOurID Int,  @AStockID Int,  @AProdID Int,
                                    @APrID Int,  @AMoreFlt VarChar(200), 
                                    @appPriorPP Int, @AOutPPID Int OUTPUT) AS
Begin
  DECLARE @w1 NVarChar(200),  @w2 NVarChar(200), @w3 NVarChar(200), @s2 NVarChar(200), @s NVarChar(4000)
  DECLARE @ADate datetime, @APPID int
  DECLARE @Rem numeric(21,13), @DateRem numeric(21,13), @TotRem numeric(21,13), @Qty numeric(21,13)

  SET @w1= 'OurID=' + cast(@AOurID As VarChar(200)) + ' AND StockID=' +    cast(@AStockID As VarChar(200)) + ' AND b.ProdID=' +  cast(@AProdID As VarChar(200)) + ' AND Priority=' + cast(@APrID As VarChar(200)) + @AMoreFlt
  SET @w2= 'OurID=' + cast(@AOurID As VarChar(200)) + ' AND NewStockID=' + cast(@AStockID As VarChar(200)) + ' AND b.ProdID=' +  cast(@AProdID As VarChar(200)) + ' AND Priority=' + cast(@APrID As VarChar(200)) + @AMoreFlt
  SET @w3= 'OurID=' + cast(@AOurID As VarChar(200)) + ' AND StockID=' +    cast(@AStockID As VarChar(200)) + ' AND b.DetProdID=' +  cast(@AProdID As VarChar(200)) + ' AND Priority=' + cast(@APrID As VarChar(200)) + @AMoreFlt

  SET @AOutPPID = 0
  If (@appPriorPP = 0) Or (@appPriorPP = 1)
    Begin
      If @appPriorPP = 0 SET @s2 = N'ASC' Else SET @s2 = N'DESC'
      SET @s=N'Declare appPPQuery CURSOR FAST_FORWARD FOR ' +  
              'SELECT DocDate, b.PPID FROM (b_Rec a INNER JOIN b_RecD b ON a.ChID=b.ChID) INNER JOIN b_PInP p ON (p.ProdID=b.ProdID AND p.PPID=b.PPID) ' + 
              'WHERE ' + @w1 + ' ' +
              'UNION All ' +
              'SELECT DocDate, b.PPID FROM (b_Cst a INNER JOIN b_CstD b ON a.ChID=b.ChID) INNER JOIN b_PInP p ON (p.ProdID=b.ProdID AND p.PPID=b.PPID) ' +
              'WHERE ' + @w1 + ' ' +
              'UNION All ' +
              'SELECT DocDate, b.PPID FROM (b_Ret a INNER JOIN b_RetD b ON a.ChID=b.ChID) INNER JOIN b_PInP p ON (p.ProdID=b.ProdID AND p.PPID=b.PPID) ' +
              'WHERE ' + @w1 + ' ' +
              'UNION All ' +
              'SELECT DocDate, b.PPID FROM (b_PExc a INNER JOIN b_PExcD b ON a.ChID=b.ChID) INNER JOIN b_PInP p ON (p.ProdID=b.ProdID AND p.PPID=b.PPID) ' +
              'WHERE ' + @w2 + ' ' +
              'UNION All ' +
              'SELECT DocDate, b.NewPPID AS PPID FROM (b_PEst a INNER JOIN b_PEstD b ON a.ChID=b.ChID) INNER JOIN b_PInP p ON (p.ProdID=b.ProdID AND p.PPID=b.NewPPID) ' +
              'WHERE ' + @w1 + ' ' +
              'UNION All ' +
              'SELECT DocDate, b.PPID FROM (b_PVen a INNER JOIN b_PVenD b ON a.ChID=b.ChID) INNER JOIN b_PInP p ON (p.ProdID=b.DetProdID AND p.PPID=b.PPID) ' +
              'WHERE ' + @w3 + ' ' +
              'UNION All ' +
              'SELECT DocDate, b.PPID FROM (b_RepA a INNER JOIN b_RepADP b ON a.ChID=b.ChID) INNER JOIN b_PInP p ON (p.ProdID=b.ProdID AND p.PPID=b.PPID) ' +
              'WHERE ' + @w1 + ' ' +
              'UNION All ' +
              'SELECT DocDate, b.PPID FROM (b_CRepA a INNER JOIN b_CRepADP b ON a.ChID=b.ChID) INNER JOIN b_PInP p ON (p.ProdID=b.ProdID AND p.PPID=b.PPID) ' +
              'WHERE ' + @w1 + ' ' +
              'UNION All ' +
              'SELECT DocDate, b.PPID FROM (b_ARepA a INNER JOIN b_ARepADP b ON a.ChID=b.ChID) INNER JOIN b_PInP p ON (p.ProdID=b.ProdID AND p.PPID=b.PPID) ' +
              'WHERE ' + @w1 + ' ' +
              'UNION All ' + 
              'SELECT ''1/1/1990'' AS DocDate, b.PPID FROM t_zInP b INNER JOIN t_PInP p ON (p.ProdID=b.ProdID AND p.PPID=b.PPID) WHERE ' + @w1 + ' ' + 
              'ORDER BY DocDate ' + @s2
      exec sp_executesql @s
      If @@error <> 0 Goto MyError
       
      OPEN appPPQuery
      If @@error <> 0 Goto MyError
      SELECT @Qty=0
 
      FETCH NEXT FROM appPPQuery
      INTO @ADate, @APPID

      WHILE @@FETCH_STATUS=0
        Begin
           SELECT @Rem=ISNULL(Sum(Qty), 0) FROM b_Rem WHERE OurID=@AOurID AND StockID=@AStockID AND ProdID=@AProdID AND PPID=@APPID
           If @@error <> 0 Goto MyError 
           EXECUTE b_GetRecT @AOurID, @AStockID, @AProdID, @APPID, @ADate, 1, @DateRem OUTPUT
           If @@error <> 0 Goto MyError 
           EXECUTE b_GetRecT @AOurID, @AStockID, @AProdID, @APPID, @ADate, 0, @TotRem OUTPUT
           If @@error <> 0 Goto MyError
           SELECT @Qty=@DateRem-@TotRem+@Rem
           If @Qty > 0 Break
           FETCH NEXT FROM appPPQuery
           INTO @ADate, @APPID
        End

      SELECT @AOutPPID=ISNULL(@APPID, 0)
      CLOSE appPPQuery
      DEALLOCATE appPPQuery
      Return 0
    End


  If @appPriorPP = 2 /* Минимальная цена прихода*/
    Begin
      SET @s=N'Declare appPPQuery CURSOR FAST_FORWARD FOR ' + 
               'SELECT m.PPID FROM b_PInP m, b_Rem b WHERE b.Qty > 0 AND b.ProdID=m.ProdID AND b.PPID=m.PPID AND ' + @w1 + ' ORDER BY m.PriceCC_In ASC'
    End

  If @appPriorPP = 3 /* Максимальная цена прихода*/
    Begin
      SET @s=N'Declare appPPQuery CURSOR FAST_FORWARD FOR ' + 
               'SELECT m.PPID FROM b_PInP m, b_Rem b WHERE b.Qty > 0 AND b.ProdID=m.ProdID AND b.PPID=m.PPID AND ' + @w1 + ' ORDER BY m.PriceCC_In DESC'
    End

  If @appPriorPP = 8 /* Минимальный номер КЦ*/
    Begin
      SET @s=N'Declare appPPQuery CURSOR FAST_FORWARD FOR ' + 
               'SELECT Min(m.PPID) FROM b_PInP m, b_Rem b WHERE b.Qty > 0 AND b.ProdID=m.ProdID AND b.PPID=m.PPID AND ' + @w1
    End

  If @appPriorPP = 9 /* Минимальный номер КЦ*/
    Begin
      SET @s=N'Declare appPPQuery CURSOR FAST_FORWARD FOR ' + 
               'SELECT Max(m.PPID) FROM b_PInP m, b_Rem b WHERE b.Qty > 0 AND b.ProdID=m.ProdID AND b.PPID=m.PPID AND ' + @w1
    End
			 						
  exec sp_executesql @s
  If @@error <> 0 Goto MyError
  OPEN appPPQuery
  If @@error <> 0 Goto MyError
  FETCH NEXT FROM appPPQuery INTO @AOutPPID
  CLOSE appPPQuery
  DEALLOCATE appPPQuery
  Return 0
MyError:
  Return 1
End
GO
