SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetProdLevies](@ProdID int, @Date smalldatetime)
/* Возвращает список сборов по товару на дату */
RETURNS @out table(LevyID int, LevyPercent numeric(21,9))
BEGIN
  INSERT INTO @out(LevyID, LevyPercent) 
  SELECT m.LevyID, m.LevyPercent FROM r_LevyRates m
    JOIN (
          SELECT LevyID, MAX(ChDate) ChDate FROM r_LevyRates
          WHERE LevyID > 0 AND ChDate <= @Date
          GROUP BY LevyID) b ON m.LevyID = b.LevyID AND m.ChDate = b.ChDate
    JOIN r_Levies c ON m.LevyID = c.LevyID
    JOIN r_ProdLV p ON m.LevyID = p.LevyID AND p.ProdID = @ProdID
  RETURN
END
GO