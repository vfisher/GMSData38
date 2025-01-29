SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_TaxDocs_Validate](@Continue bit OUTPUT, @Msg varchar(200) OUTPUT)
/* Создание налоговых накладных: Проверка */
AS
BEGIN
  DECLARE
    @ABegin smalldatetime,
    @AEnd smalldatetime,
    @TaxDocType int,
    @TaxCorrType int,
    @DocCode int,
    @OurID int,
    @CompID int,
    @SrcDocID varchar(50),
    @SrcDocDate smalldatetime,
    @ParentDocDate smalldatetime,
    @Sum_nt numeric(21, 9),
    @Sum_tx numeric(21, 9),
    @Sum_wt numeric(21, 9)

  SELECT
    @OurID = OurID,
    @CompID = CompID,
    @TaxDocType = TaxDocType,
    @TaxCorrType = TaxCorrType,
    @DocCode = ParentDocCode,
    @SrcDocID = LTRIM(ISNULL(SrcDocID, '')),
    @SrcDocDate = ISNULL(SrcDocDate, ''),
    @ParentDocDate = ParentDocDate,
    @Sum_nt = SumCC_nt,
    @Sum_tx = TaxSum,
    @Sum_wt = SumCC_wt
  FROM #_TaxDocs

  /* Проверка открытого периода */
  SET @ABegin = GETDATE()
  SELECT @ABegin = BDate, @AEnd = EDate FROM dbo.zf_GetOpenAges(@ABegin) WHERE OurID = @OurID

  IF @ParentDocDate < @ABegin
    BEGIN
      SELECT
        @Msg = dbo.zf_Translate('Дата документа меньше даты открытого периода - ') + dbo.zf_DatetoStr(@ABegin),
        @Continue = 0
      RETURN
    END

  IF @ParentDocDate > @AEnd
    BEGIN
      SELECT
        @Msg = dbo.zf_Translate('Дата документа больше даты открытого периода - ') + dbo.zf_DatetoStr(@AEnd),
        @Continue = 0
      RETURN
    END

  SELECT
    @Msg = '',
    @Continue = 1

  /* Проверка на необходимость наличия номера и даты источника */
  IF @TaxDocType = 1
    BEGIN
      IF (@SrcDocID = '' OR @SrcDocDate = '')
        BEGIN
          SELECT
            @Msg = dbo.zf_Translate('Для данного документа необходимо указать номер и дату документа-источника.'),
            @Continue = 0
          RETURN
        END

      /* Проверка на дублирование входящего номера */
      SELECT @ABegin = dbo.zf_GetMonthFirstDay(@SrcDocDate)
      SELECT @AEnd = dbo.zf_GetMonthLastDay(@SrcDocDate)
      IF EXISTS(SELECT TOP 1 1 FROM b_TRec WHERE OurID = @OurID AND CompID = @CompID AND LTRIM(SrcDocID) = @SrcDocID AND (DocDate BETWEEN @ABegin AND @AEnd))
        BEGIN
          SELECT
            @Msg = dbo.zf_Translate('Налоговая накладная от текущего предприятия с номером ') + @SrcDocID +
            dbo.zf_Translate(' в период с ') + dbo.zf_DateToStr(@ABegin) + dbo.zf_Translate(' по ') + dbo.zf_DateToStr(@AEnd) + dbo.zf_Translate(' уже зарегистрирована.'),
            @Continue = 0
          RETURN
        END
    END

  /* Проверка на нулевые суммы */
  IF @Sum_nt = 0 AND @Sum_tx = 0 AND @Sum_wt = 0
    BEGIN
      SELECT
        @Msg = dbo.zf_Translate('Все суммы равны 0. Создание налоговой накладной невозможно.'),
        @Continue = 0
    END
END

GO
