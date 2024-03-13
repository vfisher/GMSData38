SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vz_Tables] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT DocCatCode, DocGrpCode, DocName, FormClass, t.*, CodeField, NameField, SyncCode, SyncType, SyncFields
FROM z_Docs d, z_Tables t
WHERE t.DocCode = d.DocCode) GMSView
GO
