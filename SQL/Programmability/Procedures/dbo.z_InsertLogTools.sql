SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_InsertLogTools](@ParamsIn varchar(max)) 
/* Сохраняет данные в таблицу z_LogTools */  
AS
BEGIN
  DECLARE
    @ChID bigint,
    @DocDate smalldatetime,
    @RepToolCode int,
    @Note1 varchar(200),
    @Note2 varchar(200),
    @Note3 varchar(200),
    @UserCode smallint,
    @ExtraInfo varchar(8000),
    @WPID int

  /* SET @ParamsIn = ''{"Note3":"27","Note2":"3.22.0.4000","Note1":"Завершение работы Торгового клиента",
                          "RepToolCode":11100,"UserCode":0,"DocDate":"08.06.2023 18:13:11","WPID":27,
                          "ExtraInfo":"{\"Timestamp\":\"\",\"CRDateTime\":\"\",\"ComputerName\":\"name\",\"ServerDateTime\":\"08.06.2023 18:13:02\"}"}'' */

  SET @DocDate = ISNULL(CONVERT(smalldatetime, JSON_VALUE(@ParamsIn, '$.DocDate'), 103),GETDATE())
  SET @RepToolCode = JSON_VALUE(@ParamsIn, '$.RepToolCode')
  SET @Note1 = JSON_VALUE(@ParamsIn, '$.Note1')
  SET @Note2 = JSON_VALUE(@ParamsIn, '$.Note2')
  SET @Note3 = JSON_VALUE(@ParamsIn, '$.Note3')
  SET @UserCode = JSON_VALUE(@ParamsIn, '$.UserCode')
  SET @ExtraInfo = JSON_VALUE(@ParamsIn, '$.ExtraInfo')
  SET @WPID = ISNULL(JSON_VALUE(@ParamsIn, '$.WPID'),0)

  BEGIN TRANSACTION
    EXEC z_NewChID 'z_LogTools', @ChID OUTPUT
    IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN
      END

    INSERT INTO z_LogTools(ChID, DocDate, RepToolCode, Note1, Note2, Note3, UserCode, ExtraInfo, WPID)
    SELECT @ChID, @DocDate, @RepToolCode, @Note1, @Note2, @Note3, @UserCode, @ExtraInfo, @WPID

  COMMIT TRANSACTION
END
GO