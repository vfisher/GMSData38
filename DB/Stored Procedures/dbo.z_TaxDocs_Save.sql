SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_TaxDocs_Save](@Continue bit OUTPUT, @Msg varchar(200) OUTPUT)
AS
BEGIN
  EXEC z_TaxDocs_Validate @Continue OUTPUT, @Msg OUTPUT
  IF @Continue = 0 RETURN
  DECLARE
    @TaxDocType int,
    @ChID bigint,
    @OurID int,
    @DocID bigint,
    @IntDocID varchar(50),
    @TableName varchar(50),
    @ChildDocCode bigint
  SELECT @TaxDocType = TaxDocType, @OurID = OurID, @IntDocID = IntDocID FROM #_TaxDocs
  IF @TaxDocType = 1
    SELECT @TableName = 'b_TRec', @ChildDocCode = 14341
  ELSE IF @TaxDocType = 2 or @TaxDocType = 0
    SELECT @TableName = 'b_TExp', @ChildDocCode = 14342
  ELSE
    BEGIN
      SELECT
        @Msg = dbo.zf_Translate('Создание налоговой накладной из данного документа невозможно.'),
        @Continue = 0
      RETURN
    END
  EXEC z_NewChID @TableName, @ChID OUTPUT
  EXEC z_NewDocID @ChildDocCode, @TableName, @OurID, @DocID OUTPUT
  IF @IntDocID IS NULL OR @IntDocID = ''
    SET @IntDocID = CAST(@DocID as VarChar(50))
  UPDATE #_TaxDocs SET ChID = @ChID, DocID = @DocID, IntDocID = @IntDocID
  IF @TaxDocType = 1
    INSERT INTO b_TRec(
      ChID, DocID, DocDate, KursMC, OurID, CompID, SumCC_nt, TaxSum, SumCC_wt, Notes, IntDocID, StateCode,
      CodeID1, CodeID2, CodeID3, CodeID4, CodeID5,
      SrcDocID, SrcDocDate, IsCorrection,
      PosType, TaxCredit, PayDate, PayForm, TakeTotalCosts,
      GOperID, GTranID, GPosID, GTSum_wt, GTTaxSum, GTAccID, GTCorrSum_wt, GTCorrTaxSum, /*GTAdvAccID, GTAdvSum_wt, GTCorrAdvSum_wt, */
      SumCC_nt_20, TaxSum_20, SumCC_nt_7, TaxSum_7, SumCC_nt_0, TaxSum_0, SumCC_nt_Free, TaxSum_Free, SumCC_nt_No, TaxSum_No, TaxCorrType)
    SELECT
      ChID, DocID, DocDate, KursMC, OurID, CompID, SumCC_nt, TaxSum, SumCC_wt, Notes, IntDocID, StateCode,
      CodeID1, CodeID2, CodeID3, CodeID4, CodeID5,
      SrcDocID, SrcDocDate, IsCorrection,
      PosType, TaxCredit, PayDate, PayForm, TakeTotalCosts,
      GOperID, GTranID, GPosID, GTSum_wt, GTTaxSum, GTAccID, GTCorrSum_wt, GTCorrTaxSum, /*GTAdvAccID, GTAdvSum_wt, GTCorrAdvSum_wt, */
      SumCC_nt_20, TaxSum_20, SumCC_nt_7, TaxSum_7, SumCC_nt_0, TaxSum_0, SumCC_nt_Free, TaxSum_Free, SumCC_nt_No, TaxSum_No, TaxCorrType
    FROM
      #_TaxDocs
  ELSE IF @TaxDocType = 2 or @TaxDocType = 0
    INSERT INTO b_TExp(
      ChID, DocID, DocDate, KursMC, OurID, CompID, SumCC_nt, TaxSum, SumCC_wt, Notes, IntDocID, StateCode,
      CodeID1, CodeID2, CodeID3, CodeID4, CodeID5,
      /* SrcDocID, SrcDocDate, */ IsCorrection,
      PosType, TaxCredit,
      GOperID, GTranID, GPosID, GTSum_wt, GTTaxSum, GTAccID, GTCorrSum_wt, GTCorrTaxSum, /*GTAdvAccID, GTAdvSum_wt, GTCorrAdvSum_wt, */
      SumCC_nt_20, TaxSum_20, SumCC_nt_7, TaxSum_7, SumCC_nt_0, TaxSum_0, SumCC_nt_Free, TaxSum_Free, SumCC_nt_No, TaxSum_No, TaxCorrType)
    SELECT
      ChID, DocID, DocDate, KursMC, OurID, CompID, SumCC_nt, TaxSum, SumCC_wt, Notes, IntDocID, StateCode,
      CodeID1, CodeID2, CodeID3, CodeID4, CodeID5,
      /* SrcDocID, SrcDocDate, */ IsCorrection,
      PosType, TaxCredit,
      GOperID, GTranID, GPosID, GTSum_wt, GTTaxSum, GTAccID, GTCorrSum_wt, GTCorrTaxSum, /*GTAdvAccID, GTAdvSum_wt, GTCorrAdvSum_wt, */
      SumCC_nt_20, TaxSum_20, SumCC_nt_7, TaxSum_7, SumCC_nt_0, TaxSum_0, SumCC_nt_Free, TaxSum_Free, SumCC_nt_No, TaxSum_No, TaxCorrType
    FROM
      #_TaxDocs
  DECLARE
    @ParentDocCode int,
    @ParentChID bigint,
    @RepToolCode int,
    @ToolCode int
  SELECT @ParentDocCode = ParentDocCode, @ParentChID = ParentChID, @RepToolCode = TJ_RepToolCode, @ToolCode = TJ_ToolCode FROM #_TaxDocs
  EXEC z_DocLinks_Prepare @ParentDocCode, @ParentChID, @ChildDocCode, @ChID, @RepToolCode, @ToolCode
  EXEC z_DocLinks_Save @Continue OUTPUT, @Msg OUTPUT
  IF @Continue = 0 RETURN
    SELECT
      @Continue = 1,
      @Msg = ''
END

GO
