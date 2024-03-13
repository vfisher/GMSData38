SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vz_Fields] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  DocCode, TableName, TableDesc, IsView,
  f.*,
  FieldDesc, DataType, SQLType, CAST(s.name AS varchar(250)) SQLTypeName
FROM
  z_Tables t, z_Fields f, z_FieldsRep r, systypes s
WHERE
  f.TableCode = t.TableCode AND r.FieldName = f.FieldName AND
  s.xtype = SQLType) GMSView
GO
