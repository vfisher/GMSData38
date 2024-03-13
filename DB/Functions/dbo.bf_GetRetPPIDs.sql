SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[bf_GetRetPPIDs](@OurID int, @CompID int, @ProdID int, @SrcDocDate smalldatetime, @SrcDocID bigint)
/* Возвращает партию и максимальное количество возврата (Бухгалтерия) */
RETURNS @out table(DocDate datetime, PPID int, Qty numeric(21,9))
Begin
  DECLARE @RetMode int
  DECLARE @RetBDate smalldatetime
  DECLARE @RetEDate smalldatetime
  SELECT @RetMode = dbo.zf_Var('b_RetMode')
  IF @RetMode = 1     /* Партия последеней продажи */  
    BEGIN
      SELECT @RetBDate = dbo.zf_Var('b_RetBDate')
      SELECT @RetEDate = dbo.zf_Var('b_RetEDate')
      INSERT INTO @out(DocDate, PPID, Qty)
      SELECT m.DocDate, d.PPID, Sum(d.Qty) AS TQty FROM b_CInv m, b_CInvD d 
      WHERE m.ChID=d.ChID AND m.OurID = @OurID AND m.CompID = @CompID AND d.ProdID = @ProdID 
      AND (@SrcDocDate IS NULL AND m.DocDate BETWEEN @RetBDate AND @RetEDate OR @SrcDocDate IS NOT NULL AND m.DocDate = @SrcDocDate)
      AND (@SrcDocID IS NULL OR m.DocID = @SrcDocID)
      GROUP BY m.DocDate, d.PPID      
      UNION ALL
      SELECT m.DocDate, d.PPID, Sum(d.Qty) AS TQty FROM b_Inv m, b_InvD d 
      WHERE m.ChID=d.ChID AND m.OurID = @OurID AND m.CompID = @CompID AND d.ProdID = @ProdID 
      AND (@SrcDocDate IS NULL AND m.DocDate BETWEEN @RetBDate AND @RetEDate OR @SrcDocDate IS NOT NULL AND m.DocDate = @SrcDocDate)
      AND (@SrcDocID IS NULL OR m.DocID = @SrcDocID)
      GROUP BY m.DocDate, d.PPID      
      ORDER BY DocDate DESC, PPID DESC
    END
  ELSE IF @RetMode = 2    /* Партия последнего прихода */
    BEGIN
      INSERT INTO @out(DocDate, PPID, Qty)
      SELECT m.DocDate, d.PPID, 0 AS TQty FROM b_Rec m, b_RecD d WHERE m.ChID=d.ChID AND m.OurID = @OurID AND d.ProdID = @ProdID
      UNION ALL
      SELECT m.DocDate, d.PPID, 0 AS TQty FROM b_Cst m, b_CstD d WHERE m.ChID=d.ChID AND m.OurID = @OurID AND d.ProdID = @ProdID
      ORDER BY DocDate DESC, PPID DESC       
    END
  ELSE IF @RetMode = 3    /* Партия с минимальной ценой прихода */
    BEGIN
      SELECT @RetBDate = dbo.zf_Var('b_RetBDate')
      SELECT @RetEDate = dbo.zf_Var('b_RetEDate')
      INSERT INTO @out(DocDate, PPID, Qty)
      SELECT ProdDate, PPID, 0 AS TQty FROM b_PInP WHERE ProdID = @ProdID AND PriceCC_In <> 0 AND ProdDate BETWEEN @RetBDate AND @RetEDate
      ORDER BY PriceCC_In ASC
    END
  ELSE IF @RetMode = 4    /* Партия с максимальной ценой прихода */
    BEGIN
      SELECT @RetBDate = dbo.zf_Var('b_RetBDate')
      SELECT @RetEDate = dbo.zf_Var('b_RetEDate')
      INSERT INTO @out(DocDate, PPID, Qty)
      SELECT ProdDate, PPID, 0 AS TQty FROM b_PInP WHERE ProdID = @ProdID AND PriceCC_In <> 0 AND ProdDate BETWEEN @RetBDate AND @RetEDate
      ORDER BY PriceCC_In DESC
    END
  ELSE
    BEGIN
      INSERT INTO @out(DocDate, PPID, Qty)
      VALUES('1900-01-01', 0, 0)
    END
  RETURN    
End
GO
