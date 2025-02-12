SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetRetSumESV] (@OurID INT, @EmpID INT, @DocDate DATETIME, @Sum NUMERIC(21,9))
/* Возвращает сумму помощи по государственному социальному страхованию и государственному социальному обеспечению для начисления и удержания ЕСВ с учетом максимальной граничной величины */
RETURNS Numeric(21,9) AS
BEGIN
RETURN	ISNULL((SELECT
                 SUM(CASE
                       WHEN (d.DetAfterFiveSumCC + d.DetTillFiveSumCC) > @Sum THEN @Sum ELSE (d.DetAfterFiveSumCC + d.DetTillFiveSumCC)
                     END) SumCC
               FROM dbo.p_ESic m, p_ESicA d
               WHERE m.ChID = d.ChID AND m.OurID = @OurID AND m.EmpID = @EmpID AND m.DocDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate)),0)
END
GO