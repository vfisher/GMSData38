SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetIncludedTaxOur](@Sum numeric(19, 9), @OurID int, @DocDate smalldatetime)
GO