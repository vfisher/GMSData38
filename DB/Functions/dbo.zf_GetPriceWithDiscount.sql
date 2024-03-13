SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetPriceWithDiscount](@Price numeric(19, 9), @Discount numeric(19, 9))/* Возвращает сумму с учетом указанного процента скидки */RETURNS numeric(19, 9) ASBegin  RETURN dbo.zf_RoundPriceSale(dbo.zf_GetPriceWithDiscountNoRound(@Price, @Discount))End 
GO
