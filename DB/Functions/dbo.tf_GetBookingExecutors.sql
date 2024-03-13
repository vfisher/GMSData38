SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetBookingExecutors](@ChID bigint, @SrcPosID int, @StockID int)
/* Формирует список исполнителей, доступных для выбора */
RETURNS @out table(ExecutorID int, ExecutorName varchar(200), Available bit, Notes varchar(200))
BEGIN
  DECLARE @SrvcID INT
  DECLARE @BTime smalldatetime
  DECLARE @ETime smalldatetime
  DECLARE @tmp table(ExecutorID int, ExecutorName varchar(200), Notes varchar(200))

  SELECT @SrvcID = d.SrvcID, @BTime = d.BTime, @ETime = d.ETime 
  FROM t_Booking m JOIN t_BookingD d ON m.ChID = d.ChID WHERE m.ChID = @ChID AND d.SrcPosID = @SrcPosID

  IF EXISTS (SELECT TOP 1 1 FROM r_Services WITH(NOLOCK) WHERE SrvcID = @SrvcID AND NeedExecutor = 0) 
    BEGIN
      INSERT INTO @out (ExecutorID, ExecutorName, Notes, Available)
      SELECT ExecutorID, ExecutorName, '', 1 FROM r_Executors WHERE ExecutorID = 0
    END

  /* Выборка служащих в зависимости от их расписания */  
  INSERT INTO @tmp(ExecutorID, ExecutorName, Notes) 
  SELECT m.ExecutorID, m.ExecutorName,
  CASE 
    WHEN (@BTime < BTime) THEN 'Будет доступен через ' + dbo.zf_MinsToTime(DATEDIFF(mi, @BTime, BTime))
    WHEN (@BTime >= BTime AND @ETime > ETime) THEN 'Услуга на ' + dbo.zf_MinsToTime(DATEDIFF(mi, ETime, @ETime)) + ' превышает рабочее время мастера'
    ELSE NULL 
  END AS Avail 
  FROM r_Executors m WITH (NOLOCK) 
    JOIN r_ExecutorShifts d WITH (NOLOCK) ON m.ExecutorID = d.ExecutorID
    JOIN r_ExecutorServices es WITH (NOLOCK) ON m.ExecutorID = es.ExecutorID
  WHERE d.StockID = @StockID AND es.SrvcID = @SrvcID 
    AND dbo.zf_GetDate(@BTime) BETWEEN dbo.zf_GetDate(d.BTime) AND dbo.zf_GetDate(d.ETime) /* фильтрация мастеров, доступных в текущий день */
    AND ((d.BTime <= @BTime AND d.ETime > @BTime) OR (@BTime <= d.BTime AND @ETime <= d.ETime))   
  ORDER BY Avail, m.ExecutorName

  DECLARE @AExecutorID int
  DECLARE @AExecutorName varchar(200)
  DECLARE @ANotes varchar(200)
  DECLARE @AAvailable bit
  DECLARE @AChID bigint
  DECLARE @ASrcPosID int
  DECLARE @ABTime smalldatetime
  DECLARE @AETime smalldatetime
  DECLARE @AClientCount int
  DECLARE @AMaxClients int

  DECLARE ExCursor CURSOR FAST_FORWARD FOR
  SELECT ExecutorID, ExecutorName, Notes
  FROM @tmp

  /* в @tmp могут быть два варианта времени доступности мастера, нужно выбрать более подходящий или вывести варианты изменения времени заявки */ 
  OPEN ExCursor
  FETCH NEXT FROM ExCursor
  INTO @AExecutorID, @AExecutorName, @ANotes
  WHILE @@FETCH_STATUS = 0
    BEGIN
      IF NOT EXISTS (SELECT TOP 1 1 FROM @out WHERE ExecutorID = @AExecutorID)
        INSERT INTO @out (ExecutorID, ExecutorName, Notes, Available )
        VALUES (@AExecutorID, @AExecutorName, @ANotes, CASE WHEN @ANotes IS NULL THEN 1 ELSE 0 END)
      ELSE
        BEGIN
          SELECT @AAvailable = Available FROM @out WHERE ExecutorID = @AExecutorID
      /* Если мастер был доступен ранее - ничего не обновляем */
      IF @AAvailable = 0
        UPDATE @out SET Notes = Notes + ' ' + @ANotes WHERE ExecutorID = @AExecutorID
      END     
      FETCH NEXT FROM ExCursor
      INTO @AExecutorID, @AExecutorName, @ANotes
    END
  CLOSE ExCursor
  DEALLOCATE ExCursor  

  /* Обновление списка мастеров в зависимости от существующих заявок */
  DECLARE ExCursorServices CURSOR FAST_FORWARD FOR 
  SELECT DISTINCT bd.ChID, bd.SrcPosID, bd.BTime, bd.ETime, ex.ExecutorID, es.MaxClients
  FROM t_BookingD bd
    JOIN t_Booking b ON bd.ChID = b.ChID
    JOIN t_Sale s ON b.DocChID = s.ChID
    JOIN t_SaleD sd ON s.ChID = sd.ChID AND bd.DetSrcPosID = sd.SrcPosID    
    JOIN r_Executors ex WITH (NOLOCK) ON sd.EmpID = ex.EmpID
    JOIN r_ExecutorServices es WITH (NOLOCK) ON ex.ExecutorID = es.ExecutorID AND es.SrvcID = @SrvcID
    JOIN @out o ON ex.ExecutorID = o.ExecutorID    
  WHERE s.StockID = @StockID AND b.DocCode = 11035 AND o.Available = 1 AND o.ExecutorID > 0 AND bd.ForRet = 0 AND
     ((bd.BTime BETWEEN @BTime AND DATEADD(mi, -1, @ETime)) OR (bd.ETime BETWEEN DATEADD(mi, 1, @BTime) AND @ETime))
  UNION ALL

  SELECT DISTINCT bd.ChID, bd.SrcPosID, bd.BTime, bd.ETime, ex.ExecutorID, es.MaxClients
  FROM t_BookingD bd
    JOIN t_Booking b ON bd.ChID = b.ChID
    JOIN t_SaleTemp s ON b.DocChID = s.ChID
    JOIN t_SaleTempD sd ON s.ChID = sd.ChID AND bd.DetSrcPosID = sd.SrcPosID    
    JOIN r_Executors ex WITH (NOLOCK) ON sd.EmpID = ex.EmpID
    JOIN r_ExecutorServices es WITH (NOLOCK) ON ex.ExecutorID = es.ExecutorID AND es.SrvcID = @SrvcID
    JOIN @out o ON ex.ExecutorID = o.ExecutorID
  WHERE s.StockID = @StockID AND b.DocCode = 1011 AND o.Available = 1 AND o.ExecutorID > 0 AND bd.ForRet = 0 AND
    ((bd.BTime BETWEEN @BTime AND DATEADD(mi, -1, @ETime)) OR (bd.ETime BETWEEN DATEADD(mi, 1, @BTime) AND @ETime))

  OPEN ExCursorServices
  FETCH NEXT FROM ExCursorServices 
  INTO @AChID, @ASrcPosID, @ABTime, @AETime, @AExecutorID, @AMaxClients

  WHILE @@FETCH_STATUS = 0
    BEGIN
      IF NOT(@AChID = @ChID AND @ASrcPosID = @SrcPosID) /* исключаем из расчета собственную позицию */
        BEGIN            
          SELECT @AClientCount = dbo.tf_GetBookingExecutorClientsCount(@AExecutorID, @BTime, @ETime, @ChID, @SrcPosID)   
          IF (@AClientCount > 0 AND @AClientCount < @AMaxClients)
            UPDATE @Out SET Available = 1, Notes = 'Посетителей: ' + CAST(@AClientCount AS VARCHAR(10)) + '/' + CAST(@AMaxClients AS VARCHAR(10))
            WHERE ExecutorID = @AExecutorID   
          ELSE          
            UPDATE @Out SET Available = 0, Notes = 'Будет доступен через ' + dbo.zf_MinsToTime(DATEDIFF(mi, @BTime, @AETime))
            WHERE ExecutorID = @AExecutorID
        END

      FETCH NEXT FROM ExCursorServices 
      INTO @AChID, @ASrcPosID, @ABTime, @AETime, @AExecutorID, @AMaxClients
    END

  CLOSE ExCursorServices
  DEALLOCATE ExCursorServices

  RETURN
END
GO
