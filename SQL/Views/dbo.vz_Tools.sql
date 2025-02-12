SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vz_Tools] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT 
  r.RepToolCode, r.RepToolName, r.FormClass,
  t.ToolCode, t.ToolName, t.DocCode, d.DocName
FROM
  z_ToolRep r, z_Tools t, 
  z_Docs d
WHERE
  r.RepToolCode = t.RepToolCode AND t.DocCode = d.DocCode) GMSView
GO