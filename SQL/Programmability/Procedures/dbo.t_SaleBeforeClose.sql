SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleBeforeClose](@ChID bigint)
AS
BEGIN
  DECLARE @ProdID INT
  DECLARE @SrcPosID INT
  DECLARE @CSrcPosID INT
  DECLARE @Qty NUMERIC(21, 9)
  DECLARE @NewQty NUMERIC(21, 9)  
  DECLARE @PurPriceCC_wt NUMERIC(21, 9)
  DECLARE @Coeff NUMERIC(21, 9)
  DECLARE @NewSrcPosID INT
  DECLARE @NewLogID INT  
  DECLARE @DBiID INT 

  DECLARE @LogID int
  DECLARE @DiscCode int
  DECLARE @SumBonus NUMERIC(21, 9)
  DECLARE @TempSumBonus NUMERIC(21, 9)
  DECLARE @DCardID varchar(250)
  DECLARE @Remainder int

  SET NOCOUNT ON

  IF NOT EXISTS(SELECT * FROM z_Vars WHERE Varname = 't_SaleRoundDiscCode' AND VarValue <> '-1')
    BEGIN 
      SELECT 1 WHERE 1 = 0 
      RETURN
    END

  IF NOT EXISTS (SELECT * FROM t_SaleTempD AS tstd WHERE ChID = @ChID GROUP BY ChID HAVING SUM(SumCC_wt) > 0)
    BEGIN 
      SELECT 1 WHERE 1 = 0 
      RETURN
    END

  SELECT @DBiID = CAST(ISNULL(dbo.zf_Var('OT_DBiID'), 0) AS INT)

  DECLARE @oddMoneyProdID integer
  SELECT @oddMoneyProdID = VarValue 
  FROM z_Vars
  WHERE VarName = 't_SaleProcessingOddMoneyProdID'

  /* Выбираем все товары, которые не по 1 шт с учетом отмен */
  DECLARE ChequeCur CURSOR LOCAL FAST_FORWARD FOR
  SELECT MIN(CSrcPosID) AS CSrcPosID, ProdID, MIN(PurPriceCC_wt) FROM
  (  
    SELECT CSrcPosID, ProdID, SUM(Qty) Qty, PurPriceCC_wt
    FROM t_SaleTempD d
    WHERE ChID = @ChID 
          AND (ProdID NOT IN (SELECT ProdID 
                              FROM t_SaleTempD 
                              WHERE ChID = @ChID AND (QTY = 1 OR Qty = -1)
                              GROUP BY CSrcPosID, ProdID
                              HAVING SUM(Qty) > 0)
/* Внимание!!! Внимание!!! Внимание!!! На ЕВах не комментировать этот блок! У них нет весовых товаров и все ок. */
/* Данное условие убрано в связи с нерешенной проблемой бесконечного разложения весовых товаров (Qty х.412 Price 9.60) с суммовой скидкой */
/* можно добавить чудо условия проверки, нет ли такого товара с кол-вом 1, но это не решит проблему +- копеек для раскладываемого товара */
/*               OR /* Расширяем позициями с глюкавыми акциями */
          (SrcPosID IN (SELECT DISTINCT e.SrcPosID
                              FROM t_LogDiscExp e 
                              JOIN t_LogDiscExpP p ON e.SrcPosID = p.SrcPosID AND e.DiscCode = p.DiscCode AND e.DocCode = p.DocCode AND e.ChID = p.ChID AND e.DCardChID = p.DCardChID
                              WHERE e.DocCode = 1011 AND e.ChID = @ChID AND e.SumBonus > 0
                              GROUP BY e.SrcPosID, e.DiscCode
                              HAVING SUM(e.SumBonus) <> SUM(p.SumBonus))
          )
*/          
              )
          AND (ProdID <> @oddMoneyProdID OR @oddMoneyProdID IS NULL) /* Блокируем скринькотовар */
    GROUP BY CSrcPosID, ProdID, PurPriceCC_wt     
  ) a
  WHERE Qty > 0
  GROUP BY ProdID  

  IF OBJECT_ID('tempdb..#TempSaleD') IS NOT NULL
    DROP TABLE #TempSaleD
  IF OBJECT_ID('tempdb..#__TempSaleD') IS NOT NULL
    DROP TABLE #__TempSaleD
  IF OBJECT_ID('tempdb..#TempRec') IS NOT NULL
    DROP TABLE #TempRec
  IF OBJECT_ID('tempdb..#TempExp') IS NOT NULL
    DROP TABLE #TempExp

  SELECT * INTO #TempSaleD FROM t_SaleTempD WHERE 0 = 1
  SELECT * INTO #__TempSaleD FROM t_SaleTempD WHERE 0 = 1
  SELECT * INTO #TempRec FROM t_LogDiscRec WHERE 0 = 1
  SELECT * INTO #TempExp FROM t_LogDiscExp WHERE 0 = 1

  /* Вместо эксклюзивных блокировок на таблицы */
  SET XACT_ABORT ON
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
  BEGIN TRAN

  OPEN ChequeCur
  IF @@ERROR <> 0 GOTO Error

  FETCH NEXT FROM ChequeCur
  INTO @CSrcPosID, @ProdID, @PurPriceCC_wt
  WHILE @@FETCH_STATUS = 0
    BEGIN
      SELECT @Qty = SUM(Qty), @NewQty = SUM(Qty) - 1
      FROM t_SaleTempD 
      WHERE ChID = @ChID AND SrcPosID = @CSrcPosID
      HAVING SUM(Qty) > 0

      IF @NewQty > 0 /* Есть что разделять */
        BEGIN
          INSERT INTO #TempSaleD
          SELECT * FROM t_SaleTempD WHERE ChID = @ChID AND SrcPosID = @CSrcPosID

