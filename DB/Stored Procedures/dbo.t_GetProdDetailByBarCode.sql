SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetProdDetailByBarCode](@BarCode varchar(42), @BarQty numeric(21, 9), @ProdID int OUTPUT, @Qty numeric(21, 9) OUTPUT, @PLID int OUTPUT)
GO