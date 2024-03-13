SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetBookingExecutorID](@ChID bigINT, @SrcPosID INT)
/* Возвращает код исполнителя, по указанной заявке */
RETURNS INT AS
BEGIN
  DECLARE @DocCode int
  DECLARE @ExecutorID INT

  SELECT @DocCode = DocCode FROM t_Booking WHERE ChID = @ChID

  IF @DocCode = 1011  
    SELECT @ExecutorID = ex.ExecutorID 
    FROM t_Booking m 
      JOIN t_BookingD d ON m.ChID = d.ChID AND m.DocCode = 1011
      JOIN t_SaleTempD s ON m.DocChID = s.ChID AND d.DetSrcPosID = s.SrcPosID 
      JOIN r_Executors ex WITH (NOLOCK) ON s.EmpID = ex.EmpID
    WHERE 
      m.ChID = @ChID AND d.SrcPosID = @SrcPosID
  ELSE IF @DocCode = 11035
    SELECT @ExecutorID = ex.ExecutorID 
    FROM t_Booking m 
      JOIN t_BookingD d ON m.ChID = d.ChID AND m.DocCode = 11035
      JOIN t_SaleD s ON m.DocChID = s.ChID AND d.DetSrcPosID = s.SrcPosID 
      JOIN r_Executors ex WITH (NOLOCK) ON s.EmpID = ex.EmpID
    WHERE 
      m.ChID = @ChID AND d.SrcPosID = @SrcPosID
  RETURN @ExecutorID
END
GO
