SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_TaxDocs_Recalc](@ChangedField varchar(250), @Continue bit OUTPUT, @Msg varchar(200) OUTPUT)
/* Создание налоговых накладных: Обновление */
AS
BEGIN
  DECLARE
    @PosType INT,
    @ParentDocCode INT,
    @ParentChID bigINT,
    @SumCC_nt_20 numeric(21, 9),
    @TaxSum_20 numeric(21, 9),
    @SumCC_nt_7 numeric(21, 9),
    @TaxSum_7 numeric(21, 9),
    @SumCC_nt_0 numeric(21, 9),
    @TaxSum_0 numeric(21, 9),
    @SumCC_nt_Free numeric(21, 9),
    @TaxSum_Free numeric(21, 9),
    @SumCC_nt_No numeric(21, 9),
    @TaxSum_No numeric(21, 9)
  SELECT TOP 1 @ParentDocCode  = ParentDocCode, @ParentChID = ParentChID,  @PosType = PosType FROM #_TaxDocs
  CREATE TABLE #_TaxDocs_Detail(
    KeyField bigint,
    DocDate datetime,
    TaxType int,
    SumCC_nt numeric(21, 9),
    TaxSum numeric(21, 9),
    SumCC_wt numeric(21, 9))
  INSERT INTO #_TaxDocs_Detail
  EXEC z_TaxDocs_Detail @ParentDocCode, @ParentChID
  SELECT @SumCC_nt_20 = SUM(SumCC_nt), @TaxSum_20 = SUM(TaxSum) FROM #_TaxDocs_Detail WHERE TaxType = 0 AND @PosType NOT IN (23, 24)
  SELECT @SumCC_nt_7 = SUM(SumCC_nt), @TaxSum_7 = SUM(TaxSum) FROM #_TaxDocs_Detail WHERE (SELECT dbo.zf_GetTaxPercentByDate(TaxType,DocDate)) = 7 AND @PosType NOT IN (23, 24)
  SELECT @SumCC_nt_0 = SUM(SumCC_nt), @TaxSum_0 = SUM(TaxSum) FROM #_TaxDocs_Detail WHERE TaxType = 1 AND @PosType NOT IN (23, 24)
  SELECT @SumCC_nt_Free = SUM(SumCC_nt), @TaxSum_Free = SUM(TaxSum) FROM #_TaxDocs_Detail WHERE TaxType = 2 OR @PosType = 24
  SELECT @SumCC_nt_No = SUM(SumCC_nt), @TaxSum_No = SUM(TaxSum) FROM #_TaxDocs_Detail WHERE TaxType = 3 OR @PosType = 23
  IF @ParentDocCode IN (11003, 11004, 11011, 14103, 14113)
    SELECT
      @SumCC_nt_20 = -@SumCC_nt_20,
      @TaxSum_20 = -@TaxSum_20,
      @SumCC_nt_7 = -@SumCC_nt_7,
      @TaxSum_7 = -@TaxSum_7,
      @SumCC_nt_0 = -@SumCC_nt_0,
      @TaxSum_0 = -@TaxSum_0,
      @SumCC_nt_Free = -@SumCC_nt_Free,
      @TaxSum_Free = -@TaxSum_Free,
      @SumCC_nt_No = -@SumCC_nt_No,
      @TaxSum_No = -@TaxSum_No
  SELECT
    @SumCC_nt_20 = ISNULL(@SumCC_nt_20, 0),
    @TaxSum_20 = ISNULL(@TaxSum_20, 0),
    @SumCC_nt_7 = ISNULL(@SumCC_nt_7, 0),
    @TaxSum_7 = ISNULL(@TaxSum_7, 0),
    @SumCC_nt_0 = ISNULL(@SumCC_nt_0, 0),
    @TaxSum_0 = ISNULL(@TaxSum_0, 0),
    @SumCC_nt_Free = ISNULL(@SumCC_nt_Free, 0),
    @TaxSum_Free = ISNULL(@TaxSum_Free, 0),
    @SumCC_nt_No = ISNULL(@SumCC_nt_No, 0),
    @TaxSum_No = ISNULL(@TaxSum_No, 0)
  UPDATE #_TaxDocs SET
    SumCC_nt_20 = @SumCC_nt_20,
    TaxSum_20 = @TaxSum_20,
    SumCC_nt_7 = @SumCC_nt_7,
    TaxSum_7 = @TaxSum_7,
    SumCC_nt_0 = @SumCC_nt_0,
    TaxSum_0 = @TaxSum_0,
    SumCC_nt_Free = @SumCC_nt_Free,
    TaxSum_Free = @TaxSum_Free,
    SumCC_nt_No = @SumCC_nt_No,
    TaxSum_No = @TaxSum_No
  EXEC z_TaxDocs_IntDocID
  UPDATE #_TaxDocs SET SumCC_wt = SumCC_nt + TaxSum
  SELECT @Msg = '',  @Continue = 1
END
GO
