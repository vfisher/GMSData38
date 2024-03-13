SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_UpdateDocShed] (@DocCode int, @ChID bigint, @FactDate DateTime, @StateCode Int )
/* Обновляет FactDate статуса @StateCode для текущего документа 
   и пересчитывает PlanDate статусов документа с кодом @StateCode и его
   подчененных статусов */ 
AS
BEGIN
  UPDATE z_DocShed
  SET FactDate = @FactDate
  WHERE  DocCode = @DocCode AND ChID = @ChID AND StateCode = @StateCode
  EXEC z_CalcDocShed @DocCode , @ChID , @StateCode
  EXEC z_CalcChildDocShed @DocCode , @ChID , @StateCode
END
GO
