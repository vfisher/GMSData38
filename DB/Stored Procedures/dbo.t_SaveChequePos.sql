SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaveChequePos]( 
  @SrcPosID int, 
  @ChID bigint, 
  @ProdID int, 
  @TaxTypeID tinyint, 
  @UM varchar(50), 
  @Qty numeric(21,9), 
  @RealQty numeric (21,9), 
  @PriceCC_wt numeric(21,9), 
  @PurPriceCC_wt numeric(21,9), 
  @BarCode varchar(42), 
  @RealBarCode varchar(42), 
  @PLID tinyint, 
  @UseToBarQty int, 
  @CSrcPosID int, 
  @PosStatus tinyint, 
  @ServingTime smalldatetime, 
  @ServingID int, 
  @CReasonID int, 
  @CanEditQty bit, 
  @AllowQtyReduction bit, 
  @EmpID int, 
  @EmpName varchar(200), 
  @MarkCode int, 
  @AskLevyMark bit,
  @LevyMark varchar(20),
  @Msg varchar(2000) OUTPUT, 
  @Continue bit OUTPUT) 
/* Сохраняет позицию чека во временную таблицу */ 
AS 
BEGIN 
  DECLARE @SumCC_wt numeric(21,9), @PurSumCC_wt numeric(21,9) 
  DECLARE @OldQty numeric(21,9), @CountAddProds numeric(21,9) 
  SET @Msg = '' 
  SET @Continue = 1 

  /* Контроль отрицательных остатков */ 
  IF EXISTS(SELECT TOP 1 1 FROM sysobjects WHERE name = 'CK_t_Rem_AllowNegative') 
    BEGIN 
      DECLARE @OurID int 
      DECLARE @StockID int 
      DECLARE @SecID int 

      SELECT @OurID = OurID, @StockID = StockID, @SecID = SecID FROM dbo.tf_SaleGetChequeParams(@ChID) 

      IF dbo.tf_GetRem(@OurID, @StockID, @SecID, @ProdID, NULL) - 
        ISNULL(( 
          SELECT SUM(Qty * RealQty) 
          FROM t_SaleTemp m, t_SaleTempD d 
          WHERE m.ChID = d.ChID AND d.ProdID = @ProdID AND m.OurID = @OurID AND 
            m.StockID = @StockID AND NOT (m.ChID = @ChID AND d.SrcPosID = @SrcPosID)), 0) - @Qty * @RealQty < 0 
        BEGIN 
          SET @Msg = dbo.zf_Translate('Недостаточно остатка товара для продажи.') 
          SET @Continue = 0 
          RETURN 
        END 
    END 

  /* Если вместо акцизной марки передали мусор */
  IF EXISTS(SELECT * FROM r_Prods WITH(NOLOCK) WHERE ProdID = @ProdID AND RequireLevyMark = 1 AND @AskLevyMark = 1 AND @LevyMark NOT LIKE '[a-z][a-z][a-z][a-z][0-9][0-9][0-9][0-9][0-9][0-9]')
    BEGIN 
      SET @Msg = dbo.zf_Translate('Формат акцизной марки некорректен.') 
      SET @Continue = 0 
      RETURN 
    END 

  /* Если товар с такой маркой уже есть (для того чтобы можно было сделать отмену товара и снова ввести этот товар) */
  /*
  * 1. ПРРО: код акцизной марки не может дублироваться
  * 2. ПРРО: налоговая принимает ввод одной и той же акцизной марки для одного товара
  */
  SET @CountAddProds = ISNULL((SELECT SUM(Qty) FROM t_SaleTempD WITH(NOLOCK) WHERE ChID = @ChID /*AND ProdID = @ProdID*/ AND @AskLevyMark = 1 And @LevyMark IS NOT NULL And LevyMark = @LevyMark),0)
  IF (@CountAddProds > 0) And @CSrcPosID IS NULL
    BEGIN
      SET @Msg = dbo.zf_Translate('Товар с такой акцизной маркой уже присутствует в этом чеке.') 
      SET @Continue = 0 
      RETURN 
    END

  EXEC t_DiscBeforeSavePos 1011, @ChID, @SrcPosID, @CSrcPosID, @ProdID, @BarCode, @Qty, @Msg OUTPUT, @Continue OUTPUT 
  IF @Continue = 0 RETURN 

  SET @SumCC_wt = dbo.zf_Round(@PriceCC_wt * @Qty, 0.01) 
  SET @PurSumCC_wt = dbo.zf_Round(@PurPriceCC_wt * @Qty, 0.01) 
  IF @SrcPosID = -1 
    BEGIN 
      SELECT @SrcPosID = ISNULL(MAX(SrcPosID), 0) + 1 FROM t_SaleTempD WHERE ChID = @ChID 
      INSERT INTO t_SaleTempD (ChID, SrcPosID, ProdID, TaxTypeID, UM, Qty, RealQty, PriceCC_wt, SumCC_wt, PurPriceCC_wt, PurSumCC_wt, 
        BarCode, RealBarCode, PLID, UseToBarQty, CSrcPosID, PosStatus, ServingTime, ServingID, CReasonID, CanEditQty, EmpID, EmpName, MarkCode, LevyMark) 
      VALUES (@ChID, @SrcPosID, @ProdID, @TaxTypeID, @UM, @Qty, @RealQty, @PriceCC_wt, @SumCC_wt, @PurPriceCC_wt, @PurSumCC_wt, 
        @BarCode, @RealBarCode, @PLID, @UseToBarQty, ISNULL(@CSrcPosID, @SrcPosID), @PosStatus, @ServingTime, @ServingID, @CReasonID, @CanEditQty, @EmpID, @EmpName, @MarkCode, @LevyMark) 
    END 
  ELSE 
    BEGIN 
      IF @SrcPosID IS NULL 
        BEGIN 
          BEGIN
 
          DECLARE @Error_msg1 varchar(2000) = dbo.zf_Translate('Позиция в базе данных отсутствует.')
 
          RAISERROR(@Error_msg1, 16, 1)  
          END

          RETURN 
        END 

      IF @AllowQtyReduction <> 1 
      BEGIN 
        SELECT @OldQty = ISNULL(Qty, @Qty) FROM t_SaleTempD WHERE ChID = @ChID AND SrcPosID = @SrcPosID 
        IF (@OldQty > @Qty) 
          BEGIN 
            IF @OldQty > 0 
              SET @Msg = dbo.zf_Translate('Запрещено уменьшение количества товара. Воспользуйтесь функцией отмены товара.') 
            ELSE 
              SET @Msg = dbo.zf_Translate('Запрещено увеличение количества возвращаемого товара. Воспользуйтесь функцией отмены товара.') 
            SET @Continue = 0 
            RETURN 
          END 
      END 

      UPDATE t_SaleTempD 
      SET 
        ProdID = @ProdID, 
        TaxTypeID = @TaxTypeID, 
        UM = @UM, 
        Qty = @Qty, 
        RealQty = @RealQty, 
        PriceCC_wt = @PriceCC_wt, 
        SumCC_wt = @SumCC_wt, 
        PurPriceCC_wt = @PurPriceCC_wt, 
        PurSumCC_wt = @PurSumCC_wt, 
        BarCode = @BarCode, 
        RealBarCode = @RealBarCode, 
        PosStatus = @PosStatus, 
        PLID = @PLID, 
        UseToBarQty = @UseToBarQty, 
        EmpID = @EmpID, 
        EmpName = @EmpName, 
        MarkCode = @MarkCode, 
        LevyMark = @LevyMark,
        ModifyTime = GETDATE() 
      WHERE ChID = @ChID AND SrcPosID = @SrcPosID 
    END 

  IF @Qty>0 
    UPDATE r_ProdMarks SET InUse = 0, DateChange=GETDATE() WHERE MarkCode=@MarkCode 
  ELSE 
  	UPDATE r_ProdMarks SET InUse = 1, DateChange=GETDATE() WHERE MarkCode=@MarkCode 

  EXEC t_DiscAfterSavePos 1011, @ChID, @SrcPosID, @Msg OUTPUT, @Continue OUTPUT 
END

GO
