SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleFindDCard] @SearchStr varchar(200)
/* Ищет дисконтную карту по заданной строке поиска */
AS
  SET @SearchStr = '%' + @SearchStr + '%'
  SELECT
    dc.DCardID,
    p.PersonName,
    dc.Discount,
    dc.SumCC,
    p.Birthday,
    dc.SumBonus
  FROM r_DCards dc 
    JOIN r_DCTypes dt ON dc.DCTypeCode = dt.DCTypeCode
    LEFT JOIN r_PersonDC pdc ON dc.ChID = pdc.DCardChID
    LEFT JOIN r_Persons p ON pdc.PersonID = p.PersonID
  WHERE 
    dc.InUse = 1 AND dt.NoManualDCardEnter = 0 AND (  
    dc.DCardID LIKE @SearchStr OR 
    dc.Notes LIKE @SearchStr OR 
    dc.Value1 LIKE @SearchStr OR 
    dc.Value2 LIKE @SearchStr OR 
    dc.Value3 LIKE @SearchStr OR 
    dc.Note1 LIKE @SearchStr OR 
    p.PersonName LIKE @SearchStr OR
    p.Birthday LIKE @SearchStr OR
    p.Phone LIKE @SearchStr OR
    p.PhoneHome LIKE @SearchStr OR
    p.PhoneWork LIKE @SearchStr OR
    p.EMail LIKE @SearchStr)
GO
