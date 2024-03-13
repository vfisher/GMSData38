SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_FillProdInfo] (@BarCode varchar(42), 
         @app_RateMC numeric(21, 9),
         @ProdID int OUTPUT,
         @ProdName varchar(255) OUTPUT,
         @ProdNotes varchar(255) OUTPUT,
         @UM varchar(50) OUTPUT,
         @Price numeric(21, 9) OUTPUT,
         @RealQty numeric(21, 9) OUTPUT,
         @TaxPrecent numeric(21, 9) OUTPUT,
         @PLID int OUTPUT,
         @PWTax bit OUTPUT, 
         @Result int OUTPUT) AS
BEGIN
  DECLARE appCursor CURSOR LOCAL FAST_FORWARD FOR
  SELECT p.ProdID, p.ProdName, p.Notes, p.UM, dbo.zf_GetProdTaxPercent(p.ProdID, dbo.zf_GetDate(GetDate())), m.Qty, r.PriceCC, m.PLID, p.PriceWithTax
  FROM r_Prods p, r_ProdMQ m, r_ProdMPs r
  WHERE m.ProdID = p.ProdID AND (r.ProdID = m.ProdID AND r.PLID = m.PLID) AND m.BarCode = @BarCode

  OPEN appCursor

  FETCH NEXT FROM appCursor INTO
  @ProdID, @ProdName, @ProdNotes, @UM, @TaxPrecent, @RealQty, @Price, @PLID, @PWTax

  If (@PWTax = 0)And(@TaxPrecent <> 0) SELECT @Price = Round(@Price + @Price * (@TaxPrecent / 100), 2)

  If  @@FETCH_STATUS <> 0 SELECT @Result = 0
  ELSE SELECT @Result = 1

  CLOSE appCursor
  DEALLOCATE appCursor
END
GO
