SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_TaxDocs_IntDocID]
/* Создание налоговых накладных: Возвращает доп. номер */
AS
  BEGIN
    DECLARE @TaxDocType INT ,
      @TaxCorrType INT ,
      @PosType INT ,
      @DocCode INT ,
      @TableCode INT ,
      @ChID bigINT ,
      @OurID INT ,
      @SrcTaxDocID VARCHAR(250) ,
      @IntDocID VARCHAR(50) ,
      @ExtIntDocID VARCHAR(50) ,
      @s VARCHAR(50)

    SELECT  @TaxDocType = TaxDocType, @TaxCorrType = TaxCorrType, @PosType = PosType, @DocCode = ParentDocCode, @ChID = ParentChID, @SrcTaxDocID = SrcTaxDocID
    FROM    #_TaxDocs

    SET @IntDocID = NULL
    IF @TaxDocType = 1
      BEGIN
        SET @IntDocID = @SrcTaxDocID
      END
    ELSE
      IF @TaxDocType = 2
        OR @TaxDocType = 0
        BEGIN
          SELECT  @TableCode = TableCode
          FROM    z_Tables
          WHERE   TableCode = @DocCode * 1000 + 1
          SELECT  @IntDocID = ISNULL(MAX(CAST(SUBSTRING(m.IntDocID, 1, CHARINDEX('/', m.IntDocID + '/') - 1) AS BIGINT)), 0) + 1
          FROM    b_TExp m ,
                  #_TaxDocs t
          WHERE   m.DocDate BETWEEN CAST(YEAR(t.DocDate) AS VARCHAR(4)) + '0101'
                            AND     CAST(YEAR(t.DocDate) AS VARCHAR(4)) + '1231' /* В разрезе годов */
                  AND ( t.PosType <> 3
                        OR m.PosType = 3
                      ) /* В разрезе коррекций */
                  AND RIGHT('0000000000' + SUBSTRING(m.IntDocID, 1, CHARINDEX('/', m.IntDocID + '/') - 1), 10) LIKE REPLICATE('[0-9]', 10)
      /* Получение расширенного номера налоговой */
          SET @ExtIntDocID = ''
          IF @PosType = 3 /* Если выбрана корректировка, получить IntDocID налоговой накладной основополагающего документа */
            BEGIN
              DECLARE @ParentDocCode INT ,
                @ParentChID bigINT
          /* Получить данные об основополагающем документе ТМЦ: Расходная накладная */
              SELECT  @ParentDocCode = ParentDocCode, @ParentChID = ParentChID
              FROM    z_DocLinks
              WHERE   ChildDocCode = @DocCode
                      AND ChildChID = @ChID
                      AND ParentDocCode = 14111
              IF @ParentChID IS NOT NULL /* Связь с ТМЦ: Расходная накладная есть */
                BEGIN
                  EXEC z_DocLookup 'TaxDocID', @ParentDocCode, @ParentChID, @ExtIntDocID OUT
                  SET @s = 'DocID = ' + @ExtIntDocID + ' AND OurID = ' + @OurID
                  EXEC z_TableLookup 'IntDocID', @TableCode, @s, @ExtIntDocID OUT
                  SET @ExtIntDocID = '/' + @ExtIntDocID
                END
            END
          SET @IntDocID = @IntDocID + @ExtIntDocID
        END
    UPDATE  #_TaxDocs
    SET     IntDocID = ISNULL(@IntDocID, IntDocID)
    WHERE   ( IntDocID = '' )
            OR ( IntDocID IS NULL )
  END
GO