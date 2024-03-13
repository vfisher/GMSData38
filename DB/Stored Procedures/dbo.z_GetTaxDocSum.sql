SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_GetTaxDocSum](@DocCode int, @ChID bigint, @OurID int, @CompID int, @DocDate datetime, @GTSum_wt numeric(21,9), @Sum_wt numeric(21,9) output, @Sum_nt numeric(21,9) output, @TaxSum numeric(21,9) output)
AS
/* Возвращает суммы для формирования налоговой накладной */
BEGIN
  DECLARE @NewSum_wt numeric(21,9) /* сумма налоговой накладной */
  DECLARE @TaxFactor numeric(21,9) /* относительный коэффициент для расчета НДС */
  SET @TaxFactor = CASE @Sum_wt WHEN 0 THEN 0 ELSE @TaxSum / @Sum_wt END
  DECLARE @BalanceFESign int /* знак сальдо документа */
  SET @BalanceFESign = ISNULL((SELECT BalanceFESign FROM z_Docs WHERE DocCode = @DocCode), 0)
  SET @NewSum_wt = @GTSum_wt * CASE WHEN @BalanceFESign < 0 THEN -1 ELSE 1 END + @Sum_wt
  IF @NewSum_wt <> @Sum_wt
    BEGIN
      SET @Sum_wt = ROUND(@NewSum_wt, 2)
      SET  @TaxSum = ROUND(@Sum_wt * @TaxFactor, 2)
      SET @Sum_nt = @Sum_wt - @TaxSum
    END
END
GO
