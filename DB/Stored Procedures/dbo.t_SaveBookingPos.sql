SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaveBookingPos](
  @SrcPosID int,
  @ChID bigint,
  @SrvcID int,
  @ResourceID int,
  @BTime smalldatetime,
  @ETime smalldatetime,
  @DetSrcPosID int,
  @ForRet bit,
  @WPID int)
AS
/* Сохраняет информацию о заявке */ 
BEGIN
  IF NOT EXISTS (SELECT TOP 1 1 FROM r_Services WITH(NOLOCK) WHERE SrvcID = @SrvcID) RETURN 

  DECLARE @BookingOpenWorkHours int

  SELECT @BookingOpenWorkHours = d.BookingOpenWorkHours FROM r_WPS m
    JOIN r_WPRoles d ON m.WPRoleID = d.WPRoleID
  WHERE m.WPID = @WPID
  IF @ForRet = 0 AND @BTime < DATEADD(hh, -@BookingOpenWorkHours, GETDATE())
    BEGIN
      BEGIN

      DECLARE @Error_msg1 varchar(2000) = dbo.zf_Translate('Указанное время услуги находится за пределами открытого периода. Измените время услуги.')

      RAISERROR(@Error_msg1, 16, 1)
      END

      RETURN     
    END

  IF @SrcPosID = -1 
    BEGIN 
      EXEC t_CheckBookingServicesCompatible @ChID, @SrvcID, @BTime, @ETime, -1
      IF @@ERROR <> 0 RETURN    
      SELECT @SrcPosID = ISNULL(MAX(SrcPosID), 0) + 1 FROM t_BookingD WHERE ChID = @ChID
      INSERT INTO t_BookingD (ChID, SrcPosID, SrvcID, ResourceID, BTime, ETime, DetSrcPosID, ForRet)
      VALUES (@ChID, @SrcPosID, @SrvcID, @ResourceID, @BTime, @Etime, @DetSrcPosID, 0)
    END
  ELSE
    BEGIN
      IF (@BTime = @ETime) AND (@ForRet = 0)
        DELETE FROM t_BookingD WHERE ChID = @ChID AND SrcPosID = @SrcPosID
      ELSE
        BEGIN
          IF @ForRet = 0
            BEGIN
              EXEC t_CheckBookingServicesCompatible @ChID, @SrvcID, @BTime, @ETime, @SrcPosID 
              IF @@ERROR <> 0 RETURN  
              UPDATE t_BookingD
              SET
                ResourceID = @ResourceID,
                BTime = @BTime,
                ETime = @ETime,
                ForRet = 0
              WHERE ChID = @ChID AND SrcPosID = @SrcPosID
              UPDATE t_Booking SET StateCode = 0 WHERE ChID = @ChID AND StateCode = 1
            END
          ELSE
            UPDATE t_BookingD SET ForRet = 1 WHERE ChID = @ChID AND SrcPosID = @SrcPosID 
        END    
    END
END

GO
