SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_CheckBookingServicesCompatible](@ChID bigint, @SrvcID int, @BTime smalldatetime, @ETime smalldatetime, @ExcludeSrcPosID int)
AS
/* Проверяет совместимость пересекающихся по времени услуг в чеке */
BEGIN
  SET NOCOUNT ON
  DECLARE @Msg varchar(250)
  IF @ExcludeSrcPosID > 0
    SELECT @Msg = 'Невозможно изменить параметры услуги, т.к. ее время пересекается с другими несовместимыми услугами.'
  ELSE
    SELECT @Msg = 'Невозможно добавить услугу, т.к. ее время пересекается с другими несовместимыми услугами.'

  IF EXISTS (
    SELECT TOP 1 1 FROM t_BookingD m
    WHERE m.ChID = @ChID AND 
      ((@ExcludeSrcPosID > 0 AND m.SrcPosID <> @ExcludeSrcPosID) OR (@ExcludeSrcPosID <= 0)) AND
      (@ETime >= DATEADD(mi, 1, m.BTime) AND @BTime < m.ETime) AND
      (NOT EXISTS (SELECT TOP 1 1 FROM r_ServiceCompatibility d WITH (NOLOCK) WHERE d.SrvcID = @SrvcID AND d.CompatibleServiceID = m.SrvcID) AND 
       NOT EXISTS (SELECT TOP 1 1 FROM r_ServiceCompatibility d WITH (NOLOCK) WHERE d.CompatibleServiceID = @SrvcID AND d.SrvcID = m.SrvcID))	
    ) RAISERROR (@Msg, 16, 1)    
END
GO
