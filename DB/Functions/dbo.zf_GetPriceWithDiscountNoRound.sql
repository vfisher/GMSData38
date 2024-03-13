SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetPriceWithDiscountNoRound](@Price numeric(19, 9), @Discount numeric(19, 9))/* Возвращает сумму с учетом указанного процента скидки (без округления) */RETURNS numeric(19, 9) ASBegin  RETURN ISNULL(@Price * (1 - @Discount / 100), 0)End 
GO
