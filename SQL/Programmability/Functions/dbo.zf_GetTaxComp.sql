SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetTaxComp](@Sum numeric(19, 9), @CompID int, @OurID int, @Date smalldatetime)/* Возвращает сумму внешнего налога для указанной суммы и предприятия */RETURNS numeric(19, 9) ASBegin  RETURN CASE (SELECT Count(1) FROM r_Comps WHERE CompID = @CompID)    WHEN 1 THEN      dbo.zf_GetTax(@Sum, CASE (SELECT TaxPayer FROM r_Comps WHERE CompID = @CompID) WHEN 0 THEN 0 ELSE (dbo.zf_GetTaxPercentByDate(0, @Date) * (SELECT TaxPayer FROM r_Ours WHERE OurID = @OurID)) END)    ELSE      NULL    ENDEND
GO