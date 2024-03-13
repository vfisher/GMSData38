SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_GetDTranInfo](@DocDate datetime, @OurID int, @SubID int, @DepID int)
AS 
/* Информация о переносе рабочего дня */
BEGIN 
  SELECT OurID, SubID, DepID, NotUseSubID, NotUseDepID, TranDate, DestDate, DatePayFac, WTSignID, TranType
  FROM p_DTran 
  WHERE (TranDate = @DocDate OR DestDate = @DocDate) AND 
         OurID = @OurID AND 
        (NotUseSubID = 1 OR SubID = @SubID) AND 
        (NotUseDepID = 1 OR DepID = @DepID)
  ORDER BY TranDate      
END     
GO
