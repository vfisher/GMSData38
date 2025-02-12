SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetPermissionCRRepair](@ParamsIn varchar(max), @ParamsOut varchar(max) OUTPUT)
/* Возвращает разрешение на паререгистрацию офлайн документов ПРРО без дополнительной проверки пароля пользователя */
AS
BEGIN
  DECLARE @ResponseCode int, @ErrorCode int, @ResponseMessage varchar(max), @Permission bit

   /*SET @ParamsIn = '{"AppName":"Перереєстрація офлайн документів - ПРРО","AppVersion":"3.23.0.4430","ResponseMessage":"Код помилки: 7 CheckLocalNumberInvalid Помилка обробки документа за № 3 в пакеті, дислокація 12464: Некоректний локальний номер документа 4978 для ПРРО з фіскальним номером 4000454063. Номер документа повинен дорівнювати 4979","FinID":"4000454063","ResponseCode":"7","ErrorCode":"400"}' */
  SET @ParamsOut = '{}'

  DROP TABLE IF EXISTS #CRErrorMessage

  SET @ResponseCode = JSON_VALUE(@ParamsIn, '$.ResponseCode')
  SET @ErrorCode = JSON_VALUE(@ParamsIn, '$.ErrorCode')
  SET @ResponseMessage = JSON_VALUE(@ParamsIn, '$.ResponseMessage')

  SELECT 9 AS ResponseCode, 'DocumentValidationError' AS TypeError, 
  dbo.zf_Translate('Повідомлення повинно бути засвідчене кваліфікованим електронним підписом: envelopeType: EtUnknown') AS ResponseMessage
  INTO #CRErrorMessage

  INSERT INTO #CRErrorMessage
  SELECT 9 AS ResponseCode, 'DocumentValidationError' AS TypeError, 
  dbo.zf_Translate('Документ містить час %s%, що не відповідає поточному часу фіскального сервера') AS ResponseMessage

  INSERT INTO #CRErrorMessage
  SELECT 10 AS ResponseCode, 'DocumentValidationError' AS TypeError, 
  dbo.zf_Translate('Дата і час операції, зафіксованої документом %s%, не може бути меншим часу попереднього документа') AS ResponseMessage

  INSERT INTO #CRErrorMessage
  SELECT 9 AS ResponseCode, 'DocumentValidationError' AS TypeError, 
  dbo.zf_Translate('Помилки валідації XML: Error:') AS ResponseMessage

  SET @Permission = ISNULL((SELECT TOP 1 1 
  FROM #CRErrorMessage t
  WHERE t.ResponseCode = @ResponseCode AND @ResponseMessage like '%' + t.ResponseMessage + '%'),0)

  SET @ParamsOut = (SELECT @Permission AS Permission FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
END
GO