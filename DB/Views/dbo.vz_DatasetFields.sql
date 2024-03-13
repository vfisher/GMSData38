SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vz_DatasetFields] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT 
  DocCatCode, DocGrpCode, c.DocCode, c.DocName, d.DSName, f.*, d.TableCode, t.TableName, t.TableDesc,
  t.IsView, r.DataType, r.SQLType, CAST(s.Name AS varchar(250)) SQLTypeName, FieldDesc 
FROM z_Docs c, z_Datasets d, z_DataSetFields f, z_Tables t, z_FieldsRep r, systypes s 
WHERE 
  d.DSCode = f.DSCode AND t.TableCode = d.TableCode AND c.DocCode = d.DocCode AND 
  r.FieldName = f.FieldName AND s.xtype = r.SQLType) GMSView
GO
