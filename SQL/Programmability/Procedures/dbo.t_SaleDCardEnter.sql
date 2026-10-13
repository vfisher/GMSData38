SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleDCardEnter](@ParamsIn varchar(max), @ParamsOut varchar(8000) OUTPUT)
/* Реакция на ввод дисконтной карты */ 
AS
BEGIN
  DECLARE @DCardChID bigint 
  DECLARE @DCardDate smalldatetime
  DECLARE @DCardInUse bit
  DECLARE @DCTypeCode INT

  DECLARE
    @DocCode int,
    @ChID bigint,
    @DCardID varchar(250),
    @DCTypeGCode int,
    @PayFormCode int,
    @Result int,
    @Msg varchar(200)

  SET @ParamsOut = '{}'
  SET @DocCode = JSON_VALUE(@ParamsIn, '$.DocCode')
  SET @ChID = JSON_VALUE(@ParamsIn, '$.ChID')
  SET @DCardID = JSON_VALUE(@ParamsIn, '$.DCardID')
  SET @DCTypeGCode = JSON_VALUE(@ParamsIn, '$.DCTypeGCode')
  SET @PayFormCode = JSON_VALUE(@ParamsIn, '$.PayFormCode')
  SET @Result = 0
  SET @Msg = ''

  SELECT @DCardChID = ChID, @DCardDate = EDate, @DCardInUse = InUse, @DCTypeCode = DCTypeCode FROM r_DCards WHERE DCardID = @DCardID

  IF @DCardChID IS NULL
    BEGIN
      SET @Msg = FORMATMESSAGE(dbo.zf_Translate('Дисконтная карта с номером ''%s'' не существует.'), @DCardID)
      SET @ParamsOut = (SELECT @Result AS Result, @Msg AS Msg FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
      RETURN
    END

  IF EXISTS (SELECT TOP 1 1 FROM z_DocDC WHERE DCardChID = @DCardChID AND ChID = @ChID AND DocCode = @DocCode)
    BEGIN
      SET @Msg = FORMATMESSAGE(dbo.zf_Translate('Дисконтная карта с номером ''%s'' уже используется.'), @DCardID)
      SET @ParamsOut = (SELECT @Result AS Result, @Msg AS Msg FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
      RETURN
    END

  IF @DCardDate IS NOT NULL AND @DCardDate < dbo.zf_GetDate(GetDate())
    BEGIN
      SET @Msg = dbo.zf_Translate('Срок действия дисконтной карты истек.')
      SET @ParamsOut = (SELECT @Result AS Result, @Msg AS Msg FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
      RETURN
    END
  IF @DCardInUse = 0
    BEGIN
      SET @Msg = dbo.zf_Translate('Дисконтная карта заблокирована.')
      SET @ParamsOut = (SELECT @Result AS Result, @Msg AS Msg FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
      RETURN
    END

  IF @DCTypeCode = 0
    BEGIN
      SET @Msg = dbo.zf_Translate('Тип данной карты не указан.')
      SET @ParamsOut = (SELECT @Result AS Result, @Msg AS Msg FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
      RETURN
    END

  DECLARE @MaxQty int
  DECLARE @DCTypeGCodeCur int /* Код группы типов дисконтных карт для @DCardID */
  SELECT @MaxQty = MaxQty, @DCTypeGCodeCur = DCTypeGCode FROM r_DCTypes WITH(NOLOCK) WHERE DCTypeCode = @DCTypeCode
  IF @MaxQty <> 0 AND (SELECT COUNT(*) FROM z_DocDC d WITH(NOLOCK), r_DCards r  WITH(NOLOCK) WHERE d.DCardChID = r.ChID AND d.DocCode = @DocCode AND d.ChID = @ChID AND r.DCTypeCode = @DCTypeCode) >= @MaxQty
    BEGIN
      IF @MaxQty = 1 
        SET @Msg = dbo.zf_Translate('Дисконтная карта данного типа уже используется.')
      ELSE 
        SET @Msg = dbo.zf_Translate('Невозможно использовать дисконтную карту данного типа. Максимально возможное количество: ') + CAST(@MaxQty AS varchar(10))
      SET @ParamsOut = (SELECT @Result AS Result, @Msg AS Msg FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
      RETURN
    END

  DECLARE @DCTypeGNameCur varchar(250) /* Имя группы типов дисконтных карт. Не имеет прямого отношения к DCTypeGCode, т.к. DCTypeGCode - идентификатор текущего окна ввода дисконтной карты */
  DECLARE @MainDialogCur bit
  SELECT @DCTypeGNameCur = DCTypeGName, @MainDialogCur = MainDialog FROM r_DCTypeG WITH(NOLOCK) WHERE DCTypeGCode = @DCTypeGCodeCur
  IF (@MainDialogCur = 1 AND @DCTypeGCode <> 0) OR (@MainDialogCur = 0 AND @DCTypeGCode <> @DCTypeGCodeCur)
    BEGIN
      IF @MainDialogCur = 1 AND @DCTypeGCode <> 0 
        SELECT @DCTypeGNameCur = dbo.zf_Translate('Дисконтные карты')
      SET @Msg = dbo.zf_Translate('Данная дисконтная карта должна вводиться в окно ''') + @DCTypeGNameCur + '''.'
      SET @ParamsOut = (SELECT @Result AS Result, @Msg AS Msg FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
      RETURN
    END

  INSERT INTO z_DocDC(DocCode, ChID, DCardChID)
  VALUES (@DocCode, @ChID, @DCardChID)

  SET @Result = 1
  SET @ParamsOut = (SELECT @Result AS Result, '' AS Msg FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
END
GO