SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleCanRet](@DocID bigint, @OurID int, @WPID int, @CRID int, @IsFreeRet bit,
  @SaleDocID bigint OUTPUT, /* Номер соответствующего документа продажи */ 
  @CheckRet bit OUTPUT, /* Проверять наличие товаров для возврата */
  @DocDate smalldatetime OUTPUT, /* Дата создания документа продажи */
  @Continue bit OUTPUT, /* Продолжать создание возвратного чека */ 
  @Msg varchar(200) OUTPUT) /* Сообщение, выдаваемое пользователю */
/* Управляет поведением Торгового клиента при возвратном чеке */
AS
BEGIN
  DECLARE @AChID bigint
  DECLARE @PayFormName varchar(200)
  DECLARE @CashType INT, @InetChequeNum varchar(200), @SetChangeInetChequeNumForCRRet BIT 

  SELECT @Continue = 1
  SELECT @CheckRet = 1
  SET @Msg = ''

  SET @CashType = ISNULL((SELECT CashType FROM r_Crs WHERE CRID = @CRID), 0)
  SET @SetChangeInetChequeNumForCRRet = ISNULL((SELECT SetChangeInetChequeNumForCRRet FROM r_WPs w WITH (NOLOCK) JOIN r_WPRoles r WITH (NOLOCK) ON w.WPRoleID = r.WPRoleID WHERE w.WPID = @WPID),0)

  IF @IsFreeRet = 1
    BEGIN
      SELECT @SaleDocID = @DocID
      SELECT @CheckRet = 0
      SELECT @DocDate = GETDATE()
      RETURN
    END

  SELECT @AChID = ChID, @SaleDocID = DocID, @DocDate = DocDate FROM t_Sale WHERE DocID = @DocID AND OurID = @OurID
  IF @SaleDocID IS NULL
    BEGIN
      SELECT @Msg = dbo.zf_Translate('Чек с номером ') + CAST(@DocID AS varchar(20)) + dbo.zf_Translate(' не существует.')
      SELECT @Continue = 0
      RETURN
    END

  IF (SELECT CheckRetPayForms FROM r_WPRoles r, r_WPs w WHERE w.WPID = @WPID AND r.WPRoleID = w.WPRoleID) = 1
    BEGIN
      SELECT TOP 1 @PayFormName = f.PayFormName 
      FROM t_SalePays d, r_PayForms f WITH(NOLOCK), r_DCTypes t WITH(NOLOCK)
      WHERE d.PayFormCode = f.PayFormCode AND f.DCTypeGCode = t.DCTypeGCode AND
        f.AutoCalcSum <> 0 AND f.DCTypeGCode <> 0 AND d.ChID = @AChID
      IF @PayFormName IS NOT NULL
        BEGIN
          SELECT @Msg = dbo.zf_Translate('Возврат по чеку, содержащему форму оплаты ') + @PayFormName + dbo.zf_Translate(', при использовании контроля форм оплаты, невозможен.')
          SELECT @Continue = 0
          RETURN
        END
    END

  IF @CashType = 39 AND @SetChangeInetChequeNumForCRRet = 0
    BEGIN
      SELECT @InetChequeNum = InetChequeNum FROM t_CashRegInetCheques WITH (NOLOCK) WHERE ChID = @AChID AND DocCode = 11035
      IF @InetChequeNum IS NULL
		     BEGIN
		       SELECT @Msg = dbo.zf_Translate('Не найден внешний фискальный номер чека продажи. Возврат невозможен.')
		       SELECT @Continue = 0
		       RETURN
		     END   	
    END
END

GO
