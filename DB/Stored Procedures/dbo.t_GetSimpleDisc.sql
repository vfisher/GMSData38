SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetSimpleDisc](@DocCode int, @ChID bigint, @SrcPosID int, @Vals varchar(3800))
/* Процедура предложения простой позиционной скидки */
/* Сгенерирована 25.04.2019 16:26:29; Приложение: SPComm.exe (Версия 3.14.0.900, 25.04.2019 12:58:58); Версия БД: 3.17.0.0 */
AS
BEGIN
  CREATE TABLE #t_GetValidDiscs_Out(
    DiscCode int, DiscName varchar(200), BonusSystem bit, AutoSelDiscs bit,
    MinSumBonus numeric(21, 9), MaxSumBonus numeric(21, 9),
    MinDiscount numeric(21, 9), MaxDiscount numeric(21, 9), Discount numeric(21, 9), AllowZeroSumBonus bit
)
  /* Оптимизация выполнения с ключем FMTONLY */
  IF (1 = 0)
    BEGIN
      SELECT * FROM #t_GetValidDiscs_Out
      DROP TABLE #t_GetValidDiscs_Out
      RETURN 0
    END


  SELECT * FROM #t_GetValidDiscs_Out
  DROP TABLE #t_GetValidDiscs_Out
END
GO
