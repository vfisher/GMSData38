SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_SaleSaveTelemetry](@CRID int, @DocTime datetime, @DocCode int, @ChID bigint, @EventId int, @ParamsIn varchar(max)) 
/* Сохраняет данные телеметрии ТК */  
AS
BEGIN
  if @DocCode = -1 set @DocCode = null
  if @ChID = -1 set @ChID = null
  if @ParamsIn = '' set @ParamsIn = null

  if @EventId = 111111
    begin
      update z_LogSale 
      set DocCode = JSON_VALUE(@ParamsIn, '$.DocCode'), ChID = JSON_VALUE(@ParamsIn, '$.ChID')
      where DocCode = @DocCode and ChID = @ChID
    end
  else
    insert into z_LogSale(CRID, DocTime, DocCode, ChID, EventId, ExtraInfo)
    values(@CRID, @DocTime, @DocCode, @ChID, @EventId, @ParamsIn) 
END
GO