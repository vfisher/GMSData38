SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vz_ValidTables] WITH VIEW_METADATA AS
SELECT * FROM (
select *
from vz_Relations
where ParentName <> 'r_Users' and ChildDocCode = 1007) GMSView
GO