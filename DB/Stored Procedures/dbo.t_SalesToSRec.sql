SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SalesToSRec](@OurID int, @StockID int, @BDate smalldatetime, @EDate smalldatetime, @UseRestShift bit)
AS
/* Формирует документы комплектация на основе продаж товара */
BEGIN
  DECLARE
    @ParentChID bigint, @DocDate smalldatetime, 
    @ParentDocID bigint, @SubStockID int, 
    @ChID bigint, @DocID bigint, @CurrID int, 
    @KursMC numeric(21,9), @EmpID int, 
    @ProdID int, @Qty numeric(21,9), @UM varchar(50),
    @SrcPosID int, @AChID bigint, @BarCode varchar(50), 
    @PPID int, @PriceCC numeric(21,9), @PLID int, 
    @DocCode int, @CodeID3 int, @ManualSRecCodeID4 int

  SELECT @CurrID = dbo.zf_GetCurrCC(), @EmpID = dbo.zf_GetEmpCode() 

  SELECT @KursMC = dbo.zf_GetRateMC(@CurrID)

  SELECT @ManualSRecCodeID4 = ISNULL(dbo.zf_Var('t_ManualSRecCode'), -1)	

  SELECT @PLID = PLID
  FROM r_Stocks WITH (NOLOCK)
  WHERE StockID = @StockID

  CREATE TABLE #SaleChs
  (
    DocCode int,
    ChID bigint, 
    StateCode int, 
    RestShiftChID bigint, 
    DocDate smalldatetime,
    CodeID3 int,
    PRIMARY KEY(ChID, DocCode)
  )

  CREATE TABLE #Sales
  (
    DocCode int, 
    RestShiftChID int, 
    DocDate smalldatetime, 
    RestShiftDocID bigint, 
    ProdID int, 
    Qty numeric(21,9), 
    SubStockID int,
    CodeID3 int
  )

  /* Заполнение временной таблицы продаж.
    Для продажи оператором смотрим на настройку "Использовать смены" */
  IF @UseRestShift = 1
    BEGIN
      /* Получим кода регистраций документов, смен */
      INSERT INTO #SaleChs
      SELECT 
        11035, m.ChID, m.StateCode, rs.ChID, rs.DocDate, m.CodeID3
      FROM dbo.t_RestShift rs WITH (NOLOCK)
      INNER JOIN dbo.t_Sale m WITH (NOLOCK) 
        ON rs.OurID = m.OurID AND rs.StockID = m.StockID
        AND m.DocTime >= rs.ShiftOpenTime AND m.DocTime < rs.ShiftCloseTime
      WHERE 
        rs.OurID = @OurID
        AND rs.StockID = @StockID
        AND rs.DocDate BETWEEN @BDate AND @EDate  

      /* Получим данные продаж */
      INSERT INTO #Sales
      (
        DocCode, RestShiftChID, DocDate, RestShiftDocID, 
        ProdID, Qty, SubStockID, CodeID3
      )
      SELECT 
        11035, rs.ChID, rs.DocDate, rs.DocID, 
        d.ProdID, SUM(d.Qty) Qty, s.SubStockID, m.CodeID3
      FROM dbo.t_RestShift rs WITH (NOLOCK)
      INNER JOIN dbo.t_Sale m WITH (NOLOCK) ON rs.OurID = m.OurID AND rs.StockID = m.StockID
          AND m.DocTime >= rs.ShiftOpenTime AND m.DocTime < rs.ShiftCloseTime
      INNER JOIN dbo.t_SaleD d WITH (NOLOCK) ON m.ChID = d.ChID 
      INNER JOIN dbo.r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = d.PLID
      LEFT JOIN dbo.r_StockSubs s WITH(NOLOCK) ON mp.DepID = s.DepID AND s.StockID = m.StockID
      WHERE 
        rs.OurID = @OurID
        AND rs.StockID = @StockID
        AND rs.DocDate BETWEEN @BDate AND @EDate
        AND ISNULL(s.SubStockID, 0) <> 0 
      GROUP BY 
        rs.ChID, rs.DocDate, rs.DocID, d.ProdID, s.SubStockID, m.CodeID3

      /* Удалим существующие комплектации (11321), связаанные со сменами (11060) */
      DELETE m   
      FROM dbo.t_SRec m
      INNER JOIN dbo.z_DocLinks dl
        ON dl.ParentDocCode = 11060 AND dl.ChildDocCode = 11321  
        AND m.ChID = dl.ChildChID     
      WHERE dl.ParentChID IN (SELECT RestShiftChID FROM #Sales)
      /* исключаем ручную комплектацию, значение признака 4 */
      /* Begin */
        AND m.CodeID4 <> @ManualSRecCodeID4
      /* End */
    END
  ELSE
  /* Если смен нет */
    BEGIN
      /* Кода регистрации продаж */
      INSERT INTO #SaleChs
      SELECT 
        11035, m.ChID, m.StateCode, 0, m.DocDate, m.CodeID3
      FROM dbo.t_Sale m WITH (NOLOCK) 
      WHERE 
        m.OurID = @OurID
        AND m.StockID = @StockID
        AND m.DocDate BETWEEN @BDate AND @EDate   

      /* Данные продаж */
      INSERT INTO #Sales
      (
        DocCode, RestShiftChID, DocDate, RestShiftDocID, 
        ProdID, Qty, SubStockID, m.CodeID3
      )

      /* Внесен учет возвратов по продажам - чтобы они не попадали в расчет производства */
      SELECT 
        DocCode, ChID, DocDate, DocID,
        ProdID, SUM(Qty) Qty, SubStockID, CodeID3 
      FROM (
        /*Вычисляем продажи*/
        SELECT 
          m.DocCode, 0 ChID, m.DocDate, NULL DocID, 
          d.ProdID, SUM(d.Qty) Qty, s.SubStockID, m.CodeID3 
        FROM #SaleChs m
        INNER JOIN dbo.t_Sale sa WITH (NOLOCK) ON m.ChID = sa.ChID
        INNER JOIN dbo.t_SaleD d WITH (NOLOCK) ON m.ChID = d.ChID
        INNER JOIN dbo.r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = d.PLID
        LEFT JOIN dbo.r_StockSubs s WITH(NOLOCK) ON mp.DepID = s.DepID  AND s.StockID = sa.StockID      
        WHERE m.DocCode = 11035
          AND ISNULL(s.SubStockID, 0) <> 0 
        GROUP BY 
          m.DocCode, m.DocDate, d.ProdID, d.UM, s.SubStockID, m.CodeID3 
        UNION ALL

        /*Вычисляем возвраты */
        SELECT 11035 as DocCode, 0 ChID, m.DocDate, NULL DocID,
          d.ProdID, -SUM(d.Qty) Qty, s.SubStockID, m.CodeID3 
        FROM t_CRRet m 
        INNER JOIN t_CRRetD d ON m.ChID = d.ChID
        INNER JOIN dbo.r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = @PLID
        LEFT JOIN dbo.r_StockSubs s WITH(NOLOCK) ON mp.DepID = s.DepID AND s.StockID = m.StockID     
        WHERE 
          m.OurID = @OurID         
          AND m.DocDate BETWEEN @BDate AND @EDate
          AND s.StockID = @StockID
          AND ISNULL(s.SubStockID, 0) <> 0          
        GROUP BY 
          m.DocDate, d.ProdID, d.UM, s.SubStockID, m.CodeID3   
            ) a
      GROUP BY DocCode, ChID, DocDate, DocID, ProdID, SubStockID, CodeID3

      /* Удалим существующие комплектации */
      DELETE m   
      FROM dbo.t_SRec m
      WHERE 
        m.OurID = @OurID
        AND m.StockID = @StockID
        AND m.DocDate IN (SELECT DocDate FROM #Sales) 
      /* исключаем ручную комплектацию, значение признака 4 */
      /* Begin */
        AND m.CodeID4 <> @ManualSRecCodeID4
      /* End */
    END

  /* Получим кода регистрации РДЦП */
  INSERT INTO #SaleChs
  SELECT 
    11016, m.ChID, m.StateCode, 0 SubStockID, m.DocDate, m.CodeID3 
  FROM dbo.t_Epp m WITH(NOLOCK) 
  WHERE 
    m.OurID = @OurID
    AND m.StockID = @StockID
    AND m.DocDate BETWEEN @BDate AND @EDate   

  /* Получим данные РДЦП
  !!!! ЦЕНА ДОЛЖНА БЫТЬ В ПРАЙС-ЛИСТЕ СКЛАДА,
  !!!! отдел прайс-листа должен быть равен отделу склада комплектующих
   */
  INSERT INTO #Sales
  (
    DocCode, RestShiftChID, DocDate, RestShiftDocID, 
    ProdID, Qty, SubStockID, m.CodeID3
  )
  SELECT 
    11016, 0 ChID, m.DocDate, NULL DocID, 
    d.ProdID, SUM(d.Qty) Qty, s.SubStockID, m.CodeID3 
  FROM dbo.t_Epp m WITH(NOLOCK) 
  INNER JOIN dbo.t_EppD d WITH(NOLOCK) ON m.ChID = d.ChID 
  INNER JOIN dbo.r_ProdMP mp WITH(NOLOCK) ON d.ProdID = mp.ProdID
  INNER JOIN dbo.r_StockSubs s WITH(NOLOCK) ON m.StockID = s.StockID AND s.DepID = mp.DepID
  WHERE 
    m.OurID = @OurID
    AND m.StockID = @StockID 
    AND m.DocDate BETWEEN @BDate AND @EDate
    AND mp.PLID = @PLID
  GROUP BY 
    m.DocDate, d.ProdID, d.UM, s.SubStockID, m.CodeID3

  /* Удалим все комплектации, сделанные не по сменам
  !!!!! скорее всего не нужно, так как выше чистятся все комплектации вне зависимости
   */
  DELETE m   
  FROM dbo.t_SRec m
  WHERE 
    NOT EXISTS(SELECT * FROM dbo.z_DocLinks dl WITH(NOLOCK)
      WHERE dl.ParentDocCode = 11060 AND dl.ChildDocCode = 11321
        AND m.ChID = dl.ChildChID)
    AND m.OurID = @OurID
    AND m.StockID = @StockID
    AND m.DocDate IN
    (
      SELECT DocDate FROM #Sales
    ) 
      /* исключаем ручную комплектацию, значение признака 4 */
      /* Begin */
        AND m.CodeID4 <> @ManualSRecCodeID4
      /* End */

  /* Получим продажи, для которых предусмотрена комплектация */
  SELECT
    m.DocCode, 
    m.RestShiftChID, m.DocDate, 
    m.RestShiftDocID, m.ProdID, m.Qty, p.UM, m.SubStockID, m.CodeID3 
  INTO #StockSales  
  FROM #Sales m
  INNER JOIN r_Prods p WITH (NOLOCK)
  ON m.ProdID = p.ProdID
  WHERE m.SubStockID <> 0

  SELECT DISTINCT
    DocCode, RestShiftChID, DocDate, RestShiftDocID, SubStockID, CodeID3
  FROM #StockSales
  ORDER BY 
    DocDate, SubStockID, RestShiftDocID, DocCode, CodeID3 DESC

  /*WHERE EXISTS
  (
    SELECT  
    1    
    FROM t_Spec sp 
    WHERE  
      sp.ProdID = m.ProdID 
      AND sp.StockID = @StockID  
      AND sp.DocDate <= m.DocDate
  )*/

  /* Для каждого типа документа, для каждой смены, даты, RestShiftDocID,
  склада комплектующих, создадим комплектацию */
  DECLARE SRec CURSOR LOCAL FAST_FORWARD 
  FOR 
  SELECT DISTINCT
    DocCode, RestShiftChID, DocDate, RestShiftDocID, SubStockID, CodeID3
  FROM #StockSales
  ORDER BY 
    DocDate, SubStockID, RestShiftDocID, DocCode, CodeID3 DESC

  OPEN SRec
    FETCH NEXT FROM SRec   
    INTO  
      @DocCode, @ParentChID, @DocDate, @ParentDocID, @SubStockID, @CodeID3    
  WHILE @@FETCH_STATUS = 0
    BEGIN
      EXEC dbo.z_NewChID @TableName = t_SRec, @ChID = @ChID OUTPUT;
      EXEC dbo.z_NewDocID @DocCode = 11321, @TableName = t_SRec,
        @OurID = @OurID, @DocID = @DocID OUTPUT

      INSERT INTO dbo.t_SRec
      (
        ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, 
        CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, Notes, 
        SubDocDate, SubStockID, Value1, Value2, Value3, CurrID, 
        StateCode
      )
      SELECT
        @ChID, @DocID, @DocID, @DocDate, @KursMC, @OurID, @StockID, 
        0 CodeID1, 0 CodeID2, @CodeID3 AS CodeID3, 0 CodeID4, 0 CodeID5, @EmpID, 
        CASE 
          WHEN @DocCode = 11016 THEN dbo.zf_Translate('Списание') 
          ELSE ''
        END Notes, 
        @DocDate, @SubStockID, 0 Value1, 0 Value2, 0 Value3, @CurrID,
        0 StateCode

      /* Если используем смены, создадим связь с конкретной сменой */
      IF @UseRestShift = 1 AND @DocCode = 11035
        INSERT INTO z_DocLinks
        (
          ParentDocCode, ParentChID, ParentDocDate, ParentDocID, 
          ChildDocCode, ChildChID, ChildDocDate, ChildDocID
        )
        SELECT
          11060 ParentDocCode, @ParentChID, @DocDate, @ParentDocID, 
          11321 ChildDocCode, @ChID, @DocDate, @DocID   

      /* Для каждого товара создадим запись в комплектации,
      рассчитаем и занесём комплектующие */
      DECLARE SRecA CURSOR FAST_FORWARD LOCAL
      FOR 
        SELECT
          ProdID, Qty, UM 
        FROM #StockSales
        WHERE 
          DocCode = @DocCode
          AND RestShiftChID = @ParentChID
          AND DocDate = @DocDate
          AND SubStockID = @SubStockID
          AND CodeID3 = @CodeID3
        ORDER BY
          ProdID

      OPEN SRecA
        FETCH NEXT FROM SRecA
        INTO
          @ProdID, @Qty, @UM
      WHILE @@FETCH_STATUS = 0
        BEGIN 
          SELECT TOP 1
            @AChID = ISNULL(m.AChID + 1, c.ChStart)
          FROM zf_ChIDRange() c LEFT JOIN t_SRecA m 
          ON m.AChID BETWEEN c.ChStart AND c.ChEnd
          ORDER BY m.AChID DESC

          SELECT
            @SrcPosID = ISNULL(MAX(SrcPosID), 0) + 1
          FROM t_SRecA
          WHERE ChID = @ChID

          SELECT
            @BarCode = BarCode, 
            @PPID = 0
          FROM r_ProdMQ WITH (NOLOCK)
          WHERE 
            ProdID = @ProdID AND UM = @UM

          SELECT
            @PriceCC = 0
          SELECT
            @PriceCC = mp.PriceMC
          FROM r_ProdMP mp WITH (NOLOCK)
          WHERE
            PLID = @PLID AND ProdID = @ProdID

          INSERT INTO t_SRecA
          (
            ChID, SrcPosID, ProdID, PPID, UM, Qty, SetCostCC, 
            SetValue1, SetValue2, SetValue3, 
            PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, 
            Extra, PriceCC, NewPriceCC_nt, NewSumCC_nt, NewTax, 
            NewTaxSum, NewPriceCC_wt, NewSumCC_wt, 
            AChID, BarCode, SecID     
          )
          SELECT
            @ChID, @SrcPosID, @ProdID, @PPID, @UM, @Qty, 0 SetCostCC, 
            0 SetValue1, 0 SetValue2, 0 SetValue3, 
            0 PriceCC_nt, 0 SumCC_nt, 0 Tax, 0 TaxSum, 0 PriceCC_wt, 0 SumCC_wt, 
            0 Extra, @PriceCC, 0 NewPriceCC_nt, 0 NewSumCC_nt, 0 NewTax, 
            0 NewTaxSum, 0 NewPriceCC_wt, 0 NewSumCC_wt, 
            @AChID, @BarCode, 1 SecID

          /* Заполнение комплектующими, расчёт комплектов */
          EXECUTE t_SRecASpecCalc
            @OurID = @OurID, @StockID = @StockID, @SubStockID = @SubStockID, 
            @DocDate = @DocDate, @KursMC = @KursMC, @AChID = @AChID, 
            @ProdID = @ProdID, @PPID = @PPID OUTPUT, @Qty = @Qty, @CurrID = @CurrID

          FETCH NEXT FROM SRecA
          INTO
            @ProdID, @Qty, @UM
        END

      CLOSE SRecA
      DEALLOCATE SRecA

      /* Обновление партий в продаже товара */
      IF @DocCode = 11035
        BEGIN
          UPDATE m
          SET m.StateCode = 0 
          FROM t_Sale m
          INNER JOIN #SaleChs c ON m.ChID = c.ChID
          WHERE 
            m.StateCode <> 0 AND c.DocCode = @DocCode
            AND c.RestShiftChID = @ParentChID 
            AND c.DocDate = @DocDate
            AND m.CodeID3 = @CodeID3

          UPDATE d
          SET d.PPID = sa.PPID
          FROM t_Sale m WITH (NOLOCK)
          INNER JOIN #SaleChs c ON m.ChID = c.ChID
          INNER JOIN t_SaleD d
          ON m.ChID = d.ChID
          INNER JOIN t_SRecA sa WITH (NOLOCK)
          ON sa.ChID = @ChID AND d.ProdID = sa.ProdID
          WHERE 
            d.PPID <> sa.PPID AND c.DocCode = @DocCode
            AND c.RestShiftChID = @ParentChID 
            AND c.DocDate = @DocDate
            AND m.CodeID3 = @CodeID3

          UPDATE m
          SET m.StateCode = c.StateCode 
          FROM t_Sale m
          INNER JOIN #SaleChs c ON m.ChID = c.ChID
          WHERE 
            m.StateCode <> c.StateCode AND c.DocCode = @DocCode
            AND c.RestShiftChID = @ParentChID 
            AND c.DocDate = @DocDate
            AND m.CodeID3 = @CodeID3
        END

      /* Обновление партий в РДЦП */
      IF @DocCode = 11016
        BEGIN
          UPDATE m
          SET m.StateCode = 0 
          FROM t_Epp m
          INNER JOIN #SaleChs c ON m.ChID = c.ChID
          WHERE 
            m.StateCode <> 0 AND c.DocCode = @DocCode
            AND c.RestShiftChID = @ParentChID 
            AND c.DocDate = @DocDate
            AND m.CodeID3 = @CodeID3

          UPDATE d
          SET 
            d.PPID = sa.PPID, 
            d.PriceCC_nt = sa.PriceCC_nt, 
            d.SumCC_nt = sa.PriceCC_nt * d.Qty, 
            d.Tax = sa.Tax, 
            d.TaxSum = sa.Tax * d.Qty, 
            d.PriceCC_wt = sa.PriceCC_wt, 
            d.SumCC_wt = sa.PriceCC_wt * d.Qty
          FROM t_Epp m WITH (NOLOCK)
          INNER JOIN #SaleChs c ON m.ChID = c.ChID
          INNER JOIN t_EppD d
          ON m.ChID = d.ChID
          INNER JOIN t_SRecA sa WITH (NOLOCK)
          ON sa.ChID = @ChID AND d.ProdID = sa.ProdID
          WHERE 
            d.PPID <> sa.PPID AND c.DocCode = @DocCode
            AND c.RestShiftChID = @ParentChID 
            AND c.DocDate = @DocDate
            AND m.CodeID3 = @CodeID3

          UPDATE m
          SET m.StateCode = c.StateCode 
          FROM t_Epp m
          INNER JOIN #SaleChs c ON m.ChID = c.ChID
          WHERE 
            m.StateCode <> c.StateCode AND c.DocCode = @DocCode
            AND c.RestShiftChID = @ParentChID 
            AND c.DocDate = @DocDate
            AND m.CodeID3 = @CodeID3
        END

      FETCH NEXT FROM SRec   
      INTO  
        @DocCode, @ParentChID, @DocDate, @ParentDocID, @SubStockID, @CodeID3
    END
  CLOSE SRec
  DEALLOCATE SRec
END

GO
