SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vv_Tables] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  v.RepID, v.SourceID, v.ParentIdx, v.TableIdx,
  ISNULL((SELECT TableCode FROM v_Tables iv
          WHERE (iv.RepID = v.RepID) AND (iv.TableIdx = v.ParentIdx)), 0) ParentTableCode,
  v.TableCode, t.TableName, t.TableDesc, v.JoinLevel, v.JoinType, v.RelName,
  ISNULL(r.ParentCode, 0) AS ParentCode, r.ParentNames, r.ParentDescs,
  ISNULL(r.ChildCode, 0) AS ChildCode, r.ChildNames, r.ChildDescs
FROM v_Tables v INNER JOIN z_Tables t ON v.TableCode = t.TableCode
     LEFT OUTER JOIN z_Relations r ON v.RelName = r.RelName) GMSView
GO
