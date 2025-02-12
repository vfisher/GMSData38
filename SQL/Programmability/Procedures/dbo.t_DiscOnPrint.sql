SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_DiscOnPrint](@DocCode int, @ChID bigint, @CancelCheque bit, @Msg varchar(2000) OUTPUT)
/* Формирует сообщение дисконтной системы, выводимое на печать */
/* Сгенерирована 25.04.2019 16:26:29; Приложение: SPComm.exe (Версия 3.14.0.900, 25.04.2019 12:58:58); Версия БД: 3.17.0.0 */
AS
GO