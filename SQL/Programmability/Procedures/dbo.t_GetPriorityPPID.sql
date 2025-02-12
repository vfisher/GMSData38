SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[t_GetPriorityPPID] (@AOurID Int,  @AStockID Int,  @AProdID Int, @ASecID Int, 
                                    @APrID Int,  @AMoreFlt VarChar(200), 
                                    @appPriorPP Int, @AOutPPID Int OUTPUT) AS
Begin
  DECLARE @w1 NVarChar(200),  @w2 NVarChar(200), @w3 NVarChar(200), @WSE NVarChar(200), @s2 NVarChar(200), @s NVarChar(4000)
  DECLARE @ADate datetime, @APPID int
  DECLARE @Rem numeric(21,13), @DateRem numeric(21,13), @TotRem numeric(21,13), @Qty numeric(21,13)
  
  SET @w1= 'OurID=' + cast(@AOurID As VarChar(200)) + ' AND StockID=' +    cast(@AStockID As VarChar(200)) + ' AND SecID=' +    cast(@ASecID As VarChar(200)) + ' AND b.ProdID=' +  cast(@AProdID As VarChar(200)) + ' AND Priority=' + cast(@APrID As VarChar(200))
  SET @w2= 'OurID=' + cast(@AOurID As VarChar(200)) + ' AND NewStockID=' + cast(@AStockID As VarChar(200)) + ' AND NewSecID=' + cast(@ASecID As VarChar(200)) + ' AND b.ProdID=' +  cast(@AProdID As VarChar(200)) + ' AND Priority=' + cast(@APrID As VarChar(200))
  SET @w3= 'OurID=' + cast(@AOurID As VarChar(200)) + ' AND StockID=' +    cast(@AStockID As VarChar(200)) + ' AND SecID=' +    cast(@ASecID As VarChar(200)) + ' AND b.DetProdID=' +  cast(@AProdID As VarChar(200)) + ' AND Priority=' + cast(@APrID As VarChar(200))
  SET @wse='OurID=' + cast(@AOurID As VarChar(200)) + ' AND SubStockID=' + cast(@AStockID As VarChar(200)) + ' AND SubSecID=' + cast(@ASecID As VarChar(200)) + ' AND SubProdID=' + cast(@AProdID As VarChar(200)) + ' AND Priority=' + cast(@APrID As VarChar(200))
 
  If @AMoreFlt = '' SET @AMoreFlt = N' IS NOT NULL ' Else SET @AMoreFlt = N' NOT IN (' + @AMoreFlt + N')'

  SET @AOutPPID = 0
  If (@appPriorPP = 0) Or (@appPriorPP = 1)
    Begin
      If @appPriorPP = 0 SET @s2 = N'ASC' Else SET @s2 = N'DESC'
      SET @s=N'Declare appPriorPP CURSOR FAST_FORWARD FOR ' +  
              'SELECT DocDate, b.PPID FROM (t_Rec a INNER JOIN t_RecD b ON a.ChID=b.ChID) INNER JOIN t_PInP p ON (p.ProdID=b.ProdID AND p.PPID=b.PPID) ' + 
              'WHERE ' + @w1 + ' AND b.PPID ' + @AMoreFlt + ' ' + 
              'UNION All ' +
              'SELECT DocDate, b.PPID FROM (t_Cst a INNER JOIN t_CstD b ON a.ChID=b.ChID) INNER JOIN t_PInP p ON (p.ProdID=b.ProdID AND p.PPID=b.PPID) ' +
              'WHERE ' + @w1 + ' AND b.PPID ' + @AMoreFlt + ' ' +
              'UNION All ' +
              'SELECT DocDate, b.PPID FROM (t_Ret a INNER JOIN t_RetD b ON a.ChID=b.ChID) INNER JOIN t_PInP p ON (p.ProdID=b.ProdID AND p.PPID=b.PPID) ' +
              'WHERE ' + @w1 + ' AND b.PPID ' + @AMoreFlt + ' ' +
              'UNION All ' +
              'SELECT DocDate, b.PPID FROM (t_CRRet a INNER JOIN t_CRRetD b ON a.ChID=b.ChID) INNER JOIN t_PInP p ON (p.ProdID=b.ProdID AND p.PPID=b.PPID) ' +
              'WHERE ' + @w1 + ' AND b.PPID ' + @AMoreFlt + ' ' +
              'UNION All ' +
              'SELECT DocDate, b.PPID FROM (t_Exc a INNER JOIN t_ExcD b ON a.ChID=b.ChID) INNER JOIN t_PInP p ON (p.ProdID=b.ProdID AND p.PPID=b.PPID) ' +
              'WHERE ' + @w2 + ' AND b.PPID ' + @AMoreFlt + ' ' +
              'UNION All ' +
              'SELECT DocDate, b.NewPPID AS PPID FROM (t_Est a INNER JOIN t_EstD b ON a.ChID=b.ChID) INNER JOIN t_PInP p ON (p.ProdID=b.ProdID AND p.PPID=b.NewPPID) ' +
              'WHERE ' + @w1 + ' AND b.NewPPID ' + @AMoreFlt + ' ' +
              'UNION All ' +
              'SELECT DocDate, b.PPID FROM (t_Ven a INNER JOIN t_VenD b ON a.ChID=b.ChID) INNER JOIN t_PInP p ON (p.ProdID=b.DetProdID AND p.PPID=b.PPID) ' +
              'WHERE ' + @w3 + ' AND b.PPID ' + @AMoreFlt + ' ' +
              'UNION All ' +
              'SELECT DocDate, b.PPID FROM (t_SRec a INNER JOIN t_SRecA b ON a.ChID=b.ChID) INNER JOIN t_PInP p ON (p.ProdID=b.ProdID AND p.PPID=b.PPID) ' +
              'WHERE ' + @w1 + ' AND b.PPID ' + @AMoreFlt + ' ' +
              'UNION All ' +
              'SELECT SubDocDate AS DocDate, SubPPID AS PPID FROM ((t_SExp a INNER JOIN t_SExpA t ON a.ChID=t.ChID) INNER JOIN t_SExpD b ON t.AChID = b.AChID) INNER JOIN t_PInP p ON (p.ProdID=b.SubProdID AND p.PPID=b.SubPPID) ' +
              'WHERE ' + @wse + ' ANDSubPPID ' + @AMoreFlt + ' ' +
              'UNION All ' + 
              'SELECT ''1/1/1990'' AS DocDate, b.PPID FROM t_zInP b INNER JOIN t_PInP p ON (p.ProdID=b.ProdID AND p.PPID=b.PPID) WHERE ' + @w1 + ' AND b.PPID ' + @AMoreFlt + ' ' +
              'ORDER BY DocDate ' + @s2
      exec sp_executesql @s
      If @@error <> 0 Goto MyError
       
      OPEN appPriorPP
      If @@error <> 0 Goto MyError
      SELECT @Qty=0
 
      FETCH NEXT FROM appPriorPP
      INTO @ADate, @APPID

      WHILE @@FETCH_STATUS=0
        Begin
           SELECT @Rem=ISNULL(Sum(Qty), 0) FROM t_Rem WHERE OurID=@AOurID AND StockID=@AStockID AND SecID=@ASecID AND ProdID=@AProdID AND PPID=@APPID
           If @@error <> 0 Goto MyError 
           EXECUTE t_GetRet @AOurID, @AStockID, @ASecID, @APPID, @AProdID, @ADate, 1, @DateRem OUTPUT
           If @@error <> 0 Goto MyError 
           EXECUTE t_GetRet @AOurID, @AStockID, @ASecID, @APPID, @AProdID, @ADate, 0, @TotRem OUTPUT
           If @@error <> 0 Goto MyError
           SELECT @Qty=@DateRem-@TotRem+@Rem
           If @Qty > 0 Break
           FETCH NEXT FROM appPriorPP
           INTO @ADate, @APPID
        End

      SELECT @AOutPPID=ISNULL(@APPID, 0)
      CLOSE appPriorPP
      DEALLOCATE appPriorPP
      Return 0
    End


  If @appPriorPP = 2 /* Минимальная цена прихода*/
    Begin
      SET @s=N'Declare appPriorPP CURSOR FAST_FORWARD FOR ' + 
               'SELECT m.PPID FROM t_PInP m, t_Rem b WHERE b.Qty > 0 AND b.ProdID=m.ProdID AND b.PPID=m.PPID AND ' + @w1 + ' AND b.PPID ' + @AMoreFlt + ' ORDER BY m.PriceMC_In ASC'
    End

  If @appPriorPP = 3 /* Максимальная цена прихода*/
    Begin
      SET @s=N'Declare appPriorPP CURSOR FAST_FORWARD FOR ' + 
               'SELECT m.PPID FROM t_PInP m, t_Rem b WHERE b.Qty > 0 AND b.ProdID=m.ProdID AND b.PPID=m.PPID AND ' + @w1 + ' AND b.PPID ' + @AMoreFlt + ' ORDER BY m.PriceMC_In DESC'
    End

  If @appPriorPP = 8 /* Минимальный номер КЦ*/
    Begin
      SET @s=N'Declare appPriorPP CURSOR FAST_FORWARD FOR ' + 
               'SELECT Min(m.PPID) FROM t_PInP m, t_Rem b WHERE b.Qty > 0 AND b.ProdID=m.ProdID AND b.PPID=m.PPID AND ' + @w1 + ' AND b.PPID ' + @AMoreFlt
    End

  If @appPriorPP = 9 /* Минимальный номер КЦ*/
    Begin
      SET @s=N'Declare appPriorPP CURSOR FAST_FORWARD FOR ' + 
               'SELECT Max(m.PPID) FROM t_PInP m, t_Rem b WHERE b.Qty > 0 AND b.ProdID=m.ProdID AND b.PPID=m.PPID AND ' + @w1 + ' AND b.PPID ' + @AMoreFlt
    End

  exec sp_executesql @s  
  If @@error <> 0 Goto MyError
  OPEN appPriorPP
  If @@error <> 0 Goto MyError
  FETCH NEXT FROM appPriorPP INTO @AOutPPID
  CLOSE appPriorPP
  DEALLOCATE appPriorPP
  Return 0
MyError:
  Return 1
End
GO