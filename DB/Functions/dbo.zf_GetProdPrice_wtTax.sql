SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetProdPrice_wtTax](@Price numeric(19, 9), @ProdID int, @DocDate smalldatetime)
GO