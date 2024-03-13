SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_DocIDRange]()
/* Возвращает диапазон номеров документов */
RETURNS @out table (DocIDStart bigint, DocIDEnd bigint)
BEGIN
  INSERT INTO @out(DocIDStart, DocIDEnd)
  SELECT DocID_Start, DocID_End FROM r_DBIs WHERE DBiID = dbo.zf_Var('OT_DBiID')
  RETURN
END
GO
