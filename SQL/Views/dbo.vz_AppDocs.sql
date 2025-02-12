SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vz_AppDocs] WITH VIEW_METADATA AS
SELECT * FROM (
select a.AppCode, a.AppName, d.*
from z_Apps a, z_Docs d, z_AppDocs ad
where a.AppCode = ad.AppCode and d.doccode = ad.doccode) GMSView
GO