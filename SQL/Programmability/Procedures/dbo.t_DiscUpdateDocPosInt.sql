SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_DiscUpdateDocPosInt](@DocCode int, @ChID bigint, @SrcPosID int, @PriceCC_wt numeric(21, 9), @SumCC_wt numeric(21, 9))
/* Изменения цен и сумм в указанном документе */
AS
GO