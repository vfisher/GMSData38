SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_PostStrucEDate] WITH VIEW_METADATA
AS
SELECT     
  TOP (100) PERCENT d.ChID, d.EDate, m_1.OurID, m_1.OurName, d.SubID, s.SubName, d.PostID, p.PostName, d.StrucPostID
FROM         
  (SELECT     
    (SELECT     
      TOP (1) ChID
     FROM         
       p_PostStruc AS m
     WHERE     
       (StateCode =
         (SELECT     VarValue
          FROM          dbo.z_Vars
          WHERE      (VarName = 'p_StrucStateCode'))) AND (DocDate <= GETDATE()) AND (OurID = o.OurID)
          ORDER BY DocDate DESC, OurID DESC) AS ChID, OurID, OurName
          FROM          
            r_Ours AS o) AS m_1 INNER JOIN
            p_PostStrucD AS d ON m_1.ChID = d.ChID INNER JOIN
            r_Subs AS s ON d.SubID = s.SubID INNER JOIN
            r_Posts AS p ON d.PostID = p.PostID
          WHERE     
            (d.EDate IS NOT NULL) AND (d.EDate BETWEEN dbo.zf_GetDate(GETDATE()) - 1 AND dbo.zf_GetDate(GETDATE()) + 1)
ORDER BY d.EDate, m_1.OurID
GO
