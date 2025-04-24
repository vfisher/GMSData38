SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleOnEvent](@EventID int, @DocCode int, @ChID bigint, @CRID int, @AppCode INT, @AXml XML)
AS
/* Процедура, вызываемая при различных событиях в Торговых модулях */
BEGIN
/*
 ---=== Входящие данные ===---
 События
 */
  DECLARE /* @SALE_EVENT... */ 
  @SALE_EVENT_APP_START tinyint = 1,               /* Старт приложения */
  @SALE_EVENT_APP_START_SHOW_MAINFORM tinyint = 2, /* Отображение главной формы при старте */
  @SALE_EVENT_APP_FINISH tinyint = 100,            /* Завершение работы приложения */
  @SALE_EVENT_ON_IDLE tinyint = 10,                /* по таймеру для отображения рекламы на РРО и других действиях */
  @SALE_EVENT_PROCESSING_IS_ONLINE tinyint = 20,   /* Processing is online */
  @SALE_EVENT_PROCESSING_IS_OFFLINE tinyint = 21,  /* Processing is offline */
  @SALE_EVENT_BEFORE_CLOSE tinyint = 30,           /* Событие начала закрытия чека */
  @SALE_EVENT_AFTER_CLOSE tinyint = 31,            /* Событие окончания закрытия чека */
  @SALE_EVENT_AFTER_CLOSE_COMPLETED_FULLY tinyint = 32,    /* После полного завершения закрытия чека в приложении (можно осуществить переход к другому чеку, добавить товары...) */
  @SALE_EVENT_ON_CLOSE_CLICK_OK_BUTTON tinyint = 33,       /* После сохранения оплат при нажатии OK окне закрытия */
  @SALE_EVENT_ON_CLOSE_CHANGE_TO_TRASHCASH tinyint = 34,   /* При вызове экшена ChangeToTrashCash в окне закрытия*/
  @SALE_EVENT_ON_CLOSE_CLICK_OK_BUTTON_BEFORE_SAVEPAYS tinyint = 35, /* До сохранения оплат при нажатии OK окне закрытия */
  @SALE_EVENT_BEFORE_RECEXP tinyint = 40,          /* Событие начала денежного вноса\выноса */
  @SALE_EVENT_ON_RECEXP tinyint = 41,              /* Событие денежного вноса\выноса */
  @SALE_EVENT_BEFORE_ZREP tinyint = 50,            /* Событие начала Z-отчёта */
  @SALE_EVENT_ZREP_AFTER_ALL_CHECKS tinyint = 51,  /* Z-отчёт, перед печатью на РРО, но после всех проверок и диалогов */
  @SALE_EVENT_BEFORE_CALC_INV tinyint = 60,        /* Событие начала расчёта инвентаризации */
  @SALE_EVENT_ON_CREATE_INV tinyint = 61,          /* Событие создания инвентаризации */
  @SALE_EVENT_ON_EDIT_INV tinyint = 62,            /* Событие редактирования инвентаризации */
  @SALE_EVENT_AFTER_CUSTOM_PRINTFORM tinyint = 70, /* После отображения произвольной печатки */
  @SALE_EVENT_ON_CUSTOM_QRCODE tinyint = 90,       /* Обработка значнения, соответствующего UniInpit с кодом 72 */
  @SALE_EVENT_ON_CUSTOM_QRCODE2 tinyint = 91,      /* Обработка значнения, соответствующего UniInpit с кодом 73 */
  @SALE_EVENT_ON_CUSTOM_QRCODE3 tinyint = 92,      /* Обработка значнения, соответствующего UniInpit с кодом 74 */
  @SALE_EVENT_ON_CUSTOM_REPORTS tinyint = 200,     /* Нажатие кнопки "Разное" в меню Дополнительно */
  @SALE_EVENT_AFTER_PRODADD int = 1000,            /* После добавления товара */
  @SALE_EVENT_AFTER_GET_DC_FROM_PC int = 1100,     /* После обращения к ПЦ за параметрами дисконтной карты */
  @SALE_EVENT_ON_CLICK_OPEN_MONEYBOX int = 2000    /* Нажатие на кнопку "Открыть денежный ящик" */
