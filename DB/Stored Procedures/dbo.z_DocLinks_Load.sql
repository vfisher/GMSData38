SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_DocLinks_Load](@ParentDocCode int, @ParentChID bigint, @ChildDocCode int, @ChildChID bigint, @RepToolCode int, @ToolCode int)
AS 
/* Связь документов: Загрузка */
BEGIN  
  DECLARE 
    @LinkID int,
    @DocLinkTypeID int,
    @LinkSumCC numeric(21, 9),
    @LinkDocDate smalldatetime

  SELECT 
    @LinkID = LinkID,
    @DocLinkTypeID = DocLinkTypeID,
    @LinkSumCC = LinkSumCC,
    @LinkDocDate = LinkDocDate
  FROM
    z_DocLinks
  WHERE
    ParentDocCode = @ParentDocCode AND
    ParentChID = @ParentChID AND
    ChildDocCode = @ChildDocCode AND
    ChildChID = @ChildChID

  EXEC z_DocLinks_Prepare @ParentDocCode, @ParentChID, @ChildDocCode, @ChildChID, @RepToolCode, @ToolCode

  UPDATE #_DocLinks
  SET
    DocLinkTypeID = @DocLinkTypeID,
    ParentSumCCClosed = ParentSumCCClosed - @LinkSumCC,
    ParentSumCCFree = ParentSumCCFree + @LinkSumCC,
    ChildSumCCClosed = ChildSumCCClosed - @LinkSumCC,
    ChildSumCCFree = ChildSumCCFree + @LinkSumCC,
    LinkSumCC = @LinkSumCC,
    LinkDocDate = @LinkDocDate,
    LinkID = @LinkID

END
GO
