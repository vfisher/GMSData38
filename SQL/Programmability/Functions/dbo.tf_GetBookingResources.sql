SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetBookingResources](@ChID bigint, @SrcPosID int, @StockID int)
/* Формирует список ресурсов, доступных для выбора */
RETURNS @out table(ResourceID int, ResourceName varchar(200), Available bit, Notes varchar(200))
BEGIN
  DECLARE @SrvcID INT
  DECLARE @BTime smalldatetime
  DECLARE @ETime smalldatetime  
  DECLARE @tmp table(ResourceID int, ResourceName varchar(200), Notes varchar(200))

  SELECT @SrvcID = d.SrvcID, @BTime = d.BTime, @ETime = d.ETime 
  FROM t_Booking m JOIN t_BookingD d ON m.ChID = d.ChID WHERE m.ChID = @ChID AND d.SrcPosID = @SrcPosID

  IF EXISTS (SELECT TOP 1 1 FROM r_Services WITH (NOLOCK) WHERE SrvcID = @SrvcID AND NeedResource = 0) 
    BEGIN
      INSERT INTO @out (ResourceID, ResourceName, Available, Notes)
      SELECT ResourceID, ResourceName, 1, '' FROM r_Resources WHERE ResourceID = 0
    END

  /* Выбор всех доступных ресурсов по складу, расписанию, услуге */
  INSERT INTO @tmp(ResourceID, ResourceName, Notes)
  SELECT DISTINCT m.ResourceID, m.ResourceName,
  CASE
    WHEN (@BTime < BTime) THEN 'Будет доступен через ' + dbo.zf_MinsToTime(DATEDIFF(mi, @BTime, BTime))
    WHEN (@BTime >= BTime AND @ETime > ETime) THEN 'Услуга на ' + dbo.zf_MinsToTime(DATEDIFF(mi, ETime, @ETime)) + ' превышает рабочее время ресурса'
    ELSE NULL 
  END AS Avail
  FROM r_Resources m WITH (NOLOCK)  
    JOIN r_ResourceSched d WITH (NOLOCK) ON m.ResourceID = d.ResourceID
    JOIN r_ResourceTypes t WITH (NOLOCK) ON m.ResourceTypeID = t.ResourceTypeID
    JOIN r_ServiceResources r WITH (NOLOCK) ON t.ResourceTypeID = r.ResourceTypeID 
  WHERE m.StockID = @StockID AND m.ResourceID > 0 AND r.SrvcID = @SrvcID
    AND dbo.zf_GetDate(@BTime) BETWEEN dbo.zf_GetDate(d.BTime) AND dbo.zf_GetDate(d.ETime)  /* фильтрация мастеров, доступных в текущий день */
    AND ((d.BTime <= @BTime AND d.ETime > @BTime) OR (@BTime <= d.BTime AND @ETime <= d.ETime))   
  ORDER BY Avail, m.ResourceName   

  DECLARE @AResourceID int 
  DECLARE @AResourceName varchar(200)
  DECLARE @ANotes varchar(200) 
  DECLARE @AMaxClients int
  DECLARE @AClientCount int
  DECLARE @AAvailable bit
  DECLARE @AChID bigint
  DECLARE @ASrcPosID int
  DECLARE @ABTime smalldatetime
  DECLARE @AETime smalldatetime

  /* в @tmp могут быть два варианта времени доступности ресурса, нужно выбрать более подходящий или вывести варианты изменения времени заявки */
  DECLARE ResCursor CURSOR FAST_FORWARD FOR
  SELECT ResourceID, ResourceName, Notes
  FROM @tmp

  OPEN ResCursor
  FETCH NEXT FROM ResCursor
  INTO @AResourceID, @AResourceName, @ANotes

  WHILE @@FETCH_STATUS = 0
    BEGIN
      IF NOT EXISTS (SELECT TOP 1 1 FROM @out WHERE ResourceID = @AResourceID)
        INSERT INTO @out (ResourceID, ResourceName, Notes, Available)
        VALUES (@AResourceID, @AResourceName, @ANotes, CASE WHEN @ANotes IS NULL THEN 1 ELSE 0 END)
      ELSE
        BEGIN
          SELECT @AAvailable = Available FROM @out WHERE ResourceID = @AResourceID
          /* Если ресурс был доступен ранее - ничего не обновляем */
          IF @AAvailable = 0
            UPDATE @out SET Notes = Notes + ' ' + @ANotes WHERE ResourceID = @AResourceID
        END     
      FETCH NEXT FROM ResCursor
      INTO @AResourceID, @AResourceName, @ANotes
    END
  CLOSE ResCursor
  DEALLOCATE ResCursor

   /* Обновление списка ресурсов в зависимости от существующих заявок */   
  DECLARE ResCursorServices CURSOR FAST_FORWARD FOR 
  SELECT DISTINCT bd.ChID, bd.SrcPosID, bd.BTime, bd.ETime, bd.ResourceID, r.MaxClients
  FROM t_BookingD bd
    JOIN t_Booking b ON bd.ChID = b.ChID
    JOIN t_Sale s ON b.DocChID = s.ChID
    JOIN t_SaleD sd ON s.ChID = sd.ChID AND bd.DetSrcPosID = sd.SrcPosID    
    JOIN r_Resources r ON bd.ResourceID = r.ResourceID
    JOIN @out o ON r.ResourceID = o.ResourceID    
  WHERE s.StockID = @StockID AND b.DocCode = 11035 AND o.Available = 1 AND o.ResourceID > 0 AND bd.ForRet = 0 AND
     ((bd.BTime BETWEEN @BTime AND DATEADD(mi, -1, @ETime)) OR (bd.ETime BETWEEN DATEADD(mi, 1, @BTime) AND @ETime))
  UNION ALL

  SELECT DISTINCT bd.ChID, bd.SrcPosID, bd.BTime, bd.ETime, bd.ResourceID, r.MaxClients
  FROM t_BookingD bd
    JOIN t_Booking b ON bd.ChID = b.ChID
    JOIN t_SaleTemp s ON b.DocChID = s.ChID
    JOIN t_SaleTempD sd ON s.ChID = sd.ChID AND bd.DetSrcPosID = sd.SrcPosID    
    JOIN r_Resources r ON bd.ResourceID = r.ResourceID
    JOIN @out o ON r.ResourceID = o.ResourceID    
  WHERE s.StockID = @StockID AND b.DocCode = 1011 AND o.Available = 1 AND o.ResourceID > 0 AND bd.ForRet = 0 AND
     ((bd.BTime BETWEEN @BTime AND DATEADD(mi, -1, @ETime)) OR (bd.ETime BETWEEN DATEADD(mi, 1, @BTime) AND @ETime))

  OPEN ResCursorServices
  FETCH NEXT FROM ResCursorServices 
  INTO @AChID, @ASrcPosID, @ABTime, @AETime, @AResourceID, @AMaxClients

  WHILE @@FETCH_STATUS = 0
    BEGIN
      IF NOT(@AChID = @ChID AND @ASrcPosID = @SrcPosID) /* исключаем из расчета собственную позицию */
        BEGIN            
          SELECT @AClientCount = dbo.tf_GetBookingResourceClientsCount(@AResourceID, @BTime, @ETime, @ChID, @SrcPosID)   
          IF (@AClientCount > 0 AND @AClientCount < @AMaxClients)
            UPDATE @Out SET Available = 1, Notes = 'Посетителей: ' + CAST(@AClientCount AS VARCHAR(10)) + '/' + CAST(@AMaxClients AS VARCHAR(10))
            WHERE ResourceID = @AResourceID
          ELSE          
            UPDATE @Out SET Available = 0, Notes = 'Будет доступен через ' + dbo.zf_MinsToTime(DATEDIFF(mi, @BTime, @AETime))
            WHERE ResourceID = @AResourceID  
        END

      FETCH NEXT FROM ResCursorServices 
      INTO @AChID, @ASrcPosID, @ABTime, @AETime, @AResourceID, @AMaxClients
    END

  CLOSE ResCursorServices
  DEALLOCATE ResCursorServices

  RETURN 
END
GO