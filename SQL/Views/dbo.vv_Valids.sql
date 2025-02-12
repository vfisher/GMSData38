SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vv_Valids] WITH VIEW_METADATA AS
SELECT * FROM (
select
  v.RepID, v.SourceID,
  v.TableIdx, v.TableCode, f1.TableName, f1.TableDesc,
  v.FieldName, f1.FieldDesc,
  v.ValidTableCode, f2.TableName ValidTableName, f2.TableDesc ValidTableDesc,
  v.ValidFieldName, f2.FieldDesc ValidFieldDesc
from
  v_Valids v, vz_Fields f1, vz_Fields f2
where
  v.TableCode = f1.TableCode and v.FieldName = f1.FieldName
  and v.ValidTableCode = f2.TableCode and v.ValidFieldName = f2.FieldName) GMSView
GO