SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetPriceWithDiscountNoRound](@Price numeric(19, 9), @Discount numeric(19, 9))
GO