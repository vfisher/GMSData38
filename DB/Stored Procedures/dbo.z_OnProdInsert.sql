SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_OnProdInsert](@ProdID int, @UM varchar(50), @PLID int, @AppPrefix varchar(1), @BarCode varchar(42), @ProdBarCode varchar(42), @Msg varchar(200) OUTPUT)
AS
/* Действия при добавлении товара */
BEGIN
  INSERT INTO r_ProdMQ (ProdID, UM, Qty, PLID, BarCode, ProdBarCode) VALUES (@ProdID, @UM, 1, 0, CASE WHEN @BarCode IS NULL THEN CONVERT(varchar(10), @ProdID) + '_' + @UM ELSE @BarCode END, @ProdBarCode)
  IF (SELECT dbo.zf_Var('t_ZeroPricesOnNewProd')) = 0 
    INSERT INTO r_ProdMP (ProdID, PLID, PriceMC, CurrID) VALUES (@ProdID, @PLID, 0, dbo.zf_GetCurrPL(@AppPrefix))
  ELSE
    INSERT INTO r_ProdMP (ProdID, PLID, PriceMC, CurrID) SELECT @ProdID, PLID, 0, dbo.zf_GetCurrPL(@AppPrefix) FROM r_PLs  
  INSERT INTO t_PInP (ProdID, ProdDate, PPID, PriceMC_In, PriceMC, Priority, CurrID, CompID, PPDesc, Article) VALUES (@ProdID, dbo.zf_GetDate(GetDate()), 0, 0, 0, 0, dbo.zf_GetCurrPP('t'), 0, '', '')
  INSERT INTO b_PInP (ProdID, ProdDate, PPID, PriceMC, Priority, CompID, PPDesc, Article) VALUES (@ProdID, dbo.zf_GetDate(GetDate()), 0, 0, 0, 0, '', '')  

END
GO
