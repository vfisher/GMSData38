SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_TSersE] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT  m.*, t.EmpID, t.TripBDate, t.TripEDate
FROM  p_TSer m, z_DocLinks d, p_ETrpsE t
WHERE d.ParentDocCode = 15024 AND d.ChildDocCode = 15043 AND  d.ParentChID = t.ParentChID AND d.ChildChID = m.ChID) GMSView
GO