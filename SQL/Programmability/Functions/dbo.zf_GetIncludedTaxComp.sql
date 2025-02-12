SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetIncludedTaxComp](@Sum numeric(19, 9), @CompID int, @OurID int, @DocDate smalldatetime)/* Возвращает сумму внутреннего налога для указанной суммы и предприятия */RETURNS numeric(19, 9) ASBEGIN  RETURN CASE (SELECT Count(1) FROM r_Comps WHERE CompID = @CompID)    WHEN 1 THEN      dbo.zf_GetIncludedTax(@Sum, CASE (SELECT TaxPayer FROM r_Comps WHERE CompID = @CompID) WHEN 0 THEN 0 ELSE dbo.zf_GetTaxPercentByDate(0, @DocDate) * (SELECT TaxPayer FROM r_Ours WHERE OurID = @OurID) END)    ELSE      NULL    ENDEND
GO