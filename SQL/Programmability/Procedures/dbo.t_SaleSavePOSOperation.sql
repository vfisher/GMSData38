SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
Create procedure [dbo].[t_SaleSavePOSOperation](@ParamsIn varchar(Max), @ParamsOut varchar(8000) output)
as
begin
  declare -- @DocCode int
           @ChID bigint
          ,@WPID int
          ,@POSPayID int
          ,@GUID varchar(200)
          ,@RRN  varchar(200)
          ,@Operation tinyint
          ,@Status int
          ,@Flags INT
          ,@Request varchar(max)
          ,@Response varchar(max)
          ,@Msg varchar(250)

  -- это передает ТК в ХП
  select @WPID = JSON_VALUE(@ParamsIn, '$.WPID')
        ,@POSPayID = JSON_VALUE(@ParamsIn, '$.POSPayID')
        ,@RRN = JSON_VALUE(@ParamsIn, '$.RRN')
        ,@GUID = JSON_VALUE(@ParamsIn, '$.GUID')
        ,@Operation = JSON_VALUE(@ParamsIn, '$.Operation')
        ,@Status = JSON_VALUE(@ParamsIn, '$.Status')
        ,@Flags = JSON_VALUE(@ParamsIn, '$.Flags')
        ,@ChID = JSON_VALUE(@ParamsIn, '$.ChID')
        ,@Request = JSON_VALUE(@ParamsIn, '$."Request"')
        ,@Response = JSON_VALUE(@ParamsIn, '$."Response"')
        ,@Msg = JSON_VALUE(@ParamsIn, '$."Msg"')

  begin TRAN
    IF @ChID IS NOT NULL AND @ChID <> -1
      update t_POSPayJournal with (updlock, holdlock)
      set  Response = @Response--CASE WHEN @Response IS NULL THEN Response ELSE JSON_MODIFY(ISNULL(Response, '[]'), 'append $', @Response) END
         , Request = @Request--CASE WHEN @Request IS NULL THEN Request ELSE JSON_MODIFY(ISNULL(Request, '[]'), 'append $', @Request) END
         , RRN = CASE WHEN @RRN IS null THEN RRN ELSE @RRN END
         , STATUS = CASE WHEN @Status IS null THEN Status ELSE @Status END
         , Flags = Flags | @Flags
         , Msg = LEFT(@Msg, 250)
      where ChID = @ChID
    if @@ROWCOUNT = 0
      BEGIN
        EXEC z_NewChID 't_POSPayJournal', @ChID OUTPUT
        INSERT INTO t_POSPayJournal
        (
          ChID
         ,WPID
         ,Operation
         ,POSPayID
         ,GUID
         ,Request
         ,Response
         ,RRN
         ,DocTime
         ,Status
         ,Flags
         ,Msg
        )
        VALUES
        (
          @ChID
         ,@WPID
         ,@Operation
         ,@POSPayID
         ,@GUID
         ,JSON_QUERY(@ParamsIn, '$."Request"')
         ,JSON_QUERY(@ParamsIn, '$."Response"')
         ,@RRN
         ,GETDATE()
         ,@Status
         ,@Flags        
         ,@Msg
        );
      end
  commit

  set @ParamsOut = (SELECT @ChID AS ChID for json path, without_array_wrapper)
end
GO