SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_MDIOnEvent](@EventID int, @AppCode INT, @JSON varchar(max))
AS
/* Процедура, вызываемая при различных событиях в MDI модулях */
BEGIN
 /* DlgType int - тип отображаемого диалога (см. google:MessageDlg) */
 DECLARE
   @mtWarning tinyint = 0,
   @mtError tinyint = 1,
   @mtInformation tinyint = 2,
   @mtConfirmation tinyint = 3,
   @mbYes tinyint = 1,
   @mbNo tinyint = 2,
   @mbOK tinyint = 4,
   @mbCancel tinyint = 8,
   @mbAbort tinyint = 16,
   @mbRetry tinyint = 32,
   @mbIgnore tinyint = 64,
   @mbAll tinyint = 128,
   @mbNoToAll int = 256,
   @mbYesToAll int = 512,
   @mbHelp int = 1024,
   @mbClose int = 2048
  /* Пример 'Да, Нет, Отмена' = mbYes + mbNo + mbCancel = 1 + 2 + 8 = 11  */
  DECLARE    
    @idOK tinyint       = 1,
    @idCancel tinyint   = 2,
    @idAbort tinyint    = 3,
    @idRetry tinyint    = 4,
    @idIgnore tinyint   = 5,
    @idYes tinyint      = 6,
    @idNo tinyint       = 7,
    @idClose tinyint    = 8,
    @idHelp tinyint     = 9,
    @idTryAgain tinyint = 10,
    @idContinue tinyint = 11,
    @mrNone tinyint     = 0,
    @mrOk tinyint,
    @mrCancel tinyint,
    @mrAbort tinyint,
    @mrRetry tinyint,
    @mrIgnore tinyint,
    @mrYes tinyint,
    @mrNo tinyint,
    @mrClose tinyint,
    @mrHelp tinyint,
    @mrTryAgain tinyint,
    @mrContinue tinyint,
    @mrAll tinyint,
    @mrNoToAll tinyint,
    @mrYesToAll tinyint
  SELECT
    @mrOk       = @idOk,
    @mrCancel   = @idCancel,
    @mrAbort    = @idAbort,
    @mrRetry    = @idRetry,
    @mrIgnore   = @idIgnore,
    @mrYes      = @idYes,
    @mrNo       = @idNo,
    @mrClose    = @idClose,
    @mrHelp     = @idHelp,
    @mrTryAgain = @idTryAgain,
    @mrContinue = @idContinue,
    @mrAll      = @mrContinue + 1,
    @mrNoToAll  = @mrAll + 1,
    @mrYesToAll = @mrNoToAll + 1


  /* События */
  DECLARE /* @SALE_EVENT... */ 
    @EVENT_APP_START tinyint = 1               /* Старт приложения */

  /* Действия */
  DECLARE 
    @EVENT_ACTION_SHOWDIALOG TINYINT = 2               /* показать диалог , см. документацию в гугле: "Delphi MessageDlg function", имена параметров те же*/
   ,@EVENT_ACTION_SHOWPRINTFORM tinyint = 3            /*  показать печатку, которая лежит по пути ...*/
   ,@EVENT_ACTION_SHOWTRANSLATION_MONITOR TINYINT = 11 /*  показать монтиор перевода   */
   
  /* Пример */
  /*IF @EventID = @EVENT_APP_START AND @Appcode = 11000
    SELECT '{"actions":[{"id":1,"action":'+ cast(@EVENT_ACTION_SHOWPRINTFORM AS Varchar(10))+',"Path":"D:\\GMS\\SrvDirs\\ReportsUni\\1.fr3", "Preview":true, "Export": false}]}' AS Result
  */

  /*
  IF @EventID = @EVENT_ACTION_SHOWTRANSLATION_MONITOR AND @Appcode = 11000
  BEGIN
    -- Пример обработки запроса. Имеем диалог с вопросом, при успешном ответе отображаем монитор перевода
    -- Входящий json может иметь вид {"rq":[{"DSCode":10105001,"id":0}, {"Result":8,"id":1}]}'
    -- id указывает глубину вложенности вызовов OnEvent
    DECLARE @DSCode INT 
    DECLARE @Result INT 

    -- из нулевого элемента берем DSCode
    SELECT @DSCode = JSON_VALUE(value, '$.DSCode')
    FROM OPENJSON(@json, '$.rq')
    WHERE JSON_VALUE(value, '$.id') = '0';

    -- Пример фильтрации по источнику
    --IF @DSCode <> 10105001 
    --  RETURN

    -- из первого элемента берем Result
    SELECT @Result = JSON_VALUE(value, '$.Result')
    FROM OPENJSON(@json, '$.rq')
    WHERE JSON_VALUE(value, '$.id') = '1';
    
    IF @Result IS NULL -- диалога еще не было, см. документацию в гугле: "Delphi MessageDlg function"
      BEGIN
        -- отображаем диалог
       SELECT 
        (SELECT 
            1 AS id,
            @EVENT_ACTION_SHOWDIALOG AS action,
            dbo.zf_Translate(
                N'Запись сохранена. Сейчас будет открыт инструмент мониторинга перевода для завершения внесения данных в глобальный справочник. Нажмите "ОК", чтобы перейти к вводу данных в глобальный справочник.'
            ) AS Msg,
            @mtInformation AS DlgType,
            (@mbOK) AS Buttons
        FOR JSON PATH, ROOT('actions')
    ) AS Result

      END
    ELSE IF @Result = @mrOk -- см. документацию в гугле: "Delphi mrYes modalresult constant"
      BEGIN
        -- отображаем монитор
        SELECT '{"actions":[{"id":1,"action":'+ cast(@EVENT_ACTION_SHOWTRANSLATION_MONITOR AS VARCHAR(10))+'}]}' AS Result
      END

  END -- IF @EventID = @EVENT_ACTION_SHOWTRANSLATION_MONITOR AND @Appcode = 11000
  */

END
GO