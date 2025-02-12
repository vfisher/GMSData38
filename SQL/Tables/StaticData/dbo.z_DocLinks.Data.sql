SET IDENTITY_INSERT dbo.z_DocLinks ON
GO
INSERT dbo.z_DocLinks(LinkID, LinkDocDate, ParentDocCode, ParentChID, ParentDocDate, ParentDocID, ChildDocCode, ChildChID, ChildDocDate, ChildDocID, LinkSumCC, DocLinkTypeID) VALUES (0, '1900-01-01 00:00:00', 0, 0, '1900-01-01 00:00:00', 0, 0, 0, '1900-01-01 00:00:00', '', 0.000000000, 0);
GO
SET IDENTITY_INSERT dbo.z_DocLinks OFF
GO