SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetIncludedTaxOur](@Sum numeric(19, 9), @OurID int, @DocDate smalldatetime)/* Возвращает сумму внутреннего налога для указанной суммы и внутренней фирмы */RETURNS numeric(19, 9) ASBEGIN  RETURN CASE (SELECT COUNT(1) FROM r_Ours WHERE OurID = @OurID)    WHEN 1 THEN      dbo.zf_GetIncludedTax(@Sum, CASE (SELECT TaxPayer FROM r_Ours WHERE OurID = @OurID) WHEN 0 THEN 0 ELSE dbo.zf_GetTaxPercentByDate(0, @DocDate) END)    ELSE      NULL    ENDEND
GO