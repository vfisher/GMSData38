SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetTaxComp](@Sum numeric(19, 9), @CompID int, @OurID int, @Date smalldatetime)
GO