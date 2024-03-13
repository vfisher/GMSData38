SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vz_Relations] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT 
  RelName,
  p.DocCode ParentDocCode, ParentCode, p.TableName ParentName, p.TableDesc ParentDesc,
  ParentNames, ParentDescs,
  c.DocCode ChildDocCode, ChildCode, c.TableName ChildName, c.TableDesc ChildDesc,
  ChildNames, ChildDescs,
  CascUpdate, CascDelete, RelType
FROM z_Relations m, z_Tables p, z_Tables c
WHERE p.TableCode = m.ParentCode AND c.TableCode = m.ChildCode) GMSView
GO
