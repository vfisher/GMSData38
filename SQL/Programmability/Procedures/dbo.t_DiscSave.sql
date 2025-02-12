SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_DiscSave](@DiscCode int, @DocCode int, @ChID bigint, @SrcPosID int, @SumBonus numeric(21, 9), @Discount numeric(21, 9) , @IsManualSelDisc bit)
/* Процедура списания бонусов/записи скидки по акции */
/* Сгенерирована 25.04.2019 16:26:29; Приложение: SPComm.exe (Версия 3.14.0.900, 25.04.2019 12:58:58); Версия БД: 3.17.0.0 */
AS
GO