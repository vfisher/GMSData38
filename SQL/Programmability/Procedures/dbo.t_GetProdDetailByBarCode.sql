SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetProdDetailByBarCode](@BarCode varchar(42), @BarQty numeric(21, 9), @ProdID int OUTPUT, @Qty numeric(21, 9) OUTPUT, @PLID int OUTPUT)
/* Возвращает параметры товара по штрихкоду */
AS
BEGIN
  IF @BarCode = ''
    BEGIN
      BEGIN

      DECLARE @Error_msg1 varchar(2000) = dbo.zf_Translate('Штрихкод является пустой строкой, возможно, он справа ограничен не цифровым символом.')

      RAISERROR(@Error_msg1, 16, 1)
      END

      RETURN
    END
  SELECT
    @ProdID = NULL
  SELECT
    @ProdID = ProdID,
    @Qty = Qty,
    @PLID = PLID
  FROM
    r_ProdMQ WITH (NOLOCK)
  WHERE
    BarCode = @BarCode
  IF @ProdID IS NULL
    BEGIN
      SELECT @ProdID = 0
      DECLARE @Msg varchar(200)
      SELECT @Msg = dbo.zf_Translate('Товар со штрихкодом ') + '''' + @BarCode + '''' + dbo.zf_Translate(' не обнаружен.')
      RAISERROR(@Msg, 16, 1)
      RETURN
    END
END
GO