/*
 @AXml - произвольные данные, например, код ответа на диалоговое сообщение
 В формате <xml><result>1</result><value>test</value><cookies>произвольные_данные</cookies></xml>
 ---=== Возвращаемые поля ===---
 Msg - текст сообщения, рекламы, путь к печатке, описание поля ввода значения
 Action int - код действия      
 */
  DECLARE 
  @EVENT_ACTION_NONE tinyint = 0,                     /* ничего не делать */
  @EVENT_ACTION_SHOWMESSAGE tinyint = 1,              /* показать сообщение без возврата в t_SaleOnevent */
  @EVENT_ACTION_SHOWDIALOG tinyint = 2,               /* показать диалог (см. google:MessageDlg), возврат в t_SaleOnevent */
  @EVENT_ACTION_SHOWPRINTFORM tinyint = 3,            /* показать печатку, которая лежит по пути Msg */
  @EVENT_ACTION_ENTERVALUE tinyint = 4,               /* диалог ввода значения */
  @EVENT_ACTION_ENTERPWDQR tinyint = 5,               /* eva запросить пароля через QR */
  @EVENT_ACTION_ENTERPWD tinyint = 6,                 /* eva запрос пароля через QR */
  @EVENT_ACTION_UNIINPUT tinyint = 7,                 /* обработка значения через uniInput, как будто оно введено пользователем */ 
  @EVENT_ACTION_BUTTONLIST tinyint = 8,               /* список с кнопками. Можно использовать для построения меню. В @value вернется имя кнопки */
  @EVENT_ACTION_MULTI_UNIINPUT tinyint = 9,           /* ввод сразу нескольких значений */
  @EVENT_ACTION_DISPLAY_ON_RRO tinyint = 10,          /* отобразить текст на дисплее РРО */
  @EVENT_ACTION_CREXTRA tinyint = 11,                 /* произвольный отчет на РРО */
  @EVENT_ACTION_OPEN_MONEY_CONTROL_BOOK tinyint = 12, /* eva - открытие формы при нажатии кнопки "Разное" -> "ЖУКД" в меню Дополнительно */
  --@EVENT_ACTION_OPEN_FIND_PROD_INFO tinyint = 13,   /* не реализовано открыть окно с информацией о товаре */ 
  @EVENT_ACTION_GETFROMAPI tinyint = 19,              /* получить документ из api-сервера gms */ 
  @EVENT_ACTION_GOTOCHEQUE tinyint = 20,              /* переход к чеку */ 
  --@EVENT_ACTION_REFRESH = 21,                       /* не реализовано */
  @EVENT_ACTION_AUTOCLOSE_DOC tinyint = 22,           /* автоматический переход и автозакрытие чека, внос-вынос */ 
  @EVENT_ACTION_ABORT int = 9999,                     /* прервать выполенение текущей операции без отображения ошибки */
  @EVENT_ACTION_EXIT_WITH_RESULT int = 10000          /* вернуть в вызывающий код значение value.
                                                         Имеет смысл только де тех вызовов, возвращаемые значения которых обрабатываются приложением.
                                                         Сейчас это SALE_EVENT_BEFORE_CLOSE. Если вернуть value = 1, чек будет отменен. Таким образом можно                    сменить закрытие чека на отмену на лету */

/*
 DlgType int - тип отображаемого диалога (см. google:MessageDlg) */
 DECLARE
   @mtWarning tinyint = 0,
   @mtError tinyint = 1,
   @mtInformation tinyint = 2,
   @mtConfirmation tinyint = 3
/* При возврате EVENT_ACTION_SHOWDIALOG:
   Buttons int - набор кнопок для диалога */
 DECLARE
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
/*     Пример 'Да, Нет, Отмена' = mbYes + mbNo + mbCancel = 1 + 2 + 8 = 11 
 При возврате EVENT_ACTION_ENTERVALUE:
   Value varchar(max)- значение, которым можно инициализировать диалог ввода (значение по-умолчанию)
   Caption varchar(max) - заголовок окна (опционально)
   Notes varchar(max) - 
   OnlyNumbers bit - ввод только чисел
   InitWithValue bit - подставить в поле ввода значение по-умолчанию, переданное в Value
   ShowNotes bit - отобразить Notes
 Cookies varchar(max) - произвольный идентификатор диалога (аналог cookies). Будет передан неизменно вместе с результатом диалога
 AXML
   result */
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


DECLARE @value VARCHAR(Max)
DECLARE @result INT    
DECLARE @cookies VARCHAR(Max)

