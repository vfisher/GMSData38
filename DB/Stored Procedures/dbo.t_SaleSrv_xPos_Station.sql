SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSrv_xPos_Station](@CRID int)/* xPOS: Выгружает список рабочиx станций */ASBEGIN  DECLARE @AStockGID int  SELECT @AStockGID = StockGID FROM r_Stocks s, r_CRs c WHERE s.StockID = c.StockID AND c.CRID = @CRID  SELECT CRName AS NAME FROM r_CRs r, r_Stocks s WHERE r.StockID = s.StockID AND s.StockGID = @AStockGID AND r.CRID > 0END
GO
