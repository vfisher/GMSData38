SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleDCardEnter](
  @DocCode int,
  @ChID bigint,
  @DCardID varchar(250),
  @DCTypeGCode int,
  @Result int OUTPUT,
  @Msg varchar(200) OUTPUT
)
/* Реакция на ввод дисконтной карты */ 
AS
BEGIN
  DECLARE @DCardChID bigint 
  DECLARE @DCardDate smalldatetime
  DECLARE @DCardInUse bit
  DECLARE @DCTypeCode int

  SET @Result = 0
  SET @Msg = ''

  SELECT @DCardChID = ChID, @DCardDate = EDate, @DCardInUse = InUse, @DCTypeCode = DCTypeCode FROM r_DCards WHERE DCardID = @DCardID

  IF @DCardChID IS NULL
    BEGIN
      SET @Msg = dbo.zf_Translate('Дисконтная карта с номером ''') + @DCardID + dbo.zf_Translate(''' не существует.')
      RETURN
    END

  IF EXISTS (SELECT TOP 1 1 FROM z_DocDC WHERE DCardChID = @DCardChID AND ChID = @ChID AND DocCode = @DocCode)
    BEGIN
      SET @Msg = dbo.zf_Translate('Дисконтная карта с номером ''') + @DCardID + dbo.zf_Translate(''' уже используется.')
      RETURN
    END

  IF @DCardDate IS NOT NULL AND @DCardDate < dbo.zf_GetDate(GetDate())
    BEGIN
      SET @Msg = dbo.zf_Translate('Срок действия дисконтной карты истек.')
      RETURN
    END
  IF @DCardInUse = 0
    BEGIN
      SET @Msg = dbo.zf_Translate('Дисконтная карта заблокирована.')
      RETURN
    END

  IF @DCTypeCode = 0
    BEGIN
      SET @Msg = dbo.zf_Translate('Тип данной карты не указан.')
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
      RETURN
    END

  INSERT INTO z_DocDC(DocCode, ChID, DCardChID)
  VALUES (@DocCode, @ChID, @DCardChID)

  SET @Result = 1
END
GO