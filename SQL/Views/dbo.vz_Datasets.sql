SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vz_Datasets] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  DocCatCode, DocGrpCode, c.DocName, d.*, t.TableName
FROM z_Docs c, z_Datasets d, z_Tables t 
WHERE t.TableCode = d.TableCode AND c.DocCode = d.DocCode) GMSView
GO