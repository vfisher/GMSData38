SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_ETrpsE] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT  d.ParentChID, m.*
FROM    p_ETrp m ,
        ( SELECT  ParentChID, OurID, MAX(DocID) DocID
          FROM    z_DocLinks mm ,
                  p_ETrp dd
          WHERE   mm.ChildChID = dd.ChID
                  AND ParentDocCode = 15024
                  AND ChildDocCode IN (15024, 15043)
          GROUP BY OurID, ParentDocCode, ParentChID
        ) d
WHERE   m.OurID = d.OurID
        AND m.DocID = d.DocID
UNION ALL
SELECT  ChID, *
FROM    p_ETrp
WHERE   ChID NOT IN ( SELECT  ParentChID
                      FROM    z_DocLinks
                      WHERE   ParentDocCode = 15024 )
        AND ChID NOT IN ( SELECT  ChildChID
                          FROM    z_DocLinks
                          WHERE   ChildDocCode = 15024 )
        AND OrderType = 0) GMSView
GO