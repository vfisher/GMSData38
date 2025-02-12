SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[r_EmpNamesDates] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT  ChDate BDate,
        ISNULL((SELECT  DATEADD(d, -1, MIN(ChDate))
                FROM    r_EmpNames
                WHERE   OurID = m.OurID
                        AND EmpID = m.EmpID
                        AND ChDate > m.ChDate), CAST('20790101' AS smalldatetime)) AS EDate,
        *
FROM    r_EmpNames m) GMSView
GO