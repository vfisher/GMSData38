SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetProdRecTax](@ProdID int, @CompID int, @OurID int, @DocDate smalldatetime)
GO