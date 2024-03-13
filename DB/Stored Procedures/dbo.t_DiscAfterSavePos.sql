SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_DiscAfterSavePos](@DocCode int, @ChID bigint, @SrcPosID int, @Msg varchar(2000) OUTPUT, @Continue bit OUTPUT)
/* Формирует сообщение дисконтной системы, выводимое после сохранения позиции */
/* Сгенерирована 25.04.2019 16:26:29; Приложение: SPComm.exe (Версия 3.14.0.900, 25.04.2019 12:58:58); Версия БД: 3.17.0.0 */
AS
GO
