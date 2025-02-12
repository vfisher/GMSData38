SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vz_ToolDocs] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT 
  r.RepToolCode, r.RepToolName, r.FormClass,
  t.ToolCode, t.ToolName, t.ShortCut, t.DocCode TargetDocCode, d1.DocName TargetDocName,
  d.DocCode SourceDocCode, d2.DocName SourceDocName
FROM
  z_ToolRep r, z_Tools t, z_ToolDocs d, 
  z_Docs d1, z_Docs d2
WHERE
  r.RepToolCode = t.RepToolCode AND t.ToolCode = d.ToolCode AND t.DocCode = d1.DocCode AND d.DocCode = d2.DocCode
) GMSView
GO