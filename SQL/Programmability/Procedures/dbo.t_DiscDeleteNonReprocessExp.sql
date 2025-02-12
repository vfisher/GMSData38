SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_DiscDeleteNonReprocessExp](@DocCode int, @ChID bigint, @SrcPosID int)
/* Удаляет скидки по акциям без обратного предоставления */
/* Сгенерирована 25.04.2019 16:26:29; Приложение: SPComm.exe (Версия 3.14.0.900, 25.04.2019 12:58:58); Версия БД: 3.17.0.0 */
AS
BEGIN
  DELETE FROM t_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND GroupSumBonus IS NULL AND GroupDiscount IS NULL

      IF @DocCode = 1011
        DELETE p
        FROM t_LogDiscExpP p
        INNER JOIN t_SaleTempD t ON p.ChID = t.ChID AND p.DocCode = 1011 AND p.SrcPosID = t.SrcPosID
        WHERE t.CSrcPosID = @SrcPosID 

      ELSE 
        DELETE FROM t_LogDiscExpP
        WHERE DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID 

END
GO