/*           UPDATE #TempSaleD 
          SET
            Qty = Qty - 1
          WHERE SrcPosID = @CSrcPosID */

          INSERT INTO #__TempSaleD
          SELECT *  FROM t_SaleTempD WHERE ChID = @ChID AND SrcPosID = @CSrcPosID

          SELECT @NewSrcPosID = MAX(SrcPosID) 
          FROM t_SaleTempD d
          WHERE ChID = @ChID          

          SELECT @NewSrcPosID = CASE WHEN @NewSrcPosID > MAX(d.SrcPosID) THEN @NewSrcPosID + 1 ELSE MAX(d.SrcPosID) + 1 END
          FROM #TempSaleD d
          WHERE ChID = @ChID          

          /*PRINT @NewSrcPosID */

          UPDATE #__TempSaleD 
          SET
            Qty = 1,            
            SrcPosID = @NewSrcPosID,
            CSrcPosID = @NewSrcPosID,
            PurSumCC_wt = PurPriceCC_wt,
            SumCC_wt = PriceCC_wt
          WHERE SrcPosID = @CSrcPosID

          INSERT INTO #TempSaleD
          SELECT * FROM #__TempSaleD    
          UPDATE #TempSaleD 
          SET
            Qty = Qty - 1
          WHERE SrcPosID = @CSrcPosID AND ChID = @ChID  

          UPDATE t_SaleTempD 
          SET
            Qty = Qty - 1,
            PurSumCC_wt = dbo.zf_RoundPriceSale((Qty - 1)*PurPriceCC_wt),
            SumCC_wt = dbo.zf_RoundPriceSale((Qty - 1)*PriceCC_wt)
          WHERE SrcPosID = @CSrcPosID AND ChID = @ChID        


          INSERT INTO t_SaleTempD
          SELECT * FROM #__TempSaleD 

          SELECT @NewLogID = MAX(LogID) + 1
          FROM t_LogDiscRec d
          WHERE DBiID = @DBiID         

          /* начисления - списания */
          INSERT INTO #TempRec
                  ( LogID ,
                    TempBonus ,
                    DocCode ,
                    ChID ,
                    SrcPosID ,
                    DiscCode ,
                    SumBonus ,
                    LogDate ,
                    BonusType ,
                    SaleSrcPosID ,
                    DBiID ,
                    DCardChID
                  )
          SELECT @NewLogID + (SELECT COUNT(1)
                              FROM t_LogDiscRec d1
                              WHERE d.DocCode = d1.DocCode AND
                                    d.ChID = d1.ChID AND 
                                    d.SrcPosID = d1.SrcPosID AND 
                                    d1.LogID < d.LogID AND 
                                    DBiID = @DBiID                               
                             ),
                 d.TempBonus, d.DocCode, d.ChID, @NewSrcPosID, DiscCode, dbo.zf_RoundPriceSale(d.SumBonus/@Qty), LogDate, BonusType, SaleSrcPosID, DBiID, DCardChID 
          FROM t_LogDiscRec d
          WHERE DocCode = 1011 AND d.ChID = @ChID AND d.SrcPosID = @CSrcPosID AND DBiID = @DBiID               

          UPDATE t_LogDiscRec
          SET SumBonus = dbo.zf_RoundPriceSale(SumBonus*@NewQty/@Qty)
          WHERE DocCode = 1011 AND ChID = @ChID AND SrcPosID = @CSrcPosID AND DBiID = @DBiID                       

          INSERT INTO t_LogDiscRec(LogID, TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, LogDate, BonusType, SaleSrcPosID, DBiID, DCardChID)
          SELECT LogID, TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, LogDate, BonusType, SaleSrcPosID, DBiID, DCardChID FROM #TempRec

          /* Списания */
          /* Нужно не потерять копейку */
          /* Два немного разных алгоритма для весовых и невесовых товаров (не целое кол-во) */
          SELECT @NewLogID = MAX(LogID) + 1
          FROM t_LogDiscExp d
          WHERE DBiID = @DBiID         
          IF dbo.zf_Round(@NewQty, 1) = dbo.zf_Round(@NewQty, 0.001)
            BEGIN
              INSERT INTO #TempExp
                  ( LogID,
                  TempBonus,
                  DocCode,
                  ChID,
                  SrcPosID,
                  DiscCode,
                  SumBonus,
                  Discount,
                  LogDate,
                  BonusType,
                  GroupSumBonus,
                  GroupDiscount,
                  DBiID,
                  DCardChID,
                  IsManualSeldisc
                  )

              SELECT @NewLogID + (SELECT COUNT(1)
                        FROM t_LogDiscExp d1
                        WHERE d.DocCode = d1.DocCode AND
                          d.ChID = d1.ChID AND 
                          d.SrcPosID = d1.SrcPosID AND 
                          d1.LogID < d.LogID AND 
                          DBiID = @DBiID                               
                       ),
                 TempBonus, DocCode, ChID, @NewSrcPosID, DiscCode, dbo.zf_RoundPriceSale(d.SumBonus/@Qty + 0.01*(CAST( dbo.zf_RoundPriceSale(SumBonus*@NewQty/@Qty)*100 AS INT) % CAST(@NewQty AS INT))), 
                 Discount, LogDate, BonusType, GroupSumBonus, GroupDiscount, DBiID, DCardChID, IsManualSeldisc
              FROM t_LogDiscExp d
              WHERE DocCode = 1011 AND d.ChID = @ChID AND d.SrcPosID = @CSrcPosID AND DBiID = @DBiID               

              UPDATE t_LogDiscExp
              SET SumBonus = dbo.zf_RoundPriceSale(SumBonus*@NewQty/@Qty - 0.01*(CAST( dbo.zf_RoundPriceSale(SumBonus*@NewQty/@Qty)*100 AS INT) % CAST(@NewQty AS INT))) 
              WHERE DocCode = 1011 AND ChID = @ChID AND SrcPosID = @CSrcPosID AND DBiID = @DBiID
            END
          ELSE
            BEGIN
              /* Для корректного разложения предоставленной скидки на 2 позиции для случаев, когда она нормально не раскладывается (5.412 по цене 9.60 скидка 4.72)
                 мы посчитаем сначала сумму бонусов, которая реально применится на позицию без дробных частей, а потом используем ее для остатка, а на 
                 единицу товара предоставим уже разницу между SumBonus и реально предоставленной скидкой. Это избавит нас от несоответстия по копейкам 
                 реальной и желаемой скидки
              */
              INSERT INTO #TempExp
                  ( LogID,
                  TempBonus,
                  DocCode,
                  ChID,
                  SrcPosID,
                  DiscCode,
                  SumBonus,
                  Discount,
                  LogDate,
                  BonusType,
                  GroupSumBonus,
                  GroupDiscount,
                  DBiID,
                  DCardChID,
                  IsManualSeldisc
                  )
              SELECT @NewLogID + (SELECT COUNT(1)
                        FROM t_LogDiscExp d1
                        WHERE d.DocCode = d1.DocCode AND
                          d.ChID = d1.ChID AND 
                          d.SrcPosID = d1.SrcPosID AND 
                          d1.LogID < d.LogID AND 
                          DBiID = @DBiID                               
                       ),
                 TempBonus, DocCode, ChID, @NewSrcPosID, DiscCode,
                 d.SumBonus - dbo.zf_RoundPriceSale((@PurPriceCC_wt*@NewQty) - dbo.zf_RoundPriceSale(((@PurPriceCC_wt*@NewQty)/*PurSum*/-(d.SumBonus/@Qty*@NewQty)/*сумма на остаток кол-ва*/)/@NewQty)/*Новая цена*/*@NewQty)                 
                 ,Discount, LogDate, BonusType, GroupSumBonus, GroupDiscount, DBiID, DCardChID, IsManualSeldisc
              FROM t_LogDiscExp d
              WHERE DocCode = 1011 AND d.ChID = @ChID AND d.SrcPosID = @CSrcPosID AND DBiID = @DBiID               

              UPDATE t_LogDiscExp
              SET SumBonus =
                dbo.zf_RoundPriceSale((@PurPriceCC_wt*@NewQty) - dbo.zf_RoundPriceSale(((@PurPriceCC_wt*@NewQty)/*PurSum*/-(SumBonus/@Qty*@NewQty)/*сумма на остаток кол-ва*/)/@NewQty)/*Новая цена*/*@NewQty)
              WHERE DocCode = 1011 AND ChID = @ChID AND SrcPosID = @CSrcPosID AND DBiID = @DBiID              
            END                         

          INSERT INTO t_LogDiscExp(LogID,TempBonus,DocCode,ChID,SrcPosID,DiscCode,SumBonus,Discount,LogDate,BonusType,GroupSumBonus,GroupDiscount,DBiID,DCardChID,IsManualSeldisc)
          SELECT LogID,TempBonus,DocCode,ChID,SrcPosID,DiscCode,SumBonus,Discount,LogDate,BonusType,GroupSumBonus,GroupDiscount,DBiID,DCardChID,IsManualSeldisc
          FROM #TempExp

          DELETE FROM #TempRec
          DELETE FROM #TempExp
          DELETE FROM #__TempSaleD
        END /* IF @NewQty > 0 */

      FETCH NEXT FROM ChequeCur
      INTO @CSrcPosID, @ProdID, @PurPriceCC_wt
    END

  CLOSE ChequeCur
  DEALLOCATE ChequeCur  

  SELECT * FROM #TempSaleD

  COMMIT    
  RETURN
Error:
  SELECT * FROM #TempSaleD WHERE 1=0
  ROLLBACK  
END
GO