SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetNewOrderID](@OurID int)
/* Возвращает новый номер приказа */ 
RETURNS INT AS 
BEGIN 
RETURN ISNULL((SELECT MAX(WOrderID) + 1 FROM ( 
       SELECT WOrderID FROM p_OPWrk WHERE OurID = @OurID 
       UNION ALL
       SELECT WOrderID FROM p_EGiv WHERE OurID = @OurID
       UNION ALL
       SELECT WOrderID FROM p_EExc WHERE OurID = @OurID
       UNION ALL
       SELECT WOrderID FROM p_LExc WHERE OurID = @OurID
       UNION ALL
       SELECT WOrderID FROM p_WExc WHERE OurID = @OurID
       UNION ALL
       SELECT WOrderID FROM p_EDis WHERE OurID = @OurID
       UNION ALL
       SELECT WOrderID FROM p_ETrp WHERE OurID = @OurID
       UNION ALL
       SELECT WOrderID FROM p_ELeav WHERE OurID = @OurID) m), 1)
END
GO