SET @result = -1
SET @cookies = null   
IF @AXml IS NOT NULL
  SELECT 
    @value = n.value('value[1]', 'varchar(max)') 
  , @result = n.value('result[1]', 'int') 
  , @cookies = n.value('cookies[1]', 'varchar(max)')  
  FROM @AXml.nodes('/xml') AS t(n)

  /*--------- Полезная нагрузка  -------------------------------------------- */
/*
  Пример отображения кнопочного меню: 
          declare @json varchar(4000)
          set @json = '{ "buttons": [ {"caption":"Бланк выдачи", "name":"Button1", "hotkey":"F1"},
                                 {"caption":"Чек отбора", "name":"Button2", "hotkey":"F2"},
                  ]
             }'
        -- В msg описание кнопок, [Action] = показать кнопки, [Caption] - заголовок окна
        SELECT @json Msg, @EVENT_ACTION_BUTTONLIST [Action], 'Разное' Caption, '<blanc><step>1</step></blanc>' cookies
*/

/*
  Пример вноса и выноса
  SELECT @EVENT_ACTION_AUTOCLOSE_DOC [Action], 11051 v1, '<xml><doc doccode="11051"><sum>30</sum><notes>Comment</notes><CodeID1>1</CodeID1></doc></xml>' v2
  SELECT @EVENT_ACTION_AUTOCLOSE_DOC [Action], 11052 v1,'<xml><doc doccode="11052"><sum>30</sum><CodeID5>3</CodeID1></doc></xml>' v2
  Пример вызова печатки
  SELECT '\Внедрение\Инструменты\Инструмент - Переоценки за сегодня.fr3' Msg, @EVENT_ACTION_SHOWPRINTFORM [Action], 0 as Preview
*/

/*
  Приклад автоматичного повного службового винесення перед виконанням зет-звіту
  Налаштування:
  Для того, щоб не відображалось діалогове вікно з вказанною сумою повного винесення необхідно налаштувати в довіднику (r_WPRoles) RequireExp = 0 "Вынос денег перед окончанием смены обязателен". 
  Розрахувати суму службового винесення @Sum.
*/
/*
DECLARE @SumCash numeric(21,9) 
DECLARE @ParamsIn varchar(max) 
DECLARE @ParamsOut varchar(max)

SET @SumCash = 0
SET @ParamsIn = (SELECT @CRID AS CRID FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
EXEC t_GetCRBalance @ParamsIn, @ParamsOut OUTPUT  
SET @SumCash = JSON_VALUE(@ParamsOut, '$.SumCash')

IF (@EventID = @SALE_EVENT_BEFORE_ZREP) AND (@SumCash <> 0) 
  BEGIN
    IF @result IS NULL
      SELECT @EVENT_ACTION_AUTOCLOSE_DOC [Action], 11052 v1,'<xml><doc doccode="11052"><sum>' + CAST(FORMAT(@SumCash, 'N2', 'ru-UA') as VARCHAR(20)) + '</sum><CodeID5>0</CodeID1></doc></xml>' v2
    ELSE IF @result <> 1
      RAISERROR ('Помилка виконання службового винесення. Зверніться до адміністратора.', 18, 0)
  END
*/

IF (@EventID = @SALE_EVENT_BEFORE_CLOSE) OR (@EventID = @EVENT_ACTION_AUTOCLOSE_DOC) 
  OR (@EventID = @SALE_EVENT_ON_RECEXP) OR (@EventID = @SALE_EVENT_BEFORE_ZREP) 
  BEGIN  
    DECLARE @CashType int
	   SET @CashType = (SELECT TOP 1 CashType FROM r_Crs WHERE CRID = @CRID)

    IF (@CashType = 39) AND EXISTS(SELECT TOP 1 1 from t_CashRegInetCheques WITH(NOLOCK) where CRID = @CRID and [Status] NOT IN (0,1))
   /* SELECT  */
	  /*'Касу заблоковано. Виконується перереєстрація офлайн чеків.' Msg, */
	  /*@EVENT_ACTION_SHOWDIALOG [Action],  */
	  /*@mtInformation AS DlgType, */
	  /*@mrOk AS Buttons */

      RAISERROR ('Касу заблоковано. Виконується перереєстрація офлайн чеків.', 18, 0)
  END
END
GO