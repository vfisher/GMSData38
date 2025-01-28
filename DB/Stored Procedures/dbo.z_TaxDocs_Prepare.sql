SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_TaxDocs_Prepare](@ParentDocCode int, @ParentChID bigint, @RepToolCode int, @ToolCode int, @Continue bit OUTPUT, @Msg varchar(200) OUTPUT)
AS
BEGIN
  DECLARE
    @ABegin datetime,
    @AEnd datetime,
    @AErr varchar(200),
    @TaxDocType int,
    @TJ_Prompt varchar(250),
    @TJ_ShowDialog bit,
    @ParentDocID bigint,
    @ParentDocDate smalldatetime,
    @ParentTableCode int,
    @ParentTableName varchar(50),
    @ChildDocCode int,
    @ChID bigint,
    @DocID bigint,
    @DocDate smalldatetime,
    @KursMC numeric(21,9),
    @OurID int,
    @CompID int,
    @Notes varchar(200),
    @CodeID1 int,
    @CodeID2 int,
    @CodeID3 int,
    @CodeID4 int,
    @CodeID5 int,
    @IntDocID varchar(50),
    @StateCode int,
    @SrcDocID varchar(250),
    @SrcDocDate smalldatetime,
    @SrcTaxDocID varchar(250),
    @SrcTaxDocDate smalldatetime,
    @GOperID int,
    @GTranID int,
    @GTSum_wt numeric(21, 9),
    @GTTaxSum numeric(21, 9),
    @GTAccID int,
    @GPosID int,
    @GTCorrSum_wt numeric(21, 9),
    @GTCorrTaxSum numeric(21, 9),
    @PosType int,
    @TaxCorrType int,
    @TaxCredit bit,
    @PayDate smalldatetime,
    @PayForm varchar(200),
    @TakeTotalCosts bit,
    @IsCorrection bit,
    @SumCC_nt numeric(21, 9),
    @TaxSum numeric(21, 9),
    @SumCC_wt numeric(21, 9),
    @SumCC_nt_Closed numeric(21, 9),
    @TaxSum_Closed numeric(21, 9),
    @SumCC_wt_Closed numeric(21, 9),
    @SumCC_nt_20 numeric(21, 9),
    @TaxSum_20 numeric(21, 9),
    @SumCC_nt_7 numeric(21, 9),
    @TaxSum_7 numeric(21, 9),
    @SumCC_nt_0 numeric(21, 9),
    @TaxSum_0 numeric(21, 9),
    @SumCC_nt_Free numeric(21, 9),
    @TaxSum_Free numeric(21, 9),
    @SumCC_nt_No numeric(21, 9),
    @TaxSum_No numeric(21, 9),
    @DocLinkTypeID int,
    @LinkSumCC numeric(21, 9),
    @TableName varchar(200),
    @SQLStr nvarchar(2000),
    @Params nvarchar(2000),
    @s varchar(250),
    @SumCC_ntField varchar(250),
    @TaxSumField varchar(250),
    @SumCC_wtField varchar(250)
  IF @ParentDocCode IN (11045, 11046, 14113, 14131, 14310, 14311, 14011, 14012, 14021, 14022, 14031, 14032)
    BEGIN
      SELECT
        @Msg = dbo.zf_Translate('Документ не поддерживает создание налоговой накладной.'),
        @Continue = 0
      RETURN
    END
  SELECT
    @Msg = '',
    @Continue = 1
  SELECT @TaxDocType = TaxDocType FROM z_Docs WHERE DocCode = @ParentDocCode
  SELECT @ParentTableName = TableName FROM z_Tables WHERE TableCode = @ParentDocCode * 1000 + 1
  SELECT @ParentTableCode = TableCode FROM z_Tables WHERE TableCode = @ParentDocCode * 1000 + 1
  IF @TaxDocType = 1
    SELECT @TableName = 'b_TRec', @ChildDocCode = 14341, @TaxCredit = 1
  ELSE IF @TaxDocType = 2
    SELECT @TableName = 'b_TExp', @ChildDocCode = 14342, @TaxCredit = 0
  ELSE
  BEGIN
    SELECT
      @Msg = dbo.zf_Translate('Создание налоговой накладной из данного документа невозможно.'),
      @Continue = 0
    RETURN
  END
  SELECT @SQLStr = N'SELECT @ParentDocIDOUT = DocID, @ParentDocDateOUT = DocDate, @OurIDOUT = OurID, @CompIDOUT = CompID,
    @CodeID1OUT = CodeID1, @CodeID2OUT = CodeID2, @CodeID3OUT = CodeID3, @CodeID4OUT = CodeID4, @CodeID5OUT = CodeID5, @KursMCOUT = KursMC, '
  IF EXISTS(SELECT TOP 1 1 FROM z_Fields WHERE TableCode = @ParentTableCode AND FieldName = 'SrcTaxDocID') AND
     EXISTS(SELECT TOP 1 1 FROM z_Fields WHERE TableCode = @ParentTableCode AND FieldName = 'SrcTaxDocDate')
     SELECT @SQLStr = @SQLStr + '@SrcDocIDOUT = SrcTaxDocID, @SrcDocDateOUT = SrcTaxDocDate, '
  ELSE
    SELECT @SQLStr = @SQLStr + '@SrcDocIDOUT = NULL, @SrcDocDateOUT = NULL, '
  IF EXISTS(SELECT TOP 1 1 FROM z_Fields WHERE TableCode = @ParentTableCode AND FieldName = 'GTSum_wt')
    SELECT @SQLStr = @SQLStr + '@GTSum_wtOUT = GTSum_wt, '
  ELSE
    SELECT @SQLStr = @SQLStr + '@GTSum_wtOUT = 0, '
  SELECT
    @SumCC_ntField = dbo.zf_SumField(@ParentTableName, @ParentChID, 1),
    @TaxSumField = dbo.zf_SumField(@ParentTableName, @ParentChID, 0),
    @SumCC_wtField = dbo.zf_SumField(@ParentTableName,@ParentChID, 2)
  SELECT @SQLStr = @SQLStr + '@SumCC_ntOUT = ' + @SumCC_ntField + ', @TaxSumOUT = ' + @TaxSumField + ', @SumCC_wtOUT = ' + @SumCC_wtField
  SELECT @SQLStr = @SQLStr + N' FROM ' + @ParentTableName + ' WHERE ChID = '+ CAST (@ParentChID as varchar(50))
  SELECT @Params = N'@ChID bigint, @ParentDocIDOUT bigint OUTPUT, @ParentDocDateOUT smalldatetime OUTPUT, @OurIDOUT int OUTPUT, @CompIDOUT int OUTPUT, ' +
    '@CodeID1OUT int OUTPUT, @CodeID2OUT int OUTPUT, @CodeID3OUT int OUTPUT, @CodeID4OUT int OUTPUT, @CodeID5OUT int OUTPUT, ' +
    '@SrcDocIDOUT varchar(250) OUTPUT, @SrcDocDateOUT smalldatetime OUTPUT, ' +
    '@SrcTaxDocIDOUT varchar(250) OUTPUT, @SrcTaxDocDateOUT smalldatetime OUTPUT, ' +
    '@GTSum_wtOUT numeric(21, 9) OUTPUT, @SumCC_ntOUT numeric(21, 9) OUTPUT, ' +
    '@TaxSumOUT numeric(21, 9) OUTPUT, @SumCC_wtOUT numeric(21, 9) OUTPUT, @KursMCOUT numeric(21, 9) OUTPUT'
  EXECUTE sp_executesql @SQLStr, @Params, @ChID = @ParentChID, @ParentDocIDOUT = @ParentDocID OUTPUT, @ParentDocDateOUT = @ParentDocDate OUTPUT, @OurIDOUT = @OurID OUTPUT, @CompIDOUT = @CompID OUTPUT,
    @CodeID1OUT = @CodeID1 OUTPUT, @CodeID2OUT = @CodeID2 OUTPUT, @CodeID3OUT = @CodeID3 OUTPUT, @CodeID4OUT = @CodeID4 OUTPUT, @CodeID5OUT = @CodeID5 OUTPUT,
    @SrcDocIDOUT = @SrcDocID OUTPUT, @SrcDocDateOUT = @SrcDocDate OUTPUT,
    @SrcTaxDocIDOUT = @SrcTaxDocID OUTPUT, @SrcTaxDocDateOUT = @SrcTaxDocDate OUTPUT,
    @GTSum_wtOUT = @GTSum_wt OUTPUT, @SumCC_ntOUT = @SumCC_nt OUTPUT,
    @TaxSumOUT = @TaxSum OUTPUT, @SumCC_wtOUT = @SumCC_wt OUTPUT, @KursMCOUT = @KursMC OUTPUT
  EXEC z_GetTaxDocSum @ParentDocCode, @ParentChID, @OurID, @CompID, @ParentDocDate, @GTSum_wt, @SumCC_wt OUTPUT, @SumCC_nt OUTPUT, @TaxSum OUTPUT
  IF @ParentDocCode IN (11003, 11004, 11011, 14103, 14113) SELECT @SumCC_wt = -@SumCC_wt, @SumCC_nt = -@SumCC_nt, @TaxSum = -@TaxSum
  SELECT @SQLStr = N'SELECT @SumCC_ntOUT = ISNULL(SUM(d.SumCC_nt), 0), @TaxSumOUT = ISNULL(SUM(d.TaxSum), 0), @SumCC_wtOUT = ISNULL(SUM(d.SumCC_wt), 0) ' +
    'FROM z_DocLinks m, ' + @TableName + ' d ' +
    'WHERE m.ChildDocCode = @AChildDocCode AND m.ChildChID = d.ChID AND m.ParentDocCode = @AParentDocCode AND m.ParentChID = @AParentChID'
  SELECT @Params = N'@AChildDocCode int, @AParentDocCode int, @AParentChID bigint, ' +
    '@SumCC_ntOUT numeric(21, 9) OUTPUT, @TaxSumOUT numeric(21, 9) OUTPUT, @SumCC_wtOUT numeric(21, 9) OUTPUT'
  EXECUTE sp_executesql @SQLStr, @Params, @AChildDocCode = @ChildDocCode, @AParentDocCode = @ParentDocCode, @AParentChID = @ParentChID,
    @SumCC_ntOUT = @SumCC_nt_Closed OUTPUT, @TaxSumOUT = @TaxSum_Closed OUTPUT, @SumCC_wtOUT = @SumCC_wt_Closed OUTPUT
  SELECT @SumCC_nt = @SumCC_nt - @SumCC_nt_Closed, @TaxSum = @TaxSum - @TaxSum_Closed, @SumCC_wt = @SumCC_wt - @SumCC_wt_Closed
  SELECT
    @TJ_Prompt = dbo.zf_Translate('Необходимо указать свойства налоговой накладной. Указанные свойства будут занесены в книгу продаж/приобретений. Для отмены создания налоговой накладной нажмите "Отмена".'),
    @TJ_ShowDialog = 1,
    @ChID = NULL,
    @DocID = NULL,
    @Notes = '',
    @IntDocID = '',
    @StateCode = 0,
    @GOperID = 0,
    @GTranID = 0,
    @GTSum_wt = 0,
    @GTTaxSum = 0,
    @GTAccID = 0,
    @GPosID = 0,
    @GTCorrSum_wt = 0,
    @GTCorrTaxSum = 0,
    @PosType = 1,
    @TaxCorrType = 0,
    @PayDate = dbo.zf_GetDate(GETDATE()),
    @PayForm = '',
    @TakeTotalCosts = 1,
    @IsCorrection = 0,
    @DocLinkTypeID = 0,
    @LinkSumCC = 0
  SELECT TOP 1 @GOperID = GOperID FROM b_GOperDocs
  WHERE DSCode IN (SELECT DSCode FROM z_Datasets WHERE DocCode = @ChildDocCode)
  ORDER BY Priority, GOperID
  SET @GOperID = ISNULL(@GOperID, 0)
  CREATE TABLE #_TaxDocs_Detail(
    KeyField int,
    DocDate datetime,
    TaxType int,
    SumCC_nt numeric(21, 9),
    TaxSum numeric(21, 9),
    SumCC_wt numeric(21, 9))
  INSERT INTO #_TaxDocs_Detail
  EXEC z_TaxDocs_Detail @ParentDocCode, @ParentChID
  SELECT @SumCC_nt_20 = SUM(SumCC_nt), @TaxSum_20 = SUM(TaxSum) FROM #_TaxDocs_Detail WHERE TaxType = 0
  SELECT @SumCC_nt_7 = SUM(SumCC_nt), @TaxSum_7 = SUM(TaxSum) FROM #_TaxDocs_Detail WHERE (SELECT dbo.zf_GetTaxPercentByDate(TaxType,DocDate)) = 7
  SELECT @SumCC_nt_0 = SUM(SumCC_nt), @TaxSum_0 = SUM(TaxSum) FROM #_TaxDocs_Detail WHERE TaxType = 1
  SELECT @SumCC_nt_Free = SUM(SumCC_nt), @TaxSum_Free = SUM(TaxSum) FROM #_TaxDocs_Detail WHERE TaxType = 2
  SELECT @SumCC_nt_No = SUM(SumCC_nt), @TaxSum_No = SUM(TaxSum) FROM #_TaxDocs_Detail WHERE TaxType = 3
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
  TRUNCATE TABLE #_TaxDocs
  INSERT INTO #_TaxDocs
    (TJ_Prompt, TJ_RepToolCode, TJ_ToolCode, TJ_ShowDialog,
     ParentDocCode, ParentChID, ParentDocID, ParentDocDate,
     TaxDocType, ChID, DocID, DocDate, KursMC, OurID, CompID, Notes, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, IntDocID, StateCode,
     SrcDocID, SrcDocDate,
     SrcTaxDocID, SrcTaxDocDate,
     GOperID, GTranID, GTSum_wt, GTTaxSum, GTAccID, GPosID, GTCorrSum_wt, GTCorrTaxSum,
     PosType, TaxCredit,
     PayDate, PayForm, TakeTotalCosts,
     IsCorrection,
     SumCC_nt, TaxSum, SumCC_wt,
     SumCC_nt_20, TaxSum_20, SumCC_nt_7, TaxSum_7, SumCC_nt_0, TaxSum_0, SumCC_nt_Free, TaxSum_Free, SumCC_nt_No, TaxSum_No,
     DocLinkTypeID, LinkSumCC, TaxCorrType)
  VALUES
     (@TJ_Prompt, @RepToolCode, @ToolCode, @TJ_ShowDialog,
      @ParentDocCode, @ParentChID, @ParentDocID, @ParentDocDate,
      @TaxDocType, @ChID, @DocID, @ParentDocDate, @KursMC, @OurID, @CompID, @Notes, @CodeID1, @CodeID2, @CodeID3, @CodeID4, @CodeID5, @IntDocID, @StateCode,
      @SrcDocID, @SrcDocDate,
      @SrcTaxDocID, @SrcTaxDocDate,
      @GOperID, @GTranID, @GTSum_wt, @GTTaxSum, @GTAccID, @GPosID, @GTCorrSum_wt, @GTCorrTaxSum,
      @PosType, @TaxCredit,
      @PayDate, @PayForm, @TakeTotalCosts,
      @IsCorrection,
      @SumCC_nt, @TaxSum, @SumCC_wt,
      @SumCC_nt_20, @TaxSum_20, @SumCC_nt_7, @TaxSum_7, @SumCC_nt_0, @TaxSum_0, @SumCC_nt_Free, @TaxSum_Free, @SumCC_nt_No, @TaxSum_No,
      @DocLinkTypeID, @LinkSumCC, @TaxCorrType)
  EXEC z_TaxDocs_IntDocID
  DECLARE @GetDate datetime
  SET @GetDate = GETDATE()
  SELECT @ABegin = BDate, @AEnd = EDate FROM dbo.zf_GetOpenAges(@GetDate) WHERE OurID = @OurID
  IF EXISTS(SELECT 1 FROM #_TaxDocs WHERE ParentDocDate < @ABegin)
  BEGIN
    SELECT @AErr = dbo.zf_Translate('Дата документа меньше даты открытого периода - ') + dbo.zf_DatetoStr(@ABegin)
    RAISERROR (@AErr, 18, 1)
    RETURN
  END
  IF EXISTS(SELECT 1 FROM #_TaxDocs WHERE ParentDocDate > @AEnd)
  BEGIN
    SELECT @AErr = dbo.zf_Translate('Дата документа больше даты открытого периода - ') + dbo.zf_DatetoStr(@AEnd)
    RAISERROR (@AErr, 18, 1)
    RETURN
  END
END

GO
