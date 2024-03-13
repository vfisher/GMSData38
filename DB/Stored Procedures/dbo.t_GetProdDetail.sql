SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetProdDetail](
  @DocCode int, @ChID bigint, @OurID int, @StockID int, @SecID int, @ProdID int, @IgnorePPList varchar(250), @FQty numeric(21, 9),
  @MaxPPQty numeric(21, 9) OUTPUT, @MaxQty numeric(21, 9) OUTPUT, @PPID int OUTPUT, @AutoPPProdID int OUTPUT,
  @PPField int OUTPUT, @QtyField numeric (21, 9) OUTPUT, @SetQty bit OUTPUT, @Msg varchar(200) OUTPUT)
/*
  Заполняет свойства документа
  Чтобы не устанавливать значение количества задайте @QtyField = NULL
*/
AS
BEGIN
  DECLARE
    @APPID int, @APPID1 int,
    @AQty numeric (21, 9),
    @AQty1 numeric(21, 9),
    @PP int,
    @AccQty numeric (21, 9),
    @StrRem varchar (20)

  SELECT @SetQty = 1

  /* Если товар не участвует в остатках и установлена опция "Обрабатывать участие товара в остатках" */
  IF EXISTS (SELECT * FROM r_Prods WITH(NOLOCK/*, FASTFIRSTROW */) WHERE ProdID = @ProdID AND InRems = 0) AND dbo.zf_Var('t_UseInRems') = 1
    BEGIN
      SELECT
        @APPID = MIN(PPID) FROM t_PInP WHERE ProdID = @ProdID AND PPID > 0
      SELECT
        @APPID = ISNULL(@APPID, 0),
        @AQty = 1,
        @PPField = @APPID

      IF NOT @DocCode IN (
        11002, /* Приход товара */
        11003, /* Возврат товара от получателя */
        11004  /* Возврат товара по чеку */
      ) SELECT @QtyField = @AQty
      RETURN
    END

  SELECT
    @APPID1 = NULL,
    @AQty1 = NULL

  SELECT @PP = dbo.zf_Var('t_PP')
  /* Определяем партию и количество */
  IF dbo.zf_Var('t_PPQC') = 0
    BEGIN
      RAISERROR('Списание без опции "Учет текущих остатков" не поддерживается.', 16, 1)
      RETURN
    END
  SET @IgnorePPList = ',' + @IgnorePPList + ','
  SELECT TOP 1
    @APPID1 = PPID,
    @AQty1 = RemQty
  FROM
    dbo.tf_GetPPIDRems(@PP, @OurID, @StockID, @SecID, @ProdID)
  WHERE NOT @IgnorePPList LIKE '%,' + CAST(PPID AS varchar(50)) + ',%'

  SELECT
    @AQty1 = ISNULL(@AQty1, 0)

  /* Если нет остатка используем вторичный метод списания */
  IF @AQty1 <= 0
    BEGIN
      SELECT @APPID1 = dbo.tf_GetSPPID(@OurID, @StockID, @ProdID, @SecID, NULL), @AQty1 = 0
      IF dbo.zf_Var('t_UseAlts') = 0 OR EXISTS (SELECT * FROM r_Prods WITH(NOLOCK/*, FASTFIRSTROW */) WHERE ProdID = @ProdID AND UseAlts = 0)
      SELECT @Msg = 'Недостаточно остатка товара.'
      SELECT @AccQty = SUM(AccQty) FROM t_Rem WHERE ProdID = @ProdID AND OurID = @OurID AND StockID = @StockID AND SecID = @SecID
      IF @AccQty > 0 SELECT @Msg = @Msg + ' Количество единиц товара в резерве: ' + CAST(CAST(@AccQty AS numeric(21, 3)) AS VARCHAR (20))
    END

  SELECT
    @PPField = @APPID1,
    @APPID = @APPID1,
    @PPID = @APPID1,
    @MaxPPQty = @AQty1


  IF @PP IN (0, 1) RETURN
  /* Обрабатываем возможность автосписания с разных партий */
  IF dbo.zf_Var('t_AutoPP') = 1 AND dbo.tf_DocAutoPP(@DocCode) = 1
    SELECT
      @MaxQty = dbo.tf_GetRem(@OurID, @StockID, @SecID, @ProdID, NULL),
      @AutoPPProdID = @ProdID,
      @QtyField = @MaxQty
  ELSE
    SELECT @QtyField = @AQty1
END
GO
