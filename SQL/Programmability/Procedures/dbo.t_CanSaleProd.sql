SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_CanSaleProd](@DocCode int, @ChID bigint, @BarCode varchar(42), @CanSale bit OUTPUT, @Msg varchar(200) OUTPUT)
/* Возвращает возможна ли продажа товара и выводимое сообщение */
AS
BEGIN
  SET @CanSale = 1
  SET @Msg = ''
END
GO