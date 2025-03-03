﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_InStopList](@DocID bigint, @ProdID int)
RETURNS bit AS
BEGIN
  RETURN (CASE WHEN @DocID IN (11002, 11321, 11322, 11211, 11221, 11017) AND ((SELECT InStopList FROM r_Prods WHERE ProdID = @ProdID) = 1) THEN 1 ELSE 0 END)  
END
GO