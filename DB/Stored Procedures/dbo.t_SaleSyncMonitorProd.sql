SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSyncMonitorProd](@DocCode int, @ChID bigint, @SrcPosID int, @WPID int, @InitQueueTime bit)
AS
/* Заполняет и обновляет таблицу данных монитора заказов */
BEGIN
  SET NOCOUNT ON
  DECLARE @Qty numeric(21, 9), @CurrOrderQty numeric(21, 9), @TempQty numeric(21, 9)
  DECLARE @IsDecQty bit
  DECLARE @UM varchar(50)
  DECLARE @ProdID int, @CSrcPosID int
  DECLARE @CreateTime datetime, @QueueTime datetime

  /* Аннуляция всего чека */
  IF @SrcPosID = -1
    BEGIN
      UPDATE t_OrderMonitorsTemp SET DocCode = 0, Qty = 0 WHERE DocCode = @DocCode AND DocChID = @ChID AND WPID = @WPID
      RETURN
    END

  SELECT @CreateTime = GETDATE()
  IF ISNULL(@InitQueueTime, 0) = 1
    SELECT @QueueTime = @CreateTime
  ELSE
  SELECT @QueueTime = NULL

  SELECT @ProdID = m.ProdID, @IsDecQty = d.IsDecQty, @UM = m.UM, @CSrcPosID = CSrcPosID FROM t_SaleTempD m
    JOIN r_Prods d WITH (NOLOCK) ON m.ProdID = d.ProdID
  WHERE m.ChID = @ChID AND SrcPosID = @SrcPosID

  SELECT @Qty = SUM(Qty) FROM t_SaleTempD WHERE ChID = @ChID AND CSrcPosID = @CSrcPosID

  SELECT @CurrOrderQty = SUM(Qty) FROM t_OrderMonitorsTemp
  WHERE DocCode = @DocCode AND DocChID = @ChID AND WPID = @WPID AND SaleSrcPosID = @CSrcPosID

  /* Вставка новой записи */
  IF @Qty >= 0
    BEGIN
      /* Если это необязательный модификатор-товар, то не добавдяем его в таблицу монитора */
      IF (@DocCode = 1011) AND NOT EXISTS(SELECT TOP 1 1 FROM t_SaleTempM m
                                            JOIN r_Mods d ON m.ModCode = d.ModCode
                                          WHERE m.ChID = @ChID AND m.SaleSrcPosID = @SrcPosID AND d.Required = 0)
        BEGIN
          SELECT @TempQty = ISNULL(@CurrOrderQty, 0)

          /* Если это не дробный товар, то раскладываем его отдельные позиции по-одному */
          IF @IsDecQty = 0
            BEGIN
              /* Если увеличили количество */
              IF @TempQty < @Qty
                WHILE @TempQty < @Qty
                  BEGIN
                    INSERT INTO t_OrderMonitorsTemp (DocCode, DocChID, SaleSrcPosID, CreateTime, QueueTime, ProdID, UM, Qty, WPID, StateCode, Suspended, ServingID, ServingTime)
                    SELECT @DocCode, @ChID, @SrcPosID, @CreateTime, @QueueTime, ProdID, UM, 1, @WPID, 0, 0, ServingID, ServingTime FROM t_SaleTempD WHERE ChID = @ChID AND SrcPosID = @SrcPosID
                    SELECT @TempQty = @TempQty + 1
                  END
              ELSE IF @TempQty > @Qty /* Если уменьшили количество */
                UPDATE t_OrderMonitorsTemp SET Qty = 0
                WHERE LogIDEx IN (
                  SELECT TOP (CONVERT(int, (@TempQty - @Qty))) LogIDEx
                  FROM t_OrderMonitorsTemp
                  WHERE DocCode = @DocCode AND DocChID = @ChID AND SaleSrcPosID = @SrcPosID AND Qty > 0 AND WPID = @WPID
                  ORDER BY LogIDEx DESC )
            END
          ELSE /* Простой апдейт\инсерт для весовых товаров */
            BEGIN
              IF @CurrOrderQty IS NULL
                INSERT INTO t_OrderMonitorsTemp (DocCode, DocChID, SaleSrcPosID, CreateTime, QueueTime, ProdID, UM, Qty, WPID, StateCode, Suspended, ServingID, ServingTime)
                SELECT @DocCode, @ChID, @SrcPosID, @CreateTime, @QueueTime, ProdID, UM, Qty, @WPID, 0, 0, ServingID, ServingTime FROM t_SaleTempD WHERE ChID = @ChID AND SrcPosID = @SrcPosID
              ELSE
                UPDATE t_OrderMonitorsTemp SET Qty = @Qty WHERE DocCode = @DocCode AND DocChID = @ChID AND ProdID = @ProdID AND UM = @UM AND WPID = @WPID
            END
        END
    END
  ELSE /* @Qty < 0 - отмена позиции */
    BEGIN
      IF @IsDecQty = 0
        BEGIN
          UPDATE t_OrderMonitorsTemp SET Qty = 0
          WHERE LogIDEx IN (
            SELECT TOP (CONVERT(int, ABS(@Qty))) LogIDEx
            FROM t_OrderMonitorsTemp
            WHERE DocCode = 1011 AND DocChID = @ChID AND SaleSrcPosID = @CSrcPosID AND Qty > 0 AND WPID = @WPID
            ORDER BY LogIDEx DESC )
        END
      ELSE
        UPDATE t_OrderMonitorsTemp SET Qty = @CurrOrderQty + @Qty WHERE DocCode = 1011 AND DocChID = @ChID AND SaleSrcPosID = @CSrcPosID AND WPID = @WPID
    END

  /* Удаление заказов, которые были поданы */ 
  DELETE d 
  FROM t_SaleTempD m JOIN t_OrderMonitorsTemp d ON m.ChID = d.DocChID AND m.SrcPosID = d.SaleSrcPosID
  WHERE m.ChID = @ChID AND d.WPID = @WPID AND d.DocCode = @DocCode AND m.PosStatus = 3

  /* Обновляем информацию о модификаторах */
  IF @DocCode = 1011
    BEGIN
      DECLARE @ASrcPosID int
      DECLARE modsCursor CURSOR FAST_FORWARD FOR
      SELECT DISTINCT m.SrcPosID FROM t_SaleTempD m
        LEFT JOIN t_SaleTempM d ON m.ChID = d.ChID AND m.SrcPosID = d.SrcPosID
      ORDER BY m.SrcPosID

      OPEN modsCursor
      FETCH NEXT FROM modsCursor
      INTO @ASrcPosID

      WHILE @@FETCH_STATUS = 0
        BEGIN
          UPDATE t_OrderMonitorsTemp
          SET Notes = NULLIF(dbo.tf_GetProdModsStr(1011, @ChID, @ASrcPosID), '') WHERE LogIDEx = (
            SELECT TOP 1 LogIDEx
            FROM t_OrderMonitorsTemp
            WHERE DocCode = 1011 AND DocChID = @ChID AND SaleSrcPosID = @ASrcPosID AND WPID = @WPID AND Qty > 0
            ORDER BY LogIDEx )

          IF @@ERROR <> 0 GOTO Error

          FETCH NEXT FROM modsCursor INTO @ASrcPosID
        END
      CLOSE modsCursor
      DEALLOCATE modsCursor

      RETURN
    Error:
      CLOSE modsCursor
      DEALLOCATE modsCursor
   END
END
GO
