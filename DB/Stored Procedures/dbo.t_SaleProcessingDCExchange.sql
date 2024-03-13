SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleProcessingDCExchange](@ChID bigint, @CRID int, @ProcessingID int, @DocTime datetime, @CardInfo varchar(250), @OldDCardID varchar(250), @NewDCardID varchar(250), @RRN varchar(250), @Status int, @NewChID bigint OUTPUT)
 /* Сохраняет информацию об обмене карт процессинга */
 AS
 BEGIN
   IF @ChID IS NULL OR @ChID < 0
     BEGIN
       EXEC z_NewChID 'z_LogProcessingExchange', @NewChID OUTPUT
       SELECT @ChID = @NewChID
       INSERT INTO z_LogProcessingExchange(ChID, CRID, ProcessingID, DocTime, CardInfo, OldDCardID, NewDCardID, RRN, Status)
       VALUES (@ChID, @CRID, @ProcessingID, @DocTime, @CardInfo, @OldDCardID, @NewDCardID, @RRN, @Status)
     END
   ELSE
     BEGIN
       SELECT @NewChID = @ChID        
       UPDATE z_LogProcessingExchange SET Status = @Status, RRN = @RRN WHERE ChID = @NewChID
     END      
 END
GO
