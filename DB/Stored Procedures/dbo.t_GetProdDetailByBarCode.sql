SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetProdDetailByBarCode](@BarCode varchar(42), @BarQty numeric(21, 9), @ProdID int OUTPUT, @Qty numeric(21, 9) OUTPUT, @PLID int OUTPUT)/* Возвращает параметры товара по штрихкоду */ASBEGIN  IF @BarCode = ''    BEGIN      RAISERROR('Штрихкод является пустой строкой, возможно, он справа ограничен не цифровым символом.', 16, 1)      RETURN    END  SELECT    @ProdID = NULL  SELECT    @ProdID = ProdID,    @Qty = Qty,    @PLID = PLID  FROM    r_ProdMQ WITH (NOLOCK)  WHERE    BarCode = @BarCode  IF @ProdID IS NULL    BEGIN      SELECT @ProdID = 0      DECLARE @Msg varchar(200)      SELECT @Msg = 'Товар со штрихкодом ' + '''' + @BarCode + '''' + ' не обнаружен.'      RAISERROR(@Msg, 16, 1)      RETURN    ENDEND
GO
