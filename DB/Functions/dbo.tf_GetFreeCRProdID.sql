SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetFreeCRProdID](@CRID int, @StockID int, @Capacity int, @GetLast bit = 0, @UseCRProdID bit = 0)
GO