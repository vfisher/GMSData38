SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vz_ToolApps] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT 
  r.RepToolCode, r.RepToolName, r.FormClass,
  t.ToolCode, t.ToolName, t.ShortCut, t.DocCode TargetDocCode, d1.DocName TargetDocName,
  a.AppCode SourceAppCode, a1.AppName SourceAppName
FROM
  z_ToolRep r, z_Tools t, z_ToolApps a, 
  z_Docs d1, z_Apps a1
WHERE
  r.RepToolCode = t.RepToolCode AND t.ToolCode = a.ToolCode AND t.DocCode = d1.DocCode AND a.AppCode = a1.AppCode
) GMSView
GO
