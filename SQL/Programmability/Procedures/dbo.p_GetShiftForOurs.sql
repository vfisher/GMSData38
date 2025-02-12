SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_GetShiftForOurs](@OurID int)
AS 
BEGIN 
  SELECT OurID, DayBTime, DayETime, EvenBTime, EvenETime, NightBTime, NightETime, EvenPayFac, NightPayFac, OverPayFactor 
  FROM r_Ours 
  WHERE OurID = @OurID
  ORDER BY OurID 
END
GO