SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_UpdateClosedBookingPos](@ChID bigint, @SrcPosID int, @ResourceID int, @ExecutorID int, @BTime smalldatetime, @ETime smalldatetime)
AS
/* Обновляет информацию в закрытых заявках */
BEGIN
  DECLARE @SrvcID int
  DECLARE @SaleChID bigint
  DECLARE @EmpID int 
  DECLARE @BookingOpenWorkHours int

  SELECT @SaleChID = DocChID FROM t_Booking WHERE ChID = @ChID 
  IF @SaleChID IS NULL
    BEGIN
      RAISERROR('Не найдена закрытая заявка в таблице продаж.', 16, 1)
      RETURN
    END   

  SELECT @BookingOpenWorkHours = dbo.zf_Var('t_BookingOpenWorkHours')  
  IF @BTime < DATEADD(hh, -@BookingOpenWorkHours, GETDATE())
    BEGIN
      RAISERROR('Указанное время услуги выходит за пределы допустимого периода.', 16, 1)
      RETURN    
    END

  SELECT @SrvcID = SrvcID  FROM t_BookingD WITH (NOLOCK) WHERE ChID = @ChID AND SrcPosID = @SrcPosID    
  EXEC t_CheckBookingServicesCompatible @ChID, @SrvcID, @BTime, @ETime, @SrcPosID
  IF @@ERROR <> 0 RETURN  

  SELECT @EmpID = EmpID FROM r_Executors WITH (NOLOCK) WHERE ExecutorID = @ExecutorID

  BEGIN TRAN
    UPDATE t_BookingD SET ResourceID = @ResourceID, BTime = @BTime, ETime = @ETime WHERE ChID = @ChID AND SrcPosID = @SrcPosID

    UPDATE t_SaleD SET EmpID = @EmpID
    FROM t_Booking b 
      JOIN t_BookingD bd ON b.ChID = bd.ChID
      JOIN t_Sale s ON b.DocCode = 11035 AND b.DocChID = s.ChID 
      JOIN t_SaleD sd ON s.ChID = sd.ChID AND bd.DetSrcPosID = sd.SrcPosID
    WHERE bd.ChID = @ChID AND bd.SrcPosID = @SrcPosID

    IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRAN
        RETURN
      END

  COMMIT TRAN
END
GO